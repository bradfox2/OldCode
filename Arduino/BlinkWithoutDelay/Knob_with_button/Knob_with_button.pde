// Controlling a servo position using a potentiometer (variable resistor) 
// by Michal Rinott <http://people.interaction-ivrea.it/m.rinott> 

#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
int switchPin = 12;
int ledpin = 2; 
void setup() 
{ 
  myservo.attach(3);  // attaches the servo on pin 9 to the servo object 
} 
 
void loop() 
{ 
  if ((digitalRead(switchPin)) == HIGH){
     myservo.write(48);                  // sets the servo position according to the scaled value 
     digitalWrite(ledpin, HIGH);
     delay(100);
  }
    if ((digitalRead(switchPin)) == LOW){
      myservo.write(60);
      digitalWrite(ledpin, LOW);
      delay(100);
    }
} 
