void WaitForRequest(Client client) // Sets buffer[] and bufferSize
{
  bufferSize = 0;

  while (client.connected()) {
    if (client.available()) {
      char c = client.read();
      //Serial.println("c is");
      //Serial.print(c);
      if (c == '\n'){
        //operateOnRequest();  // collect the strings thats gonna be displayed to web
              //Print all the HTML to the client browser
            
             client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println();

          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println();

          // output the value of each analog input pin
          for (int analogChannel = 0; analogChannel < 6; analogChannel++) {
            client.print("analog input ");
            client.print(analogChannel);
            client.print(" is ");
            client.print(analogRead(analogChannel));
            client.println("<br />");
          }
          break;
            
            
            client.print(("hello world"));
            client.println("<br />");
          }
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
if(name == "relay" && mode_URL == "off"){
        digitalWrite(output_relay, LOW);	
	Serial.println("Relay On");
}
if(name == "relay" && mode_URL == "on"){
	digitalWrite(output_relay, HIGH);
	Serial.println("Relay Off");
}
if(action == "text" && name == "firstSector"){
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

