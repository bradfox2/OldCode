#include <SD.h>

long a = 1000000000;
char input_pin_state[15];

void setup(){
  Serial.begin(9600);
  SD.begin(3);
  Serial.println(determine_pin_state(a));
  //Serial.println(input_pin_state);
}

void loop(){}



char* determine_pin_state(int input_pin_read){  //input some 10 digit number of 1s and 0s 
  
  int number_of_state_pairs = 0;
  
  shutdown_ethernet();  //kick ethernet sheild off spi bus
  enable_sd(); //bring sd card onto spi bus
  
  File pin_state_file = SD.open("pinsts.txt");
  if (!pin_state_file) Serial.println("cant open the file");
  
  //if pin_state_file exists, determine the size of it and create a buffer array, and read in the txt file for parsing
  if(pin_state_file){

    char file_buffer[100];
    int i = 0;
    while (pin_state_file.available()){
      if(pin_state_file.peek() != -1){
        file_buffer[i] = pin_state_file.read();
        //Serial.println(file_buffer[i]);
        if (file_buffer[i] == ':'){
          number_of_state_pairs++;
          //Serial.println("Match");
        }
        i++;
      }
    };
    //Serial.print("Number of state pairs is: "); Serial.println(number_of_state_pairs);
    //Serial.print("file_buffer is: ");Serial.println(file_buffer);
    
    //we see data as "xxxxxxx":0101010101\n"xxxxxxxxxx":1010101010\n
    //first step is to seperate into an array of {xxxxxxxxx, 101010101, xxxxxxxxxx, 101010101} using \n and : as a token delimiter
    
    
    char *first_token_array[number_of_state_pairs]; //Serial.print("The first token array is: ");Serial.println(first_token_array);
    char *first_tokens = NULL;
    first_tokens = strtok(file_buffer, "\r\n:");
    int number_of_first_tokens = 0;
    while(first_tokens != NULL){
      Serial.println(first_tokens);Serial.println("----------------");
      first_token_array[number_of_first_tokens] = first_tokens;
      first_tokens = strtok(NULL,"\r\n:");
      number_of_first_tokens++;
    }
       
    //if there is a match in the stored pin states, return the corresponding member of first_token_array
    for( int var = 1; var <= 100; var = var + 2){
      if(input_pin_read == (long)atoi(first_token_array[var])){
       //strncpy(input_pin_state, first_token_array[var-1], sizeof(first_token_array[var-1]));
       //Serial.print("asdfasfd : ");Serial.println(first_token_array[var-1]);
       return first_token_array[var-1];
      }
    } 
    
    //if no value has matched
       //strncpy(input_pin_state, "No Match",9);
       char b[] = "No Match" ;
       return b;  
  }
  
  pin_state_file.close();
  
  //enable_ethernet(); // bring ethernet back onto spi bus
}
