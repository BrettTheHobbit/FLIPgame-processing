/*
Brett Hobbs
 Mr. Parchimowicz
 ICS 3U1
 A game where you rotate your world to help you get to the end: FLIP <---(the name of the game)
 */
import processing.net.*;

PVector startPoint, playerPos, playerVel, playerAcc;//refrence point for rotation || player position || acceleration of player 
int gameState, playerSpeed, setDifference;//gamestate within the game, 0 is start, negatives are misc and positions are levels || player movement speed upon the x values
float airResist, frict, floor, gravity;// air resistance of falling object || friction... is friction || floor of level || gravity || start mouse x  for rotation
color voidColour = 0, playerColour, leftPlayer; // the colour of my heart || detects colour of nearby blocks || detects pixel of left side of player
boolean jump, falling, moveLeft, moveRight, allowMove, collide, buttonLock, leftLocked, rightLocked, mayIPleaseJump;// to inhibit infinite jumping|| checks if you are falling || allows to move left || allows to move right || restricts movement if inside of a floor|| button locks a platform from being accesed || stops you from moving left || stops you from moving right || can i jump please jump please oh god i just want to live a real life, feel the breeze in my hair, just to jump in a field of grass.
PVector[] teleportExit = new PVector[5], teleportOCExit = new PVector[5];// determines where each portal ends up
Wallfloor Floor1, Floor2, Floor3, Floor4, Floor11, Floor12, Floor13, Floor14, Floor21, Floor22, Floor23, Floor24, Floor31, Floor32, Floor33, Floor34, Floor35, Floor36, Floor41, Floor42, Floor43, Floor44, Floor51, Floor52, Floor53, Floor54, Floor55, Floor56, Floor57, Floor58, Floor61, Floor62, Floor63, Floor64, Floor65, Floor66, Floor71, Floor72, Floor73, Floor74, Floor75, Floor76, Floor77, Floor78, Floor81, Floor82, Floor83, Floor84, Floor85, Floor86, Floor87, Floor88, Floor89, Floor810, Floor811, Floor812, Floor813, Floor91, Floor92, Floor93, Floor94, Floor95, Floor96, Floor97, Floor98, Floor99, Floor910, Floor911, Floor912, Floor913, Floor914, Floor915, Floor916, Floor917;// floors per each level, first num is leel and second is how many instances there are.
Server epicGamerServer;// server for multiplayer
Client epicGamerClient;// serer for client

