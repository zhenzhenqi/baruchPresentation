/**
 *Two-Faced
 *Roxanne Branford
 *Two-Faced
 *@updated 12/11/2016
 */

import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import ddf.minim.*;

AudioPlayer player;
Minim minim;

Capture video;
OpenCV opencv;
PImage img;
ArrayList<Face> faceList;
int faceCount = 0;
String [] Words  = {"Beautiful", "Gorgeous", "Royalty", "Amazing", "Inspiring", "Awesome", "Brave", "Attractive", "Pretty", "Lit", "Accomplished", "Fabulous"};
Rectangle[] faces;


void setup() {
  fullScreen();
  //size(640, 480);
  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faceList = new ArrayList<Face>();
  video.start();
  img = loadImage("crown.png");
  PFont f = loadFont( "ARCHRISTY-48.vlw" );
  textFont(f);  
  minim = new Minim(this);
  player = minim.loadFile("Formation.mp3");
}

void draw() {
  opencv.loadImage(video);
  image(video, 0, 0 );
  detectFaces();

  //filter
  for (int i = 0; i < width/2; i = i+1)
  {
    for (int j = 0; j < height; j=j+1)
    {
      color px = video.get(i, j);
      float r= red(px);
      float g= green(px);
      float b= blue(px);
      float T=0;
      float C= (r+b+g) % 255;
      if (C<40)
      {
        T= 0;
      }
      if (C>39)
      {
        T= 255;
      }
      colorMode(HSB);
      color c= color (C, C, C, T);
      set(i, j, c);
      colorMode(RGB);
    }
  }

  // Draw all the faces
  for (int i = 0; i < faces.length; i++) {
    noFill();
    //rect(faces[i].x*scl,faces[i].y*scl,faces[i].width*scl,faces[i].height*scl);


    //random text,music and crown depending on side face is on    
    //if (faces[i].x < width/2) {      
    //  fill(0);
    //  text(Words [ int (random(12))], random(0, width/2), random(height) );
    //  image(img, faces[i].x, faces[i].y-100, faces[i].width +50, faces[i].height*2);
    //  player.play();
    //} else if (player.isPlaying()) {
    //  player.pause();
    //}
  }


  for (Face f : faceList) {
    //strokeWeight(2);
    f.display();
  }
}

void detectFaces() {
  // Faces detected in this frame
  faces = opencv.detect();

  // SCENARIO 1 
  // faceList is empty
  if (faceList.isEmpty()) {
    // Just make a Face object for every face Rectangle
    for (int i = 0; i < faces.length; i++) {
      println("+++ New face detected with ID: " + faceCount);
      faceList.add(new Face(faces[i].x, faces[i].y, faces[i].width, faces[i].height));
      faceCount++;
    }

    // SCENARIO 2 
    // We have fewer Face objects than face Rectangles found from OPENCV
  } else if (faceList.size() <= faces.length) {
    boolean[] used = new boolean[faces.length];
    // Match existing Face objects with a Rectangle
    for (Face f : faceList) {
      // Find faces[index] that is closest to face f
      // set used[index] to true so that it can't be used twice
      float record = 50000;
      int index = -1;
      for (int i = 0; i < faces.length; i++) {
        float d = dist(faces[i].x, faces[i].y, f.r.x, f.r.y);
        if (d < record && !used[i]) {
          record = d;
          index = i;
        }
      }
      // Update Face object location
      used[index] = true;
      f.update(faces[index]);
    }
    // Add any unused faces
    for (int i = 0; i < faces.length; i++) {
      if (!used[i]) {
        println("+++ New face detected with ID: " + faceCount);
        faceList.add(new Face(faces[i].x, faces[i].y, faces[i].width, faces[i].height));
        faceCount++;
      }
    }

    // SCENARIO 3 
    // We have more Face objects than face Rectangles found
  } else {
    // All Face objects start out as available
    for (Face f : faceList) {
      f.available = true;
    } 
    // Match Rectangle with a Face object
    for (int i = 0; i < faces.length; i++) {
      // Find face object closest to faces[i] Rectangle
      // set available to false
      float record = 50000;
      int index = -1;
      for (int j = 0; j < faceList.size(); j++) {
        Face f = faceList.get(j);
        float d = dist(faces[i].x, faces[i].y, f.r.x, f.r.y);
        if (d < record && f.available) {
          record = d;
          index = j;
        }
      }
      // Update Face object location
      Face f = faceList.get(index);
      f.available = false;
      f.update(faces[i]);
    } 
    // Start to kill any left over Face objects
    for (Face f : faceList) {
      if (f.available) {
        f.countDown();
        if (f.dead()) {
          f.delete = true;
        }
      }
    }
  }

  // Delete any that should be deleted
  //for (int i = faceList.size()-1; i >= 0; i--) {
  //  Face f = faceList.get(i);
  //  if (f.delete) {
  //    faceList.remove(i);
  //  }
  //}
}

void captureEvent(Capture c) {
  c.read();
}