//    Tiny Robot Wifi Control Program
//    November 9th, 2009
//    Robert Svec

#include <WiShield.h>
#include <Servo.h>

#define WIRELESS_MODE_INFRA	1
#define WIRELESS_MODE_ADHOC	2

Servo LeftServo;
Servo RightServo;
Servo IRServo;

unsigned char local_ip[] = {192,168,1,2};
unsigned char gateway_ip[] = {192,168,1,1};
unsigned char subnet_mask[] = {255,255,255,0};
const prog_char ssid[] PROGMEM = {"Gibson"};
unsigned char security_type = 3;	// 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2
const prog_char security_passphrase[] PROGMEM = {"AlexanderTheSimple"};
prog_uchar wep_keys[] PROGMEM = {};
unsigned char wireless_mode = WIRELESS_MODE_INFRA;
unsigned char ssid_len;
unsigned char security_passphrase_len;

char mybuff[20], sendbuff;
int myintbuff, objdist1, objdist2, objdist3;

void setup()
{
	WiFi.init();
        
        pinMode(7,OUTPUT);
        //RightServo.write(90);
        //delay(20);
        //LeftServo.write(90);
        //delay(20);
        //IRServo.write(100);
        //delay(20);
        myintbuff = 0;
}

void loop()
{
	WiFi.run();
        myintbuff = atoi(mybuff);
        if (myintbuff == 1)
        {
         digitalWrite(7,HIGH);
         mybuff[0] = '9';
        }
         if (myintbuff == 2)
        {
         digitalWrite(7,LOW);
         mybuff[0] = '9';
        }
       
}






