void setup() {//sets up the program
  size(500, 500);
  surface.setResizable(true);
  background(0);
  ellipseMode(CENTER);
  rectMode(CENTER);
  teleportEnds();
  Floor1 = new Wallfloor(100, 350, 150, 50, "floor", 0, 0);// the two zeros indicate unused vars
  Floor2 = new Wallfloor(400, 450, 150, 50, "floor", 0, 0);//tutorial
  Floor3 = new Wallfloor(400, 250, 150, 50, "floor", 0, 0);
  Floor4 = new Wallfloor(100, 150, 150, 50, "endGoal", 0, 0);
  Floor11 = new Wallfloor(100, 50, 50, 50, "endGoal", 0, 0);//first level
  Floor12 = new Wallfloor(100, 300, 150, 50, "floor", 0, 0);
  Floor13 = new Wallfloor(100, 460, 150, 50, "floor", 0, 0);
  Floor14 = new Wallfloor(400, 350, 150, 50, "floor", 0, 0);
  Floor21 = new Wallfloor(width/2, 250, width, 50, "floor", 0, 0);//second level
  Floor22 = new Wallfloor(100, 400, 50, 50, "tp1", 200, 190);
  Floor23 = new Wallfloor(100, 200, 50, 50, "tp2", 200, 390);
  Floor24 = new Wallfloor(250, 0, 100, 50, "endGoal", 0, 0);
  Floor31 = new Wallfloor((width/2)+75, 250, width, 50, "floor", 0, 0);//third level
  Floor32 = new Wallfloor(250, 140, 50, 170, "floor", 0, 0);
  Floor33 = new Wallfloor(375, 450, 50, 170, "floor", 0, 0);
  Floor34 = new Wallfloor(50, 250, 100, 50, "gate", 0, 0);
  Floor35 = new Wallfloor(500, 400, 50, 100, "button", 0, 0);
  Floor36 = new Wallfloor(400, 100, 50, 50, "endGoal", 0, 0);
  Floor41 = new Wallfloor(200, 175, 300, 50, "floor", 0, 0);// fourth level
  Floor42 = new Wallfloor(25, 25, 25, 25, "endGoal", 0, 0);
  Floor43 = new Wallfloor(450, 400, 100, 50, "bouncing", 0, 0);
  Floor44 = new Wallfloor(400, 450, 100, 50, "floor", 0, 0);
  Floor51 = new Wallfloor(100, 500, 200, 50, "death", 0, 0);// fifth level
  Floor52 = new Wallfloor(150, 400, 50, 50, "floor", 0, 0);
  Floor53 = new Wallfloor(50, 300, 50, 50, "floor", 0, 0);
  Floor54 = new Wallfloor(150, 200, 50, 50, "floor", 0, 0);
  Floor55 = new Wallfloor(250, 150, 100, 50, "floor", 0, 0);
  Floor56 = new Wallfloor(400, 100, 75, 50, "endGoal", 0, 0);
  Floor57 = new Wallfloor(400, 500, 200, 50, "death", 0, 0);
  Floor61 = new Wallfloor(50, 100, 100, 50, "button", 0, 0);// sixth level
  Floor62 = new Wallfloor(50, 400, 100, 50, "bouncing", 0, 0);
  Floor63 = new Wallfloor(350, 250, 50, 200, "death", 0, 0);
  Floor64 = new Wallfloor(400, 100, 60, 50, "endGoal", 0, 0);
  Floor65 = new Wallfloor(370, 250, 50, 200, "floor", 0, 0);
  Floor66 = new Wallfloor(410, 370, 185, 50, "gate", 0, 0);
  Floor71 = new Wallfloor(50, 450, 75, 50, "endGoal", 0, 0);// seventh level
  Floor72 = new Wallfloor(50, 350, 75, 50, "gate", 0, 0);
  Floor73 = new Wallfloor(125, 350, 25, 250, "death", 0, 0);
  Floor74 = new Wallfloor(150, 100, 50, 50, "button", 0, 0);
  Floor75 = new Wallfloor(250, 325, 100, 50, "bouncing", 0, 0);
  Floor76 = new Wallfloor(250, 375, 100, 50, "death", 0, 0);
  Floor77 = new Wallfloor(400, 100, 200, 200, "death", 0, 0);
  Floor78 = new Wallfloor(420, 450, 100, 50, "floor", 0, 0);
  Floor81 = new Wallfloor(0, 375, 50, 100, "button", 0, 0);// eighth level
  Floor82 = new Wallfloor(450, 450, 100, 50, "bouncing", 0, 0);
  Floor83 = new Wallfloor(100, 50, 100, 50, "endGoal", 0, 0);
  Floor84 = new Wallfloor(100, 0, 100, 50, "floor", 0, 0 );
  Floor85 = new Wallfloor(150, 150, 25, 150, "floor", 0, 0 );
  Floor86 = new Wallfloor(50, 200, 100, 50, "floor", 0, 0 );
  Floor87 = new Wallfloor(100, 150, 50, 50, "tp1", 300, 150 );
  Floor88 = new Wallfloor(200, 100, 50, 51, "death", 0, 0 );//fake tp
  Floor89 = new Wallfloor(200, 100, 50, 50, "tp2", 0, 0 );//it doesnt even go anywhere lol
  Floor810 = new Wallfloor(400, 100, 50, 50, "tp2", 50, 100 );//real tp
  Floor811 = new Wallfloor(300, 250, 100, 50, "floor", 0, 0 );
  Floor812 = new Wallfloor(450, 300, 100, 50, "gate", 0, 0 );
  Floor813 = new Wallfloor(150, 200, 100, 50, "floor", 0, 0 );
  Floor91 = new Wallfloor(50, 0, 50, 50, "endGoal", 0, 0);//final level
  Floor92 = new Wallfloor(250, 100, 500, 50, "floor", 0, 0);
  Floor93 = new Wallfloor(250, 250, 500, 50, "floor", 0, 0);
  Floor94 = new Wallfloor(250, 400, 500, 50, "floor", 0, 0);
  Floor95 = new Wallfloor(250, 50, 50, 100, "gate", 0, 0);
  Floor96 = new Wallfloor(250, 250, 50, 250, "floor", 0, 0);
  Floor97 = new Wallfloor(100, 150, 50, 50, "button", 0, 0);// random tp system that gurantees success everytime via a reacher/settler system
  Floor98 = new Wallfloor(500, 475, 25, 100, "tp1", int(teleportOCExit[0].x), int(teleportOCExit[0].y));// blue oc (colour = must connect)
  Floor99 = new Wallfloor(500, 325, 25, 100, "tp1", int(teleportOCExit[1].x), int(teleportOCExit[1].y));// yellow oc
  Floor910 = new Wallfloor(500, 175, 25, 100, "tp1", int(teleportOCExit[2].x), int(teleportOCExit[2].y));// orange oc
  Floor911 = new Wallfloor(500, 38, 25, 75, "tp1", int(teleportOCExit[3].x), int(teleportOCExit[3].y));// red oc
  Floor912 = new Wallfloor(238, 175, 25, 100, "tp1", int(teleportOCExit[4].x), int(teleportOCExit[4].y));// purple oc
  Floor913 = new Wallfloor(264, 175, 25, 100, "tp2", int(teleportExit[0].x), int(teleportExit[0].y));// random tps
  Floor914 = new Wallfloor(264, 325, 25, 100, "tp2", int(teleportExit[1].x), int(teleportExit[1].y));
  Floor915 = new Wallfloor(0, 475, 25, 100, "tp2", int(teleportExit[2].x), int(teleportExit[2].y));
  Floor916 = new Wallfloor(0, 325, 25, 100, "tp2", int(teleportExit[3].x), int(teleportExit[3].y));
  Floor917 = new Wallfloor(238, 325, 25, 100, "tp2", int(teleportExit[4].x), int(teleportExit[4].y));
  initialize();
}

