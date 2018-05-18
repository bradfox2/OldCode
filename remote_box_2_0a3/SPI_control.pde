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
