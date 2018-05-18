//This function will read the client data into a buffer and decide if it is a post, or get and update relevant data to the stuct http_info.

struct http_storage read_http_request(Client client){
  char data_sent_from_client[200], misc_data_buffer[200], post_data[200];
  int index = 0;

  client = server.available();
  if (client){
    boolean is_the_current_line_blank = true;  //http request ends with blank line
    index = 0; //reset input buf
    while (client.connected()){ 
      if (client.available()){ //is client showing data available to read?
        char c = client.read();
        if (c!='\n' && c!='\r'){ //add new data to buffer if we havent gotten a new line or return
          data_sent_from_client[index] = c;
          index++;
          
          if (index >= STRING_BUFFER_SIZE){
            index = STRING_BUFFER_SIZE - 1;  //if buffer overflow occurs set the last char in string to toss
            Serial.println();
            Serial.print("Buffer Overflow on HTTP String");
            continue;
          }
        }
      }  
      
      data_sent_from_client[index] = 0;
      
      if (strstr (data_sent_from_client, "GET / ") != 0){
        header_info.get = true;
        header_info.post = false;
        strcpy(header_info.page_request, "index.html");
        //client.println("HTTP/1.1 200 OK");   //should be handled by the main loop
        //client.println("Content-Type: text/html");
        //client.println();
        //page_printer(client, header_info.page_request);
        Serial.println("The page Request is:"); Serial.print(header_info.page_request);
      }
       
      else if(strstr (data_sent_from_client, "GET /") != 0){
        //parse out the actual GET request
        char *filename = data_sent_from_client + 5;
        strcpy(header_info.page_request, filename);
        Serial.println("The page request is:"); Serial.print(header_info.page_request);
        (strstr(header_info.page_request," HTTP"))[0] = 0;
        //page_printer(client, header_info.page_request);  // should be handled in main loop
        Serial.println("The page request is:"); Serial.println(header_info.page_request);
      }
     
      if (strstr (data_sent_from_client, "POST / ") != 0){
        header_info.post = true;
        header_info.get = false;
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
      }  
    strcpy(header_info.post_data, post_data);
    }
  }
}  
        
      
           
   