void draw() {// continues the porgram
  if (gameState == 0) {// start screen
    background(0);
    textSize(height/5);
    fill(200);//darker colour (for style)
    scaledText("FLIP", 150, 100);
    if (mouseX > 150*width/500 && mouseX < 350*width/500 && mouseY > 200*height/500 && mouseY < 300*height/500) {
      fill(130);
      if (mousePressed) {
        gameState = 1;// transition to the real gameplay
      }
    }

    scaledRect(250, 250, 200, 100);//start
    fill(255);
    if (mouseX > 150*width/500 && mouseX < 350*width/500 && mouseY > 200*height/500 && mouseY < 300*height/500) {
      fill(205);
    }
    scaledRect(252, 250, 200, 100);//start front
    fill(210);
    scaledRect(250, 350, 200, 100);//race
    scaledRect(250, 450, 200, 100);
    fill(255);//lighter colour
    scaledText("FLIP", 152, 100);

    if (mouseX > 150*width/500 && mouseX < 350*width/500 && mouseY > 300*height/500 && mouseY < 400*height/500) {
      fill(205);
      if (mousePressed) {
        gameState = -1;
      }
    }


    scaledRect(252, 350, 200, 100);//race
    fill(255);
    if (mouseX > 150*width/500 && mouseX < 350*width/500 && mouseY > 400*height/500 && mouseY < 500*height/500) {
      fill(205);
      if (mousePressed) {
        exit();
      }
    }
    scaledRect(252, 450, 200, 100);//exit
    fill(0);
    textSize(height/7.69230769231);
    scaledText("START", 153, 270);
    scaledText(" RACE", 153, 370);
    scaledText(" EXIT", 153, 470);
  } else if (gameState == -1) {// multiplayer race levels
    background(0);
    fill(255);
    if (mouseX > 200*width/500 && mouseX < 300*width/500 && mouseY > 100*height/500 && mouseY < 200*height/500) {
      fill(200);
      if (mousePressed) {
        epicGamerClient = new Client(this, "72.39.68.35", 25565); // attempts to join any servver at said ip and port.
        println(epicGamerClient.active());//checks if great success
        if (epicGamerClient.active() == true) {
          gameState = -2;// racce gameState
        }
      }
    }
    scaledRect(250, 150, 100, 100);//join server
    fill(255);
    if (mouseX > 200*width/500 && mouseX < 300*width/500 && mouseY > 300*height/500 && mouseY < 400*height/500) {
      fill(200);
      if (mousePressed) {
        epicGamerServer = new Server(this, 25565); // tries to create a server at this ip + port.
      }
    }
    scaledRect(250, 350, 100, 100);//host server
    textSize(height/20);
    fill(0);//text colour
    scaledText("  Join\nServer", 210, 140);
    scaledText(" Host\nServer", 210, 340);
  } else if (gameState == 1) {// first level/test level
    /* //PUSH/POP MATRIX EXAMPLE
     background(0);
     pushMatrix();
     setDifference = mouseX - (width/2);
     rotate(radians(setDifference));
     levelOne();//draws the layout of the first level
     popMatrix();
     */
    background(0);
    fill(255);
    textSize(height/20);
    scaledText("Use W,A,S to move.\n    Get to the end.", 150, 300);
    fill(170, 0, 200);// makes the player a nice purple colour
    scaledEllipse(playerPos.x, playerPos.y, 50, 50);
    levelOne();
    updatePlayer();
  } else if (gameState == 2) {//second level, introduces rotation
    background(0);
    setDifference = mouseX - (width/2);
    pushMatrix();
    translate(width/2, height/2);//fixes the rotation around the center
    rotate(radians(setDifference/2.5));//sensitivity of rotation
    translate(-(width/2), -(height/2));
    levelTwo();//draws the layout of the first level
    popMatrix();
    text("   How about now?\n Try using the mouse.", 230, 100);
    fill(170, 0, 200);// makes the player a nice purple colour
    scaledEllipse(playerPos.x, playerPos.y, 50, 50);
    updatePlayer();
  } else if (gameState == 3) {// third level, 2 blocks (TP)
    background(0);
    fill(255);
    textSize(height/25);
    scaledText("It seems like you need\n to get around some\n other way...", 250, 350);
    fill(170, 0, 200);// makes the player a nice purple colour
    scaledEllipse(playerPos.x, playerPos.y, 50, 50);
    setDifference = mouseX - (width/2);
    pushMatrix();
    translate(width/2, height/2);//fixes the rotation around the center
    rotate(radians(setDifference/2.5));//sensitivity of rotation
    translate(-(width/2), -(height/2));
    levelThree();
    popMatrix();
    updatePlayer();
  } else if (gameState == 4) {//fourth level, 2 more blocks (Button/Gate)
    background(0);
    fill(170, 0, 200);// makes the player a nice purple colour
    scaledEllipse(playerPos.x, playerPos.y, 50, 50);
    setDifference = mouseX - (width/2);
    pushMatrix();
    translate(width/2, height/2);//fixes the rotation around the center
    rotate(radians(setDifference/2.5));//sensitivity of rotation
    translate(-(width/2), -(height/2));
    levelFour();
    popMatrix();
    updatePlayer();
  } else if (gameState == 5) {// fifth level, bouncing block
    background(0);
    fill(170, 0, 200);// makes the player a nice purple colour
    scaledEllipse(playerPos.x, playerPos.y, 50, 50);
    setDifference = mouseX - (width/2);
    pushMatrix();
    translate(width/2, height/2);//fixes the rotation around the center
    rotate(radians(setDifference/2.5));//sensitivity of rotation
    translate(-(width/2), -(height/2));
    levelFive();
    popMatrix();
    updatePlayer();
  } else if (gameState == 6) {//sixth level, death block
    background(0);
    fill(170, 0, 200);// makes the player a nice purple colour
    scaledEllipse(playerPos.x, playerPos.y, 50, 50);
    setDifference = mouseX - (width/2);
    pushMatrix();
    translate(width/2, height/2);//fixes the rotation around the center
    rotate(radians(setDifference/2.5));//sensitivity of rotation
    translate(-(width/2), -(height/2));
    levelSix();
    popMatrix();
    updatePlayer();
  } else if (gameState == 7) {// combo leel 7
    background(0);
    fill(170, 0, 200);// makes the player a nice purple colour
    scaledEllipse(playerPos.x, playerPos.y, 50, 50);
    setDifference = mouseX - (width/2);
    pushMatrix();
    translate(width/2, height/2);//fixes the rotation around the center
    rotate(radians(setDifference/2.5));//sensitivity of rotation
    translate(-(width/2), -(height/2));
    levelSeven();
    popMatrix();
    updatePlayer();
  } else if (gameState == 8) {// leel 8, bring elem,ents tog.
    background(0);
    fill(170, 0, 200);// makes the player a nice purple colour
    scaledEllipse(playerPos.x, playerPos.y, 50, 50);
    setDifference = mouseX - (width/2);
    pushMatrix();
    translate(width/2, height/2);//fixes the rotation around the center
    rotate(radians(setDifference/2.5));//sensitivity of rotation
    translate(-(width/2), -(height/2));
    levelEight();
    popMatrix();
    updatePlayer();
  } else if (gameState == 9) {// level 9, another lel, lots of death blocks
    background(0);
    fill(170, 0, 200);// makes the player a nice purple colour
    scaledEllipse(playerPos.x, playerPos.y, 50, 50);
    setDifference = mouseX - (width/2);
    pushMatrix();
    translate(width/2, height/2);//fixes the rotation around the center
    rotate(radians(setDifference/2.5));//sensitivity of rotation
    translate(-(width/2), -(height/2));
    levelNine();
    popMatrix();
    updatePlayer();
  } else if (gameState == 10) {//level 10, final level of fun
    background(0);
    fill(170, 0, 200);// makes the player a nice purple colour
    scaledEllipse(playerPos.x, playerPos.y, 50, 50);
    setDifference = mouseX - (width/2);
    pushMatrix();
    translate(width/2, height/2);//fixes the rotation around the center
    rotate(radians(setDifference/2.5));//sensitivity of rotation
    translate(-(width/2), -(height/2));
    levelTen();
    popMatrix();
    updatePlayer();
  } else if (gameState == 11) {//win cond.
    background(0);
    fill(235);
    textSize(height/10);
    scaledText("     You Win!\n Press [SPACE] to \n return to menu!", 50, 150);
    fill(255);
    scaledText("     You Win!\n Press [SPACE] to \n return to menu!", 51, 150);
  }
}

