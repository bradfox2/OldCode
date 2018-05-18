#include <EEPROM.h>
#include <LiquidCrystal.h>
#include <avr/pgmspace.h>
#include <Ethernet.h>
#include <String.h>
#include <SPI.h>


LiquidCrystal lcd(4, 5, 6, 7, 8, 9); // initialize the LCD library with the pin settings

//------------from led code -------------//
byte mac[] = {0x00, 0x1E, 0x2A, 0x77, 0x24, 0x02};
byte gateway[] = {192, 168, 0, 1};
byte subnet[] = {255, 255, 0, 0};
byte ip[] = {192,168,0,187};
byte ipEEP[] = {(EEPROM.read(1)),(EEPROM.read(2)),(EEPROM.read(3)),(EEPROM.read(4))};
Server server(80); // Port 80 is http.

String mode = "Normal"; // these lines set the box upon start up to a default normal mode
byte modeB = 1;

//--------------------------------------//


char html_buffer[200]; //buffer to hold html lines  
char buffer[50];    // holds the string buffer for display of state

const int input[] = {        
  22,23,24,25,26,27,28,29,30,31};

const int output[] = {
  32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47};

const int output_relay = 49; //output to control relay to control 110v

int data; 

String human_status;

boolean client_connected;

unsigned long time;
int reset_client = 75000;

void setup() {
  if (EEPROM.read(0)==0){
      Ethernet.begin(mac, ip, gateway, subnet);
   }
  else if(EEPROM.read(0)==1){
      Ethernet.begin(mac,ipEEP,gateway,subnet);
  }
  
  for (int x = 0; x < 10; x++){
    pinMode(input[x],INPUT);
  }
  
  for (int x = 0; x < 16; x++){
    pinMode(output[x],OUTPUT);
    digitalWrite(output[x],LOW);
  }

  pinMode(output_relay, OUTPUT); //declare relay output pin as output
  digitalWrite(output_relay, HIGH); //write relay pin high to turn on power to remote system
  
  //----------from led code-----------//
  //Ethernet.begin(mac, ip, gateway, subnet);
  server.begin();
  //---------------------------------//
  writeNormal();  // set box to normal mode on start up
  Serial.begin(9600);
  lcd.begin(16, 2);
}

//-----------from led code ---------------//
#define bufferMax 200
int bufferSize;
char bufferLED[bufferMax];
//-----------------------------------------//

void loop() {
  for (int x=0; x < 10; x++){  
   int temp = digitalRead(input[x]);  //read the input pins to aquire a data state of 10 digits
    if (temp){
      bitWrite(data,x,1);
    }
    else{
      bitWrite(data,x,0);
    }  
    
    //--------------from led code----------------------//
    Client client = server.available();
    if (client)
    {
      client_connected = true;
      time = millis();
      WaitForRequest(client);  // waits for client and sees when the request has ended
      delay(5);
      client.stop(); 

    }
  //--------------------------------------------------------//
  }
    
  Serial.println(data,BIN);  //data is the binary number representing pins on1 or off0
  Serial.println(identifydata(data));  //identify data takes a binary number and returns a integer value based on it from 0-35,  35 being the default state
  Serial.println(buffer); //buffer is assigned a value(human readable string)from state table according to the identify data function
  human_status = buffer;
    
  Serial.println("the mode is");
  Serial.println(mode);
  
  String x;  
  if ( x!=human_status){
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(human_status);
    lcd.setCursor(0,1);
    lcd.print("Mode: ");
    lcd.print(mode);
    x = human_status;
  }
  
  //reset the client connected if we havent seen a client in 3 min
  if (millis() - time >= reset_client){
    client_connected = false;
  }
  
  if (client_connected == true){
    lcd.setCursor(15,1);
    lcd.print("Y");
  }

  //stop();
  delay(500);

}


