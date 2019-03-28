import processing.serial.*;
import controlP5.*;

boolean startup = true;

float t = 0;
float h = 0;
float tempMin = 10;
float tempMax = 10;
String portStream;

Serial myPort;
PImage img;
PFont fontHeading;
PFont fontNormal;
ControlP5 cp5;

void setup() {
  cp5 = new ControlP5(this);
  cp5.addButton("Min+").setPosition(570,385).setSize(50,20);
  cp5.addButton("Min-").setPosition(630,385).setSize(50,20);
  cp5.addButton("Max+").setPosition(570,415).setSize(50,20);
  cp5.addButton("Max-").setPosition(630,415).setSize(50,20);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  fontHeading = createFont("Fredoka One",27);
  fontNormal = createFont("Fredoka One",14);
  img = loadImage("logo.png");
  size(700,500,P3D);
  background(255);
}
void draw() {
  background(255);
  getData();
  if (startup == false){
    //Titelleiste
    fill(255, 204, 77);
    rect(0,0,width,100);
    fill(0);
    textFont(fontHeading);
    text("Auftau Schrank Übersicht",250,60);
    drawGraph();
    drawText();
  }
  logo();
}

void drawText() {
  int xPos = 350;
  int yPos = 340;
  int lineSpacing = 30;
  textFont(fontNormal);
  fill(100,100,200);
  text("aktuelle Luftfeuchtigkeit: " + h + "%", xPos,yPos);
  yPos += lineSpacing;
  fill(255,0,0);
  text("aktuelle Temperatur: " + t + "°C", xPos,yPos);
  fill(0,255,0);
  yPos += lineSpacing;
  text("mindest Temperatur: " + tempMin + "°C", xPos,yPos);
  yPos += lineSpacing;
  text("maximal Temperatur: " + tempMax + "°C", xPos,yPos);
}

void drawGraph() {
  //Aktuelle Temperatur
  fill(255);
  rect(30,200,100,250);

  int mx = int(map(tempMax,60,0,0,250));
  int ms = int(map(tempMin,60,0,0,250));
  fill(0,255,0);
  rect(30,mx+200,100,ms-mx);
  //println(mx + "  " + ms + " " + (ms-mx));

  int m = int(map(t,60,0,0,250));
  fill(255,0,0);
  rect(30,m+200,100,250-m);


  if (t != 0) {
    textFont(fontNormal);
    text("Temp.: " + t + "°C",30,470);
  } else {
    textFont(fontNormal);
    text("Sensor Fehler",30,470);
  }
  //Aktuelle Luftfeuchtigkeit
  m = int(map(h,100,0,0,250));
  fill(100,100,200);
  rect(150,m+200,100,250-m);
  if (h != 0){
    textFont(fontNormal);
    text("Luft.: " + h + "%",150,470);
  } else {
    textFont(fontNormal);
    text("Sensor Fehler",150,470);
  }
}

void getData() {
  if (portStream != null) {
    if (portStream.charAt(0) == '#' && portStream.charAt(portStream.length()-3) == ';') {
      t = float(portStream.substring(portStream.indexOf("T")+1,portStream.indexOf("H")-1));
      h = float(portStream.substring(portStream.indexOf("H")+1,portStream.indexOf("S")-1));
      tempMin = float(portStream.substring(portStream.indexOf("S")+1,portStream.indexOf("X")-1));
      tempMax = float(portStream.substring(portStream.indexOf("X")+1,portStream.indexOf(";")-1));
    }
  }
}

int yPos=100;
float size=0.9;
int runs = 0;
void logo() {
  image(img, 5, yPos, 781*size, 292*size); //781*0.3, 292*0.3
  if (!(runs < 100)){
    if (yPos > 10 || size > 0.3) {
      if (yPos > 10) {
        yPos-= 1.000005;
      }
      if (size > 0.25) {
        size-=0.01;
      }
    }else{startup = false;}
  }
  runs++;
}

void keyPressed() {
  println(key);
}
void serialEvent(Serial myPort) {
  portStream = myPort.readString();
}
