int identifydata(int x){  //accepts a binary number and returns a corresponding number that matches into state["blah"] to match to a human string
  //Serial.print(x); // see what binary number were trying to match  
  
  db.open(input_table);
  
  for (int i = 1; i <= 30; i++)
  {
    db.read(i, DB_REC inputdb);
    if(x == inputdb.input_pin_state){
      sprintf(buffer, inputdb.input_state_name);
    }
  } 

  
  switch(x){
  case 0b0000000000 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[0]))); // Necessary casts and dereferencing, just copy. 
    return(0);
    break;
  case 0b1010101010  :  // 1010101010 in binary
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[1]))); // Necessary casts and dereferencing, just copy. 
    return(1);
    break;
  case 0b1110000111 :  // see if binary number matches 
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[2]))); // Necessary casts and dereferencing, just copy. 
    return(2);
    break;
  case 0b1110011111 :  // see if binary number matches 
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[3]))); // Necessary casts and dereferencing, just copy. 
    return(3);
    break;
  case 0b1000000001 :  // see if binary number matches 
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[4]))); // Necessary casts and dereferencing, just copy.
    return(4); 
    break;
  case 0b1000000010 :  // see if binary number matches 
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[5]))); // Necessary casts and dereferencing, just copy. 
    return(5);
    break;
  case 0b1100000001 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[6]))); // Necessary casts and dereferencing, just copy. 
    return(6);
    break;
  case 0b110000001 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[7]))); // Necessary casts and dereferencing, just copy. 
    return(7);
    break;
  case 0b1100000011 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[8]))); // Necessary casts and dereferencing, just copy. 
    return(8);
    break;
  case 0b11000001 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[9]))); // Necessary casts and dereferencing, just copy. 
    return(9);
    break;
  case 0b1100000101 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[10]))); // Necessary casts and dereferencing, just copy. 
    return(10);
    break;
  case 0b110000011:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[11]))); // Necessary casts and dereferencing, just copy. 
    return(11);
    break;
  case 0b1100000111:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[12]))); // Necessary casts and dereferencing, just copy. 
    return(12);
    break;
  case 0b1100001000:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[13]))); // Necessary casts and dereferencing, just copy. 
    return(13);
    break;
  case 0b1100001001:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[14]))); // Necessary casts and dereferencing, just copy. 
    return(14);
    break;
  case 0b1110000001:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[15]))); // Necessary casts and dereferencing, just copy. 
    return(15);
    break;
  case 0b1111100000:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[16]))); // Necessary casts and dereferencing, just copy. 
    return(16);
    break;
  case 0b0000011111:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[17]))); // Necessary casts and dereferencing, just copy. 
    return(17);
    break;
  case 0b1111000000:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[18]))); // Necessary casts and dereferencing, just copy. 
    return(18);
    break;
  case 0b1111000001:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[19]))); // Necessary casts and dereferencing, just copy. 
    return(19);
    break;
  case 0b111100001:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[20]))); // Necessary casts and dereferencing, just copy. 
    return(20);
    break;
  case 0b1111000011:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[21]))); // Necessary casts and dereferencing, just copy. 
    return(21);
    break;
  case 0b11110001:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[22]))); // Necessary casts and dereferencing, just copy. 
    return(22);
    break;
  case 0b1111000101:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[23]))); // Necessary casts and dereferencing, just copy. 
    return(23);
    break;
  case 0b111100011:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[24]))); // Necessary casts and dereferencing, just copy. 
    return(24);
    break;    
  case 0b1111000111:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[25]))); // Necessary casts and dereferencing, just copy. 
    return(25);
    break;
  case 0b1111001000:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[26]))); // Necessary casts and dereferencing, just copy. 
    return(26); //state 27 
    break;
  case 0b1111001001:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[27]))); // Necessary casts and dereferencing, just copy. 
    return(27);
    break;
  case 0b111100101:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[28]))); // Necessary casts and dereferencing, just copy. 
    return(28);
    break;
  case 0b1111001011:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[29]))); // Necessary casts and dereferencing, just copy. 
    return(29);
    break;
  case 0b11110011:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[30]))); // Necessary casts and dereferencing, just copy. 
    return(30);
    break;
  case 0b1111001101:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[31]))); // Necessary casts and dereferencing, just copy. 
    return(31);
    break;
  case 0b1111001110:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[32]))); // Necessary casts and dereferencing, just copy. 
    return(32);
    break;
  case 0b1111001111:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[33]))); // Necessary casts and dereferencing, just copy. 
    return(33);
    break;
  default:
    return(35);
    break;  
  }
}  
