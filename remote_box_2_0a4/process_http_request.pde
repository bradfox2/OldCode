 //This function will use the header_info struct and process the data 

boolean process_http_request(Client client, boolean get_request, boolean post_request){
  
  //DEBUG
  Serial.print("PHR: The page to send is: "); Serial.println(header_info.page_request);
 
  //process the GET request for all pages EXCEPT for the index.htm
  if (get_request && !post_request){
    //Serial.print("Printing the GET request of: "); Serial.print(header_info.page_request); Serial.println(" to client.");
    if(!page_printer(client, header_info.page_request)){ // false return indicates a 404 error
      return false;
    }
    else{
      return true;    
    }
  }
   
   //process the post request
  if (!get_request && post_request){
     //the hard stuff here
     return true;
  }
  else Serial.println("PHR failure");
  return false;
}
