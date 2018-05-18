#include "socketapp.h"
#include "uip.h"
#include <string.h>

extern char mybuff[20];
extern char sendbuff;

static int handle_connection(struct socket_app_state *s);

void socket_app_init(void)
{
  uip_listen(HTONS(9000));
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
    //PSOCK_SEND_STR(&s->p, sendbuff);
    PSOCK_SEND_STR(&s->p, " CMD: ");
    PSOCK_READTO(&s->p, '=');
    PSOCK_SEND_STR(&s->p, s->inputbuffer);  
    memcpy(mybuff,s->inputbuffer,20);
    //memset(s->inputbuffer, 0x00, sizeof(s->inputbuffer));
  } while(1);  
  PSOCK_CLOSE(&s->p);
  PSOCK_END(&s->p);
}


