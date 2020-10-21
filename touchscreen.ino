#include <Adafruit_GFX.h>
#include "SWTFT.h"
#include <TouchScreen.h>
#include<SoftwareSerial.h>

#define BLACK   0x0000
#define BLUE    0x001F
#define RED     0xF800
#define GREEN   0x07E0
#define CYAN    0x07FF
#define MAGENTA 0xF81F
#define YELLOW  0xFFE0
#define WHITE   0xFFFF

#define YP A1
#define XM A2  
#define YM 7   
#define XP 6

#define TS_MINX 150
#define TS_MINY 120
#define TS_MAXX 920
#define TS_MAXY 940

#define BUTTONRADIUS 30

#define MAXPRESSURE 1000
#define MINPRESSURE 10

#define dataPin 13
#define latchPin 11
#define clockPin 12

#define onColor GREEN
#define offColor RED

int sum=0;
SoftwareSerial mySerial(0,1);


TouchScreen ts = TouchScreen(XP, YP, XM, YM, 300);
SWTFT tft;

bool switch1change=0;
bool switch1touch=0;
bool switch2change=0;
bool switch2touch=0;
bool switch3change=0;
bool switch3touch=0;
bool switch4change=0;
bool switch4touch=0;
bool switch5change=0;
bool switch5touch=0;
bool switch6change=0;
bool switch6touch=0;
bool switch7change=0;
bool switch7touch=0;
bool switch8change=0;
bool switch8touch=0;

boolean StringReady=false;

void setup() {

  pinMode(0, INPUT);
  pinMode(1, OUTPUT);

  pinMode(dataPin, OUTPUT);
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  
  mySerial.begin(9600);
  //Serial.begin(19200);
  tft.reset();
  tft.begin(0x9325);
  tft.setRotation(180);
  tft.setTextColor(BLUE);
  tft.setTextSize(2);
  tft.fillScreen(BLUE);
}

void setChanges(String IncomingString){
  if(IncomingString=="output1high"){
    switch1touch =0;
    switch1change = 0;
  }else if(IncomingString=="output1low"){
    switch1touch =1;
    switch1change = 0;
  }else if(IncomingString=="output2high"){
    switch2touch =0;
    switch2change = 0;
  }else if(IncomingString=="output2low"){
    switch2touch =1;
    switch2change = 0;
  }else if(IncomingString=="output3high"){
    switch3touch =0;
    switch3change = 0;
  }else if(IncomingString=="output3low"){
    switch3touch =1;
    switch3change = 0;
  }else if(IncomingString=="output4high"){
    switch4touch =0;
    switch4change = 0;
  }else if(IncomingString=="output4low"){
    switch4touch =1;
    switch4change = 0;
  }else if(IncomingString=="output5high"){
    switch5touch =0;
    switch5change = 0;
  }else if(IncomingString=="output5low"){
    switch5touch =1;
    switch5change = 0;
  }else if(IncomingString=="output6high"){
    switch6touch =0;
    switch6change = 0;
  }else if(IncomingString=="output6low"){
    switch6touch =1;
    switch6change = 0;
  }else if(IncomingString=="output7high"){
    switch7touch =0;
    switch7change = 0;
  }else if(IncomingString=="output7low"){
    switch7touch =1;
    switch7change = 0;
  }else if(IncomingString=="output8high"){
    switch8touch =0;
    switch8change = 0;
  }else if(IncomingString=="output8low"){
    switch8touch =1;
    switch8change = 0;
  }
}

