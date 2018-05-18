void set_output_pins(){
  int n;
  for (n = 0; n < 16; n++){
    int x = bitRead(binarymode,n);
    //Serial.print("The bitread is :");
    //Serial.print(x);
    //Serial.print(output[n]);
    if (x == 1){
        digitalWrite(output[n],HIGH);
        //Serial.print("Outputmode is ");
        //Serial.print(output[n]);
    }
    else{
      digitalWrite(output[n],LOW);
    }
  }
}
    
