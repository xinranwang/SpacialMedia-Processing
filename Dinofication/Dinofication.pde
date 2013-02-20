/* --------------------------------------------------------------------------
 * Dinofication
 * --------------------------------------------------------------------------
 * prog:  Xinran Wang / Ju Young Park
 * date:  02/19/2013
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
PImage dinoHead;
SimpleOpenNI  context;
boolean       autoCalib=true;

float ratio = 1;
float imgWidth = 200; 
float imgHeight = imgWidth / ratio;

PVector      LeftHandVec = new PVector();
PVector      LeftElbowVec = new PVector();
PVector      LeftHandOnScreenVec = new PVector();
PVector      LeftElbowOnScreenVec = new PVector();
float kinectTrackingSpeed = 0.5;
  
void setup()
{
  context = new SimpleOpenNI(this);
  context.enableRGB();
   
  // enable depthMap generation 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  

  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  dinoHead = loadImage("dinohead.png");
  background(200,0,0);

  stroke(0,0,255);
  strokeWeight(3);
  smooth();
  
  size(context.rgbWidth(), context.rgbHeight());
}

void draw()
{
  // update the cam
  context.update();
  
  // draw rgbImageMap
  image(context.rgbImage(), 0, 0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i])) {
      getHandsPos(userList[i]);
      drawDino();
    }
  }
}

void drawDino() {
  pushMatrix();  

  float a = atan2((LeftElbowOnScreenVec.y - LeftHandOnScreenVec.y), (LeftElbowOnScreenVec.x - LeftHandOnScreenVec.x));
  translate((LeftHandOnScreenVec.x + (LeftElbowOnScreenVec.x - LeftHandOnScreenVec.x) / 2), (LeftHandOnScreenVec.y + (LeftElbowOnScreenVec.y - LeftHandOnScreenVec.y) / 2));
  rotate(0.9 * a);
  image(dinoHead, -imgWidth/2, -imgHeight/2, imgWidth, imgHeight);

  popMatrix();

}

void getHandsPos(int userId) {

  float confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,LeftHandVec);
  
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,LeftElbowVec);

  LeftHandOnScreenVec.x = width / 2 + LeftHandVec.x * kinectTrackingSpeed;
  LeftHandOnScreenVec.y = height / 2 - LeftHandVec.y * kinectTrackingSpeed;
  LeftHandOnScreenVec.z = -LeftHandVec.z * kinectTrackingSpeed + 1000;
  
  LeftElbowOnScreenVec.x = width / 2 + LeftElbowVec.x * kinectTrackingSpeed;
  LeftElbowOnScreenVec.y = height / 2 - LeftElbowVec.y * kinectTrackingSpeed;
  LeftElbowOnScreenVec.z = -LeftElbowVec.z * kinectTrackingSpeed + 1000;

} 


// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");
  
  if(autoCalib)
    context.requestCalibrationSkeleton(userId,true);
  else    
    context.startPoseDetection("Psi",userId);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void onExitUser(int userId)
{
  println("onExitUser - userId: " + userId);
}

void onReEnterUser(int userId)
{
  println("onReEnterUser - userId: " + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
  
  if (successfull) 
  { 
    println("  User calibrated !!!");
    context.startTrackingSkeleton(userId); 
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    context.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose,int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");
  
  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);
 
}

void onEndPose(String pose,int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}




