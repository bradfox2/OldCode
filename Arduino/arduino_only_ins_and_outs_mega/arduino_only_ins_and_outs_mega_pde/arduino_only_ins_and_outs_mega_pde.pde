#include <avr/pgmspace.h>
#include <SPI.h>
#include <Ethernet.h>
#include <String.h>

prog_char state_0[] PROGMEM = "State 1";   // "String 0" etc are strings to store - change to suit.
prog_char state_1[] PROGMEM = "State 2";
prog_char state_2[] PROGMEM = "state 3";
prog_char state_3[] PROGMEM = "state 4";
prog_char state_4[] PROGMEM = "state 5";
prog_char state_5[] PROGMEM = "state 6";
prog_char state_6[] PROGMEM = "State 7";   
prog_char state_7[] PROGMEM = "State 8";
prog_char state_8[] PROGMEM = "state 9";
prog_char state_9[] PROGMEM = "state 10";
prog_char state_10[] PROGMEM = "state 11";
prog_char state_11[] PROGMEM = "state 12";
prog_char state_12[] PROGMEM = "State 13";   // "String 0" etc are strings to store - change to suit.
prog_char state_13[] PROGMEM = "State 14";
prog_char state_14[] PROGMEM = "state 15";
prog_char state_15[] PROGMEM = "state 16";
prog_char state_16[] PROGMEM = "state 17";
prog_char state_17[] PROGMEM = "state 18";
prog_char state_18[] PROGMEM = "State 19";   // "String 0" etc are strings to store - change to suit.
prog_char state_19[] PROGMEM = "State 20";
prog_char state_20[] PROGMEM = "state 21";
prog_char state_21[] PROGMEM = "state 22";
prog_char state_22[] PROGMEM = "state 23";
prog_char state_23[] PROGMEM = "state 24";
prog_char state_24[] PROGMEM = "State 25";   // "String 0" etc are strings to store - change to suit.
prog_char state_25[] PROGMEM = "State 26";
prog_char state_26[] PROGMEM = "state 27";
prog_char state_27[] PROGMEM = "state 28";
prog_char state_28[] PROGMEM = "state 29";
prog_char state_29[] PROGMEM = "state 30";
prog_char state_30[] PROGMEM = "state 31";
prog_char state_31[] PROGMEM = "state 32";
prog_char state_32[] PROGMEM = "state 33";
prog_char state_33[] PROGMEM = "state 34";


PROGMEM const char *state_table[] = 	   // change "state_table" name to suit
{   
  state_0,
  state_1,
  state_2,
  state_3,
  state_4,
  state_5,
  state_6,
  state_7,
  state_8,
  state_9,
  state_10,
  state_11,
  state_12,
  state_13,
  state_14,
  state_15,
  state_16,
  state_17,
  state_18,
  state_19,
  state_20,
  state_21,
  state_22,
  state_23,
  state_24,
  state_25,
  state_26,
  state_27,
  state_28,
  state_29,
  state_30,
  state_31,
  state_32,
  state_33,
};
char html_buffer[30]; //buffer to hold html lines  
char buffer[50];    // make sure this is large enough for the largest string it must hold

const int input[] = {        
  22,23,24,25,26,27,28,29,30,31};

const int output[] = {
  32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47};

const int output_relay = 48; //output to control reed switch to control 110 v relay

int data; 

String human_status;


void setup() {
  for (int x = 0; x < 10; x++){
    pinMode(input[x],INPUT);
  }
  for (int x = 0; x < 16; x++){
    pinMode(output[x],OUTPUT);
    digitalWrite(output[x],LOW);
  }

  pinMode(output_relay, OUTPUT); //declare relay output pin as output
  digitalWrite(output_relay, HIGH); //write relay pin high
  Serial.begin(9600);
}

void loop() { 
  for (int x=0; x < 10; x++){ 
    int temp = digitalRead(input[x]);
    if (temp){
      bitWrite(data,x,1);
    }
    else{
      bitWrite(data,x,0);
    }  
  }
  //Serial.println(data,BIN);
  //Serial.println(data);  //data is the binary number representing pins on1 or off0
  //Serial.println(identifydata(data));  //identify data takes a binary number and returns a integer value based on it from 0-35,  35 being the default state
  //Serial.println(buffer); //buffer is assigned a value(human readable string)from state table according to the identify data function
  delay(100); 
}


