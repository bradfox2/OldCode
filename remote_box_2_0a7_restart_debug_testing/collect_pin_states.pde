
//function that returns an int of 10 digits of either 1s or 0s that represent the high/low state of pins in input[] array.

int collect_pin_states(){
   int data = 0b0000000000;
   for (int x=0; x < 10; x++){  
      //read the input pins to aquire a data state of 10 digits
      if (digitalRead(inputpins[x])){
        bitWrite(data,x,1);
      }
      else{
        bitWrite(data,x,0);
      }
   }
   return data;
}  
    
