
//___________________________________________________Read in the Shift Registers_______//

//define where your pins are
int latchPin = 8;
int dataPin = 9;
int clockPin = 10;

byte switchVar1;
byte switchVar2;
long registerinput;

void setup() {
  //start serial
  Serial.begin(9600);

  //define pin modes
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT); 
  pinMode(dataPin, INPUT)
}

void loop() {
  //Pulse the latch pin:
  //set it to 1 to collect parallel data
  digitalWrite(latchPin,1);
  //set it to 1 to collect parallel data, wait
  delayMicroseconds(20);
  //set it to 0 to transmit data serially  
  digitalWrite(latchPin,0);
  
  switchVar1 = shiftIn(dataPin, clockPin);
  switchVar2 = shiftIn(dataPin, clockPin);
  bitWrite(switchVar1,7,1);
  bitWrite(switchVar2,3,1);
  registerinput = (switchVar2 << 8) | switchVar1; 
  Serial.println(registerinput, BIN);
  Serial.println(bitRead(registerinput,2));
delay(1000);
}

int shiftIn(int myDataPin, int myClockPin) { 
    int i;
    int temp = 0;
    int pinState;
    byte myDataIn = 0;

    pinMode(myClockPin, OUTPUT);
    pinMode(myDataPin, INPUT);

    for (i=7; i>=0; i--)
  {
    digitalWrite(myClockPin, 0);
    delayMicroseconds(2);
    temp = digitalRead(myDataPin);
    if (temp) {
      pinState = 1;
      //set the bit to 0 no matter what
      myDataIn = myDataIn | (1 << i);
    }
    else {
      pinState = 0;
    }
    digitalWrite(myClockPin, 1);
  }
  return myDataIn;
}


//_______________________________________________________________END read in shift registers________________________________________________//
