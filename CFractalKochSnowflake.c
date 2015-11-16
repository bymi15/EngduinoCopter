/* Written by BRIAN MIN 08/10/2015
   This is programming exercise question Q1.12
   This program draws the Koch snowflake fractal using recursion
*/

#include "graphics.h"
#include <math.h>

void drawFractalLine(int count, int x1, int y1, int x2, int y2){
  int deltaX, deltaY, xA, yA, xB, yB, xC, yC;
  if(count == 1){
    drawLine(x1, y1, x2, y2);
    return;
  }
    deltaX = x2 - x1;
    deltaY = y2 - y1;

    xA = x1 + deltaX / 3;
    yA = y1 + deltaY / 3;

    xB = (int) (0.5*(x1+x2) + sqrt(3) * (y1-y2)/6);
    yB = (int) (0.5*(y1+y2) + sqrt(3) * (x2-x1)/6);

    xC = x1 + 2 * deltaX / 3;
    yC = y1 + 2 * deltaY / 3;

    drawFractalLine(count-1, x1, y1, xA, yA);
    drawFractalLine(count-1, xA, yA, xB, yB);
    drawFractalLine(count-1, xB, yB, xC, yC);
    drawFractalLine(count-1, xC, yC, x2, y2);
}

int main(void){
  setColour(blue);

  int iteration = 5;

  //Length of the equalateral triangle is 200
  drawFractalLine(iteration, 160, 220, 360, 220);
  drawFractalLine(iteration, 360, 220, 260, 47);
  drawFractalLine(iteration, 260, 47, 160, 220);
  
  return 0;
}
