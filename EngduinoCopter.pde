import processing.serial.*;
import java.io.BufferedWriter;
import java.io.FileWriter;

//GLOBAL VARIABLES
Serial ser; //serial port where data is read from
BufferedReader reader; //reads files from the computer
BufferedWriter writer; //writes files to the computer
float xA, yA; //x and y acceleration values
float vel = 25; //velocity of the player
float x, y; //x and y position of the player

int gameState = 0; //0 represents the main menu, 1 represents the running game
boolean buttonPressed = false; //stores true if the engduino button is pressed

PImage bgImg;
PImage playerImg;
PImage wallImg;
PImage mainImg;

final String fileName = "highscore.dat"; //contains the filename of the highscore saved on the computer
int highscore = 0;
int score = 0;
int timer = 0;

float backX = 0; //stores the x position of the background
float backY = 0; //stores the y position of the background
float wx[] = new float[2]; //stores the x position of the two walls
//wy represents the top of the bottom section of the wall
float wy[] = new float[2]; //stores the y position of the two walls
int scrollSpeed = 3; //stores the speed at which the background scrolls across
int gap = 350; //gap between the top and bottom section of the wall

//runs once at the start of the application
void setup(){
  //sets the initial values of global variables
  initialise();
  
  //connects to a serial port
  connectToPort();

  //reads the highscore from file
  File f = new File(sketchPath(fileName));
  
  if (f.exists()){
    loadHighScore(f);
  }else{
    saveHighScore();
  }

  //loads the images onto memory
  loadImages(); 
  
  //sets the dimensions of the window
  size(800, 800);
}

void connectToPort(){
  //List all the available serial ports: 
  printArray(Serial.list()); 
  String portName = Serial.list()[0]; //note that this index may need to change depending on the machine
  ser = new Serial(this, portName, 9600);
  
}

void saveHighScore(){
  PrintWriter writer = null;
  try {
    writer = createWriter(fileName);
    writer.println(highscore + "\n");
  }
  catch (Exception e) {
    println("Error while writing to file");
    e.printStackTrace();
  }
  finally {
    if (writer != null) {
      try {
        writer.close();
      } catch (Exception e) {
        println("Error while closing writer");
        e.printStackTrace();
      }
    }
  }

}

