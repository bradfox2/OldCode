int latchPin = 8;
int dataPin = 9;
int clockPin = 10;

int firstreg; 
int secondreg;

void setup() {
  //start serial
  Serial.begin(9600);

  //define pin modes
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT); 
  pinMode(dataPin, INPUT);

}

void loop() {

  //Pulse the latch pin:
  //set it to 1 to collect parallel data
  digitalWrite(latchPin,1);
  //set it to 1 to collect parallel data, wait
  delayMicroseconds(20);
  //set it to 0 to transmit data serially  
  digitalWrite(latchPin,0);

  firstreg = shiftIn(dataPin, clockPin);
  //secondreg = shiftIn(dataPin, clockPin);

  Serial.println(firstreg, BIN);
  
Serial.println("-------------------");

delay(500);

}
int shiftIn(int myDataPin, int myClockPin) { 
  int i;
  int data[8];
  int pinState;
  int myDataIn = 0;

  pinMode(myClockPin, OUTPUT);
  pinMode(myDataPin, INPUT);

  for (i=7; i>=0; i--)
  {
    digitalWrite(myClockPin, 0);
    delayMicroseconds(2);
    data[i] = digitalRead(myDataPin);
    Serial.print(data[i]);
    Serial.print("     ");
    digitalWrite(myClockPin, 1);
  }
 //return data;
}



