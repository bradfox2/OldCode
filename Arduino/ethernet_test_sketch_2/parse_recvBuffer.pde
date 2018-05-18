void parse_recvBuffer(){
  
  //type cast recvbuffer to string so we can use String Library
    
  //memset(recvBuffer,0,200);             //clear the char array for new writing (pointer to memory location of recvBuffer, nullify 200 places)
  String string_buff = recvBuffer;
//  byte equalSign_1 = string_buff.indexOf('=');
//  byte equalSign_2 = string_buff.indexOf('=', equalSign_1 + 1);
//  byte equalSign_3 = string_buff.indexOf('=', equalSign_2 + 1);
//  byte equalSign_4 = string_buff.indexOf('=', equalSign_3 + 1);
//  byte equalSign_5 = string_buff.indexOf('=', equalSign_4 + 1);
  
  byte semicolon_1 = string_buff.indexOf(';');
  byte semicolon_2 = string_buff.indexOf(';', semicolon_1 + 1);
  byte semicolon_3 = string_buff.indexOf(';', semicolon_2 + 1);
  byte semicolon_4 = string_buff.indexOf(';', semicolon_3 + 1);
  byte semicolon_5 = string_buff.indexOf(';', semicolon_4 + 1);
  
  // string_buff should look like "DataState=example state one;OutputMode=exampleModeone;"
  
  //parse string representations of the different data out of the recv buffer
  Data_State = string_buff.substring( string_buff.indexOf('Data_State=') + 1, semicolon_1);
  Serial.println(Data_State);
  Output_Mode = string_buff.substring(string_buff.indexOf('Output_Mode=') + 1, semicolon_2);
  String Binary_Mode = string_buff.substring( string_buff.indexOf('Binary_Mode=') +1 , semicolon_3);
  String relay = string_buff.substring( string_buff.indexOf('relay=') + 1, semicolon_4);
  String change_ip = string_buff.substring( string_buff.indexOf('change_ip=') + 1, semicolon_5);
  
  //convert the strings to ints where needed
  
  //convert from string to chararray to int
  char binary_mode[17];
  Binary_Mode.toCharArray(binary_mode, 16);
  binarymode = atoi(binary_mode);
  //Serial.println("The Binarymode (INT) is: ");
  //Serial.println(binarymode);
  //Serial.println("The Binarymode (char array) is: ");
  //Serial.println(binary_mode);
 
  char relaychar[2];
  relay.toCharArray(relaychar, 1);
  relay_state = atoi(relaychar);  

}
  
  
