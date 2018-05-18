//This function will read the client data into a buffer and decide if it is a post, or get and update relevant data to the stuct http_info.

//struct http_storage 
void read_http_request(Client client){
  char data_sent_from_client[200], misc_data_buffer[200], post_data[200];
  int index = 0;
  
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
         if(c=='\n') break; // if the 404 error breaks, then fix the while client.available loop
      }  
      
      Serial.print("Client says: "); Serial.println(data_sent_from_client);
      
      data_sent_from_client[index] = 0;
      
      //Print the index page
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
       
      else if (strstr (data_sent_from_client, "GET /") != NULL){
        
        //parse out the actual GET request and print the requested page to client
        char *filename = data_sent_from_client + 5;
        header_info.post_request = false;
        header_info.get_request = true;
        strcpy(header_info.page_request, filename);
        (strstr(header_info.page_request," HTTP"))[0] = 0;
        if(!process_http_request(client,1,0)) Serial.println("Process HTTP request failed");
        //page_printer(client, header_info.page_request);  // should be handled in main loop
        //Serial.print("The page request is:"); Serial.println(header_info.page_request);
        break;
      }
      
      if (strstr (data_sent_from_client, "POST / ") != 0){
        header_info.post_request = true;
        header_info.get_request = false;
        while (strcmp(data_sent_from_client, "Content-Length: ") !=0 ){
          char c = client.read();
          data_sent_from_client[index] = c;
          index++;
        }
        
        if (client.available()){
          char c;
          if (c!='\n' && c!='\r'){ //add new data to buffer if we havent gotten a new line or return
            data_sent_from_client[index] = c;
            index++;       
          }
          client.read();client.read(); //discard the /r/n after the end of the content length line
          int var = 0;
          while (client.available()){
            char c = client.read();
            post_data[var] = c;       //collect all the data read in this line as post data
            if (var > 200) Serial.println("Post data recv buffer overflow");
            var++;
          }      
        }
        strcpy(header_info.post_data, post_data);  
        break;
      }  
    }
    Serial.println("Stopping Client");
    client.stop(); delay(5);
  }
}  
        
      
           
   
