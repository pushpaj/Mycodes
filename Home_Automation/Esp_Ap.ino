
#include <ESP8266WiFi.h>

/* Set these to your desired credentials. */
const char *ssid = "connect"; // You can change it according to your ease
const char *password = "12345678"; // You can change it according to your ease

String header;

// Auxiliar variables to store the current output state
String output1State = "on";
String output2State = "on";
String output3State = "on";
String output4State = "on";
String output5State = "on";
String output6State = "on";
String output7State = "on";
String output8State = "on";

boolean StringReady=0;
const char* deviceName = "Esp01";
WiFiServer server(80);
IPAddress myIP;

void setup() {
  
  Serial.begin(9600);
 // Serial.begin(19200);
  
  Serial.print("Configuring access point...");
  Serial.println("");
  // for station mode
  WiFi.begin(ssid,password);
  while (WiFi.status() != WL_CONNECTED) {  //Wait for connection
      delay(500);
      Serial.println("Waiting to connect...");
  }
  myIP = WiFi.localIP();
  
  Serial.print("AP IP address: ");
  Serial.println(myIP);
  server.begin();
  Serial.println("HTTP server started");
}

void setChanges(String touchResponse){
  if(touchResponse=="output1StateOff"){
        output1State="off";
      }else if(touchResponse=="output1StateOn"){
        output1State="on";
      }else if(touchResponse=="output2StateOff"){
        output2State="off";
      }else if(touchResponse=="output2StateOn"){
        output2State="on";
      }else if(touchResponse=="output3StateOff"){
        output3State="off";
      }else if(touchResponse=="output3StateOn"){
        output3State="on";
      }else if(touchResponse=="output4StateOff"){
        output4State="off";
      }else if(touchResponse=="output4StateOn"){
        output4State="on";
      }else if(touchResponse=="output5StateOff"){
        output5State="off";
      }else if(touchResponse=="output5StateOn"){
        output5State="on";
      }else if(touchResponse=="output6StateOff"){
        output6State="off";
      }else if(touchResponse=="output6StateOn"){
        output6State="on";
      }else if(touchResponse=="output7StateOff"){
        output7State="off";
      }else if(touchResponse=="output7StateOn"){
        output7State="on";
      }else if(touchResponse=="output8StateOff"){
        output8State="off";
      }else if(touchResponse=="output8StateOn"){
        output8State="on";
      }
}

