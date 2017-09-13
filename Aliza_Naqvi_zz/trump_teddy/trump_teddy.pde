//Code for words
import processing.serial.*;

Serial myPort; //create object serial class
int val;

float red_prob;
String[] negative = {"Build A Wall", "They're All Terrorists", "Minority", "Criminals, Drug Dealers & Rapists", "Moron"};
String[] positive = {"Break the Wall", "Their One of Us", "Love", "Peace", "Respect"};

Phrase[] phrases = new Phrase[20];

void setup() {
//  fullScreen();
  size(1500, 900);
  red_prob = 0;
  background(255);
  printArray(Serial.list());
  String portName = Serial.list()[7];
  myPort = new Serial(this, portName, 9600);
  //in the begining, set up every phrase to display negative and record the time
  for (int i = 0; i < phrases.length; i ++ ) {
    phrases[i] = new Phrase();
  }
}

void draw() {


  if (myPort.available() > 0) { //if data is available 
    val = myPort.read(); //read it and store
  }

  println(val);

  background(255);

  textSize(12);
  text(frameRate, 10, 20);

  // arduino code goes in mouseX , also replace width with sensor value of soft potentiometer 
  //  red_prob = map(val, 0, 255, 0, 1);   // 60% chance of red color
  if (val<10) {
    red_prob = 1;
  } else {
    red_prob = 0;
  }



  for (int i = 0; i < phrases.length; i++) {
    phrases[i].display();
    phrases[i].timeUp();
    if (phrases[i].fading) {
      phrases[i].fade(red_prob);
    }
  }
}
