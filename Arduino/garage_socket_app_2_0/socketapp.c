#include "socketapp.h"
#include "uip.h"
#include <string.h>

extern char mybuff[20], password[20];
extern char door_status;
extern int access_granted;


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
    //PSOCK_SEND_STR(&s->p, "Welcome to Arduino Garage Door Opener");
    //PSOCK_SEND_STR(&s->p, '13');
    PSOCK_SEND_STR(&s->p, "What is the access code?");
    PSOCK_READTO(&s->p, '=');
    memcpy(password,s->inputbuffer,20);
    memset(s->inputbuffer,0,20);

        if (access_granted == 1){
          PSOCK_SEND_STR(&s->p, "Access granted.");
          PSOCK_SEND_STR(&s->p, '\n');
          break;
        }
        else if (access_granted == 0){
          PSOCK_SEND_STR(&s->p, "Access denied.");
          PSOCK_SEND_STR(&s->p, '\n');
          PSOCK_SEND_STR(&s->p, "Please enter again, one attempt remaining.");
          PSOCK_SEND_STR(&s->p, '\n');
          memset(s->inputbuffer,0,20);
          PSOCK_READTO(&s->p, '=');
          memcpy(password,s->inputbuffer,20);
              if (access_granted == 1){
                PSOCK_SEND_STR(&s->p, "Access granted.");
                PSOCK_SEND_STR(&s->p, '\n');
                break;
              }
              if (access_granted == 0){
                PSOCK_SEND_STR(&s->p, "Access denied, Goodbye.");
               break;
              }        
        }

    PSOCK_SEND_STR(&s->p, "The status is:");
    PSOCK_SEND(&s->p, &door_status, 20);
    //PSOCK_SEND_STR(&s->p, '/n');
    memset(s->inputbuffer,0,20);
    PSOCK_READTO(&s->p, '=');
    memcpy(mybuff,s->inputbuffer,20);
        
  }
  while(1);  

  PSOCK_CLOSE(&s->p);
  PSOCK_END(&s->p);
}



