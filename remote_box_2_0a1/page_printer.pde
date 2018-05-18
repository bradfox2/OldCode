//function to print pages to the client

boolean page_printer(Client client, char page_to_print[]){
  shutdown_ethernet(); enable_sd();
  if( SD.exists(page_to_print)){
    File the_file = SD.open(page_to_print, FILE_READ);
    if(the_file){
      while (the_file.available()){
        char a = the_file.read();
        enable_ethernet;
        client.print(a);
        shutdown_ethernet(); enable_sd();
      }
      the_file.close();
    }
  }
  else{
    enable_ethernet();
    client.println("HTTP:/ 1.1 404 Not Found");
    client.println("Content-Type: text/html");
    client.println();
    client.println("<h2>File Not Found </h2>");
    shutdown_ethernet(); enable_sd();
  }    
return false;
}
