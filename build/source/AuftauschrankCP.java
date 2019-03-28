import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AuftauschrankCP extends PApplet {



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

public void setup() {
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  fontHeading = createFont("Fredoka One",27);
  fontNormal = createFont("Fredoka One",14);
  img = loadImage("logo.png");
  
  background(255);
}
public void draw() {
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

public void drawText() {
  int xPos = 380;
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

public void drawGraph() {
  //Aktuelle Temperatur
  int m = PApplet.parseInt(map(t,60,0,0,250));
  fill(255,0,0);
  rect(30,m+200,100,250-m);
  m = PApplet.parseInt(map(tempMin,60,0,0,250));
  fill(0,255,0);
  rect(30,m+200,100,3);
  m = PApplet.parseInt(map(tempMax,60,0,0,250));
  fill(0,0,255);
  rect(30,m+200,100,3);
  if (t != 0) {
    textFont(fontNormal);
    text("Temp.: " + t + "°C",30,470);
  } else {
    textFont(fontNormal);
    text("Sensor Fehler",30,470);
  }
  //Aktuelle Luftfeuchtigkeit
  m = PApplet.parseInt(map(h,100,0,0,250));
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

public void getData() {
  if (portStream != null) {
    if (portStream.charAt(0) == '#' && portStream.charAt(portStream.length()-3) == ';') {
      t = PApplet.parseFloat(portStream.substring(portStream.indexOf("T")+1,portStream.indexOf("H")-1));
      h = PApplet.parseFloat(portStream.substring(portStream.indexOf("H")+1,portStream.indexOf("S")-1));
      tempMin = PApplet.parseFloat(portStream.substring(portStream.indexOf("S")+1,portStream.indexOf("X")-1));
      tempMax = PApplet.parseFloat(portStream.substring(portStream.indexOf("X")+1,portStream.indexOf(";")-1));
    }
  }
}

int yPos=100;
float size=0.9f;
int runs = 0;
public void logo() {
  image(img, 5, yPos, 781*size, 292*size); //781*0.3, 292*0.3
  if (!(runs < 100)){
    if (yPos > 10 || size > 0.3f) {
      if (yPos > 10) {
        yPos-= 1.000005f;
      }
      if (size > 0.25f) {
        size-=0.01f;
      }
    }else{startup = false;}
  }
  runs++;
}

public void keyPressed() {
  println(key);
}
public void serialEvent(Serial myPort) {
  portStream = myPort.readString();
}
  public void settings() {  size(700,500,P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AuftauschrankCP" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
