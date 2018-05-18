String identifydata(int x){  //accepts a binary number and returns a corresponding number that matches into state["blah"] to match to a human string
  //Serial.print(x); // see what binary number were trying to match  
  switch(x){
  case 0 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[0]))); // Necessary casts and dereferencing, just copy. 
    return(0);
    break;
  case 1 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[1]))); // Necessary casts and dereferencing, just copy. 
    return(1);
    break;
  case 2 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[2]))); // Necessary casts and dereferencing, just copy. 
    return(2);
    break;
  case 3 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[3]))); // Necessary casts and dereferencing, just copy. 
    return(3);
    break;
  case 4 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[4]))); // Necessary casts and dereferencing, just copy.
    return(4); 
    break;
  case 5 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[5]))); // Necessary casts and dereferencing, just copy. 
    return(5);
    break;
  case 6 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[6]))); // Necessary casts and dereferencing, just copy. 
    return(6);
    break;
  case 7 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[7]))); // Necessary casts and dereferencing, just copy. 
    return(7);
    break;
  case 8 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[8]))); // Necessary casts and dereferencing, just copy. 
    return(8);
    break;
  case 9 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[9]))); // Necessary casts and dereferencing, just copy. 
    return(9);
    break;
  case 10 :  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[10]))); // Necessary casts and dereferencing, just copy. 
    return(10);
    break;
  case 11:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[11]))); // Necessary casts and dereferencing, just copy. 
    return(11);
    break;
  case 12:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[12]))); // Necessary casts and dereferencing, just copy. 
    return(12);
    break;
  case 13:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[13]))); // Necessary casts and dereferencing, just copy. 
    return(13);
    break;
  case 14:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[14]))); // Necessary casts and dereferencing, just copy. 
    return(14);
    break;
  case 15:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[15]))); // Necessary casts and dereferencing, just copy. 
    return(15);
    break;
  case 16:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[16]))); // Necessary casts and dereferencing, just copy. 
    return(16);
    break;
  case 17:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[17]))); // Necessary casts and dereferencing, just copy. 
    return(17);
    break;
  case 18:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[18]))); // Necessary casts and dereferencing, just copy. 
    return(18);
    break;
  case 19:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[19]))); // Necessary casts and dereferencing, just copy. 
    return(19);
    break;
  case 20:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[20]))); // Necessary casts and dereferencing, just copy. 
    return(20);
    break;
  case 21:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[21]))); // Necessary casts and dereferencing, just copy. 
    return(21);
    break;
  case 22:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[22]))); // Necessary casts and dereferencing, just copy. 
    return(22);
    break;
  case 23:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[23]))); // Necessary casts and dereferencing, just copy. 
    return(23);
    break;
  case 24:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[24]))); // Necessary casts and dereferencing, just copy. 
    return(24);
    break;    
  case 25:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[25]))); // Necessary casts and dereferencing, just copy. 
    return(25);
    break;
  case 26:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[26]))); // Necessary casts and dereferencing, just copy. 
    return(26);
    break;
  case 27:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[27]))); // Necessary casts and dereferencing, just copy. 
    return(27);
    break;
  case 28:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[28]))); // Necessary casts and dereferencing, just copy. 
    return(28);
    break;
  case 29:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[29]))); // Necessary casts and dereferencing, just copy. 
    return(29);
    break;
  case 30:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[30]))); // Necessary casts and dereferencing, just copy. 
    return(30);
    break;
  case 31:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[31]))); // Necessary casts and dereferencing, just copy. 
    return(31);
    break;
  case 32:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[32]))); // Necessary casts and dereferencing, just copy. 
    return(32);
    break;
  case 33:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[33]))); // Necessary casts and dereferencing, just copy. 
    return(33);
    break;
  case 34:  // see if binary number matches zero
    strcpy_P(buffer, (char*)pgm_read_word(&(state_table[34]))); // Necessary casts and dereferencing, just copy. 
    return(34);
    break;   
  default:
    return(35);
    break;  
  }
}  