void teleportEnds() {// initializes pvector arrays
  int blueX = round(random(1, 4)), blueY = round(random(1, 4)), yellowX = round(random(1, 4)), yellowY = round(random(1, 4)), orangeX = round(random(1, 4)), orangeY = round(random(1, 4)), redX = round(random(1, 4)), redY = round(random(1, 4)), purpleX = round(random(1, 4)), purpleY = round(random(1, 4));// randomized exits

  switch(blueX) {// determines where "blue" portal ends up
  case 1:
    blueX = 364;
    blueY = 325;
    break;
  case 2:
    blueX = 364;
    blueY = 175;
    break;
  case 3:
    blueX = 200;
    blueY = 325;
    break;
  case 4:
    blueX = 100;
    blueY = 325;
    break;
  }

  switch(yellowX) {// deter. random "yellow" exit
  case 1:
    yellowX = 100;
    yellowY = 400;
    break;
  case 2:
    yellowX = 364;
    yellowY = 175;
    break;
  case 3:
    yellowX = 200;
    yellowY = 325;
    break;
  case 4:
    yellowX = 100;
    yellowY = 325;
    break;
  }

  switch(orangeX) {// determ. random "orange" exit
  case 1:
    orangeX = 100;
    orangeY = 400;
    break;
  case 2:
    orangeX = 364;
    orangeY = 325;
    break;
  case 3:
    orangeX = 200;
    orangeY = 325;
    break;
  case 4:
    orangeX = 100;
    orangeY = 325;
    break;
  }

  switch(redX) {// determ. random "red" exit
  case 1:
    redX = 100;
    redY = 400;
    break;
  case 2:
    redX = 364;
    redY = 325;
    break;
  case 3:
    redX = 364;
    redY = 175;
    break;
  case 4:
    redX = 100;
    redY = 325;
    break;
  }

  switch(purpleX) {// determines random "purple" exit
  case 1:
    orangeX = 100;
    orangeY = 400;
    break;
  case 2:
    orangeX = 364;
    orangeY = 325;
    break;
  case 3:
    orangeX = 200;
    orangeY = 325;
    break;
  case 4:
    orangeX = 364;
    orangeY = 175;
    break;
  }


  teleportExit[0] = new PVector(400, 400);// blue exit
  teleportExit[1] = new PVector(400, 325);// yellow exit
  teleportExit[2] = new PVector(400, 175);//orange exit
  teleportExit[3] = new PVector(400, 38);//red exit
  teleportExit[4] = new PVector(138, 175);// purple exit
  teleportOCExit[0] = new PVector(blueX, blueY);// random blue exit
  teleportOCExit[1] = new PVector(yellowX, yellowY);//random yellow exit
  teleportOCExit[2] = new PVector(orangeX, orangeY);// random orange exit
  teleportOCExit[3] = new PVector(redX, redY);// random red exit
  teleportOCExit[4] = new PVector(purpleX, purpleY);// random purple exit
}