void loadHighScore(File fileName){
  reader = createReader(fileName);
  String line;
  try {
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  if (line == null) {
    line = "-1"; //represents an error in reading the highscore
  } else {
    highscore = Integer.parseInt(line);
  }
  
}

void loadImages(){
  bgImg = loadImage("http://i.imgur.com/PlnZtbt.png");
  playerImg = loadImage("http://i.imgur.com/KSeXiXm.png");
  wallImg = loadImage("http://i.imgur.com/rUGgFSr.png");
  mainImg = loadImage("http://i.imgur.com/lSI3yq0.png");
  
  //error - could not load images properly
  if(bgImg.equals(null) || playerImg.equals(null) || wallImg.equals(null) || mainImg.equals(null)){
    println("Error - could not load images properly");
    exit();
  }
}

void initialise(){
  gameState = 0;
  xA = 0;
  yA = 0;
  x =  width / 3;
  y = height / 2;
  score = 0;
  highscore = 0;
}

//Reads data from the serial port
void readFromSerial(){
  if(ser.available() > 0){
    //read until the end of the line
    String s = ser.readStringUntil('\n');
    if(s != null){
      s = trim(s); //trim off any whitespace
      if(s.contains("PRESSED")){ //engduino sent button press data
        buttonPressed = true;
      }else if(s.contains(",")){ //engduino sent acceleration data
        float[] values = float(s.split(","));
        if(values != null){
          xA = values[0];
          yA = values[1];
        }
      }
    }
  }
}

//collision detection between player, top/bottom boundaries and walls
//i represents the current wall being processed
void checkCollision(int i){
  //if player touches the top or bottom of the screen
  if(y < 0 || y + playerImg.height > height){
    gameover();
  }
    
  float wallX = wx[i];
  float wallTopY = (wy[i] - gap) - wallImg.height;
  float wallBotY = wy[i];
  
  //checking collision with top wall
  if(x < wallX + wallImg.width && x + playerImg.width > wallX
    && y < wallTopY + wallImg.height && playerImg.height + y > wallTopY){
    
      gameover();
      
  }
  
  //checking collision with bottom wall
  if(x < wallX + wallImg.width && x + playerImg.width > wallX
    && y < wallBotY + wallImg.height && playerImg.height + y > wallBotY){
    
      gameover();
      
  }
}

//this method is run when the player collides with wall or goes out of bounds
void gameover(){
  saveHighScore(); //writes the highscore to file
  gameState = 0;
}

//re-initialises the variables before starting the game
void resetValues(){
  //sets the inital x and y values of the walls
   wx[0] = 700;
   wy[0] = (int)random(height-gap) + gap; //this generates a number between gap (gap between top and bottom wall) and height (height of the frame)
   wx[1] = 1150;
   wy[1] = (int)random(height-gap) + gap;
   
   //sets the initial background position to (0,0)
   backX = backY = 0;
   
   //sets the initial player position
   x = width / 3;
   y = height / 2;
   
   score = 0;
   
   scrollSpeed = 3;
   
   timer = millis(); //start the timer - set timer to current time in milliseconds
}

void checkButtonPress(){
  if(buttonPressed){
    if(gameState == 0) { //in main screen
       resetValues();
       gameState = 1;
    }
    
    buttonPressed = false;
  }
}

//returns true if 'ms' milliseconds have passed since timer has started
boolean timePassed(int ms){
  if(millis() - timer > ms){
    return true;
  }
  
  return false;
}

void update(){
  y += vel * yA; //increments player y-position by velocity * y-acceleration
  
  backX -= scrollSpeed; //scroll background
  
  //once the background image scrolls completely, reset the x position to 0
  if(backX <= -width+1 && backX >= -width-1){ //checks with a margin of error of +/- 1
    backX = 0;
  }
  
  //increase the difficulty of the game by increasing the scroll speed and decreasing the gap
  if(score == 10){
    scrollSpeed = 4;
  }else if(score == 50){
    gap = 300;
  }else if(score == 100){
    scrollSpeed = 4;
  }else if(score == 200){
    gap = 250;
  }
}

void drawPlayer(){
  image(playerImg, x, y);
}

void drawScore(){
  textSize(40);
  fill(255); //specifying font colour
  text(""+score, width/2-15, height-30);
}

void drawMainScreen(){
  imageMode(CENTER); //sets the origin (0,0) at the center of the image
  image(mainImg, width/2,height/2);
  
  textSize(35);
  fill(255); //specifying font colour
  text("High Score: "+ highscore, 30, height-200);
}

void drawWalls(){
  //loops through the walls - there are always two walls on the screen
  for(int i = 0 ; i < 2; i++) {
    //draws top section of the wall
    image(wallImg, wx[i], wy[i]);
    //draws bottom section of the wall
    image(wallImg, wx[i], (wy[i] - gap) - height);
      
    if(wx[i] + wallImg.width < 0) { //if the wall leaves the screen
      //wy represents the top of the bottom section of the wall
      //this generates a number between gap (gap between top and bottom wall) and height (height of the frame)
      wy[i] = (int)random(height - gap) + gap;
      wx[i] = width; //sets the x position of the wall to the width of the frame (just off-screen to the right)
    }
      
    //this block runs every second (1000ms)
    if(timePassed(1000)){
      highscore = max(++score, highscore); //increments score, and updates the high score
      timer = millis(); //reset the timer
    }
      
    checkCollision(i); //detects collision between player, top and bottom walls, and boundaries
      
    wx[i] -= scrollSpeed; //moves the walls 'scrollSpeed' to the left
  }
}

void drawBackground(){
    imageMode(CORNER); //sets the origin (0,0) at the top-left corner of the image
    image(bgImg, backX, 0);
    image(bgImg, backX+bgImg.width, 0);
}

void draw(){
  background(0); //sets the background colour to black
  
  readFromSerial(); //reads input from serial
  
  checkButtonPress(); //checks whether the endguino button was pressed
  
  if(gameState == 0){ //main screen
    
    drawMainScreen();
  
  }else{ //in-game state
    
    update(); //updates the values
    
    drawBackground();
    
    drawWalls();
    
    drawScore();
    
    drawPlayer();
    
  }
}