void loop() {
  WiFiClient client = server.available();
  
///////// Very IMPORTANT BLOCK/////////
  String touchResponse="";
  if((Serial.available()) && (!StringReady)){
    touchResponse=Serial.readString();
    StringReady=1;
  }
  if(StringReady){
    setChanges(touchResponse);
    StringReady=0;
  }
//////////////////////////////////////    

 if(client){
    String currentLine=""; 
    while(client.connected()){
///////// Very IMPORTANT BLOCK/////////
      String touchResponse="";
      if((Serial.available()) && (!StringReady)){
        touchResponse=Serial.readString();
        StringReady=1;
      }
      if(StringReady){
        setChanges(touchResponse);
        StringReady=0;
      }
//////////////////////////////////////              
      if(client.available()){
        char c= client.read();
        //Serial.write(c);
        header+=c;
        //Serial.println(header);
        if(c=='\n'){
          if(currentLine.length()==0){

            if (header.indexOf("GET /1/on") >= 0) {
              output1State = "on";
              Serial.write("output1high");
            } else if (header.indexOf("GET /1/off") >= 0) {
              output1State = "off";
              Serial.write("output1low");
            } else if (header.indexOf("GET /2/on") >= 0) {
              output2State = "on";
              Serial.write("output2high");
            } else if (header.indexOf("GET /2/off") >= 0) {
              output2State = "off";
              Serial.write("output2low");
            }else if (header.indexOf("GET /3/on") >= 0) {
              output3State = "on";
              Serial.write("output3high");
            } else if (header.indexOf("GET /3/off") >= 0) {
              output3State = "off";
              Serial.write("output3low");
            }else if (header.indexOf("GET /4/on") >= 0) {
              output4State = "on";
              Serial.write("output4high");
            } else if (header.indexOf("GET /4/off") >= 0) {
              output4State = "off";
              Serial.write("output4low");
            }else if (header.indexOf("GET /5/on") >= 0) {
              output5State = "on";
              Serial.write("output5high");
            } else if (header.indexOf("GET /5/off") >= 0) {
              output5State = "off";
              Serial.write("output5low");
            }else if (header.indexOf("GET /6/on") >= 0) {
              output6State = "on";
              Serial.write("output6high");
            } else if (header.indexOf("GET /6/off") >= 0) {
              output6State = "off";
              Serial.write("output6low");
            }else if (header.indexOf("GET /7/on") >= 0) {
              output7State = "on";
              Serial.write("output7high");
            } else if (header.indexOf("GET /7/off") >= 0) {
              output7State = "off";
              Serial.write("output7low");
            }else if (header.indexOf("GET /8/on") >= 0) {
              output8State = "on";
              Serial.write("output8high");
            } else if (header.indexOf("GET /8/off") >= 0) {
              output8State = "off";
              Serial.write("output8low");
            }
            
            client.println("<!DOCTYPE html><html>");
            client.println("<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
            //client.println("<meta http-equiv='refresh' content='5'>");
            client.println("<link rel=\"icon\" href=\"data:,\">");
            client.println("<style>html { font-family: Helvetica; display: inline-block; margin: 0px auto; text-align: center;}");
            client.println(".button { background-color: #195B6A; border: none; color: white; padding: 16px 40px;");
            client.println("text-decoration: none; font-size: 30px; margin: 2px; cursor: pointer;}");
            client.println(".button2 {background-color: #77878A;}</style></head>");
            client.println("<body><h1><p><a href=http://+myIP+/\><button class=\"button\">Refresh</button></a></p></h1>");

            client.println("<p>LED1 - State " + output1State + "</p>");

            if (output1State=="on") {
              client.println("<p><a href=\"/1/off\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/1/on\"><button class=\"button button2\">OFF</button></a></p>");
            } 
            client.println("<p>LED2 - State " + output2State + "</p>");
             
            if (output2State=="on") {  
              client.println("<p><a href=\"/2/off\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/2/on\"><button class=\"button button2\">OFF</button></a></p>");
            }
            client.println("<p>LED3 - State " + output3State + "</p>");
            
            if (output3State=="on") {
              client.println("<p><a href=\"/3/off\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/3/on\"><button class=\"button button2\">OFF</button></a></p>");
            }
            client.println("<p>LED4 - State " + output4State + "</p>");
            
            if (output4State=="on") {          
              client.println("<p><a href=\"/4/off\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/4/on\"><button class=\"button button2\">OFF</button></a></p>");
            }
            client.println("<p>LED5 - State " + output5State + "</p>");
            
            if (output5State=="on") {
              client.println("<p><a href=\"/5/off\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/5/on\"><button class=\"button button2\">OFF</button></a></p>");
            }
            client.println("<p>LED6 - State " + output6State + "</p>");
            
            if (output6State=="on") {   
              client.println("<p><a href=\"/6/off\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/6/on\"><button class=\"button button2\">OFF</button></a></p>");
            }
            client.println("<p>LED7 - State " + output7State + "</p>");
            
            if (output7State=="on") {
              client.println("<p><a href=\"/7/off\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/7/on\"><button class=\"button button2\">OFF</button></a></p>");
            }
            client.println("<p>LED8 - State " + output8State + "</p>");
            
            if (output8State=="on") {
              client.println("<p><a href=\"/8/off\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/8/on\"><button class=\"button button2\">OFF</button></a></p>");
            } 
   
            client.println("</body></html>");
            break;
            
        }else { // if you got a newline, then clear currentLine
            currentLine = "";
          }
      }else if (c != '\r') {  // if you got anything else but a carriage return character,
          currentLine += c;      // add it to the end of the currentLine
        }
    }
  }
  header="";
  client.stop();
  }
 
}
