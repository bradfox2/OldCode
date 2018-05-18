//This function will read the client data into a buffer and decide if it is a post, or get and update relevant data to the stuct http_info.

//struct http_storage 
void read_http_request(Client client){
  char data_sent_from_client[STRING_BUFFER_SIZE], post_data[512];
  memset(data_sent_from_client,NULL,STRING_BUFFER_SIZE);
  int index = 0;
  char content_length_C[5];
  
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
        
        //look for "Content-Length: " and stop after we find it 
        char * first_appearance_of_content_length;
        while(client.available()){
          char c = client.read();
          //Serial.println(c);
          data_sent_from_client[index] = c;
          //Serial.println(data_sent_from_client);
          //Serial.println(index);
          if (strstr(data_sent_from_client, "Content-Length: ") !=0 ){
            first_appearance_of_content_length = strstr(data_sent_from_client, "Content-Length: ");
            Serial.print("Found content-length at: "); Serial.println(first_appearance_of_content_length);
            Serial.print("Data sent from client is: ");Serial.println(data_sent_from_client);
            break;
          }
          index++;
        }
        
        //Found content length,  now record the actual content length.
        Serial.println("-----");
        
        int x=0;
        char a;

        while (client.peek() != '\n' && '\r'){
          content_length_C[x] = client.read();    
          x++;
          //Serial.println(content_length_C[x]);
        }
        content_length_C[x] = NULL;
        Serial.println(content_length_C);
        client.read();client.read();client.read();  // skip the blank space
        
        for( int x=0; x<atoi(content_length_C);x++){
          if(client.peek() != NULL||'\n'||'\r'){
            post_data[x] = client.read();
            Serial.print(x);Serial.print(" : ");Serial.println(post_data[x]);
            if(x>=512){
              x--;
              Serial.println("Post Data buffer overflow.");
            }
          }
        }
        post_data[atoi(content_length_C)] = NULL;
        strcpy(header_info.post_data, post_data);
        Serial.print("The post data is: "); Serial.println(post_data);
        Serial.print("RHR: the header_info.post_data is: "); Serial.println(header_info.post_data);  
      
       process_http_request(client,0,1);
       break; 
      }     
    }
    Serial.println("Stopping Client"); Serial.println();
    client.stop(); 
  }
}  
        
      
           
   

