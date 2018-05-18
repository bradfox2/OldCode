#include <EEPROM.h>
#include <LiquidCrystal.h>
#include <Ethernet.h>
#include <String.h>
#include <SPI.h>


// initialize the lcd library with the pin settings
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
int input[] = {        
 22,23,24,25,26,27,28,29,30,31};
int output[] = {
  32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47};
  
//output to control relay to control 110v  
const int output_relay = 49; 

//variable to hold binary representation of the output state
int binarymode;

//variables to hold parsed strings
String Output_Mode, Data_State, Data_State_2;

//int to hold relay state
int relay_state;


void setup() {

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
  Data_State_2 = "0";
}

void loop() {    
  // print the ip of box to lcd screen and an N for not connected.
  printIpTolcd();
  //start the server code   
  bufferSize = 0;

  // wait for a new client:
  Client clientwithdata = arduinoserver.available();
  
  if (clientwithdata){
    lcd.setCursor(15,0);
    lcd.print("Y");
  }
  
  //while a client is conected:
  while (clientwithdata.connected()){  
    if (clientwithdata.available()){
      char c = clientwithdata.read();     //read the data, byte by byte coming in from client
        if (c == '\n'){                  //if the next character is return then stop reading and execute the if statment
          Serial.println("Return Key detected");
          parse_recvBuffer();           //run fucntion to parse the incoming buffer from client
          printTolcd(Data_State, true);  //print the data state to lcd with connected flag high
          set_output_pins();              //set the output pins based on the binary mode variable 

        }
        else if (bufferSize < bufferMax){   //otherwise if buffer still has space then add it on to recvbuffer
          recvBuffer[bufferSize++] = c;
        }
    }
    if ((newPinData()) == true){
  
      clientwithdata.print("<Mode>");
      clientwithdata.print(binarymode, BIN);
      clientwithdata.print("</Mode>");
      clientwithdata.print("<Data>");
      clientwithdata.print(getPinData(), BIN);
      clientwithdata.print("</Data>");
    }
   }
}

//====================================================================================================================//

unsigned int getPinData(){  // function to evaluate the input pin states and return an int with binary pin states
  unsigned int pin_data;
  for (int z=0; z < 16; z++){  
     bitWrite(pin_data,z,digitalRead(input[z]));
   }
   Serial.print("getPinData called");
   Serial.println(pin_data, BIN);
   printInt(pin_data);
   return pin_data;
}

//====================================================================================================================//

int y;
int last_val;

boolean newPinData(){  //boolean that returns true on new pin data or false on same pin data
  int y = getPinData();
  if (y != last_val){
    last_val = y;
    Serial.println("Newpindata called and detected");
    return true;
  }
  else{
    Serial.println("Newpindata called and not detected");
    return false;
  }
}

//====================================================================================================================//


void printTolcd(String i, boolean client_connected_flag){
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(i);
    Serial.println("Printing " + i + " to Lcd");
    if (client_connected_flag == true){
      lcd.setCursor(15,0);
      lcd.print("Y");

    }
    memset(recvBuffer,0,200);        
}    

//====================================================================================================================//

void set_output_pins(){
  int n;
  for (n = 0; n < 16; n++){
    int x = bitRead(binarymode,n);
    //Serial.print("The bitread is :");
    //Serial.print(x);
    //Serial.print(output[n]);
    if (x == 1){
        digitalWrite(output[n],HIGH);
        //Serial.print("Outputmode is ");
        //Serial.print(output[n]);
    }
    else{
      digitalWrite(output[n],LOW);
    }
  }
}

//====================================================================================================================//

void printIpTolcd(){
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


//====================================================================================================================//

void printInt (unsigned int pin_data){
  for(word mask = 0x800; mask; mask >>= 1){
    if(mask  & pin_data)
      Serial.print('1');
    else
      Serial.print('0');
  }
}

    
