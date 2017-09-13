class Phrase {
  // Phrase variables
  //alpha controls transparency
  float x, y, alpha;
  float sensorProb;
  int index;
  int margin;
  //wait for a few seconds before fading out and reappear somewhere else
  int wait;
  //last time phrase was updated
  int time; 
  boolean fading;
  String myText;
  color myCol;
  int mySize;
  color positiveCol, negativeCol;
  int fadeSpeed = 10;

  // Phrase constructor
  // the tempS is the potentiometer S
  Phrase() {
    x = random(margin, width-margin);
    y = random(margin, height-margin); 
    index = int(random(negative.length));  
    margin = 50;
    myText = negative[index];
    mySize = int(random(10, 25)); 
    alpha = 255;
    //randomly wait 2 to 3 second
    wait = int(random(2000, 3000));
    //record system time when phrase first appear; 
    time = millis();
    fading = false;
    sensorProb = 0;
    positiveCol = color(0, 0, 255);
    negativeCol = color(255, 0, 0);
    myCol = negativeCol;
  }



  //fade out, if already faded out then regenerate a new phrase according to red_prob and put it somewhere else on screen
  void fade(float prob) {
    if (alpha>0) {
      alpha -= fadeSpeed;
    } else {
      fading = false;
      time = millis();
      sensorProb = prob;
      float num = random(0, 1); 
      index = int(random(negative.length)); 
      if (num > sensorProb) {
        myCol = negativeCol;
        myText = negative[index];
        // If random number is between .6 and .7
      } else {
        myCol = positiveCol;
        myText = positive[index];
      }
      alpha = 255;
      x = random(margin, width-margin);
      y = random(margin, height-margin);
      mySize = int(random(10, 25)); 
      wait = int(random(2000, 3000));
    }
  }

  void timeUp() {
    if (millis()-time >= wait) {
      fading = true;
      //println(fading);
    }
  }

  void display() {
    textSize(mySize);
    fill(myCol, alpha);
    text(myText, x, y);
  }
  
}
