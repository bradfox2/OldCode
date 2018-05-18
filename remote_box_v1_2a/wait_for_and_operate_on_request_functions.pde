void WaitForRequest(Client client) // Sets buffer[] and bufferSize
{
  bufferSize = 0;

  while (client.connected()) {
    if (client.available()) {
      char c = client.read();
      //Serial.println("c is");
      //Serial.print(c);
      if (c == '\n'){
        operateOnRequest(client);  // collect the strings thats gonna be displayed to web
              //Print all the HTML to the client browser
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


void operateOnRequest(Client client){

String URL = bufferLED;  //change URL to the actual read variable
  
byte equalSign_1 = URL.indexOf('=');
byte equalSign_2 = URL.indexOf('=', equalSign_1 + 1);
byte equalSign_3 = URL.indexOf('=', equalSign_2 + 1);
byte equalSign_4 = URL.indexOf('=', equalSign_3 + 1);
byte amper_1 = URL.indexOf('&');
byte amper_2 = URL.indexOf('&', amper_1 + 1);
byte amper_3 = URL.indexOf('&', amper_2 + 1);
byte amper_4 = URL.indexOf('&', amper_3 + 1);
  

Serial.println("buffer is");
Serial.println(bufferLED);
Serial.println("url string is");
Serial.println(URL);

String action = URL.substring( URL.indexOf('/') + 1, URL.indexOf('?'));  // parses the string between the / and the question mark
Serial.println("the action is");
Serial.println(action);
String name = URL.substring(URL.indexOf('?') + 1,equalSign_1);
Serial.println("the name is");
Serial.println(name);
String mode_URL = URL.substring(equalSign_1 + 1, URL.lastIndexOf(' '));
Serial.println("the mode is");
Serial.println(mode_URL);

String first_sector = URL.substring(equalSign_1 + 1, amper_1);
Serial.println("the first sector is");
Serial.println(first_sector);
String second_sector = URL.substring(equalSign_2 + 1 , amper_2);
Serial.println("the second sector is");
Serial.println(second_sector);
String third_sector = URL.substring(equalSign_3 + 1, amper_3);
Serial.println("the third sector is");
Serial.println(third_sector);
String fourth_sector = URL.substring(equalSign_4 + 1, URL.lastIndexOf(' '));
Serial.println("the fourth sector is");
Serial.println(fourth_sector);
//int d = atoi(mode) // convert what is after the last equals sign into an integer ( for //eeprom storage of last 3 digits of ip addy)

int n; // convert the recieved ip strings into ints
    char carray[4];
    first_sector.toCharArray(carray, sizeof(carray));
   int first_sector_int = atoi(carray); 
   byte first_sector_byte = (byte)first_sector_int;
    second_sector.toCharArray(carray, sizeof(carray));
   int second_sector_int = atoi(carray);
   byte second_sector_byte = (byte)second_sector_int;
    third_sector.toCharArray(carray, sizeof(carray));
   int third_sector_int = atoi(carray);
   byte third_sector_byte = (byte)third_sector_int;
    fourth_sector.toCharArray(carray, sizeof(carray));
   int fourth_sector_int = atoi(carray);
   byte fourth_sector_byte = (byte)fourth_sector_int;
 
    
//    Serial.println(first_sector_int);
 //   Serial.println(second_sector_int);
   // Serial.println(third_sector_int);
    //Serial.println(fourth_sector_int);


//Set decsion variables according to what browser is asking for
if(URL.indexOf("/page/index.htm") >=0) {
        printIndex(client);
}

if(URL.indexOf("/page/configure") >=0) {
        printConfigure(client);
}

if(action=="write" && name=="modename") {
	mode = "Loader";
	modeB = 0;
	writeLoader();
	Serial.println("The mode has been changed to Loader");
}

if(URL.indexOf("/write?mode=normal") >=0) {
	mode = "Normal";
	modeB = 1;
	writeNormal();
	Serial.println("The mode has been changed to Normal");
}

if(URL.indexOf("/write?mode=common") >=0) {
	mode = "Common";
	modeB = 2;
	writeCommon();
	Serial.println("The mode has been changed to Common");
}
if(name == "relay" && mode_URL == "off"){
        digitalWrite(output_relay, LOW);	
	Serial.println("Relay On");
}
if(name == "relay" && mode_URL == "on"){
	digitalWrite(output_relay, HIGH);
	Serial.println("Relay Off");
}
if(URL.indexOf("page/text?firstSector=")>=0){
       
	EEPROM.write(1,first_sector_byte);
        EEPROM.write(2,second_sector_byte);
        EEPROM.write(3,third_sector_byte);
        EEPROM.write(4,fourth_sector_byte);
        EEPROM.write(0,1);
	Serial.println("EEPROM IP has been written to");
        byte j[] ={first_sector_byte,second_sector_byte,third_sector_byte,fourth_sector_byte};
        Ethernet.begin(mac,j,gateway,subnet);
}

if(action == "ip" && name == "reset"){
	EEPROM.write(0,0);
        EEPROM.write(1,192);
        EEPROM.write(2,168);
        EEPROM.write(3,0);
        EEPROM.write(4,187);
        
        byte k[] = {192,168,0,187};
        
        Ethernet.begin(mac, k, gateway, subnet);
	Serial.println("IP Reset");
}
}

void printIndex(Client client){
          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[34])))); // Necessary casts and dereferencing, just copy. 
          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[35])))); // Necessary casts and dereferencing, just copy. 
          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[36])))); // Necessary casts and dereferencing, just copy.
          client.print("<a href=""/page/configure"">Configuration Page</a>");
          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[37])))); // Necessary casts and dereferencing, just copy.
          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[38])))); // Necessary casts and dereferencing, just copy.
          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[39])))); // Necessary casts and dereferencing, just copy.
          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[40])))); // Necessary casts and dereferencing, just copy.
          //client.print();//here is the option form code//)
          for( int i = 5; i<=50 ; i++)
            {
               db.read(i, DB_REC outputdb);
               char buffer[30];
               sprintf(buffer, "<option>%s</option>",outputdb.output_state_name);
               Serial.print("Option Choices are:"); Serial.println(buffer);
               Serial.print("Output state name is:"); Serial.println(outputdb.output_state_name);
               client.print(buffer);
            } 
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
//          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[49])))); // Necessary casts and dereferencing, just copy
//          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[50])))); // Necessary casts and dereferencing, just copy              
//          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[51])))); // Necessary casts and dereferencing, just copy
//          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[52])))); // Necessary casts and dereferencing, just copy
          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[53])))); // Necessary casts and dereferencing, just copy
          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[54])))); // Necessary casts and dereferencing, just copy
          client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[48])))); // Necessary casts and dereferencing, just copy
          
}

