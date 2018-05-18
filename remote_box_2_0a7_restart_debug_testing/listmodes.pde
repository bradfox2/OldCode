
// function to list the output modes


char* listmodes(char file[]){ 
  shutdown_ethernet();
  enable_sd();

  File outsts = SD.open(file, FILE_READ);
  if (!outsts) {Serial.print("DPS: Cant open the file : "); Serial.println(file);}
	
  int number_of_state_pairs = 0;
   if(outsts){
      char file_buffer[1000];
      int i = 0;
      while (outsts.available()){
        if(outsts.peek() != -1){
          file_buffer[i] = outsts.read();
          //Serial.println(file_buffer[i]);
          if (file_buffer[i] == ':'){
            number_of_state_pairs++;
            //Serial.println("Match");
          }
          i++;
        }
      };
	  file_buffer[i] = NULL;  //null terminate the array

      //Serial.print("Number of state pairs is: "); Serial.println(number_of_state_pairs);
      //Serial.print("file_buffer is: ");Serial.println(file_buffer);
      
      //we see data as "xxxxxxx":0101010101\n"xxxxxxxxxx":1010101010\n
      //first step is to seperate into an array of {xxxxxxxxx, 101010101, xxxxxxxxxx, 101010101} using \n and : as a token delimiter
      
      
      char *first_token_array[number_of_state_pairs]; //Serial.print("The first token array is: ");Serial.println(first_token_array);
      char *first_tokens = NULL;
      first_tokens = strtok(file_buffer, "   \r\n:");
      int number_of_first_tokens = 0;
      int j = 0;
      int k = 0;
      while(first_tokens != NULL){
		  //Serial.print("token");Serial.print(number_of_first_tokens);Serial.print(": ");
        //Serial.println(first_tokens);
        if (number_of_first_tokens % 2){ // if (its odd)
          mode_value_list[j] = first_tokens; // list of the names of modes corresponding to same index value as the mode value list 
          //Serial.println(mode_name_list[j]);
          j++;
        }
        else{
          mode_name_list[k] = first_tokens;
          //Serial.println(mode_value_list[k]);
          k++;
        }
//        first_token_array[number_of_first_tokens] = first_tokens;
        first_tokens = strtok(NULL,"   \r\n:");
        number_of_first_tokens++;
        
      }
      
	  number_of_mode_buttons = number_of_first_tokens/2;  // list the amount of modes as numer of first tokens/ divided by two

	  //Serial.println(number_of_mode_buttons);
	
      //copy all the mode names to mode_list by looping over first token array where mode names are 0,2,4...
	  //int y = 0;
          //Serial.println(availableMemory());     
   }
  outsts.close();

}