void levelTen() {
  Floor91.build();
  Floor91.detect();
  Floor92.build();
  Floor92.detect();
  Floor93.build();
  Floor93.detect();
  Floor94.build();
  Floor94.detect();
  if (!buttonLock) {
    Floor95.build();
    Floor95.detect();
  }
  Floor96.build();
  Floor96.detect();
  Floor97.build();
  Floor97.detect();
  Floor98.build();
  Floor98.detect();
  Floor99.build();
  Floor99.detect();
  Floor910.build();
  Floor910.detect();
  Floor911.build();
  Floor911.detect();
  Floor912.build();
  Floor912.detect();
  Floor913.build();
  Floor913.detect();
  Floor914.build();
  Floor914.detect();
  Floor915.build();
  Floor915.detect();
  Floor916.build();
  Floor916.detect();
  Floor917.build();
  Floor917.detect();
}

void levelNine() {
  Floor81.build();
  Floor81.detect();
  Floor82.build();
  Floor82.detect();
  Floor83.build();
  Floor83.detect();
  Floor84.build();
  Floor84.detect();
  Floor85.build();
  Floor85.detect();
  Floor86.build();
  Floor86.detect();
  Floor87.build();
  Floor87.detect();
  Floor88.build();
  Floor88.detect();
  Floor89.build();
  Floor89.detect();
  Floor810.build();
  Floor810.detect();
  Floor811.build();
  Floor811.detect();
  if (!buttonLock) {
    Floor812.build();
    Floor812.detect();
  }

  Floor813.build();
  Floor813.detect();
}