void printConfigure(Client client){
  client.print("<html><body><h3>Configuration Page</h3><a href=""page/index.htm"">|Home Page|</a> <table border = ""1"">");
  client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[49])))); // Necessary casts and dereferencing, just copy
  client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[50])))); // Necessary casts and dereferencing, just copy              
  client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[51])))); // Necessary casts and dereferencing, just copy
  client.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[52])))); // Necessary casts and dereferencing, just copy
  client.print("<tr><td><h4>Input Pin Configuration</h4>Status Name: <form method = ""post"" action = ""/form/inputchange"" input type=""text"" name=""statusname""/><br> <p>Check the pins that will be high to define the input status. <br><br>");
  client.print("<input type=""checkbox"" name=""pin"" value=""1"" /> 1<input type=""checkbox"" name=""pin"" value=""2"" /> 2<input type=""checkbox"" name=""pin"" value=""3"" /> 3<input type=""checkbox"" name=""pin"" value=""4"" /> 4");
  client.print("<input type=""checkbox"" name=""pin"" value=""5"" /> 5 <input type=""checkbox"" name=""pin"" value=""6"" /> 6<input type=""checkbox"" name=""pin"" value=""7"" /> 7<input type=""checkbox"" name=""pin"" value=""8"" /> 8");
  client.print("<input type=""checkbox"" name=""pin"" value=""9"" /> 9<input type=""checkbox"" name=""pin"" value=""10"" /> 10<br><br><input type=""submit"" value=""Save"" /></form></table>");
  client.print("<table border = ""1""><tr><td><h4>Output Pin Configuration</h4>Input a name for the output mode and select the pin configuration that will be applied.<br> Default is to 3.3v.<br>Output Mode Name: <form method=""post"" action = ""outputchange"" input type=""text"" name=""outputmodename""/><br>");
  client.print("Pin 1<input type=""radio"" name = ""1"" value=""1"" checked>  High<input type=""radio"" name = ""1"" value=""0"" >  Low<br>Pin 2<input type=""radio"" name = ""2"" value=""1"" checked>  High<input type=""radio"" name = ""2"" value=""0"" >  Low<br>Pin 3");
  client.print("<input type=""radio"" name = ""3"" value=""1"" checked>  High<input type=""radio"" name = ""3"" value=""0"" >  Low<br>Pin 4<input type=""radio"" name = ""4"" value=""1"" checked>  High<input type=""radio"" name = ""4"" value=""0"" >  Low<br>Pin 5");
  client.print("<input type=""radio"" name = ""5"" value=""1"" checked>  High<input type=""radio"" name = ""5"" value=""0"" >  Low<br>Pin 6<input type=""radio"" name = ""6"" value=""1"" checked>  High<input type=""radio"" name = ""6"" value=""0"" >  Low<br>Pin 7");
  client.print("<input type=""radio"" name = ""7"" value=""1"" checked>  High<input type=""radio"" name = ""7"" value=""0"" >  Low<br>Pin 8<input type=""radio"" name = ""8"" value=""1"" checked>  High<input type=""radio"" name = ""8"" value=""0"" >  Low<br>Pin 9");
  client.print("<input type=""radio"" name = ""9"" value=""1"" checked>  High<input type=""radio"" name = ""9"" value=""0"" >  Low<br>Pin 10<input type=""radio"" name = ""10"" value=""1"" checked>  High<input type=""radio"" name = ""10"" value=""0"" >  Low<br>Pin 11");
  client.print("<input type=""radio"" name = ""11"" value=""1"" checked>  High<input type=""radio"" name = ""11"" value=""0"" >  Low<br>Pin 12<input type=""radio"" name = ""12"" value=""1"" checked>  High<input type=""radio"" name = ""12"" value=""0"" >  Low");
  client.print("<br>Pin 13<input type=""radio"" name = ""13"" value=""1"" checked>  High<input type=""radio"" name = ""13"" value=""0"" >  Low<br>Pin 14<input type=""radio"" name = ""14"" value=""1"" checked>  High<input type=""radio"" name = ""14"" value=""0"" >  Low");
  client.print("<br>Pin 15<input type=""radio"" name = ""15"" value=""1"" checked>  High<input type=""radio"" name = ""15"" value=""0"" >  Low<br>Pin 16<input type=""radio"" name = ""16"" value=""1"" checked>  High<input type=""radio"" name = ""16"" value=""0"" >  Low");
  client.print("<br><br><input type=""submit"" value=""Save"" /></form>");





  
}

