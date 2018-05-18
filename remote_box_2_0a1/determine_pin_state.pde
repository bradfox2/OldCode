//function to determine the pin state by comparing the input pin read against a file on the sd card.

char determine_pin_state(int input_pin_read){
  
  int number_of_state_pairs = 0;
  
  shutdown_ethernet();  //kick ethernet sheild off spi bus
  enable_sd(); //bring sd card onto spi bus
  
  File pin_state_file = SD.open("pinsts.txt");
  
  //if pin_state_file exists, determine the size of it and create a buffer array, and read in the txt file for parsing
  if(pin_state_file){
    char file_buffer[pin_state_file.size()];
    while (pin_state_file.available()){
      for ( int i = 0; i < pin_state_file.size(); i++) {
        file_buffer[i] = pin_state_file.read();
        if (strcmp(&file_buffer[i], ":") == 0); ++number_of_state_pairs;
      }
    }
    
    char* first_token_array[number_of_state_pairs];
    char *first_tokens = strtok(file_buffer, "\r\n");
    int number_of_first_tokens = 0;
    while(first_tokens != NULL){
      first_token_array[number_of_first_tokens] = first_tokens;
      first_tokens = strtok(NULL,"\r\n");
      number_of_first_tokens++;
    }
    
    char *second_token_array[number_of_first_tokens];
    int number_of_second_tokens = 0;
    for (int i = 0; i<=sizeof(number_of_first_tokens); i++){    
      char *second_tokens = strtok(first_token_array[i],":");
      while (second_tokens != NULL){
        second_token_array[number_of_second_tokens] = second_tokens; 
        second_tokens = strtok(NULL,":");
        number_of_second_tokens++;   
      }
      char state_name[number_of_second_tokens];
      char stored_pin_values[number_of_second_tokens];
    }
    
    char state_name[number_of_second_tokens];
    for (int evens = 0; evens <= number_of_second_tokens;){
      state_name[evens] = *second_token_array[evens];
      evens = evens + 2;
    }
    
    char stored_pin_values[number_of_second_tokens];
    for (int odds = 1; odds <= number_of_second_tokens;){
      stored_pin_values[odds] = *second_token_array[odds];
      odds = odds + 2;
    }
    
    for( int var = 0; var <= 100; var++){
      if(input_pin_read == atoi(&stored_pin_values[number_of_state_pairs])){
       //return state_name[var]
       strncpy(input_pin_state, state_name, number_of_state_pairs);
      }
    } 
    
    //if no value has matched
       strncpy(input_pin_state, "No Match",9);  
  }
  
  pin_state_file.close();
  
  enable_ethernet(); // bring ethernet back onto spi bus
}