void levelEight() {
  Floor71.build();
  Floor71.detect();
  if (!buttonLock) {
    Floor72.build();
    Floor72.detect();
  }
  Floor73.build();
  Floor73.detect();
  Floor74.build();
  Floor74.detect();
  Floor75.build();
  Floor75.detect();
  Floor76.build();
  Floor76.detect();
  Floor77.build();
  Floor77.detect();
  Floor78.build();
  Floor78.detect();
}

void levelSeven() {
  Floor61.build();
  Floor61.detect();
  Floor62.build();
  Floor62.detect();
  Floor63.build();
  Floor63.detect();
  Floor64.build();
  Floor64.detect();
  Floor65.build();
  Floor65.detect();
  if (!buttonLock) {//gate
    Floor66.build();
    Floor66.detect();
  }
}

void levelSix() {//sixth level
  Floor51.build();
  Floor51.detect();
  Floor52.build();
  Floor52.detect();
  Floor53.build();
  Floor53.detect();
  Floor54.build();
  Floor54.detect();
  Floor55.build();
  Floor55.detect();
  Floor56.build();
  Floor56.detect();
}

void levelFive() {// fifth level
  Floor41.build();
  Floor41.detect();
  Floor42.build();
  Floor42.detect();
  Floor43.build();
  Floor43.detect();
  Floor44.build();
  Floor44.detect();
}

void levelFour() {// fourth level
  Floor31.build();
  Floor31.detect();
  Floor32.build();
  Floor32.detect();
  Floor33.build();
  Floor33.detect();
  if (!buttonLock) {//gate
    Floor34.build();
    Floor34.detect();
  }
  Floor35.build();
  Floor35.detect();
  Floor36.build();
  Floor36.detect();
}

void levelThree() {//third level
  Floor21.build();
  Floor21.detect();
  Floor22.build();
  Floor22.detect();
  Floor23.build();
  Floor23.detect();
  Floor24.build();
  Floor24.detect();
}

void levelTwo() {

  Floor11.build();
  Floor11.detect();
  Floor12.build();
  Floor12.detect();
  Floor13.build();
  Floor13.detect();
  Floor14.build();
  Floor14.detect();
}

void levelOne() {

  Floor1.build();
  Floor1.detect();
  Floor2.build();
  Floor2.detect();
  Floor3.build();
  Floor3.detect();
  Floor4.build();
  Floor4.detect();
}

void initialize() {// initializes variables (desc. at top of code)
  playerPos = new PVector(250, 475);
  playerVel = new PVector(0, 0);
  jump = false;
  falling = false;
  moveLeft = false;
  moveRight = false;
  gameState = 0;
  playerAcc = new PVector(0, 0.9);
  airResist = 0.8;
  frict = 0.7;
  playerSpeed = 5;
  floor = height-25;
  gravity = 4.9;
  allowMove = true;
  collide = false;
  buttonLock = false;
  leftLocked = false;
  rightLocked = false;
  mayIPleaseJump = true;
}




