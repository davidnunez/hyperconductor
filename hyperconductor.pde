import de.voidplus.leapmotion.*;
// Add the library to the sketch
import signal.library.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

// -----------------------------------------------------
// Create the filter
SignalFilter rightHandYFilter;
SignalFilter rightHandZFilter;
SignalFilter rightHandXFilter, leftHandXFilter;
// -----------------------------------------------------

// Main OneEuroFilter parameters
float minCutoff = 0.05; // decrease this to get rid of slow speed jitter
float beta      = 4.0;  // increase this to get rid of high speed lag

float xPos = 0;
float textBgHeight = 30;
color textBgColor = color(150);
float sectionSize = 0;

float x1, x2 = 0;
float rightHandYPrev, rightHandYFiltered, rightHandYFilteredPrev;
float rightHandZPrev, rightHandZFiltered, rightHandZFilteredPrev;


float leftHandXPrev, leftHandXFiltered, leftHandXFilteredPrev;
float rightHandXPrev, rightHandXFiltered, rightHandXFilteredPrev;

float rightHandYUpBeatX, rightHandYUpBeatXPrev;
float rightHandYUpBeatY, rightHandYUpBeatYPrev;
float rightHandYDownBeatX, rightHandYDownBeatXPrev;
float rightHandYDownBeatY, rightHandYDownBeatYPrev;

float rightHandXUpBeatX, rightHandXUpBeatXPrev;
float rightHandXUpBeatY, rightHandXUpBeatYPrev;
float rightHandXDownBeatX, rightHandXDownBeatXPrev;
float rightHandXDownBeatY, rightHandXDownBeatYPrev;

float leftHandXUpBeatX, leftHandXUpBeatXPrev;
float leftHandXUpBeatY, leftHandXUpBeatYPrev;
float leftHandXDownBeatX, leftHandXDownBeatXPrev;
float leftHandXDownBeatY, leftHandXDownBeatYPrev;





float rightHandYSlope, rightHandYSlopePrev = 0;
float rightHandXSlope, rightHandXSlopePrev = 0;
float leftHandXSlope, leftHandXSlopePrev = 0;

float bpm = 0;
float dynamics = 0;
float registration = 0;
float weighting = 0;
float articulation = 0;
LeapMotion leap;

void setup(){
    //size(800, 500, OPENGL);
    size(512,512);
    background(180);
    sectionSize = height / 3.0;

    oscP5 = new OscP5(this,12001);
    myRemoteLocation = new NetAddress("127.0.0.1",12002);

    // ...
    rightHandYFilter = new SignalFilter(this);
    rightHandZFilter = new SignalFilter(this);
    rightHandXFilter = new SignalFilter(this);
    leftHandXFilter = new SignalFilter(this);
    leap = new LeapMotion(this);
}

void draw(){
    //background(255);
    // ...
    int fps = leap.getFrameRate();

    try {
    // ========= HANDS =========
	//HandList hands = frame.hands();
    //Hand leftmost = hands.leftmost();
    Hand leftHand = leap.getLeftHand();
    Hand rightHand = leap.getRightHand();
    // ----- BASICS -----

    // int     hand_id          = hand.getId();
    // PVector hand_position    = hand.getPosition();
    // PVector hand_stabilized  = hand.getStabilizedPosition();
    // PVector hand_direction   = hand.getDirection();
    // PVector hand_dynamics    = hand.getDynamics();
    // float   hand_roll        = hand.getRoll();
    // float   hand_pitch       = hand.getPitch();
    // float   hand_yaw         = hand.getYaw();
    // boolean hand_is_left     = hand.isLeft();
    // boolean hand_is_right    = hand.isRight();
    // float   hand_grab        = hand.getGrabStrength();
    // float   hand_pinch       = hand.getPinchStrength();
    // float   hand_time        = hand.getTimeVisible();
    // PVector sphere_position  = hand.getSpherePosition();
    // float   sphere_radius    = hand.getSphereRadius();

    leftHand.drawSphere();
    rightHand.drawSphere();
    float leftHandX = map(leftHand.getPosition().x, 0, 500, 0,1);
    float leftHandY = map(leftHand.getPosition().y, 0, 500, 0,1);
    float leftHandZ = map(leftHand.getPosition().z, 0, 100, 0,1);
    float rightHandX = map(rightHand.getPosition().x, 0, 500, 0, 1);
    float rightHandY = map(rightHand.getPosition().y, 0, 500, 0,1);
    float rightHandZ = map(rightHand.getPosition().z, 0, 100, 0,1);
    

    drawSignal(leftHandX, leftHandY, leftHandZ, rightHandX, rightHandY, rightHandZ);


//    drawSignal(map(handY,0,500,0,1), map(handY, 0,500,0,1));
} catch (Exception e) {
	System.out.println(e.toString());
}

}

