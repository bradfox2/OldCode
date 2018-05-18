//    Tiny Robot Wifi Control Program
//    November 9th, 2009
//    Robert Svec

#include <WiShield.h>

#define WIRELESS_MODE_INFRA	1
#define WIRELESS_MODE_ADHOC	2

unsigned char local_ip[] = {192,168,0,156};
unsigned char gateway_ip[] = {192,168,0,1};
unsigned char subnet_mask[] = {255,255,255,0};
const prog_char ssid[] PROGMEM = {"iseeyou"};
unsigned char security_type = 1;	// 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2
const prog_char security_passphrase[] PROGMEM = {"1111111111"};
prog_uchar wep_keys[] PROGMEM = {};
unsigned char wireless_mode = WIRELESS_MODE_INFRA;
unsigned char ssid_len;
unsigned char security_passphrase_len;


int up(){
  if (digitalRead(5)){
    return 1;
  }
}

int down(){
  if (digitalRead(4)){
    return 1;
  }
}

void toggle_door(){
     digitalWrite(6,HIGH);
     delay(750);
     digitalWrite(6,LOW);
}

#define fourhours 14400000;
unsigned long time_last_down;
unsigned long time_now = millis();
char command[20], sendbuff[20], password[5], state[7];
int myintbuff, access_granted;
int NUMpassword;
boolean last_seen_closed, last_seen_open;

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
        //Serial.begin(9600);
}

void loop(){

  //Serial.println(password);
    
  if (up()){
    memset(state,0,5);
    //char o[5] = "Open";
    strcpy(state, "Open");
    last_seen_closed = false;
    last_seen_open = true;
    unsigned long time_last_up = millis();
  }
  
  if (down()){
    memset(state,0,7);
    //char c[7] = "Closed";
    strcpy(state, "Closed");
    last_seen_closed = true;
    last_seen_open = false;
    unsigned long time_last_down = millis();
  }
  
  if (!up() && !down()){
    if (!last_seen_closed && !last_seen_open){
      memset(state, 0, 7);
      strcpy(state, "Unknown");
    }
    if(last_seen_closed){
      memset(state, 0, 7);
      strcpy(state, "Openin");
    }
    if(last_seen_open){
      memset(state,0,7);
      strcpy(state, "Closin");
    }
  }
  
//  if (!down()){
//    if (time_now - time_last_down > fourhours){
//      memcopy(sendbuff, ((time_now-time_last_down)/.0000002777), 20);
//      toggle_door();
//    }
//  }

  
  //String SPassword = password[5];
  //Serial.print(SPassword);
  //NUMpassword = atoi(password);
  //if (NUMpassword == 123){
    //access_granted = 1;      //set flag high for matched password
    //memset(password, 0, 5);      // clear password buffer
    //Serial.print(password[5]);
    //strcpy(sendbuff, "Access Granted");
    //Serial.println(sendbuff);
  //}
  
  myintbuff = atoi(command);
  if (myintbuff == 1){
          
     digitalWrite(6,HIGH);
     delay(750);
     digitalWrite(6,LOW);
     command[0] = '9';
     //
  }
    WiFi.run();
  // delay(50);
}
  
