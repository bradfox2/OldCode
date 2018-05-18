//functions to overcome the Wiz net SPI bug.   shuts down and starts up the ethernet sheild 
// other functions to set up pin modes etc..

void ethernet_setup(){
    if (EEPROM.read(0) == 1) {
    Ethernet.begin(mac, ipEEP, gateway, subnet);
	current_ip_address = ipEEP;
  }
  else{ 
    Ethernet.begin(mac,ip,gateway,subnet);
	current_ip_address = ip;
  }
}

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
}

void relay_off(){
  digitalWrite(relaypin,LOW);  
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
char mode[] = {0000000000000000};
strcpy(current_output_mode, "Select the mode");
change_the_output_mode(mode);
}

int availableMemory() {
  int size = 1024; // Use 2048 with ATmega328
  byte *buf;

  while ((buf = (byte *) malloc(--size)) == NULL)
    ;

  free(buf);

  return size;
}

void change_the_output_mode(char *p_outmode){  // takes a pointer to a char array that is 1s and 0s 
  //function will change the output mode of the box depending on mode button click on index page, or button press on the physical unit
  Serial.println("change the output mode called");
  for(int n = 0; n <= 15; n++){  // p_output mode is the first address of the 1010.. number.  loop through the addresses testing each digit
  Serial.println(p_outmode[n]);
    if (p_outmode[n] != NULL){
      if( *(p_outmode + n) == '1'){
        Serial.print("Output pin"); Serial.print(outputpins[n]); Serial.println("going high"); 
        digitalWrite(outputpins[n], HIGH);
      } 
      else{
        Serial.print("Output pin"); Serial.print(outputpins[n]); Serial.println("going low");         
        digitalWrite(outputpins[n], LOW);
      }
    }
    else break;  
  } 
}


///---------------Listen for mode cycle button press and change the mode-----------------------------//
// This function listens for a button press and starts the mode change process if the relay state is off.  It will issue a time out and wait for another button press before
// timeout has expired and then go to next mode if pressed again.
void mode_cycle_button_pressed(){
  listmodes("outsts.txt"); // populate the modes array with a list of current output modes in prep for printing a page where client can select a mode
    if(mode_cycle_button.isPressed()){
      Serial.println("Mode cycle button press is detected.");
      delay(1000);
      if(!local_target_power()){ // if the target power switch (side of box) is off then go ahead and change mode
        Serial.println("Relay state is off, going to display the first mode");
        change_the_output_mode(mode_value_list[0]);
        strcpy(current_output_mode, mode_name_list[0]);
        Serial.println(mode_name_list[0]);
        lcd.clear();
        lcd.print(mode_name_list[0]);
        unsigned long timeout = millis();
        int n = 0;
        while(millis() - timeout <= 5000){  // timeout after 5 seconds // wait for next press
          if (mode_cycle_button.isPressed()){ // if pressed again then start through the modes
            if(mode_value_list[n] != NULL){
              delay(1000); // delay to let the button bounce so it doesnt fast cycle through all the modes
              change_the_output_mode(mode_value_list[n]);
              Serial.println(mode_name_list[n]);
              strcpy(current_output_mode, mode_name_list[n]);
              lcd.clear();
              lcd.print(mode_name_list[n]);
              Serial.print("Mode cycle pressed again going to mode: "); Serial.println(mode_name_list[n]);
              n++;
              timeout = millis(); // reset the timer when the button is clicked again
            }
           else{ // loop back around to start the lists over when they run out.
             change_the_output_mode(mode_value_list[0]);
             strcpy(current_output_mode, mode_name_list[0]);
             Serial.println("restarting the mode select list");
             Serial.println(current_output_mode);
             lcd.clear();
             lcd.print(mode_name_list[0]);
             n = 0; 
             timeout = millis();
           }
          } 
        }
      }
      else Serial.println("The local target power switch is on, cannot change mode.");
    }
}  

//////-------- poll the target power switch on side of box and see if we need to keep it on or turn it off------------//
boolean local_target_power(){
  if(target_power_state_switch.isPressed()){
    relay_on();
    return 1; // if its turned on
  }
  else{
   relay_off();
   return 0;
  }
}
  
  
