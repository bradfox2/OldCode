#define __AVR_ATmega1280__
#define __cplusplus
#define __builtin_va_list int
#define __attribute__(x)
#define __inline__
#define __asm__(x)
extern "C" void __cxa_pure_virtual() {}
#include "C:\arduino\libraries\EEPROM\EEPROM.h"
#include "C:\arduino\libraries\LiquidCrystal\LiquidCrystal.h"
#include "C:\arduino\libraries\Ethernet\Client.h"
#include "C:\arduino\libraries\Ethernet\Ethernet.h"
#include "C:\arduino\libraries\Ethernet\Server.h"
#include "C:\arduino\libraries\Ethernet\Udp.h"
#include "C:\arduino\libraries\Ethernet\utility\socket.h"
#include "C:\arduino\libraries\Ethernet\utility\w5100.h"
#include "C:\arduino\libraries\SPI\SPI.h"
#include "C:\arduino\libraries\SD\SD.h"
#include "C:\arduino\libraries\SD\utility\FatStructs.h"
#include "C:\arduino\libraries\SD\utility\Sd2Card.h"
#include "C:\arduino\libraries\SD\utility\Sd2PinMap.h"
#include "C:\arduino\libraries\SD\utility\SdFat.h"
#include "C:\arduino\libraries\SD\utility\SdFatmainpage.h"
#include "C:\arduino\libraries\SD\utility\SdFatUtil.h"
#include "C:\arduino\libraries\SD\utility\SdInfo.h"
#include "C:\arduino\libraries\EEPROM\EEPROM.cpp"
#include "C:\arduino\libraries\LiquidCrystal\LiquidCrystal.cpp"
#include "C:\arduino\libraries\Ethernet\Client.cpp"
#include "C:\arduino\libraries\Ethernet\Ethernet.cpp"
#include "C:\arduino\libraries\Ethernet\Server.cpp"
#include "C:\arduino\libraries\Ethernet\Udp.cpp"
#include "C:\arduino\libraries\Ethernet\utility\socket.cpp"
#include "C:\arduino\libraries\Ethernet\utility\w5100.cpp"
#include "C:\arduino\libraries\SPI\SPI.cpp"
#include "C:\arduino\libraries\SD\File.cpp"
#include "C:\arduino\libraries\SD\SD.cpp"
#include "C:\arduino\libraries\SD\utility\Sd2Card.cpp"
#include "C:\arduino\libraries\SD\utility\SdFile.cpp"
#include "C:\arduino\libraries\SD\utility\SdVolume.cpp"
void setup();
void loop();
int collect_pin_states();
char * determine_pin_state(int input_pin_read, char file[]);
boolean code_injector(char key, char injection_buffer[], char file_type[], File the_file, Client client );
void INJECT_input_pin_read(char *injection_buffer, Client client);
void INJECT_input_pin_state(char *injection_buffer, Client client);
void INJECT_current_output_mode(char *injection_buffer, Client client);
void INJECT_current_input_definitions(char *injection_buffer, Client client);
void INJECT_current_output_definitions(char *injection_buffer, Client client);
void INJECT_mode_change_buttons(char* injection_buffer, Client client);
char* listmodes(char file[]);
boolean page_printer(Client client, char page_to_print[]);
boolean process_http_request(Client client, boolean get_request, boolean post_request);
boolean pin_name_exists(char* pin_read, char file[]);
void read_http_request(Client client);
void enable_ethernet();
void shutdown_ethernet();
void enable_sd();
void set_pinmodes();
void relay_on();
void relay_off();
int bin2dec(char *bin);
void init_default_mode();
int availableMemory();

#include "C:\arduino\hardware\arduino\cores\arduino\WProgram.h"
#include "c:\Users\b\Dropbox\remote_box_2_0a7\remote_box_2_0a7.pde" 
#include "c:\Users\b\Dropbox\remote_box_2_0a7\collect_pin_states.pde"
#include "c:\Users\b\Dropbox\remote_box_2_0a7\determine_pin_state.pde"
#include "c:\Users\b\Dropbox\remote_box_2_0a7\injection_functions.pde"
#include "c:\Users\b\Dropbox\remote_box_2_0a7\listmodes.pde"
#include "c:\Users\b\Dropbox\remote_box_2_0a7\page_printer.pde"
#include "c:\Users\b\Dropbox\remote_box_2_0a7\process_http_request.pde"
#include "c:\Users\b\Dropbox\remote_box_2_0a7\read_http_request.pde"
#include "c:\Users\b\Dropbox\remote_box_2_0a7\SPI_and_pin_control.pde"