void toggleElements(int x){
  sum+=x;
  digitalWrite(latchPin,LOW);
  shiftOut(dataPin,clockPin,MSBFIRST,sum);
  digitalWrite(latchPin,HIGH);
}
void loop() {
///////////DO NOT DISTURB THIS BLOCK///////////
  String IncomingString=""; 
  if((mySerial.available()) && (!StringReady)){
    IncomingString=mySerial.readString();
    StringReady=true;
  }
 if(StringReady){
   setChanges(IncomingString);
   StringReady=false;
 }
//////////////////////////////////////////
   
 if ((switch1change == 0 && switch1touch == 0)) {
    toggleElements(1);
    mySerial.write("output1StateOn");
    tft.fillCircle(50, 50, BUTTONRADIUS, onColor);
    tft.setCursor(25, 40);
    tft.println("LED1");
    switch1change = 1;
    delay(200);
  }

  if ((switch1change == 0 && switch1touch == 1)) {
    toggleElements(-1);
    mySerial.write("output1StateOff");
    tft.fillCircle(50, 50,BUTTONRADIUS , offColor);
    tft.setCursor(25, 40);
    tft.println("LED1");
    switch1change = 1;
    delay(200);
  }  

  if ((switch2change == 0 && switch2touch == 0)) {
    toggleElements(2);
    mySerial.write("output2StateOn");
    tft.fillCircle(180, 50, BUTTONRADIUS, onColor);
    tft.setCursor(155, 40);
    tft.println("LED2");
    switch2change = 1;
    delay(200);
  }

  if ((switch2change == 0 && switch2touch == 1)) {
    //digitalWrite(led2, HIGH);
    toggleElements(-2);
    mySerial.write("output2StateOff");
    tft.fillCircle(180, 50, BUTTONRADIUS, offColor);
    tft.setCursor(155, 40);
    tft.println("LED2");
    switch2change = 1;
    delay(200);
  }

  if ((switch3change == 0 && switch3touch == 0)) {
    //digitalWrite(led3, LOW);
    toggleElements(4);
    mySerial.write("output3StateOn");
    tft.fillCircle(50, 120, BUTTONRADIUS, onColor);
    tft.setCursor(25, 110);
    tft.println("LED3");
    switch3change = 1;
    delay(200);
  }

  if ((switch3change == 0 && switch3touch == 1)) {
    toggleElements(-4);
    mySerial.write("output3StateOff");
    tft.fillCircle(50, 120,BUTTONRADIUS, offColor);
    tft.setCursor(25, 110);
    tft.println("LED3");
    switch3change = 1;
    delay(200);
  }

  if ((switch4change == 0 && switch4touch == 0)) {
    toggleElements(8);
    mySerial.write("output4StateOn");
    tft.fillCircle(180, 120, BUTTONRADIUS, onColor);
    tft.setCursor(155, 110);
    tft.println("LED4");
    switch4change = 1;
    delay(200);
  }

  if ((switch4change == 0 && switch4touch == 1)) {
    toggleElements(-8);
    mySerial.write("output4StateOff");
    tft.fillCircle(180, 120, BUTTONRADIUS, offColor);
    tft.setCursor(155, 110);
    tft.println("LED4");
    switch4change = 1;
    delay(200);
  }
  
  if ((switch5change == 0 && switch5touch == 0)) {
    toggleElements(16);
    mySerial.write("output5StateOn");
    tft.fillCircle(50, 190, BUTTONRADIUS, onColor);
    tft.setCursor(25, 180);
    tft.println("LED5");
    switch5change = 1;
    delay(200);
  }

  if ((switch5change == 0 && switch5touch == 1)) {
    toggleElements(-16);
    mySerial.write("output5StateOff");
    tft.fillCircle(50, 190, BUTTONRADIUS, offColor);
    tft.setCursor(25, 180);
    tft.println("LED5");
    switch5change = 1;
    delay(200);
  }
  if ((switch6change == 0 && switch6touch == 0)) {
    toggleElements(32);
    mySerial.write("output6StateOn");
    tft.fillCircle(180,190,BUTTONRADIUS,onColor);
    tft.setCursor(155, 180);
    tft.println("LED6");
    switch6change = 1;
    delay(200);
  }

  if ((switch6change == 0 && switch6touch == 1)) {
    toggleElements(-32);
    mySerial.write("output6StateOff");
    tft.fillCircle(180, 190, BUTTONRADIUS, offColor);
    tft.setCursor(155, 180);
    tft.println("LED6");
    switch6change = 1;
    delay(200);
  }
  if ((switch7change == 0 && switch7touch == 0)) {
    toggleElements(64);
    mySerial.write("output7StateOn");
    tft.fillCircle(50, 260, BUTTONRADIUS, onColor);
    tft.setCursor(25, 250);
    tft.println("LED7");
    switch7change = 1;
    delay(200);
  }

  if ((switch7change == 0 && switch7touch == 1)) {
    toggleElements(-64);
    mySerial.write("output7StateOff");
    tft.fillCircle(50, 260, BUTTONRADIUS, offColor);
    tft.setCursor(25, 250);
    tft.println("LED7");
    switch7change = 1;
    delay(200);
  }
  if ((switch8change == 0 && switch8touch == 0)) {
    toggleElements(128);
    mySerial.write("output8StateOn");
    tft.fillCircle(180, 260, BUTTONRADIUS, onColor);
    tft.setCursor(155, 250);
    tft.println("LED8");
    switch8change = 1;
    delay(200);
  }

  if ((switch8change == 0 && switch8touch == 1)) {
    toggleElements(-128);
    mySerial.write("output8StateOff");
    tft.fillCircle(180, 260, BUTTONRADIUS, offColor);
    tft.setCursor(155, 250);
    tft.println("LED8");
    switch8change = 1;
    delay(200);
  } 
 
  TSPoint p = ts.getPoint();
  pinMode(XM, OUTPUT);
  pinMode(YP, OUTPUT);
  if (p.z > MINPRESSURE && p.z < MAXPRESSURE) {
    p.x = map(p.x, TS_MINX, TS_MAXX, tft.width(), 0);
    p.y = map(p.y, TS_MINY, TS_MAXY, tft.height(), 0);
    if (p.x > 50-BUTTONRADIUS && p.x < 50+BUTTONRADIUS) {
      if (p.y > 50-BUTTONRADIUS && p.y < 50+BUTTONRADIUS) {
        switch1change = 0;
        switch1touch = !switch1touch;
      }
    }

    if (p.x > 180-BUTTONRADIUS && p.x < 180+BUTTONRADIUS) {
      if (p.y > 50-BUTTONRADIUS && p.y < 50+BUTTONRADIUS) {
        switch2change = 0;
        switch2touch = !switch2touch;
      }
    }
    if (p.x >50-BUTTONRADIUS && p.x < 50+BUTTONRADIUS) {
      if (p.y > 120-BUTTONRADIUS && p.y < 120+BUTTONRADIUS) {
        switch3change = 0;
        switch3touch = !switch3touch;
      }
    }

    if (p.x > 180-BUTTONRADIUS && p.x < 180+BUTTONRADIUS) {
      if (p.y > 120-BUTTONRADIUS && p.y < 120+BUTTONRADIUS) {
        switch4change = 0;
        switch4touch = !switch4touch;
      }
    }

    if (p.x > 50-BUTTONRADIUS && p.x < 50+BUTTONRADIUS) {
      if (p.y > 190-BUTTONRADIUS && p.y < 190+BUTTONRADIUS) {
        switch5change = 0;
        switch5touch = !switch5touch;
      }
    }

    if (p.x > 180-BUTTONRADIUS && p.x < 180+BUTTONRADIUS) {
      if (p.y > 190-BUTTONRADIUS && p.y < 190+BUTTONRADIUS) {
        switch6change = 0;
        switch6touch = !switch6touch;
      }
    }

    if (p.x > 50-BUTTONRADIUS && p.x < 50+BUTTONRADIUS) {
      if (p.y > 260-BUTTONRADIUS && p.y < 260+BUTTONRADIUS) {
        switch7change = 0;
        switch7touch = !switch7touch;
      }
    }
    
    if (p.x > 180-BUTTONRADIUS && p.x < 180+BUTTONRADIUS) {
      if (p.y > 260-BUTTONRADIUS && p.y < 260+BUTTONRADIUS) {
        switch8change = 0;
        switch8touch = !switch8touch;
      }
    }
  }
}
