import netP5.*;
import oscP5.*;

OPC opc;
OscP5 oscP5;
NetAddress myRemoteLocation;

int row, column;
float angles[][]; 
int colorChoice[][];

int fadeSpeed = 500;

//scene 5
boolean isSnake[][];
int snakeX, snakeY;
boolean cantMoveUp, cantMoveDown, cantMoveRight, cantMoveLeft = false;


int scene = 3;

String message;
float squareColor = 0.0f;

int sweepCounter = 0;
int sweepPeriod = 1;
int millisEntered = 0;

int numOscillators = 20;

void setup()
{
  opc = new OPC(this, "127.0.0.1", 7890);

  oscP5 = new OscP5(this, 8005);
  myRemoteLocation = new NetAddress("127.0.0.1", 8001);

  float spacing = width / 60.0;

  //left side, top to bottom, reversed because of strip positions
  opc.ledStrip(0, 30, width/4, 5, spacing, 0, true);  
  opc.ledStrip(30, 30, width/4, height/20 + 5, spacing, 0, true);
  opc.ledStrip(60, 30, width/4, 2 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(90, 30, width/4, 3 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(120, 30, width/4, 4 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(150, 30, width/4, 5 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(180, 30, width/4, 6 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(210, 30, width/4, 7 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(240, 30, width/4, 8 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(270, 30, width/4, 9 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(300, 30, width/4, 10 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(330, 30, width/4, 11 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(360, 30, width/4, 12 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(390, 30, width/4, 13 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(420, 30, width/4, 14 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(450, 30, width/4, 15 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(480, 30, width/4, 16 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(510, 30, width/4, 17 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(540, 30, width/4, 18 * height/20 + 5, spacing, 0, true);
  opc.ledStrip(570, 30, width/4, 19 * height/20 + 5, spacing, 0, true);

  //right side, top to bottom, reversed because
  opc.ledStrip(600, 30, width - width/4, 0 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(630, 30, width - width/4, 1 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(660, 30, width - width/4, 2 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(690, 30, width - width/4, 3 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(720, 30, width - width/4, 4 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(750, 30, width - width/4, 5 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(780, 30, width - width/4, 6 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(810, 30, width - width/4, 7 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(840, 30, width - width/4, 8 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(870, 30, width - width/4, 9 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(900, 30, width - width/4, 10 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(930, 30, width - width/4, 11 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(960, 30, width - width/4, 12 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(990, 30, width - width/4, 13 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(1020, 30, width - width/4, 14 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(1050, 30, width - width/4, 15 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(1080, 30, width - width/4, 16 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(1110, 30, width - width/4, 17 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(1140, 30, width - width/4, 18 * height/20 + 5, spacing, 0, false);
  opc.ledStrip(1170, 30, width - width/4, 19 * height/20 + 5, spacing, 0, false);


  size(1200, 200);

  row = 60;
  column = 10;

  angles = new float[row][column];
  colorChoice = new int[row][column];
  isSnake = new boolean[row][column];

  for (int x = 0; x < row; x++)
  {
    for (int y = 0; y < column; y++)
    {
      angles[x][y] = random(2 * PI);

      if (random(2) > 1)
        colorChoice[x][y] = 0;
      else
        colorChoice[x][y] = 1;

      isSnake[x][y] = false;
    }
  }

  message = "";

  frameRate(20);
}

void draw()
{
  background(0);
  //println(frameRate);
  OscMessage myMessage = new OscMessage("/amplitudes");

  switch(scene)
  {
  case 1:
    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        angles[x][y] += 0.002;
        stroke(255);
        fill(color(200 * sin(angles[x][y]), 0, 0));
        rect(x * width / row, y * height / column, width / row, height / column);
      }
    }
    break;

  case 2:
    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        angles[x][y] += 0.002;
        stroke(255);
        fill(color(255 * sin(angles[x][y])));
        rect(x * width / row, y * height / column, width / row, height / column);
      }
    }
    break;

  case 3:
  
    int oscMessageCounter = 0;
  
    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        angles[x][y] += PI / (PI * fadeSpeed);

        if (abs(sin(angles[x][y])) < 0.01)
        {
          //println("ASDF");
          if (random(2) > 1)
            colorChoice[x][y] = 0;
          else
            colorChoice[x][y] = 1;
        }

        stroke(255);

        if (colorChoice[x][y] == 0)
          fill(color(200 * sin(angles[x][y])));
        else if (colorChoice[x][y] == 1)
          fill(color(200 * sin(angles[x][y]), 0, 0));

        rect(x * width / row, y * height / column, width / row, height / column);

        oscMessageCounter++;
        if(oscMessageCounter < numOscillators)
          myMessage.add( 200 * sin(angles[x][y]));
      }
    }
    break;

  case 4:
    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        angles[x][y] += PI / (PI * fadeSpeed);

        stroke(255);

        if (colorChoice[x][y] == 0)
          fill(color(200 * sin(angles[x][y])));
        else if (colorChoice[x][y] == 1)
          fill(color(200 * sin(angles[x][y]), 0, 0));

        rect(x * width / row, y * height / column, width / row, height / column);
        myMessage.add(200 * sin(angles[x][y]));
      }
    }

    break;

  case 5:

    if (isSnake[snakeX][snakeY] && angles[snakeX][snakeY] < PI)
    {
      angles[snakeX][snakeY] += PI / (PI * 7);
    } else if (isSnake[snakeX][snakeY] && angles[snakeX][snakeY] >= PI)
    {
      cantMoveUp = cantMoveDown = cantMoveRight = cantMoveLeft = false;

      int direction = 0;
      boolean moveMade = false;

      while (!moveMade && (!cantMoveUp || !cantMoveDown || !cantMoveRight || !cantMoveLeft))
      {
        direction = (int)random(4);
        switch(direction)
        {
          //right
        case 0:
          if (snakeX < row-1 && !isSnake[snakeX+1][snakeY])
          {
            snakeX++;
            isSnake[snakeX][snakeY] = true;
            moveMade = true;
          } else
          {
            cantMoveRight = true;
          }
          break;

          //down
        case 1:
          if (snakeY < column-1 && !isSnake[snakeX][snakeY+1])
          {
            snakeY++;
            isSnake[snakeX][snakeY] = true;
            moveMade = true;
          } else
          {
            cantMoveDown = true;
          }
          break;

          //left
        case 2:
          if (snakeX > 0 && !isSnake[snakeX-1][snakeY])
          {
            snakeX--;
            isSnake[snakeX][snakeY] = true;
            moveMade = true;
          } else
          {
            cantMoveLeft = true;
          }
          break;

          //up
        case 3:
          if (snakeY > 0 && !isSnake[snakeX][snakeY-1])
          {
            snakeY--;
            isSnake[snakeX][snakeY] = true;
            moveMade = true;
          } else
          {
            cantMoveUp = true;
          }
          break;
        }
      }

      if (!moveMade && cantMoveRight && cantMoveDown && cantMoveLeft && cantMoveUp)
      {
        for (int x = 0; x < row; x++)
        {
          for (int y = 0; y < column; y++)
          {
            isSnake[x][y] = false;
            angles[x][y] = PI/2;
          }
        }

        snakeX = (int)random(row);
        snakeY = (int)random(column);
        isSnake[snakeX][snakeY] = true;
      }
    }

    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        stroke(255);
        if (isSnake[x][y])
        {
          fill(color(200 * sin(angles[x][y]))); //white
          //fill(color(200, 200 * sin(angles[x][y]), 200 * sin(angles[x][y]))); //red
        } else
        {
          fill(color(200, 200 * sin(angles[x][y] + PI/2), 200 * sin(angles[x][y] + PI/2))); //red
          //fill(color(200 * sin(angles[x][y]))); //white
        }
        rect(x * width / row, y * height / column, width / row, height / column);
        myMessage.add(200 * sin(angles[x][y]));
      }
    }

    break;

  case 6:

    //println(millis());
    //rintln((sweepPeriod * sweepCounter) + millisEntered);
    if (millis() > (sweepPeriod * sweepCounter) + millisEntered && sweepCounter < row)
    {
      sweepCounter++;
      //println("ASDF");
    }

    for (int x = 0; x < sweepCounter; x++)
    {
      for (int y = 0; y < column; y++)
      {
        angles[x][y] += PI / (PI * fadeSpeed);

        if (abs(sin(angles[x][y])) < 0.01)
        {
          //println("ASDF");
          if (random(2) > 1)
            colorChoice[x][y] = 0;
          else
            colorChoice[x][y] = 1;
        }

        stroke(255);

        if (colorChoice[x][y] == 0)
          fill(color(200 * sin(angles[x][y])));
        else if (colorChoice[x][y] == 1)
          fill(color(200 * sin(angles[x][y]), 0, 0));

        rect(x * width / row, y * height / column, width / row, height / column);

        myMessage.add(200 * sin(abs(angles[x][y])));
      }
    }
    break;
  }
  
  //OscMessage myMessage = new OscMessage("/amplitudes");
  //myMessage.add(message);
 
  oscP5.send(myMessage, myRemoteLocation);

  //println(message);
  message = "";
}

void keyPressed() {
  switch(key)
  {
  case '1':
    scene = 1;
    break;

  case '2':
    scene = 2;
    break;

  case '3':

    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        angles[x][y] = random(2 * PI);

        if (random(2) > 1)
          colorChoice[x][y] = 0;
        else
          colorChoice[x][y] = 1;
      }
    }
    scene = 3;
    break;

  case '4':
    scene = 4;
    boolean isRed = false;

    if (random(2) > 1)
      isRed = true;

    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        if (column > 0)
          angles[x][y] = 0.157 / column;
        else
          angles[x][y] = 0;

        if (isRed)  
          colorChoice[x][y] = 1;
        else
          colorChoice[x][y] = 0;
      }
    }

    break;

  case '5':
    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        isSnake[x][y] = false;
        angles[x][y] = PI/2;
      }
    }

    //start on top left
    isSnake[0][0] = true;
    snakeX = 0;
    snakeY = 0;

    scene = 5;
    break;

  case '6':
    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        angles[x][y] = 0;
      }
    }
    println("millis: " + millis());
    millisEntered = millis();
    sweepCounter = 0;
    scene = 6;
    break;

  default:
    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        angles[x][y] = 0;

        if (random(2) > 1)
          colorChoice[x][y] = 0;
        else
          colorChoice[x][y] = 1;
      }
    }
    scene = 6;
    break;
  }
}

void setupScene(int sceneNum)
{
  switch(sceneNum)
  {
  case 1:
    scene = 1;
    break;

  case 2:
    scene = 2;
    break;

  case 3:

    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        angles[x][y] = random(2 * PI);

        if (random(2) > 1)
          colorChoice[x][y] = 0;
        else
          colorChoice[x][y] = 1;
      }
    }
    scene = 3;
    millisEntered = millis();
    sweepCounter = 0;
    break;

  case 4:
    scene = 4;
    boolean isRed = false;

    if (random(2) > 1)
      isRed = true;

    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        if (column > 0)
          angles[x][y] = 0.157 / column;
        else
          angles[x][y] = 0;

        if (isRed)  
          colorChoice[x][y] = 1;
        else
          colorChoice[x][y] = 0;
      }
    }

    break;

  case 5:
    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        isSnake[x][y] = false;
        angles[x][y] = PI/2;
      }
    }

    //start on top left
    isSnake[0][0] = true;
    snakeX = 0;
    snakeY = 0;

    scene = 5;
    break;

  case 6:
    for (int x = 0; x < row; x++)
    {
      for (int y = 0; y < column; y++)
      {
        angles[x][y] = 0;
      }
    }
    millisEntered = millis();
    sweepCounter = 0;
    scene = 6;
    break;

  default:

    break;
  }
}