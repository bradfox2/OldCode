#include "socketapp.h"
#include "uip.h"
#include <string.h>

extern char command[20], password[5], state[7],signalStrength[5]; 
extern char sendbuff[20];
extern int access_granted;
extern unsigned int rssi;

static int handle_connection(struct socket_app_state *s);

void socket_app_init(void)
{
  uip_listen(HTONS(8080));
}


void socket_app_appcall(void)
{

  struct socket_app_state *s = &(uip_conn->appstate);
  if(uip_connected()) 
  {
    PSOCK_INIT(&s->p, s->inputbuffer, sizeof(s->inputbuffer));
  }
  handle_connection(s);
}


static int handle_connection(struct socket_app_state *s)
{
  PSOCK_BEGIN(&s->p);
  do
  {
    //if (!access_granted){
      //PSOCK_SEND_STR(&s->p, "Welcome to the Garage Door Opener.\r\n");
      //PSOCK_SEND_STR(&s->p, "What is the access code?\r\n");
      //PSOCK_READTO(&s->p, '\n');
      //memcpy(password,s->inputbuffer,5);
      //memset(s->inputbuffer,0,20);
      //}
    //else if (access_granted){ 
      
      PSOCK_SEND_STR(&s->p, "The door is: ");
      PSOCK_SEND_STR(&s->p, state);
      PSOCK_SEND_STR(&s->p, "\r\n");
      PSOCK_SEND_STR(&s->p, "Wifi Strength: ");
      PSOCK_SEND_STR(&s->p, signalStrength);
      PSOCK_SEND_STR(&s->p, "\r\n");
      PSOCK_SEND_STR(&s->p, "Command?\r\n");
      PSOCK_READTO(&s->p, '\n');
      memcpy(command,s->inputbuffer,20);

      //delay(50);
      //memset(s->inputbuffer,0,20);
    //}
  }   
   while(1);  
  PSOCK_CLOSE(&s->p);
  PSOCK_END(&s->p); 
}
