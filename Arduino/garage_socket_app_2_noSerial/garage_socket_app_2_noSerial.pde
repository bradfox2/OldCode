//Garage Door Opener//
//April 21, 2011//

#include <WiShield.h>
extern "C"{
  #include "g2100.h"
  #include "uip.h"
  #include <avr/io.h>
  #include <avr/wdt.h>
}

//---------------------------------------------------------------------------//

unsigned char local_ip[] = {192,168,0,156};
unsigned char gateway_ip[] = {192,168,0,1};
unsigned char subnet_mask[] = {255,255,255,0};
char ssid[]  = {"dlink"};
unsigned char security_type = 3;	// 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2
const prog_char security_passphrase[] PROGMEM = {"storm123"};
prog_uchar wep_keys[] PROGMEM = {};
#define WIRELESS_MODE_INFRA	1
#define WIRELESS_MODE_ADHOC	2
unsigned char wireless_mode = WIRELESS_MODE_INFRA;
unsigned char ssid_len;
unsigned char security_passphrase_len;
//----------------------------------------------------------------------------//

char state[10], returnMessage[100]; 
int command, pin, counter;
boolean oopen, closed, middle, socket_needs_close, activity_flag, connected_flag;
unsigned char minutes;
unsigned long activity,time_open, time_close, time_open_last, time_closed_last, time_last_toggled;
unsigned int conn_state;


void setup()
{
        minutes = 0;
        activity = 0;
        counter = 0;
  
        // set up the pins   
        pinMode(3,OUTPUT);
        digitalWrite(3,LOW);
        pinMode(4, INPUT);
        digitalWrite(4,HIGH);
        pinMode(5, INPUT);
        digitalWrite(5,HIGH);
        pinMode(6, OUTPUT);
        digitalWrite(6,LOW);
        
        // init the wisheild
        WiFi.init();
        
        ////Serial.begin(57600);
}

void loop()
{
  //check door states
   if (!digitalRead(5) && digitalRead(4)){
     oopen = 1;
     closed = 0;
     middle = 0;
     time_open = millis();
     strcpy(state, "Up");
     //sprintf(returnMessage, "The door is up."); 
     //socket_app_appcall();
     //////Serial.println("Showing Up");
     
   }
   
   else if (digitalRead(5) && !digitalRead(4)){
     closed = 1;
     oopen = 0;
     middle = 0;
     time_close = millis();
     strcpy(state, "Down");
     //////Serial.println("Showing Down");
   }
   
   else if (!closed||!oopen){
     middle = 1;
     strcpy(state, "Middle");
     //////Serial.println("Showing Middle");
   }
   
   time_open_last = (millis()- time_open)/60000; //in minutes
   time_closed_last = (millis()- time_close); // in hours
   
   
   ////Serial.print("Current count time is:");
   ////Serial.println(millis());
   ////Serial.print("The count last seen open was:");
   ////Serial.println(time_open);
   ////Serial.print("Time last open was:");
   ////Serial.println(time_open_last);
   
   
   
   if (activity_flag){
     if ( millis() > activity){
       ////Serial.println("Activity timer expired");
       socket_needs_close = 1;
       activity_flag = false;
     }
   }
    if (connected_flag){
       digitalWrite(3, HIGH);
       ////Serial.println("Connected flag high");
    }
    else{
      //Serial.println("Connected flag low.");
      digitalWrite(3, LOW);
    }
   
   
   sprintf(returnMessage, "Garage is %s. Last opened %ld minute(s) ago.\r\n", state, time_open_last); 
   //Serial.println(returnMessage);
   ////Serial.println(sizeof(returnMessage));
   //Service wifi sheild;
   WiFi.run();
   
   

   counter = counter++;
   
   //Serial.println(counter);
   
   conn_state = zg_get_conn_state();
   if (!conn_state){
     WiFi.init();
   }
   
   //Serial.print("The connection state is:");
   //if (conn_state) //Serial.println("Connected");
   //else //Serial.println("Not connected");
   
}
extern "C"
{
 
 int processRequest(unsigned char* requestData)
   { 
     if ('t' == requestData[0] || 'T' == requestData[0]){
       toggle();
       strcpy(returnMessage, "\r\nToggling door. ");
       //Serial.println("Toggle Request");
       counter = 0;
     }
     
//    unsigned int rssi = zg_get_rssi();
//    requestData[1] = rssi >> 8;
//    requestData[2] = rssi & 0xFF;
//    requestData[3] = 0;   

   socket_needs_close = 0; 
   
   activity_flag=true;   
   activity = millis() + 300000;
   return 4;
 
   }
   
   
  void socket_app_init(void)
   {
      uip_listen(HTONS(8080));
   }
   
   
  void socket_app_appcall(void)
   {
      if (uip_connected()){
            connected_flag = true;      
            //Serial.println("UIP says connected");
           }
         
      if(uip_newdata() || uip_rexmit()) {
          activity = millis() + 300000;
          processRequest((unsigned char*)uip_appdata);
          uip_send(returnMessage, 100);
      }
      
      if(uip_poll()) {
         if((1 == socket_needs_close) || uip_timedout()) {
           //Serial.println("Socket needs to be closed");
            uip_close();
            connected_flag = false;
         }
      }
      
      if(uip_closed()) {
         //Serial.println("Closed by remote party");
         connected_flag = false;
         socket_needs_close = 0;
      }
      
   }
}

  
void toggle(){
     digitalWrite(6,HIGH);
     delay(750);
     digitalWrite(6,LOW);  
     time_last_toggled = millis();
}


  


