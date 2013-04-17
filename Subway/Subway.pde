import processing.video.*;
import java.util.*;

Capture cam;

int blockHeight;

ArrayList<Pillar> pillars = new ArrayList<Pillar>();
ArrayList<Frame> frames = new ArrayList<Frame>();

PGraphics pg;

void setup() {
  size(1280, 720);

  blockHeight = height / 3;

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();
  }

  pg = createGraphics(width, height);

  // add pillars
  for (int i = 0; i < 5; i++) {
    pillars.add(new Pillar(100 + i * 300, 1));
  }

  for (int i = 0; i < 10; i++) {
    pillars.add(new Pillar(40 + i * 200, 3));
  }

  // sort pillars
  Collections.sort(pillars);

  // add frames
  for (int i = 0; i < pillars.size() - 1; i++) {
    if (pillars.get(i+1).left - pillars.get(i).right > 0 && pillars.get(i+1).right < width) {
      PImage img;
      Frame frame;
      if (i == 0) {
        img = cam.get(0, pillars.get(i).y, pillars.get(i+1).left, pillars.get(i).pillarHeight);
        frame = new Frame(img, 0, pillars.get(i).y, pillars.get(i+1).left, pillars.get(i).pillarHeight);
      }
      else
      {
        img = cam.get((int)pillars.get(i).right, (int)pillars.get(i).y, (int)(pillars.get(i+1).left - pillars.get(i).right), (int)pillars.get(i).pillarHeight);
        frame = new Frame(img, pillars.get(i).right, pillars.get(i).y, pillars.get(i+1).left - pillars.get(i).right, pillars.get(i).pillarHeight);
      }
      frames.add(frame);
    }
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();

    //    pushMatrix();
    //    scale(-1, 1);
    //    translate(-cam.width, 0);
    //    image(cam, 0, 0);
    //    popMatrix();
    // The following does the same, and is faster when just drawing the image
    // without any additional resizing, transformations, or tint.
    //set(0, 0, cam);
    
    background(0);
    // draw pillars
//    noStroke();
//    fill(0);
//    rect(0, 0, width, blockHeight);
//    rect(0, height - blockHeight, width, blockHeight);
//
//    for (int i = 0; i < pillars.size(); i++) {
//      pillars.get(i).draw();
//      //println(pillars.get(i).x);
//    }

    // update frames
    for (int i = 0; i < frames.size(); i++) {
      PImage img = cam.get((int)frames.get(i).x, (int)frames.get(i).y, (int)frames.get(i).w, (int)frames.get(i).h);
      if (!frames.get(i).isSelected) {
        frames.get(i).updateImg(img);
      }
      //frames.get(i).checkSelected();
      frames.get(i).draw();
    }

    int count = 0;
    for (int i = 0; i < frames.size(); i++) {
      if (frames.get(i).isSelected == true) count++;
    }
    
    if (count == frames.size()) {
      pg.beginDraw();
      pg.background(0);
      for (int i = 0; i < frames.size(); i++) {
        PImage img = frames.get(i).img;
        pg.image(img, frames.get(i).x, frames.get(i).y);
        frames.get(i).isSelected = false;
      }
      pg.endDraw();
      pg.save("pic"+ year() + "_" + month()+ "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + "_" + millis() +".png");
      println("image saved.");
    }
  }
}

void mouseClicked() {
  for(int i = 0; i < frames.size(); i++) {
    if(mouseX > frames.get(i).x && mouseX < frames.get(i).x+frames.get(i).w && mouseY > frames.get(i).y && mouseY < frames.get(i).y+frames.get(i).h) 
      frames.get(i).isSelected = true;
  }
}

