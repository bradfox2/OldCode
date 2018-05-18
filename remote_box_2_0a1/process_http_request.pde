 //This function will recieve the header_info struct and process the data
 
 void process_http_request(Client client){
   Serial.println("The requested page is: "); Serial.print(header_info.page_request);
   
   //process the GET request
   if (header_info.get && !header_info.post){
     page_printer(client, header_info.page_request);     
   }
   
   //process the post request
   if (!header_info.get && header_info.post){
     
     
     //the hard stuff here
   
   }
 }
