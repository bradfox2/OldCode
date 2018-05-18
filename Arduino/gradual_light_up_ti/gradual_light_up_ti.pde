/*
    Fades a line down the channels, with max value and duration based on
    the voltage of analog pin 0.
    Try grounding analog 0: everything should turn off.
    Try putting +5V into analog 0: everything should turn on.

    See the BasicUse example for hardware setup.


    Alex Leone <acleone ~AT~ gmail.com>, 2009-02-03 */
#include "Tlc5940.h"

void setup()
{
  Tlc.init();
  Serial.begin(9600); 
}

void loop(){
int x;
for (x = 0; x<30; x++){
  Tlc.set( x, 4000);
  Tlc.update();
  delay(1000); 
  Serial.print(x);
}
}

