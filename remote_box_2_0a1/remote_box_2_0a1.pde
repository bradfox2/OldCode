//Web Based PLC
//Brad
//July 2011

#include <EEPROM.h>
#include <LiquidCrystal.h>
#include <avr/pgmspace.h>
#include <Ethernet.h>
#include <String.h>
#include <SPI.h>
#include <stdio.h>
#include <SD.h>


/*************************************************************************************************************************************************
*                                   LCD configuration
*************************************************************************************************************************************************/

LiquidCrystal lcd(9, 8, 7, 6, 5, 4); // initialize the LCD library with the pin settings

/*************************************************************************************************************************************************
*                                   MAC address and IP address
*************************************************************************************************************************************************/
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 0, 187 };
byte ipEEP[] = {(EEPROM.read(1)),(EEPROM.read(2)),(EEPROM.read(3)),(EEPROM.read(4))};
byte gateway[] = {192, 168, 0, 1};
byte subnet[] = {255, 255, 0, 0};
/*************************************************************************************************************************************************
*                                   Memory space for string management and setup WebServer service
*************************************************************************************************************************************************/

// For sending HTML to the client
#define STRING_BUFFER_SIZE 256
char buffer[STRING_BUFFER_SIZE];

// to store data from http request
#define STRING_from_http_request_SIZE 256
char from_http_request[STRING_from_http_request_SIZE];



/*************************************************************************************************************************************************
*                                   Strings stored in flash of the HTML we will be transmitting
*************************************************************************************************************************************************/


/*************************************************************************************************************************************************
*                                                        Pin Declarations
*************************************************************************************************************************************************/
const int inputpins[] = {22,23,24,25,26,27,28,29,30,31};
const int outputpins[] = {32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47};
const int relaypin = 49;

/*************************************************************************************************************************************************
*                                        define HTTP return structure ID for parsing HTTP header request
*************************************************************************************************************************************************/
struct http_storage{
  char page_request[30];
  boolean get;
  boolean post;
  char post_data[200];
} header_info;

/*************************************************************************************************************************************************
*                                                        Shared variable
*************************************************************************************************************************************************/
Server server(80);
int input_pin_read = 0; //variable to store the combined status of all input pins
char input_pin_state[30];

void setup() {
  if (EEPROM.read(0)==1) Ethernet.begin(mac, ipEEP, gateway, subnet);
  else Ethernet.begin(mac,ipEEP,gateway,subnet);
   
  for (int pin = 22; pin <= 31; ++pin ){ // setup the input pins
     pinMode(pin,INPUT);
   }
  
  for (int pin = 32; pin <= 47; ++pin){ // setup the output pins
    pinMode(pin,OUTPUT);
    digitalWrite(pin,LOW);
  }

  pinMode(relaypin, OUTPUT); //declare relay output pin as output
  digitalWrite(relaypin, HIGH); //write relay pin high to turn on power to remote system
  
  //launch all services
  Serial.begin(9600); // DEBUG
  lcd.begin(16,2); // init the lcd screen 
  Ethernet.begin(mac, ip);
  server.begin();
  shutdown_ethernet();
  SD.begin(3);  //init the SD card with CS pin 3
    if(!SD.begin(3)) lcd.print("Error: SD Init Fail"); Serial.println("ERROR: SD init failed");
}

/*************************************************************************************************************************************************
*                                                           Main loop
*************************************************************************************************************************************************/

void loop() {
  //collect all the pin states
  input_pin_read  = collect_pin_states();  // collect the pin states into a binary int
  determine_pin_state(input_pin_read);  // compare the input pin read against a file list on the SD card and return char array pin state. copies a string to input_pin_state thats that is the current pin state
  enable_ethernet();
  Client client = server.available();
    if (client) { // now client is connected to arduino
      read_http_request(client);   // read HTTP header request... so select what page client are looking for
      process_http_request(client);
      delay(1);        // give the web browser time to receive the data
      client.stop();
    }

}

