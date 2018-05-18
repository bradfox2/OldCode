void WaitForRequest(Client client) // Sets buffer[] and bufferSize
{
  bufferSize = 0;

  while (client.connected()) {
    if (client.available()) {
      char c = client.read();
      //Serial.println("c is");
      //Serial.print(c);
      if (c == '\n'){
        operateOnRequest();  // collect the strings thats gonna be displayed to web
              //Print all the HTML to the client browser
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[34])))); // Necessary casts and dereferencing, just copy. 
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[35])))); // Necessary casts and dereferencing, just copy. 
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[36])))); // Necessary casts and dereferencing, just copy. 
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[37])))); // Necessary casts and dereferencing, just copy.
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[38])))); // Necessary casts and dereferencing, just copy.
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[39])))); // Necessary casts and dereferencing, just copy.
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[40])))); // Necessary casts and dereferencing, just copy.
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[41])))); // Necessary casts and dereferencing, just copy.
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[42])))); // Necessary casts and dereferencing, just copy.
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[43])))); // Necessary casts and dereferencing, just copy.
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[44])))); // Necessary casts and dereferencing, just copy.
              client.print(mode);
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[45])))); // Necessary casts and dereferencing, just copy.
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[46])))); // Necessary casts and dereferencing, just copy.
              client.print(data,BIN);
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[47])))); // Necessary casts and dereferencing, just copy.
              client.print(human_status); // print human status
              client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[48])))); // Necessary casts and dereferencing, just copy
        break;
      }
      else
        if (bufferSize < bufferMax){
          bufferLED[bufferSize++] = c;
        }
        else
          break;
    }
  }
}


void operateOnRequest(){
  
String URL = bufferLED;  //change URL to the actual read variable
Serial.println("buffer is");
Serial.println(bufferLED);
Serial.println("url string is");
Serial.println(URL);
String action = URL.substring( URL.indexOf('/') + 1, URL.indexOf('?'));  // parses the string between the / and the question mark
Serial.println("the action is");
Serial.println(action);
String name = URL.substring(URL.indexOf('?') + 1, URL.indexOf('='));
Serial.println("the name is");
Serial.println(name);
String mode_URL = URL.substring(URL.indexOf('=') + 1, URL.lastIndexOf(' '));
Serial.println("the mode is");
Serial.println(mode);
//int d = atoi(mode) // convert what is after the last equals sign into an integer ( for //eeprom storage of last 3 digits of ip addy)

//Set decsion variables according to what browser is asking for
if(action == "write" && mode_URL == "loader"){
	mode = "Loader";
	modeB = 0;
	writeLoader();
	Serial.println("The mode has been changed to Loader");
}

if(action == "write" && mode_URL == "normal"){
	mode = "Normal";
	modeB = 1;
	writeNormal();
	Serial.println("The mode has been changed to Normal");
}

if(action == "write" && mode_URL == "common"){
	mode = "Common";
	modeB = 2;
	writeCommon();
	Serial.println("The mode has been changed to Common");
}
}

