
//This function will use the header_info struct and process the data 

boolean process_http_request(Client client, boolean get_request, boolean post_request){
  
  //DEBUG
  Serial.print("PHR: The page to send is: "); Serial.println(header_info.page_request);
  
  //process the GET request for all pages EXCEPT for the index.htm-----------------------------

  if (get_request && !post_request){
    //Serial.print("Printing the GET request of: "); Serial.print(header_info.page_request); Serial.println(" to client.");
    if(!page_printer(client, header_info.page_request)){ // false return indicates a 404 error
      return false;
    }
    else{
      return true;    
    }
  }
   
   //process the post request -------------------------------

  char input_pin_state_define[50], output_pin_state_define[50], new_ip_address[20];
  int input_pin_read_define = 0b0, output_pin_read_define = 0b0;
  if (!get_request && post_request){
     Serial.print("PHR: Post data is: ");Serial.println(header_info.post_data);
     
     if (strstr (header_info.post_data, "Relay=") != NULL){
       Serial.println("PHR: Relay Manipulation");
       if (strstr(header_info.post_data + 6, "on") != NULL) relay_on();
       if (strstr(header_info.post_data + 6, "off") != NULL) relay_off();
     return true;
     }
     
     if (strstr (header_info.post_data, "input_pin_state_define=") != NULL){
       Serial.println("Defining new input state");
       char * pch = (strchr(header_info.post_data,'&'));
       *pch = NULL; // null out where the first & occurs
       strcpy(input_pin_state_define, &header_info.post_data[22 + 1]);
       *pch = '&';
       Serial.print("PHR: Input Define name is: "); Serial.println(input_pin_state_define);
       for (int x = 0; x <= 9; x++){
         char x_char[1];
         itoa(x + 1, x_char,10);
         Serial.println(x_char);
         if(strstr(header_info.post_data, x_char)!=NULL){
           Serial.println("Writing Bit");
           bitWrite(input_pin_read_define, x, 1);
         }
       } 
       if (!pin_name_exists(input_pin_read_define, "insts.txt")){       
         Serial.print("Pins are: ");Serial.println(input_pin_read_define, BIN);
         enable_sd();
         File pin_state_file = SD.open("insts.txt", FILE_WRITE);
         if (!pin_state_file) Serial.println("PHR: Cant open the file : insts.txt");
         pin_state_file.println();
         pin_state_file.print(input_pin_state_define);
         pin_state_file.print(":");
         pin_state_file.print(input_pin_read_define,DEC);
         pin_state_file.close();
         enable_ethernet();
       }
       else{
         Serial.println(" PHR: The pin state definition already exists.");       
         //Should also print error message to client.
       }
       return true;       
     }
     
     else if (strstr (header_info.post_data, "output_pin_state_define=") != NULL){
       Serial.println("Defining new Output state");
       char * pch = (strchr(header_info.post_data,'&'));
       *pch = NULL; // null out where the first & occurs
       strcpy(output_pin_state_define, &header_info.post_data[23 + 1]);
       *pch = '&';
       Serial.print("PHR: Output Define name is: "); Serial.println(output_pin_state_define);
       for (int x = 0; x <= 15; x++){
         char x_char[1];
         itoa(x + 1, x_char,10);
         Serial.println(x_char);
         if(strstr(header_info.post_data, x_char)!=NULL){
           Serial.println("Writing Bit");
           bitWrite(output_pin_read_define, x, 1);
         }
       }
       if (!pin_name_exists(output_pin_read_define, "outsts.txt")){       
         Serial.print("Pins are: ");Serial.println(output_pin_read_define, BIN);
         enable_sd();
         File pin_state_file = SD.open("outsts.txt", FILE_WRITE);
         if (!pin_state_file) Serial.println("PHR: Cant open the file : outsts.txt");
         pin_state_file.println();
         pin_state_file.print(output_pin_state_define);
         pin_state_file.print(":");
         pin_state_file.print(output_pin_read_define,DEC);
         pin_state_file.close();
         enable_ethernet();
       }
       else{
         Serial.println(" PHR: The pin state definition already exists.");              
         //Should also print an error message to client.
       }
       return true;       
     }  
     
     // pick out the change ip address command and then use str tok to grab each one of the ip segments and read into ip_array
     else if (strstr (header_info.post_data, "change_ip_address=") != NULL){ 
       //Serial.println("PHR: Change Ip Detected");
       //strncpy(new_ip_address, &header_info.post_data[23 + 1], (int)strchr(header_info.post_data,'&') - (23 + 1));
       char *ip_array[4]; 
       char *ip = NULL;
       strtok(header_info.post_data, ".="); //throw out the first token  aka what is behind the = sign
       ip = strtok(NULL, ".");
       int ip_segments = 0;
       while(ip != NULL){
         Serial.print("PHR: IP Segments are: ");Serial.println(ip);
         ip_array[ip_segments] = ip;
         ip = strtok(NULL,".");
         ip_segments++;
       }
       
       EEPROM.write(0,1); //set the new ip flag high
       EEPROM.write(1, atoi(ip_array[0]));
       Serial.println(ip_array[0]);
       EEPROM.write(2, atoi(ip_array[1]));
       EEPROM.write(3, atoi(ip_array[2]));
       EEPROM.write(4, atoi(ip_array[3]));
       Serial.println("PHR: IP Array is filled, IP is written to EEPROM");
       byte ip_new[] ={EEPROM.read(1), EEPROM.read(2), EEPROM.read(3), EEPROM.read(4)};
       //ADD should send a redirect to client to automatically go to new ip address.
       Ethernet.begin(mac, ip_new ,gateway,subnet);
       return true;
     }
     
     else {
       Serial.println("Post command not found");
       return false;
     }    
  }
}

char post_commands[][30] = {"Relay=",
                        "input_pin_state_define=",
                        "output_pin_state_define=",
                        "change_ip_address="};
                        
boolean pin_name_exists(int pin_read, char file[]){
  Serial.println("PNE: The pin read is: "); Serial.println(pin_read);
  if (strcmp(determine_pin_state(pin_read, file), "No Match")==0)
    return false;
  else return true;
}
  
