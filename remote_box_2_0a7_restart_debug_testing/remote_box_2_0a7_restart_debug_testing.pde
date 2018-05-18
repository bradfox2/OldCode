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
#include <Button.h>
/*************************************************************************************************************************************************
*                                                        Button Setup
*************************************************************************************************************************************************/
Button mode_cycle_button = Button(20, PULLUP);
Button target_power_state_switch = Button(21, PULLUP);

/*************************************************************************************************************************************************
*                                   LCD configuration
*************************************************************************************************************************************************/

LiquidCrystal lcd(9, 8, 7, 6, 5, 4); // initialize the LCD library with the pin settings
int key = 0;  // Key for lcd printer function 

/*************************************************************************************************************************************************
*                                  Ethernet Parameters
*************************************************************************************************************************************************/
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 0, 187 };
byte ipEEP[] = {(EEPROM.read(1)),(EEPROM.read(2)),(EEPROM.read(3)),(EEPROM.read(4))};
byte gateway[] = {192, 168, 1, 1};
byte subnet[] = {255, 255, 0, 0};
/*************************************************************************************************************************************************
*                                   Memory space for string management and setup WebServer service
*************************************************************************************************************************************************/

// For sending HTML to the client
#define STRING_BUFFER_SIZE 512
//char buffer[STRING_BUFFER_SIZE];

// to store data from http request
#define STRING_from_http_request_SIZE 1024
//char from_http_request[STRING_from_http_request_SIZE];



/*************************************************************************************************************************************************
*                                  //Functions stored in _fcts array should take pointer to char buffer as argument and return no
                                   //value. Result to send to client should be null terminated string stored in buffer.
*************************************************************************************************************************************************/
void (*_fcts['z'-'a'])(char *, Client);

/*************************************************************************************************************************************************
*                                                        Pin Declarations
*************************************************************************************************************************************************/
const int inputpins[] = {22,23,24,25,26,27,28,29,30,31};
const int outputpins[] = {32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47};
const int relaypin = 19;

/*************************************************************************************************************************************************
*                                        define HTTP return structure ID for parsing HTTP header request
*************************************************************************************************************************************************/
struct http_storage{
  char page_request[30];
  boolean get_request;
  boolean post_request;
  char post_data[200];
} header_info;

/*************************************************************************************************************************************************
*                                                        Global variables
*************************************************************************************************************************************************/
Server server(80);
int input_pin_read = 0b0000000000; //variable to store the combined status of all input pins
char input_pin_state[30], current_output_mode[30];
byte* current_ip_address;
char *mode_name_list[30];
char *mode_value_list[30];

//mime types
#define MIME_TYPE_ARRAY_LENGTH 18
char mime_type[][19] = {"htm","text/html",
                    "txt","text/plain",
                    "css","text/css",
                    "xml","text/xml",
                    "js","text/javascript",
                    "gif","image/gif",
                    "jpg","image/jpeg",
                    "png","image/png"};
                    
char parse_buffer;
char injection_buffer[100];
int number_of_mode_buttons = 0;   // aka the number of modes
long connection_timeout = 0;  //connection timeout of client
boolean is_he_connected = false;

void setup() {
  set_pinmodes(); // set the digital pins to input output modes on the board
  enable_ethernet(); //function for bringing the ethernet card onto the spi bus
  ethernet_setup();  // initialize the ethernet chip with the ethernet parameters. Control whether to obtain ip off EEPROM or hard coded
  relay_off(); //write relay pin low to turn off power to remote system
  init_default_mode();  //set the box mode the default state set by the user. 

  //launch all services
  Serial.begin(115200); // DEBUG
  lcd.begin(16,2); lcd.clear(); // init the lcd screen 
  server.begin();
  shutdown_ethernet(); enable_sd();
  if(!SD.begin(3)){  //init the SD card with CS pin 3
    lcd.print("Error: SD Init Fail"); 
    Serial.println("ERROR: SD init failed");
    
  }
  listmodes("outsts.txt"); // populate the modes array with a list of current output modes in prep for printing a page where client can select a mode
  enable_ethernet();
  
  
  //populate the array that holds the function pointers for injection.  functions are written in injection_functions tab.
  _fcts[0] = NULL;
  _fcts['b'-'a'] = INJECT_input_pin_read;
  _fcts['c'-'a'] = INJECT_input_pin_state;
  _fcts['d'-'a'] = INJECT_current_output_mode; 
  //_fcts['e'-'a'] = INJECT_current_ip_address; 
  _fcts['f'-'a'] = INJECT_current_input_definitions;
  _fcts['g'-'a'] = INJECT_current_output_definitions;
  _fcts['h'-'a'] = INJECT_mode_change_buttons;
}

/*************************************************************************************************************************************************
*                                                           Main loop
*************************************************************************************************************************************************/

void loop() {
  input_pin_read = collect_pin_states();// collect the pin states into a binary int
  strcpy(input_pin_state, determine_pin_state(input_pin_read, "insts.txt"));  // det pin states takes an int and a file to test the int against a list of states
  Client client = server.available();
    if (client) { // now client is connected to arduino
      remote_user_connected(true, millis());
      read_http_request(client);   // read HTTP header request... so select what page client are looking for and then call process http request func
      client.stop();    
    }
  if (!remote_user_connected()){
    Serial.println("Remoted user is disconnected");
    mode_cycle_button_pressed();
    local_target_power();  // true means the target power is on, false its of
  }
  lcd_printer();
    lcd.setCursor(0, 1);
  // print the number of seconds since reset:
  lcd.print(millis()/1000);
}
