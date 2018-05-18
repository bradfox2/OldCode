//html strings
//prints all the lines of html and the 3 types of variable data from the system
String returnHTML(){
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[34])))); // Necessary casts and dereferencing, just copy. 
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[35])))); // Necessary casts and dereferencing, just copy. 
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[36])))); // Necessary casts and dereferencing, just copy. 
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[37])))); // Necessary casts and dereferencing, just copy.
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[38])))); // Necessary casts and dereferencing, just copy.
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[39])))); // Necessary casts and dereferencing, just copy.
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[40])))); // Necessary casts and dereferencing, just copy.
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[41])))); // Necessary casts and dereferencing, just copy.
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[42])))); // Necessary casts and dereferencing, just copy.
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[43])))); // Necessary casts and dereferencing, just copy.
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[44])))); // Necessary casts and dereferencing, just copy.
server.print(mode);
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[45])))); // Necessary casts and dereferencing, just copy.
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[46])))); // Necessary casts and dereferencing, just copy.
server.print(data,BIN);
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[47])))); // Necessary casts and dereferencing, just copy.
server.print(human_status); // print human status
server.print(strcpy_P(html_buffer, (char*)pgm_read_word(&(state_table[48])))); // Necessary casts and dereferencing, just copy
}
