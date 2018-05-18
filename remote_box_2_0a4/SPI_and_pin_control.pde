//functions to overcome the Wiz net SPI bug.   shuts down and starts up the ethernet sheild 

void enable_ethernet(){
  digitalWrite(3, HIGH);
  digitalWrite(2, HIGH);
  digitalWrite(10,LOW);
}

void shutdown_ethernet(){
  digitalWrite(2, LOW);
  digitalWrite(10,HIGH);
}

void enable_sd(){
  digitalWrite(3, LOW);
  digitalWrite(2, LOW);
  digitalWrite(10,HIGH);
}
void set_pinmodes(){
  pinMode(2,OUTPUT);
  pinMode(53,OUTPUT);
  pinMode(3,OUTPUT);
  pinMode(10,OUTPUT);
  
  for (int pin = 22; pin <= 31; ++pin ){ // setup the input pins
     pinMode(pin,INPUT);
   }
  
  for (int pin = 32; pin <= 47; ++pin){ // setup the output pins
    pinMode(pin,OUTPUT);
    digitalWrite(pin,LOW);
  }
    pinMode(relaypin, OUTPUT); //declare relay output pin as output
}