void keyPressed() {//allows movement
  playerAcc.y = 0.9;// resets the acceleration in cases of collision. its in key pressed because you have to press keys to get off of the platform.
  if (keyCode == 68) {//D key
    if (!rightLocked) {
      moveRight = true;
    }
  } else if (keyCode == 65) {// A key 
    if (!leftLocked) {
      moveLeft = true;
    }
  } else if (keyCode == 87 && mayIPleaseJump) {//W key for jumping
//    if (!falling) {//SET FALLING VAR NOT FALSE
      jump = true;
      mayIPleaseJump = false;
  //  }
  }
  if (keyCode == 79) {// gomode keycodes to adane stages when you get softlocked
    gameState--;
  } else if (keyCode == 80) {
    gameState++;
  }
}

void keyReleased() {// stops movvement
  if (keyCode == 68) {//D key
    moveRight = false;
  } else if (keyCode == 65) {// A key 
    moveLeft = false;
  } else if (keyCode == 87) {//W key for jumping
    jump = false;
  }
}

void scaledRect(float x, float y, float w, float h) {//scales rectangles with the screen
  rect(x*width/500, y*height/500, w*width/500, h*height/500);
}
void scaledEllipse(float xBall, float yBall, float wBall, float hBall) {//scales ellipses with the screen
  ellipse(xBall*width/500, yBall*height/500, wBall*width/500, hBall*height/500);
}
void scaledText(String text, float x, float y) {//scales text w/screen
  text(text, x*width/500, y*height/500);
}




void updatePlayer() {

  if (moveRight && allowMove) {// moves the player left
    playerVel.x = 5;
  } else if (moveLeft && allowMove) {//moves player right
    playerVel.x = -5;
  } else {
    playerVel.x = 0;
  }
  if (jump) {//jumps player
    playerVel.y = -15;
    jump = false;
    falling = true;
  }
  if (falling) {
    playerPos.y += playerVel.y;// allows ball to move (Y)
    playerVel.y += playerAcc.y;// how fast ball moves down
    mayIPleaseJump = false;
  }
  if (!collide) {
    playerPos.x += playerVel.x;// allows ball to move (X)
    playerVel.x += playerAcc.x;// how fast ball moves down
  }

  if (playerPos.y >= floor) {// bounce dont go through the ground
    playerPos.y = floor;
    falling = false;
    mayIPleaseJump = true;
  }
  if (playerPos.x + 25 > width) {//right side
    playerPos.x = width-25;
  }
  if (playerPos.x - 25 < 0) {//left side 
    playerPos.x = 25;
  }

  playerColour = get(round(playerPos.x + 25), round(playerPos.y));
  leftPlayer = get(round(playerPos.x - 25), round(playerPos.y));
}






public class Wallfloor {//
  int floorX, floorY, floorW, floorH, twoX, twoY;// paramters for the floor
  String type;
  Wallfloor(int xFloor, int yFloor, int wFloor, int hFloor, String typeFloor, int xTwo, int yTwo) {//constructor
    floorX = xFloor;
    floorY = yFloor;
    floorW = wFloor;
    floorH = hFloor;
    type = typeFloor;// used to distinguish betw/ types of floors
    twoX = xTwo;//used for teleportation comms only
    twoY = yTwo;
  }

  void build() {
    if (type == "floor") {
      fill(235);//gray
    } else if (type == "endGoal") {
      fill(0, 255, 0);//green
    } else if (type == "tp1") {
      fill(200, 0, 200);//purple
    } else if (type == "tp2") {
      fill(230, 130, 50);//orange
    } else if (type == "death") {
      fill(255, 0, 0);//red
    } else if (type == "bouncing") {
      fill(0, 0, 255);//blue
    } else if (type == "button") {
      fill(0, 255, 255);//cyan
    } else if (type == "gate") {
      fill(200, 255, 255);// light cyan
    }
    scaledRect(floorX, floorY, floorW, floorH);
  }

