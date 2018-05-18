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