// ========= CALLBACKS =========

void leapOnInit(){
    // println("Leap Motion Init");
}
void leapOnConnect(){
    // println("Leap Motion Connect");
}
void leapOnFrame(){
    // println("Leap Motion Frame");
}
void leapOnDisconnect(){
    // println("Leap Motion Disconnect");
}
void leapOnExit(){
    // println("Leap Motion Exit");
}





void drawSignal(float leftHandX, float leftHandY, float leftHandZ, float rightHandX, float rightHandY, float rightHandZ)
{


  // Pass the parameters to the filter
  rightHandYFilter.setMinCutoff(minCutoff);
  rightHandYFilter.setBeta(beta);
  rightHandZFilter.setMinCutoff(minCutoff);
  rightHandZFilter.setBeta(beta);
  leftHandXFilter.setMinCutoff(minCutoff);
  leftHandXFilter.setBeta(beta);
  rightHandXFilter.setMinCutoff(minCutoff);
  rightHandXFilter.setBeta(beta);

  // Save previous values (needed to draw the lines)
  rightHandYPrev = rightHandY;
  rightHandYFilteredPrev = rightHandYFiltered;
  
  rightHandZPrev = rightHandZ;
  rightHandZFilteredPrev = rightHandZFiltered;

  leftHandXPrev = leftHandX;
  leftHandXFilteredPrev = leftHandXFiltered;

  rightHandXPrev = rightHandX;
  rightHandXFilteredPrev = rightHandXFiltered;

  // -----------------------------------------------------
  // Filter the signal [THIS IS THE IMPORTANT LINE HERE!]
  rightHandYFiltered = rightHandYFilter.filterUnitFloat( rightHandY );
  rightHandZFiltered = rightHandZFilter.filterUnitFloat( rightHandZ );

  rightHandXFiltered = rightHandXFilter.filterUnitFloat( rightHandX );
  leftHandXFiltered = leftHandXFilter.filterUnitFloat( leftHandX );


  // -----------------------------------------------------
  
  


  // Compute x positions to draw the plot line
  x1 = xPos-0.1;
  x2 = xPos;  
  

  //------------------------------------
  // Draw X signals
  pushMatrix();
  translate(0, sectionSize * 1);
  drawYSignals(leftHandX, leftHandY, leftHandZ, rightHandX, rightHandY, rightHandZ);
  popMatrix();


  pushMatrix();
  translate(0, sectionSize * 0);
  drawXSignals(leftHandX, leftHandY, leftHandZ, rightHandX, rightHandY, rightHandZ);
  popMatrix();



  pushMatrix();
  translate(0, sectionSize * 2);
  drawZSignals(leftHandX, leftHandY, leftHandZ, rightHandX, rightHandY, rightHandZ);
  popMatrix();



  //------------------------------------
  // Move the head to the right
  xPos += 1;

  // Wrap condition
  if ( xPos > width ) {
    background(180); // clear screen
    xPos = 0.0;      // move back to the left
    if (rightHandYDownBeatXPrev > 0) {
    	rightHandYDownBeatXPrev -= width;
    }

    if (rightHandYUpBeatXPrev > 0) {
    	rightHandYUpBeatXPrev -= width;
    }

    if (rightHandXDownBeatXPrev > 0) {
    	rightHandXDownBeatXPrev -= width;
    }

    if (rightHandXUpBeatXPrev > 0) {
    	rightHandXUpBeatXPrev -= width;
    }

    if (leftHandXDownBeatXPrev > 0) {
    	rightHandXDownBeatXPrev -= width;
    }

    if (leftHandXUpBeatXPrev > 0) {
    	leftHandXUpBeatXPrev -= width;
    }
}
  sendOSCMessages();
}

