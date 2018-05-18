//This function will read the client data into a buffer and decide if it is a post, or get and update relevant data to the stuct http_info.

void read_http_request(Client client){
  char data_sent_from_client[STRING_BUFFER_SIZE], post_data[512];
  memset(data_sent_from_client,NULL,STRING_BUFFER_SIZE);
  int index = 0;
  char content_length[5];
  
  if (client){
    boolean is_the_current_line_blank = false;  //http request ends with blank line
    index = 0; //reset input buf
    while (client.connected()){ 
      while (client.available()){ //is client showing data available to read?
         char c = client.read();
         if (c!='\n' && c!='\r'){ //add new data to buffer if we havent gotten a new line or return
            is_the_current_line_blank = false;
            data_sent_from_client[index] = c;
            index++;
            if (index >= STRING_BUFFER_SIZE){
              index = STRING_BUFFER_SIZE - 1;  //if buffer overflow occurs set the last char in string to toss
              Serial.println();
              Serial.print("Buffer Overflow on HTTP String");
              continue;     
            } 
         }
         if(c == '\n' ) break; // if the 404 error breaks, then fix the while client.available loop
      }  
      
      Serial.print("RHR: Client says: "); Serial.println(data_sent_from_client);
      
      data_sent_from_client[index] = 0;
      
//-------------Print the index page--------------//
      if (strstr (data_sent_from_client, "GET / ") != NULL){
        header_info.get_request = true;
        header_info.post_request = false;
        strcpy(header_info.page_request, "index.htm");
        Serial.print("The page Request should be index, and it is:"); Serial.println(header_info.page_request);
        Serial.println("Calling page_printer");
        if(!page_printer(client, header_info.page_request))Serial.println("Page printer failed");
        else Serial.println("Page printer success");
        break;
      }
      
//------------Read->Process->Print all other GET page requests-----------------------------//      
      else if (strstr (data_sent_from_client, "GET /") != NULL){
        
        //parse out the actual GET request and print the requested page to client
        char *filename = data_sent_from_client + 5;
        header_info.post_request = false;
        header_info.get_request = true;
        strcpy(header_info.page_request, filename);
        (strstr(header_info.page_request," HTTP"))[0] = 0;
        if(!process_http_request(client,1,0)){
          Serial.println("Process HTTP request failed");
        }
        //Serial.print("The page request is:"); Serial.println(header_info.page_request);
        break;
      }
      
//------------Read->Process->Print all other POST page requests-----------------------------//  

      else if (strstr (data_sent_from_client, "POST /") != 0){
        Serial.println("Detected a POST");
        header_info.post_request = true;
        header_info.get_request = false;
        boolean content_length_found =false;
        
        //---loop over client data to build string of client data in datafromclientindex
        while(client.available()){
          char c = client.read();
          data_sent_from_client[index] = c;
          //Serial.println(c); 
          index++;
        
          //--- find the content length and set it in contentlength[].  bool is to keep it from reentering after "content-length: " has been found but before the new line
          char* content_length_p = strstr(data_sent_from_client,"Content-Length: ");
          if (content_length_p != NULL && content_length_found == false){
            Serial.println("Content Length Found");
            int x = 0;
            while(client.peek() != '\n' && '\r'){
              content_length[x] = client.read();
              x++;
            }
            content_length[x] = NULL;  // null terminate the array
            Serial.println(content_length);
            content_length_found = true;  // set bool to true so we dont enter back into the the while loop and read client data that we shouldnt
          }
        
        //-- similar process to record the post body data, look for new line characters and then read everything after them
          char* first_appearance_of_newline = strstr(data_sent_from_client, "\r\n\r\n");
          if (first_appearance_of_newline != NULL ){
            Serial.println("Found new line character");
            int x;
            for(x = 0; x <= atoi(content_length); x++){  // loop over new bytes of client length data up too "content_length". 
              post_data[x] = client.read();
            }
            post_data[atoi(content_length)] = NULL; // add null terminator at the point where content should stop 
          }
          else{
            //Serial.println("Could not parse post");
          }
            
        }
        Serial.print("Post data is: "); Serial.println(post_data);     
        strcpy(header_info.post_data, post_data); // copy the post data to struct so other functions can access it 
        process_http_request(client,0,1);  // call process... to act on the post data
        break; 
      }     
    }
    Serial.println("Stopping Client"); Serial.println();
    client.stop(); 
  }
}  
        
///------------------------------------------------remote user connection status----------------------------//
//remote user is defined as connected when requesting through http so when read_http_request is called, it sets connected to true and sets the timer 

void remote_user_connected(boolean _is_he_connected, long _connection_timeout){
  Serial.print("Remote user connected at :"); Serial.println(_connection_timeout);
  connection_timeout = _connection_timeout; // _ in front of var means its private
  if(_is_he_connected){
    is_he_connected = true;  
  }
}

boolean remote_user_connected(){
  if(millis() - connection_timeout <= 300000 && is_he_connected == true){
    is_he_connected = true;  /// connection_timeout is global.  greater then 5 minutes and the user is assumed disconnected. 
    return true;
  }
  else return false;
}

           
   

