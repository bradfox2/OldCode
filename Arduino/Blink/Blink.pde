/*
  Blink
 
 Turns on an LED on for one second, then off for one second, repeatedly.
 
 The circuit:
 * LED connected from digital pin 13 to ground.
 
 * Note: On most Arduino boards, there is already an LED on the board
 connected to pin 13, so you don't need any extra components for this example.
 
 
 Created 1 June 2005
 By David Cuartielles
 
 http://arduino.cc/en/Tutorial/Blink
 
 based on an orginal by H. Barragan for the Wiring i/o board
 
 */

int ledPin =  4;    // LED connected to digital pin 13
int ledgnd = 2;
int ledblu =1;
// The setup() method runs once, when the sketch starts

void setup()   {                
  // initialize the digital pin as an output:
  pinMode(ledPin, OUTPUT);     
  pinMode(ledgnd, OUTPUT);
  pinMode(ledblu, OUTPUT);
}

// the loop() method runs over and over again,
// as long as the Arduino has power

void loop()                     
{
  digitalWrite(ledPin, HIGH);  // set the LED on
  digitalWrite(ledblu, LOW);
  digitalWrite(ledgnd, LOW);
  delay(100);                  // wait for a second
  digitalWrite(ledgnd, HIGH);    // set the LED off
  delay(100);                  // wait for a second
}