  void detect() {

    float ballRightSide = playerPos.x+25;//sides of the player and sides of instance of floor.
    float ballLeftSide = playerPos.x-25;
    float ballTopSide = playerPos.y-25;
    float ballBottomSide = playerPos.y+25;
    float floorRightSide = floorX + floorW/2;
    float floorLeftSide = floorX - floorW/2;
    float floorTopSide = (floorY - floorH/2);
    float floorBottomSide = (floorY + floorH/2);



    pushMatrix();
    translate(width/2, height/2);//fixes the rotation around the center
    rotate(radians(setDifference/2.5));//sensitivity of rotation
    translate(-(width/2), -(height/2));
    PVector TopLeftSide = new PVector(floorLeftSide, floorTopSide);
    PVector BottomRightSide = new PVector(floorRightSide, floorBottomSide);

    if (ballBottomSide > TopLeftSide.y && ballTopSide < BottomRightSide.y && ballLeftSide < BottomRightSide.x && ballRightSide > TopLeftSide.x) {//general detect
      if (ballBottomSide > TopLeftSide.y && ballTopSide < floorBottomSide && playerVel.y != 0 && falling) {//top/bottom

        if (type == "floor") {//checks each different type of floor to see if it works.

          if (ballBottomSide > TopLeftSide.y && playerVel.y < 0) {//top
            playerPos.y = floorTopSide + 80;
          } 
          if (ballTopSide < BottomRightSide.y && playerVel.y > 0) {//bottom
            playerPos.y = floorBottomSide - 80;
            falling = false;
            mayIPleaseJump = true;
          } 
          playerVel.y = 0;//stops
        } else if (type == "endGoal") {
          gameState++;
          playerPos.x = 250;
          playerPos.y = floor;
          setDifference = 0;
          buttonLock = false;
        } else if (type == "tp1") {
          playerPos = playerPos.set(twoX, twoY);// teleports to new spot
        } else if (type == "tp2") {
          playerPos = playerPos.set(twoX, twoY);// teleports to new spot (basically same effect)
        } else if (type == "death") {
          gameState--;// resets to prior level
          playerPos.x = 250;
          playerPos.y = floor;
          setDifference = 0;
        } else if (type == "bouncing") {
          playerVel.y = -20;
        } else if (type == "button") {
          buttonLock = true;
        } else if (type == "gate") {// similar function as floor type.
          if (ballBottomSide > TopLeftSide.y && playerVel.y < 0) {//top
            playerPos.y = floorTopSide + 80;
          } 
          if (ballTopSide < BottomRightSide.y && playerVel.y > 0) {//bottom
            playerPos.y = floorBottomSide - 80;
            falling = false;
          } 
          playerVel.y = 0;//stops
        }
      }
      else if (ballLeftSide < BottomRightSide.x && ballRightSide > TopLeftSide.x && playerVel.y == 0 && !falling && keyCode == 65 || keyCode == 68) {//left/right

        int floorMidline = floorY;

        color floorCol = color(235);
        color gateCol = color(200, 255, 255);

        if (type == "floor") {
          allowMove = false;//needs proper left/right detect
          if (ballLeftSide < floorMidline && playerVel.y == 0 && playerVel.x > 0 && keyCode == 68 && leftPlayer == floorCol) {// right side detect
            rightLocked = true;
            playerPos.x = floorLeftSide - 25;
            collide = true;
          } else {
            rightLocked = false; 
            collide = false;
          }
          if (ballRightSide > floorMidline && playerVel.y == 0 && playerVel.x < 0 && keyCode == 65 && playerColour == floorCol) {//left side detect
            collide = true;
            leftLocked = true;
            playerPos.x = floorRightSide + 25;
          } else {
            leftLocked = false; 
            collide = false;
          }
        } else if (type == "endGoal") {// dont want inrement to happen twice
          buttonLock = false;// locks nthe gate againm
        } else if (type == "tp1") {
          playerPos = playerPos.set(twoX, twoY);// teleports to new spot
          falling = true;
        } else if (type == "tp2") {
          playerPos = playerPos.set(twoX, twoY);// teleports to new spot
          falling = true;
        } else if (type == "button") {
          buttonLock = true;
        } else if (type == "gate") {// if it still exsists its just like a floor
          allowMove = false;// COPY THE FLOOR DETECT
          if (ballLeftSide < floorMidline && playerVel.y == 0 && playerVel.x > 0 && leftPlayer == gateCol) {// right side detect
            rightLocked = true;
            playerPos.x = floorLeftSide - 25;
          } else {
            rightLocked = false;
          }
          if (ballRightSide > floorMidline && playerVel.y == 0 && playerVel.x < 0 && playerColour == gateCol) {//left side detect
            leftLocked = true;
            playerPos.x = floorRightSide + 25;
          } else {
            leftLocked = false;
          }
        }
      }
    } else {
      allowMove = true;
      leftLocked = false;
      rightLocked = false;
    }
    popMatrix();
  }
}
