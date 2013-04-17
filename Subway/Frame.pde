class Frame {
  PImage img;
  int x;
  int y;
  int w;
  int h;
  boolean isSelected = false;
  
  Frame(PImage _img, int _x, int _y, int _w, int _h) {
    img = _img;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  
  void updateImg(PImage _img) {
    img = _img;
  }
  
//  void checkSelected() {
//    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) isSelected = true;
//  }
  
  void draw() {
    image(img, x, y);
    if(isSelected) {
      noFill();
      stroke(0, 200, 0);
      strokeWeight(5);
      rect(x, y, w, h);
    }
  }
}
