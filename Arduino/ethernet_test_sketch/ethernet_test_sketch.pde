#include <EEPROM.h>
#include <LiquidCrystal.h>
#include <Ethernet.h>
#include <String.h>
#include <SPI.h>


// initialize the LCD library with the pin settings
LiquidCrystal lcd(9,8,7,6,5,4); 

//set the ethernet card attributes
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192,168,0, 178 };
byte gateway[] = { 192,168,0, 1 };
byte subnet[] = { 255, 255, 255, 0 };

//read ip address out of the eeprom when the eeprom.read(0) flag is set high
byte ipEEP[] = {(EEPROM.read(1)),(EEPROM.read(2)),(EEPROM.read(3)),(EEPROM.read(4))};
Server arduinoserver = Server(8080);

// hold the buffer attributes for the server/client code 
#define bufferMax 200
int bufferSize;
char recvBuffer[bufferMax];

//set the input and output pin numbers
const int input[] = {        
  22,23,24,25,26,27,28,29,30,31};
const int output[] = {
  32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47};
  
//output to control relay to control 110v  
const int output_relay = 49; 

//variable to hold the input pin state
int pin_data;

//variable to hold binary representation of the output state
int binarymode;

//variables to hold parsed strings
String Output_Mode, Data_State;

//int to hold relay state
int relay_state;


void setup() {
  
//  //if the eeprom ip flag is low use the coded ip
//  if (EEPROM.read(0)==0){
//      Ethernet.begin(mac, ip, gateway, subnet);
//   }
//   
//   //if eeprom ip flag high use eeprom read ip
//  else if(EEPROM.read(0)==1){
//      Ethernet.begin(mac,ipEEP,gateway,subnet);
//  }
  
  // set pins in the input list as inputs
  for (int x = 0; x < 10; x++){
    pinMode(input[x],INPUT);
  }
  
  //set pins in the output list as outputs
  for (int x = 0; x < 16; x++){
    pinMode(output[x],OUTPUT);
    digitalWrite(output[x],LOW);
  }

  //declare relay output pin as output
  pinMode(output_relay, OUTPUT); 
  
  //write relay pin high to turn on power to remote system
  digitalWrite(output_relay, HIGH);
  
  // initialize the ethernet device
  Ethernet.begin(mac, ip, gateway, subnet);
  
  // start listening for clients
  arduinoserver.begin();
  Serial.begin(9600);
}

void loop() {
  
   //to acquire the state of the input pins, then loop over 10 input pins and build a 10 bit binary number
   for (int x=0; x < 10; x++){  
     
     //read the input pins to aquire a data state of 10 digits
     int temp = digitalRead(input[x]);  
      
      //if the read indicates high then set a 1 for that digit
      if (temp){
        bitWrite(pin_data,x,1);
      }
      
      //otherwise if it reads low then set a 0
      else{
        bitWrite(pin_data,x,0);
      }
   }
    
  //start the server code   
  bufferSize = 0;
  
  //write to all clients the output mode to provide feedback to the client application

  // wait for a new client:
  Client clientwithdata = arduinoserver.available();
  
  if (clientwithdata){
    lcd.setCursor(15,0);
    lcd.print("Y");
    Serial.print("got a client");
  }
  if (!clientwithdata){
    lcd.setCursor(0,0);
    lcd.print(ip[0],DEC);
    lcd.print(".");
    lcd.print(ip[1],DEC);
    lcd.print(".");
    lcd.print(ip[2],DEC);
    lcd.print(".");
    lcd.print(ip[3],DEC);
    lcd.setCursor(15,0);
    lcd.print("N");
  }
  
  //while a client is conected:
  while (clientwithdata.connected()){
    Serial.println("client with data is connected");
    lcd.clear();
    lcd.print(Data_State);
    lcd.setCursor(15,0);
    lcd.print("Y");
    
   
      arduinoserver.print("<Mode>");
      arduinoserver.print(binarymode);
      arduinoserver.print("</Mode>");
    
      //write the input pin data to all connected cleints
      arduinoserver.print("<Data>");
      arduinoserver.print(pin_data);
      arduinoserver.print("</Data>");
      
    
  
    
    if (clientwithdata.available()){
    
      lcd.clear();
      char c = clientwithdata.read();        //read the data, byte by byte coming in from client
        
      if (c == '\n'){          //if the next character is return then stop reading and execute the if statment
          
        ////Serial.println(recvBuffer);

        parse_recvBuffer();           //run fucntion to parse the incoming buffer from client
        
        String x;  
        if ( x!=Data_State){
          lcd.clear();
          lcd.setCursor(0, 0);
          lcd.print(Data_State);
          ////Serial.println(Data_State);
          //lcd.setCursor(0,1);
          //lcd.print(Output_Mode);
          //    lcd.print(mode);
          x = Data_State;
        }
  
          set_output_pins();
                  
          memset(recvBuffer,0,200);             //clear the char array for new writing (pointer to memory location of recvBuffer, nullify 200 places)
        }
        
        //otherwise if buffer still has space then add it on to recvbuffer
        else if (bufferSize < bufferMax){
          recvBuffer[bufferSize++] = c;
        }
        else 
          break;
    }
  }
delay(100);  
}

