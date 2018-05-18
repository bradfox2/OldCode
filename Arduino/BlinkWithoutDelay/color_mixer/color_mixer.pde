
#include <Math.h>
int val1;
int val2;
int val3;
const int buttonPin = 12;
int buttonState;             // the current reading from the input pin
int lastButtonState = LOW;   // the previous reading from the input pin
long lastDebounceTime = 5;  // the last time the output pin was toggled
long debounceDelay = 50;    // the debounce time; increase if the output flickers


void setup()
{
 Serial.begin(9600);
 pinMode(buttonPin, INPUT);
}

void loop()
{
  int reading = digitalRead(buttonPin);
  if (reading != lastButtonState) {
    lastDebounceTime = millis();
  } 
    if ((millis() - lastDebounceTime) > debounceDelay) {
    buttonState = reading;
    delay(50);
  
  val1 = random(00,255);
  val2 = random(00,255);
  val3 = random(00,255);
  
 analogWrite(9, val1); //green
 analogWrite(10, val2); //blue
 analogWrite(11, val3); //red
 analogWrite(3, val1); //green
 analogWrite(5, val2); //blue
 analogWrite(6, val3); //red
 
 Serial.print(buttonState);
 Serial.print(val1);
 Serial.print(", ");
 Serial.print(val2);
 Serial.print(", ");
 Serial.println(val3);
    }
 
 lastButtonState = reading;
}

