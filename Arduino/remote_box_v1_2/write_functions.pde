void writeCommon(){
	digitalWrite(32,LOW);	
	digitalWrite(33,LOW);
	digitalWrite(34,HIGH);	
	digitalWrite(35,HIGH);	
	digitalWrite(36,LOW);	
	digitalWrite(37,LOW);	
	digitalWrite(38,LOW);	
	digitalWrite(39,LOW);	
	digitalWrite(40,HIGH);	
	digitalWrite(41,LOW);	
	digitalWrite(42,HIGH);	
	digitalWrite(43,LOW);	
	digitalWrite(44,LOW);	
	digitalWrite(45,HIGH);	
	digitalWrite(46,HIGH);	
	digitalWrite(47,HIGH);	
}

void writeLoader(){
        digitalWrite(32,LOW);	
	digitalWrite(33,LOW);
	digitalWrite(34,HIGH);	
	digitalWrite(35,HIGH);	
	digitalWrite(36,LOW);	
	digitalWrite(37,LOW);	
	digitalWrite(38,LOW);	
	digitalWrite(39,LOW);	
	digitalWrite(40,HIGH);	
	digitalWrite(41,HIGH);	
	digitalWrite(42,HIGH);	
	digitalWrite(43,HIGH);	
	digitalWrite(44,LOW);	
	digitalWrite(45,HIGH);	
	digitalWrite(46,HIGH);	
	digitalWrite(47,HIGH);	
}

void writeNormal(){
        digitalWrite(32,HIGH);	
	digitalWrite(33,HIGH);
	digitalWrite(34,HIGH);	
	digitalWrite(35,HIGH);	
	digitalWrite(36,LOW);	
	digitalWrite(37,LOW);	
	digitalWrite(38,LOW);	
	digitalWrite(39,LOW);	
	digitalWrite(40,HIGH);	
	digitalWrite(41,LOW);	
	digitalWrite(42,HIGH);	
	digitalWrite(43,LOW);	
	digitalWrite(44,LOW);	
	digitalWrite(45,HIGH);	
	digitalWrite(46,HIGH);	
	digitalWrite(47,HIGH);	
}

void relayOn(){
  digitalWrite(48, HIGH);
}

void relayOff(){
  digitalWrite(48,LOW);
}

