import processing.serial.*;
import controlP5.*;

boolean startup = true;
boolean newData;

boolean connectionInit = false;

float t = 0;
float h = 0;
float tempMin = 0;
float tempMax = 0;
String portStream;

Serial myPort;
PImage img;
PFont fontHeading;
PFont fontNormal;
ControlP5 cp5;

void setup() {
  cp5 = new ControlP5(this);
  cp5.addButton("MinP").setPosition(570,385).setSize(50,20).setLabel("+");
  cp5.addButton("MinM").setPosition(630,385).setSize(50,20).setLabel("-");
  cp5.addButton("MaxP").setPosition(570,415).setSize(50,20).setLabel("+");
  cp5.addButton("MaxM").setPosition(630,415).setSize(50,20).setLabel("-");
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  fontHeading = createFont("Fredoka One",27);
  fontNormal = createFont("Fredoka One",14);
  img = loadImage("logo.png");
  size(700,500,P3D);
float t = 0;
  background(255);
}
void draw() {
  getData();
  background(255);
  if (startup == false){
    //Titelleiste
    fill(255, 204, 77);
    rect(0,0,width,100);
    fill(0);
    textFont(fontHeading);
    text("Auftau Schrank Übersicht",250,60);
    drawGraph(); // Diagramme zeichnen
    drawText(); // Text zeichenen
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
  fill(255);
  rect(150,200,100,250);
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

  if (portStream != null && newData == true) {
    println("receive: " + portStream);
    if (portStream != "Hi"){
      if (portStream.charAt(0) == '#' && portStream.charAt(portStream.length()-1) == ';') {
        t = float(portStream.substring(portStream.indexOf("T")+1,portStream.indexOf("H")-1));
        h = float(portStream.substring(portStream.indexOf("H")+1,portStream.indexOf("S")-1));
        tempMin = float(portStream.substring(portStream.indexOf("S")+1,portStream.indexOf("X")-1));
        tempMax = float(portStream.substring(portStream.indexOf("X")+1,portStream.indexOf(";")-1));
      }
    }
    newData = false;
    delay(500);
    sendData();
  }
}

void sendData() {
  myPort.write("S" + tempMin + "X" + tempMax + ";");
  println("send: " + "S" + tempMin + "X" + tempMax + ";");
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
public void MaxP() {
  println("MaxP");
  tempMax++;
  sendData();
}
public void MaxM() {
  println("MaxM");
  tempMax--;
  sendData();
}
public void MinP() {
  println("MinP");
  tempMin++;
  sendData();
}
public void MinM() {
  println("MinM");
  tempMin--;
  sendData();
}
void keyPressed() {
  println(key);
}
void serialEvent(Serial myPort) {
  String input = myPort.readString();
  portStream = input.substring(0,input.length()-2);
  newData = true;
}
