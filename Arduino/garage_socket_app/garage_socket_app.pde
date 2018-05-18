//Garage Door Opener//
//April 21, 2011//

#include <WiShield.h>
extern "C"{
  #include "g2100.h"
  #include "uip.h"
}

//---------------------------------------------------------------------------//
#define WIRELESS_MODE_INFRA	1
#define WIRELESS_MODE_ADHOC	2
unsigned char local_ip[] = {192,168,0,156};
unsigned char gateway_ip[] = {192,168,0,1};
unsigned char subnet_mask[] = {255,255,255,0};
char ssid[]  = {"dlink"};
unsigned char security_type = 3;	// 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2
const prog_char security_passphrase[] PROGMEM = {"storm123"};
prog_uchar wep_keys[] PROGMEM = {};
unsigned char wireless_mode = WIRELESS_MODE_INFRA;
unsigned char ssid_len;
unsigned char security_passphrase_len;
//----------------------------------------------------------------------------//

char command [20], sendbuff[20], password[5], state[7],signalStrength[5];
int myintbuff, access_granted ;
int NUMpassword, lastRssi;
unsigned int rssi;
boolean oopen, closed;

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
        Serial.begin(57600);
}

void loop(){
  WiFi.run();
  
  uip_send("ok\n", 3);
  //Serial.println(password);
    
  if (up()){
    memset(state,0,5); 
    strcpy(state, "Open");
    oopen = true;
  }
  
  if (down()){  
    memset(state,0,7);
    strcpy(state, "Closed");
    closed = true;
  }
  
  else {
    strcpy(state, "Middle");
  }
  
  
  
  myintbuff = atoi(command);
  
  if (myintbuff == 1){
     digitalWrite(6,HIGH);
     delay(750);
     digitalWrite(6,LOW);
     strcpy(sendbuff, "Actuating...");
     //
  }
    WiFi.run();
  // delay(50);
  rssi =  zg_get_rssi();
  sprintf(signalStrength,"%u\n", (rssi)); 
  Serial.println(rssi);
  int ss = (rssi/200)*100;
  Serial.println(ss);
  //Serial.println((rssi/200));
}

int up(){
  if (digitalRead(4)&& !digitalRead(5)){
    return 1;
  }
}

int down(){
  if (!digitalRead(4) && digitalRead(5)){
    return 1;
  }
}