void drawZSignals(float leftHandX, float leftHandY, float leftHandZ, float rightHandX, float rightHandY, float rightHandZ) {
  println("sectionSize: "+sectionSize);

  noStroke();
  fill(255);
  float zNoisy1 = map(rightHandZPrev, 0.0, 1.0, textBgHeight, sectionSize);
  float zNoisy2 = map(rightHandZ, 0.0, 1.0, textBgHeight, sectionSize);
  stroke(10);
  line(x1, zNoisy1, x2, zNoisy2);
  noStroke();
  fill(textBgColor);
  rect(0, 0, width, textBgHeight );
  fill(255);
  text( "Noisy signal", 10, 20 );
  noStroke();
  float zFiltered1 = map(rightHandZFilteredPrev, 0.0, 1.0, textBgHeight, sectionSize);
  float zFiltered2 = map(rightHandZFiltered, 0.0, 1.0, textBgHeight, sectionSize);
  stroke(255);
  line(x1, zFiltered1, x2, zFiltered2);

  noStroke();
  fill(textBgColor);
  rect(0, 0, width, textBgHeight );
  fill(255);

  weighting = map (zFiltered2, 0,100, 0, 1);
  text( "Z-Position\tweighting: " + weighting, 10, 20 );
}

void drawXSignals(float leftHandX, float leftHandY, float leftHandZ, float rightHandX, float rightHandY, float rightHandZ) {
  noStroke();
  fill(255);
  float xNoisy1 = map(rightHandXPrev, 0.0, 1.0, textBgHeight, sectionSize);
  float xNoisy2 = map(rightHandX, 0.0, 1.0, textBgHeight, sectionSize);
  stroke(10);
  line(x1, xNoisy1, x2, xNoisy2);
  xNoisy1 = map(leftHandXPrev, 0.0, 1.0, textBgHeight, sectionSize);  
  xNoisy2 = map(leftHandX, 0.0, 1.0, textBgHeight, sectionSize);
  line(x1, xNoisy1, x2, xNoisy2);

  noStroke();
  float xFiltered1 = map(rightHandXFilteredPrev, 0.0, 1.0, textBgHeight, sectionSize);
  float xFiltered2 = map(rightHandXFiltered, 0.0, 1.0, textBgHeight, sectionSize);
  stroke(255);
  line(x1, xFiltered1, x2, xFiltered2);


  rightHandXSlope = xFiltered2 - xFiltered1;
  if (rightHandXSlopePrev > 0) {
    if (rightHandXSlope <= 0) {
      articulation = map(abs(rightHandXDownBeatY - rightHandXUpBeatYPrev), 0, sectionSize-textBgHeight, 0, 1);
      
      ellipse(x2, xFiltered2, 10,10);
      rightHandXDownBeatX = x2;
      rightHandXDownBeatY = xFiltered2;
      rightHandXDownBeatXPrev = rightHandXDownBeatX;
      rightHandXDownBeatYPrev = rightHandXDownBeatY;
      
    }
  }
  if (rightHandXSlopePrev < 0) {
    if (rightHandXSlope >= 0) {
      fill(10);
      ellipse(x2, xFiltered2, 10, 10);
      fill(255);
      rightHandXUpBeatX = x2;
      rightHandXUpBeatY = xFiltered2;
      rightHandXUpBeatXPrev = rightHandXUpBeatX;
      rightHandXUpBeatYPrev = rightHandXUpBeatY;
    }
  }

  rightHandXSlopePrev = rightHandXSlope;



  xFiltered1 = map(leftHandXFilteredPrev, 0.0, 1.0, textBgHeight, sectionSize);
  xFiltered2 = map(leftHandXFiltered, 0.0, 1.0, textBgHeight, sectionSize);
  line(x1, xFiltered1, x2, xFiltered2);

  leftHandXSlope = xFiltered2 - xFiltered1;
  if (leftHandXSlopePrev > 0) {
    if (leftHandXSlope <= 0) {
      ellipse(x2, xFiltered2, 10,10);
      leftHandXDownBeatX = x2;
      leftHandXDownBeatY = xFiltered2;
      leftHandXDownBeatXPrev = leftHandXDownBeatX;
      leftHandXDownBeatYPrev = leftHandXDownBeatY;
      
    }
  }
  if (leftHandXSlopePrev < 0) {
    if (leftHandXSlope >= 0) {
      fill(10);
      ellipse(x2, xFiltered2, 10, 10);
      fill(255);
      leftHandXUpBeatX = x2;
      leftHandXUpBeatY = xFiltered2;
      leftHandXUpBeatXPrev = leftHandXUpBeatX;
      leftHandXUpBeatYPrev = leftHandXUpBeatY;
    }
  }

  leftHandXSlopePrev = leftHandXSlope;

  stroke(255,100,0, 100);



  registration = dist(x2, rightHandXUpBeatY, x2, leftHandXDownBeatY);

//  line(x2, rightHandXUpBeatY, x2, leftHandXDownBeatY);
//  line(x2, sectionSize/2 - 0.5 * registration, x2, sectionSize/2 + 0.5 * registration); 

  registration = map(registration, 0, 500, 0, 1);





  noStroke();
  fill(textBgColor);
  rect(0, 0, width, textBgHeight );
  fill(255);
  text( "X-Position\tregistration:" + registration + " articulation: " + articulation, 10, 20 );
}
void drawYSignals(float leftHandX, float leftHandY, float leftHandZ, float rightHandX, float rightHandY, float rightHandZ) {


  //------------------------------------
  // Draw noisy signal
  noStroke();
  fill(255);
  float yNoisy1 = map(rightHandYPrev, 0.0, 1.0, textBgHeight, sectionSize);
  float yNoisy2 = map(rightHandY, 0.0, 1.0, textBgHeight, sectionSize);
  stroke(10);
  line(x1, yNoisy1, x2, yNoisy2);
  noStroke();
  fill(textBgColor);
  rect(0, 0, width, textBgHeight );
  fill(255);
  text( "Noisy signal", 10, 20 );

  // Draw filtered signal

  noStroke();
  float yFiltered1 = map(rightHandYFilteredPrev, 0.0, 1.0, textBgHeight, sectionSize);
  float yFiltered2 = map(rightHandYFiltered, 0.0, 1.0, textBgHeight, sectionSize);
  stroke(255);
  line(x1, yFiltered1, x2, yFiltered2);
  rightHandYSlope = yFiltered2 - yFiltered1;
  
  //downbeat
  if (rightHandYSlopePrev > 0) {
    if (rightHandYSlope <= 0) {
      rightHandYDownBeatX = x2;
      rightHandYDownBeatY = yFiltered2;
      bpm = 60/(abs(rightHandYDownBeatXPrev-rightHandYDownBeatX)*(1/frameRate));
      dynamics = map(abs(rightHandYDownBeatY - rightHandYUpBeatYPrev), 0, sectionSize-textBgHeight, 0, 1);
      sendOSCMessage("/hyperconductor/bpm", bpm);
      sendOSCMessage("/hyperconductor/dynamics", dynamics);
      rightHandYDownBeatXPrev = rightHandYDownBeatX;
      rightHandYDownBeatYPrev = rightHandYDownBeatY;
      ellipse(x2, yFiltered2, 50*dynamics, 50*dynamics);
    }
  }

  // upbeat
  if (rightHandYSlopePrev < 0) {
    if (rightHandYSlope >= 0) {
      fill(10);
      ellipse(x2, yFiltered2, 10, 10);
      fill(255);
      rightHandYUpBeatX = x2;
      rightHandYUpBeatY = yFiltered2;
      rightHandYUpBeatXPrev = rightHandYUpBeatX;
      rightHandYUpBeatYPrev = rightHandYUpBeatY;
    }
  }


  rightHandYSlopePrev = rightHandYSlope;
  noStroke();
  fill(textBgColor);
  rect(0, 0, width, textBgHeight );
  fill(255);
  text( "Y-Position     BPM: " + bpm + "\t dynamics: " + dynamics, 10, 20 );
}




void sendOSCMessages() {
  sendOSCMessage("/hyperconductor/registration", registration);
  sendOSCMessage("/hyperconductor/weighting", weighting);
  sendOSCMessage("/hyperconductor/articulation", articulation);

}

void sendOSCMessage(String route, float value) {
  OscMessage oscMessage = new OscMessage(route);
  oscMessage.add(value);
  oscP5.send(oscMessage, myRemoteLocation);
}
