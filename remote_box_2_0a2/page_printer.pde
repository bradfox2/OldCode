//function to print pages to the client

boolean page_printer(Client client, char page_to_print[]){
  
  //find the mime type
  Serial.print("page_to_print is: ");Serial.println(page_to_print);
  int i;
  char the_file_type;
  char dot[] = ".";
  i = strcspn(page_to_print, dot);
  Serial.println(i);
  char file_type[] = {page_to_print[i+1], page_to_print[i+2], page_to_print[i+3], NULL};
  Serial.print("file_type: ");Serial.println(file_type);
//  for (int x = 0; x <  MIME_TYPE_ARRAY_LENGTH; x++){
//    if (strcmp(&mime_type[x][19], file_type) == 0);{ //found a match
//      //Serial.print("&mime_type[");Serial.print(x);Serial.println(&mime_type[x][19]);
//      Serial.print("mime_type[x] is:");Serial.println(mime_type[x][19]);
//      the_file_type = mime_type[x][19];
//      Serial.print("The file type is: "); Serial.println(the_file_type);
//    }
//  }
      
  shutdown_ethernet(); enable_sd();
  if (SD.exists(page_to_print)){
    Serial.print("The SD file exists and is: "); Serial.println(page_to_print);
    File the_file = SD.open(page_to_print, FILE_READ);
    if(the_file){
      Serial.println("File open successful.");
      char the_file_buffer[the_file.size()];
      Serial.print("File size: "); Serial.println(the_file.size());    
      int x = 0;
      memset(the_file_buffer,NULL,the_file.size());
      
      int16_t a;
      while (((a = the_file.read()) >=0)){//the_file.peek() >= 0){
        //a = the_file.read();
        //Serial.print(a);
        the_file_buffer[x] = (char)a;
        x++;
        //Serial.print("Reading :");
        //Serial.print(a);
        //Serial.println(" from file.");
      }
      //the_file_buffer[x + 1] = NULL; // null terminate the file buffer array so that we dont print memory locations beyond what was written to
      the_file.close();
      
      enable_ethernet();
      Serial.print("Printing :"); //Serial.print(the_file_buffer); Serial.println(" to client.");
     
      //check the file type and send the appropriate header to the browser.
      client.println("HTTP/1.1 200 OK");
      if (strstr(file_type, "htm") != 0)
             client.println("Content-Type: text/html");
         else if (strstr(file_type, "css") != 0){
             client.println("Content-Type: text/css");
             Serial.println("Printing CSS");}
         else if (strstr(file_type, "png") != 0){
             client.println("Content-Type: image/png");
             Serial.println("Printing PNG");}
         else if (strstr(file_type, "jpg") != 0){
             client.println("Content-Type: image/jpeg");
             Serial.println("Printing JPG");}
         else if (strstr(file_type, "gif") != 0)
             client.println("Content-Type: image/gif");
         else if (strstr(file_type, "3gp") != 0)
             client.println("Content-Type: video/mpeg");
         else if (strstr(file_type, "pdf") != 0)
             client.println("Content-Type: application/pdf");
         else if (strstr(file_type, "js") != 0)
             client.println("Content-Type: application/x-javascript");
         else if (strstr(file_type, "xml") != 0)
             client.println("Content-Type: application/xml");
         else
             client.println("Content-Type: text");
   
      client.println();
      
      for (int y = 0; y <= the_file.size();y++){
        client.print((char)the_file_buffer[y]);
        //Serial.println(the_file_buffer[y], HEX);
        //Serial.println(the_file_buffer[y], BYTE);
      }
      return true;
    }
  }
  
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
