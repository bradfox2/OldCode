/*
 * Switch test program
 */

int switchPin = 12;              // Switch connected to digital pin 2
int ledpin = 2;
int val;
void setup()                    // run once, when the sketch starts
{
  Serial.begin(9600);           // set up Serial library at 9600 bps
  pinMode(switchPin, INPUT);    // sets the digital pin as input to read switch
  pinMode(ledpin, OUTPUT);
}


void loop()                     // run over and over again
{
    if ((digitalRead(switchPin)) == HIGH){
    digitalWrite(ledpin, HIGH);
  }
   if ((digitalRead(switchPin)) == LOW) {
     digitalWrite(ledpin,LOW);
  }
}
