ArrayList<StandingTable> tables1 = new ArrayList();
ArrayList<StandingTable> tables2 = new ArrayList();
ArrayList<GuitarString> strings = new ArrayList();

int tableSize = 48;
int roomSize = 360;
int makeBigger = 2;
int dist = 100;

int index1 = -1;
int index2 = -1;

PVector p1 = new PVector();
PVector p2 = new PVector();

PVector mouse = new PVector();



void setup() {
  size(roomSize * makeBigger, roomSize * makeBigger);

  for (int i = 0; i < 9; i++) {
    StandingTable table = new StandingTable(150 + i * dist / 2, 100 + (i % 2) * dist);
    tables1.add(table);
    table.draw();
  }

  for (int i = 0; i < 9; i++) {
    StandingTable table = new StandingTable(150 + i * dist / 2, height - 100 - (i % 2) * dist);
    tables2.add(table);
    table.draw();
  }
}

void draw() {
  background(255);

  isAnythingHovered();

  if (index1 != -1 && index2 != -1) {
    strings.add(new GuitarString(index1, index2));
    index1 = -1;
    index2 = -1;
  }

  drawEverything();
  println("Strings: "+ strings.size());
}

void mousePressed() {
  for (int i = 0; i < tables1.size(); i++) {
    if ( (mouseX < tables1.get(i).x + tableSize && mouseX > tables1.get(i).x - tableSize)
      && (mouseY < tables1.get(i).y + tableSize && mouseY > tables1.get(i).y - tableSize) 
      && index1 == -1) {
      index1 = i;
      tables1.get(i).selected = true;
      println("index1: " + index1);
    }
  }

  for (int i = 0; i < tables2.size(); i++) {
    if ( (mouseX < tables2.get(i).x + tableSize && mouseX > tables2.get(i).x - tableSize)
      && (mouseY < tables2.get(i).y + tableSize && mouseY > tables2.get(i).y - tableSize) 
      && index2 == -1) {
      index2 = i;
      tables2.get(i).selected = true;
      //println("index2: " + index2);
    }
  }
}


void isAnythingHovered() {
  for (int i = 0; i < tables1.size(); i++) {
    if ( (mouseX < tables1.get(i).x + tableSize && mouseX > tables1.get(i).x - tableSize)
      && (mouseY < tables1.get(i).y + tableSize && mouseY > tables1.get(i).y - tableSize) ) {
      tables1.get(i).hovered = true;
    }
    else {
      tables1.get(i).hovered = false;
    }
  }

  for (int i = 0; i < tables2.size(); i++) {
    if ( (mouseX < tables2.get(i).x + tableSize && mouseX > tables2.get(i).x - tableSize)
      && (mouseY < tables2.get(i).y + tableSize && mouseY > tables2.get(i).y - tableSize) ) {
      tables2.get(i).hovered = true;
    }
    else {
      tables2.get(i).hovered = false;
    }
  }

  mouse.set(mouseX, mouseY, 0);
  for (int i = 0; i < strings.size(); i++) {
    p1.set(tables1.get(strings.get(i).index1).x, tables1.get(strings.get(i).index1).y, 0);
    p2.set(tables2.get(strings.get(i).index2).x, tables2.get(strings.get(i).index2).y, 0);
    if (pointInsideLine(mouse, p1, p2, 8)) {
      strings.get(i).hovered = true;
      if (strings.get(i).isShaking == false) {
        strings.get(i).isShaking = true;
        strings.get(i).setShakePoint(mouse.x, mouse.y);
      }
    }
    else strings.get(i).hovered = false;
  }
}

void drawEverything() {
  for (int i = 0; i < strings.size(); i++) {
    if(millis() - strings.get(i).bornTime < 10000) {
    strings.get(i).updateControlPoint();
    strings.get(i).draw();
    } else {
      tables1.get(strings.get(i).index1).selected = false;
      tables2.get(strings.get(i).index2).selected = false;
      strings.remove(i);
    }
  }

  for (int i = 0; i < tables1.size(); i++) {
    tables1.get(i).draw();
  }

  for (int i = 0; i < tables2.size(); i++) {
    tables2.get(i).draw();
  }
}

/**
 * PVector thePoint 
 * the point we will check if it is close to our line.
 *
 * PVector theLineEndPoint1 
 * one end of the line.
 *
 * PVector theLineEndPoint2
 * the second end of the line.
 *
 * int theTolerance 
 * how close thePoint must be to our line to be recogized.
 */
boolean pointInsideLine(PVector thePoint, 
PVector theLineEndPoint1, 
PVector theLineEndPoint2, 
int theTolerance) {

  PVector dir = new PVector(theLineEndPoint2.x, 
  theLineEndPoint2.y, 
  theLineEndPoint2.z);
  dir.sub(theLineEndPoint1);
  PVector diff = new PVector(thePoint.x, thePoint.y, 0);
  diff.sub(theLineEndPoint1);

  // inside distance determines the weighting 
  // between linePoint1 and linePoint2 
  float insideDistance = diff.dot(dir) / dir.dot(dir);

  if (insideDistance>0 && insideDistance<1) {
    // thePoint is inside/close to 
    // the line if insideDistance>0 or <1
//    println( ((insideDistance<0.5) ? 
//    "closer to p1":"closer to p2" ) + 
//      "\t p1:"+nf((1-insideDistance), 1, 2)+
//      " / p2:"+nf(insideDistance, 1, 2) );

    PVector closest = new PVector(theLineEndPoint1.x, 
    theLineEndPoint1.y, 
    theLineEndPoint1.z);
    dir.mult(insideDistance);
    closest.add(dir);
    PVector d = new PVector(thePoint.x, thePoint.y, 0);
    d.sub(closest);
    // println((insideDistance>0.5) ? "b":"a");
    float distsqr = d.dot(d);

    // check the distance of thePoint to the line against our tolerance. 
    return (distsqr < pow(theTolerance, 2));
  }
  return false;
}

