//Import libraries
#include <EngduinoAccelerometer.h>
#include <EngduinoLEDs.h>
#include <EngduinoButton.h>
#include <Wire.h>

void setup() {
  //Initialise the components
  EngduinoAccelerometer.begin();
  EngduinoButton.begin();
  EngduinoLEDs.begin();
  Serial.begin(9600); //initialise serial port at 9600 baud rate
  
  //Turn on the LEDs to indicate the program is running
  EngduinoLEDs.setAll(RED);
  delay(500);
  EngduinoLEDs.setAll(BLUE);
  delay(500);
  EngduinoLEDs.setAll(GREEN);
  delay(500);
  EngduinoLEDs.setAll(OFF);
}

void loop() {
  if(EngduinoButton.isPressed()){
    Serial.println("PRESSED");
    delay(200);
  }else{
    printAcceleration();
  }
  delay(20);
}

void printAcceleration(){
  float accelerations[3];
  EngduinoAccelerometer.xyz(accelerations);
  float x = accelerations[0];
  Serial.println(x);
}
