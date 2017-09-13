int n = 20;
float minRad = 1;
float maxRad = 100;
float nfAng = 0.08;
float nfTime = 0.00001;
float theta = 0;
float speed = 0.3;

void setup() {
  size(displayWidth, displayHeight);
  background(#ffffff);
  noFill();
 
}


void draw(){
  drawShape();
}

  
void drawShape(){ 
  stroke(255,87,80,10);
  translate(mouseX, mouseY);
  rotate(theta);
  beginShape();
  for (int i=0; i<n; i++) {
    float ang = map(i, 0, n, 0, TAU);
    float rad = map(noise(i*nfAng, nfTime), 0, 1, minRad, maxRad);
    float x = rad * cos(ang);
    float y = rad * sin(ang);
    curveVertex(x, y);
  }
  endShape(CLOSE);
  theta += 0.08;
  maxRad = maxRad + speed;
  if ((maxRad > 500) || (maxRad < 100)) {
    // If the object reaches either edge, multiply speed by -1 to turn it around.
    speed = speed * -1;
  }
}

void mousePressed() {
 background(#ffffff);
  beginShape();
  curveVertex(random(width), random(height));
  }

void keyPressed() {
  if (key == '1') {
save("motion.pdf");}
else{
  background(#ffffff);
  beginShape();
  curveVertex(random(width), random(height));
}
  }