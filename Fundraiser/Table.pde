class StandingTable {
  int x;
  int y;
  boolean hovered = false;
  boolean selected = false;
  
  StandingTable(int _x, int _y) {
    x = _x;
    y = _y;
  }
  
  void draw() {
    strokeWeight(1);
    if(hovered == false && selected == false)
    noStroke();
    else stroke(0);
    fill(200);
    ellipse(x, y, tableSize, tableSize);
  }
}
