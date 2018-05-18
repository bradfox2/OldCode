//function to print pages to the client,  it will find the file extension then add the correct header to send and then read off the sd card and print to client. 

boolean page_printer(Client client, char page_to_print[]){
  
  //find the file extension
  int i;
  char the_file_type;
  char dot[] = ".";
  i = strcspn(page_to_print, dot);  //locate the first dot in the header to start reading
  char file_type[] = {page_to_print[i+1], page_to_print[i+2], page_to_print[i+3], NULL};  //add the first 3 chars after the dot as our file extension.  files follow 8.3 
  Serial.print("File_type: ");Serial.println(file_type);
      
  shutdown_ethernet(); enable_sd();
  if (SD.exists(page_to_print)){
    Serial.print("The SD file exists and is: "); Serial.println(page_to_print);
    File the_file = SD.open(page_to_print, FILE_READ);
    if(the_file){
      Serial.println("File open successful.");
      Serial.print("File size: "); Serial.println(the_file.size());    
      
      enable_ethernet();
      //Serial.print("Printing :"); Serial.print(the_file_buffer); Serial.println(" to client.");
     
      //check the file type and send the appropriate header to the browser.
      client.println("HTTP/1.1 200 OK");
      if (strstr(file_type, "htm") != 0)
             client.println("Content-Type: text/html");
         else if (strstr(file_type, "css") != 0){
             client.println("Content-Type: text/css");
             Serial.println("Printing CSS");
         }   
         else if (strstr(file_type, "png") != 0){
             client.println("Content-Type: image/png");
             Serial.println("Printing PNG");
         }
         else if (strstr(file_type, "jpg") != 0){
             client.println("Content-Type: image/jpeg");
             Serial.println("Printing JPG");
         }
         else if (strstr(file_type, "gif") != 0){
             client.println("Content-Type: image/gif");
             Serial.println("Printing GIF");
         }    
         else if (strstr(file_type, "3gp") != 0){   
             client.println("Content-Type: video/mpeg");
             Serial.println("Printing MPEG");
         }
         else if (strstr(file_type, "pdf") != 0){
             client.println("Content-Type: application/pdf");
             Serial.println("Printing PDF");
         }
         else if (strstr(file_type, "js") != 0){
             client.println("Content-Type: application/x-javascript");
             Serial.println("Printing JS");
         }
         else if (strstr(file_type, "xml") != 0){
             client.println("Content-Type: application/xml");
             Serial.println("Printing XML");
         }
         else{
             client.println("Content-Type: text");
             Serial.println("No match for file extension, printing as text.");
         }
   
      client.println(); //add a line to tell browser header is done
      
      int16_t a;
      char the_file_buffer[10]; // to do: implement file buffer
      int x = 0;
      shutdown_ethernet(); enable_sd(); 
      while (((a = the_file.read()) >=0)){
        

        
//        if ((file_type == "'htm"||"css"||"xml"||"txt"||"csv") && a =='$'){ // for later work,  copy into global buffer for use in code injection
//          parse_buffer_A_id = (char)the_file.read(); // if we see a $ then copy the next value into the parse buffer 'a' for injection
//          client.print(injection_buffer);
//        }
        
        //the_file_buffer[x] = (char)a;
        //x++;
        
        //if (x >= 10){
          enable_ethernet();
          //client.print(the_file_buffer);
          //shutdown_ethernet(); enable_sd();
        //}
        if (!code_injector(a, injection_buffer, file_type, the_file, client)){
          enable_ethernet();
          client.print((char)a);   //typecast as char and send to client
          continue;
        }
        shutdown_ethernet(); enable_sd();
        //Serial.print("Reading :");
        //Serial.print(a);
        //Serial.println(" from file.");
      }
      
      //shutdown_ethernet(); enable_sd();
      the_file.close();
      
      enable_ethernet();
      //client.print(the_file_buffer);
      //Serial.print("Printing :"); Serial.print(the_file_buffer); Serial.println(" to client.");
      return true;
    }
  }
  
  
  // for any file that wasnt found,  print a 404 error to client.
  else{
    enable_ethernet();
    client.flush();
    Serial.print("PP: The file: "); Serial.print(page_to_print); Serial.println(" was not found");
      client.println("HTTP/1.1 404 Not Found  ");
      client.println("Content-Type: text/html");
      client.println();
      client.print("<html><h2>");
      client.print(page_to_print); client.println(" was not found on this server.</html>");
      Serial.print("404 error printed for: ");Serial.println(page_to_print);
    delay(1);
    return false;  
  }    
}
