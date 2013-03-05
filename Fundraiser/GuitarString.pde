class GuitarString {
  long bornTime;
  int index1;
  int index2;
  float shakeRange = 2;
  float shakeSpeed = 2.2;
  boolean isShaking = false;

  PVector shakePoint = new PVector();
  PVector controlPoint = new PVector();

  color stringColor;
  boolean hovered = false;
  float k;
  float b;
  int shakeCount = 0;

  GuitarString(int _index1, int _index2) {
    bornTime = millis();
    index1 = _index1;
    index2 = _index2;
    stringColor = color(random(255), random(255), random(255));
    controlPoint.set(tables2.get(index2).x, tables2.get(index2).y, 0);
    k = (tables2.get(index2).x - tables1.get(index1).x) / (tables2.get(index2).y - tables1.get(index1).y);
  }

  void setShakePoint(float _x, float _y) {
    shakePoint.set(_x, _y, 0);
    controlPoint.set(_x, _y, 0);
    b = -_y - k * _x;
  }

  void updateControlPoint() {
    if (isShaking == true) {
      controlPoint.x += shakeSpeed;
      //controlPoint.y -= shakeSpeed * k + b;
      if (controlPoint.x > shakePoint.x + shakeRange || controlPoint.x < shakePoint.x - shakeRange) {
        shakeSpeed *= -1;
        shakeCount++;
      }
      if (shakeCount > 20) {
        shakeCount = 0;
        isShaking = false;
        controlPoint.set(tables2.get(index2).x, tables2.get(index2).y, 0);
      }
    }
  }

  void draw() {
    
    stroke(stringColor);
    noFill();
//    if (hovered) strokeWeight(3);
//    else strokeWeight(1);
    beginShape();
    vertex(tables1.get(index1).x, tables1.get(index1).y);
    bezierVertex(controlPoint.x, controlPoint.y, tables2.get(index2).x, tables2.get(index2).y, tables2.get(index2).x, tables2.get(index2).y);
    endShape();
    //line(tables1.get(index1).x, tables1.get(index1).y, tables2.get(index2).x, tables2.get(index2).y);
  }
}

