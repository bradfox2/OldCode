//functions to overcome the Wiz net SPI bug.   shuts down and starts up the ethernet sheild 
// other functions to set up pin modes etc..

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
  shutdown_ethernet();
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

void relay_on(){
  digitalWrite(relaypin, HIGH);
  Serial.println("SPI: Relay on.");
}

void relay_off(){
  digitalWrite(relaypin,LOW);
  Serial.println("SPI: Relay off.");
  
}

int bin2dec(char *bin)
{
  int b, k, m, n;
  int len, sum = 0;
 
  len = strlen(bin) - 1;
  for(k = 0; k <= len; k++){
    n = (bin[k] - '0'); // char to numeric value
    if ((n > 1) || (n < 0)){
      return (0);
    }
  for(b = 1, m = len; m > k; m--){
    // 1 2 4 8 16 32 64 ... place-values, reversed here
    b *= 2;
   }
  // sum it up
  sum = sum + n * b;
  //printf("%d*%d + ",n,b); // uncomment to show the way this works
  }
return(sum);
}

void init_default_mode(){
}
	
