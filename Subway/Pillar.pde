class Pillar implements Comparable<Pillar> {
  int size;
  int dist;
  int x; 
  int y = blockHeight;
  int pillarHeight = blockHeight;
  int left;
  int right;
  
  Pillar(int _x, int _dist) {
    x = _x;
    dist = _dist;
    size = (int)map(1 / dist, 0, 1, 30, 50);
    left = x - size / 2;
    right = left + size;
  }

  
  void draw() {
    fill(0);
    rect(left, y, size, pillarHeight);
  }
  
  public int compareTo(Pillar pillar) {
    return (int) (x - pillar.x);
  }
}
