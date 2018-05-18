// this is a space to hold the functions which will eventually be called to inject various information into the webcode

boolean code_injector(char key, char injection_buffer[], char file_type[], File the_file, Client client ){
  
  //check to make sure that the file type is an appropriate type for injection,  IE  not an image.  
  //if it is a file type we want to inject into then set inject_flag high
  
  #define number_of_file_types 5
  boolean inject_flag = false;
  char file_types[number_of_file_types][4] = { "htm" , "css" , "xml" , "txt" , "csv" };
  int n;
  for (n = 0; n < number_of_file_types; n++){
    if (strncmp(file_types[n], file_type, 3) == 0){
      inject_flag = true;
      //Serial.print("N is: ");Serial.println(n);
      //Serial.println("Inject flag is true, prepare for injection");
    }
  }
  
  
  if (inject_flag && key =='#'){      //(file_type == "htm"||"css"||"xml"||"txt"||"csv") && key =='$'){
    Serial.print("The file type is: "); Serial.println(file_type);
    Serial.print("The key is: "); Serial.println(key);
    key = the_file.read(); // read the next char in the file.
    if ( key >= 'a' && key <='z') {
      Serial.print("The key is now: "); Serial.println(key);
      if (_fcts[ key - 'a'] == NULL) {
        Serial.println("_fcts is null"); 
        strcpy(injection_buffer ,"Data point not found.");
        } 
      else { 
        Serial.print("Calling _fcts with: "); Serial.println(key);
        _fcts[ key -'a'](injection_buffer); 
      }  
    }
    if (injection_buffer != NULL){
      enable_ethernet();
      Serial.println("Injection buffer is loaded");
      int x;
      while(injection_buffer[x] != NULL){
        Serial.print("Printing: "); Serial.print(injection_buffer[x]);Serial.println(" from injection buffer");
        client.print(injection_buffer[x]);
        x++;
      }
      memset(injection_buffer, NULL,100);
      return true;
    }
  }
  else return false;
}

// functions that are pointed to by the array declared: void (*_fcts['z'-'a'])(char *);  and populated in main tab in setup
void INJECT_input_pin_read(char *injection_buffer){
  Serial.println("INJECT_input_pin_read function was called");
  itoa(input_pin_read, injection_buffer, BIN);
}

void INJECT_input_pin_state(char *injection_buffer){
  Serial.println("INJECT_input_pin_state function was called");
  strcpy(injection_buffer, input_pin_state);
}
