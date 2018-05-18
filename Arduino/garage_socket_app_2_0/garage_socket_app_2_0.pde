//    Tiny Robot Wifi Control Program
//    November 9th, 2009
//    Robert Svec

#include <WiShield.h>

#define WIRELESS_MODE_INFRA	1
#define WIRELESS_MODE_ADHOC	2

unsigned char local_ip[] = {192,168,0,156};
  unsigned char gateway_ip[] = {192,168,0,1};
unsigned char subnet_mask[] = {255,255,255,0};
const prog_char ssid[] PROGMEM = {"dlink"};
unsigned char security_type = 0;	// 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2
const prog_char security_passphrase[] PROGMEM = {};
prog_uchar wep_keys[] PROGMEM = {};
unsigned char wireless_mode = WIRELESS_MODE_INFRA;
unsigned char ssid_len;
unsigned char security_passphrase_len;

char mybuff[20], door_status[20], password[20];
int myintbuff, objdist1, objdist2, objdist3, passcode;
int access_granted = 0;



boolean opened;
boolean closed;

int up(){
  if (digitalRead(4)&& !digitalRead(5)){
    return 1;
    opened = true;
    closed = false;
  }
}

int down(){
  if (!digitalRead(4) && digitalRead(5)){
    return 1;
    closed = true;
    opened = false;
  }
}
  

void setup()
{
        pinMode(4, INPUT);
        digitalWrite(4,HIGH);
        pinMode(5, INPUT);
        digitalWrite(5,HIGH);
        pinMode(6, OUTPUT);
        digitalWrite(6,LOW);
        
	WiFi.init();
        myintbuff = 0;
        Serial.begin(9600);
}

void loop(){
WiFi.run();

Serial.println(password);

passcode = atoi(password);
if( passcode == 123){
    access_granted = 1;
    Serial.println("access granted");
}
  
if (up() == 1){
  char up[] = {"Open"};
  memcpy(door_status, up, 5);
  Serial.println("status is up");
}

if (down() == 1){
  char closed[] = {"Closed"};
  memcpy(door_status, closed, 7);
  Serial.println("status is down");
}

       
myintbuff = atoi(mybuff);
  
  if (myintbuff == 1){
      if (up() ==1 ){
      
      digitalWrite(6,HIGH); 
      delay(750);
      digitalWrite(6,LOW);
      mybuff[0] = '9';
    }
  }
  
  if (myintbuff == 2){
       if (down() == 1){
       
       digitalWrite(6,HIGH);
       delay(750);
       digitalWrite(6,LOW);
       mybuff[0] = '9';
      }
  }
  
  if (myintbuff == 3){
            
       digitalWrite(6,HIGH);
       delay(750);
       digitalWrite(6,LOW);
       mybuff[0] = '9';
  }
  
      
}


