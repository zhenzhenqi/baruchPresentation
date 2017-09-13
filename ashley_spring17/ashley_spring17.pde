import processing.video.*;
import processing.sound.*;

int cellSize = 20; 
int cols, rows; 
Capture cam; 
int oldPixels[]; 
int drawCounter; 
PImage img;
int time;
PFont f;
color textColor;
SoundFile soundFile;
String subtitleText;
String subtitles[] = {"HEY! YOU'RE GREAT AND I LOVE YOU!!!", 
  "i am so proud of you :-)", 
  "today is your day!!!", 
  "it's okay to have your own idea of success", 
  "you have a beautiful heart", 
  "go get 'em, tiger!!!", 
  "shoutout to you for being alive", 
  "don't be so hard on yourself", 
  "give it some time... relax for now~", 
  "you are looking lovely today", 
  "you have every right to like who you are", 
  "your feelings are valid", 
  "!!! you deserve it !!!", 
  "you are worthy today and every day", 
  "don't forget to treat yourself well", 
  "i'm cheering for you! woohooo!!"};
int movementDetectedLocationsX[] = {};
int movementDetectedLocationsY[] = {};
int timestamps[] = {};
color colors[] = {color(237, 227, 37), color(144, 226, 142), color(249, 182, 227), 
color(149, 226, 219), color(174, 237, 168), color(221, 93, 88), color(117, 168, 249),
color(249, 187, 116),color(239, 182, 174), color(218, 168, 255)};


void setup() { 
  size(1280, 720); 
  cam = new Capture(this, 1280, 720); 
  cols = 1280/cellSize;
  rows = 720/cellSize;
  cam.start(); 
  oldPixels = new int[1280*720];
  drawCounter = 0;
  time = millis();
  f = loadFont("AvenirNext-Bold-48.vlw");
  soundFile = new SoundFile(this, "animalcrossing.mp3");
  soundFile.loop();
  img = loadImage("images/sparkles.png");
  textAlign(CENTER, CENTER);
}

void draw() { 
  if (cam.available() == true) {
    cam.read(); 
    cam.loadPixels(); 
    for (int i = 0; i < cols; i++) {
      for (int j =0; j < rows; j++) {
        int avgRed = 0; 
        int avgGreen = 0; 
        int avgBlue = 0; 
        int numPixels = 0; 
        for (int x1 = 0; x1 < cellSize-1; x1++) { 
          for (int y1 = 0; y1 < cellSize-1; y1++) {
            int x = i * cellSize + x1; 
            int y = j * cellSize + y1; 
            int loc = (cam.width - x) + y * cam.width; 
            avgRed = avgRed + int(red(cam.pixels[loc]));
            avgGreen = avgGreen + int(green(cam.pixels[loc]));
            avgBlue = avgBlue + int(blue(cam.pixels[loc]));
            numPixels = numPixels + 1;
          }
        }
        color avgRGB = color(avgRed/numPixels, avgGreen/numPixels, avgBlue/numPixels);
        numPixels = 0;
        int x = i * cellSize;
        int y = j * cellSize;
        int loc = (cam.width - x) + y * cam.width;
        cam.pixels[loc] = avgRGB;
        if (drawCounter > 10) {
          float distance = dist(red(cam.pixels[loc]), green(cam.pixels[loc]), blue(cam.pixels[loc]), red(oldPixels[loc]), green(oldPixels[loc]), blue(oldPixels[loc]));
          color c = cam.pixels[loc];
          if (distance > 50.0) {
            if (millis() > time) {
              time = millis() + 3000;
              textColor = colors[int(random(colors.length))];
              subtitleText = subtitles[int(random(subtitles.length))];
            }
            if (int(random(100)) % 7 == 0) {
              movementDetectedLocationsX = append(movementDetectedLocationsX, x);
              movementDetectedLocationsY = append(movementDetectedLocationsY, y);
              timestamps = append(timestamps, millis() + 500);
            }
            if (movementDetectedLocationsX.length > 35) {
              movementDetectedLocationsX = new int[0];
              movementDetectedLocationsY = new int[0];
              timestamps = new int[0];
            }
          }
        }
      }
    }
  }
  image(cam, 0, 0, width, height);
  if (millis() < time) {
    textFont(f, 50);
    fill(textColor);
    text(subtitleText, width/2, height - height/6);
  }
  arrayCopy(cam.pixels, oldPixels);
  drawCounter = drawCounter + 1;
  for (int ctr = 0; ctr < movementDetectedLocationsX.length; ctr++) {
    if (millis() < timestamps[ctr]) {
      imageMode(CENTER);   
      image(img, cam.width - movementDetectedLocationsX[ctr], cam.height - movementDetectedLocationsY[ctr], 200, 200);
      imageMode(CORNER);
    }
  }
}