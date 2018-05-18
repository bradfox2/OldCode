#include <EEPROM.h>
#include <LiquidCrystal.h>
#include <avr/pgmspace.h>
#include <Ethernet.h>
#include <String.h>
#include <SPI.h>
#include <DB.h>
/*************************************************************************************************************************************************
*                                   LCD configuration
*************************************************************************************************************************************************/

LiquidCrystal lcd(9, 8, 7, 6, 5, 4); // initialize the LCD library with the pin settings

/*************************************************************************************************************************************************
*                                   MAC address and IP address
*************************************************************************************************************************************************/
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 0, 187 };
byte ipEEP[] = {(EEPROM.read(1)),(EEPROM.read(2)),(EEPROM.read(3)),(EEPROM.read(4))};
byte gateway[] = {192, 168, 0, 1};
byte subnet[] = {255, 255, 0, 0};
/*************************************************************************************************************************************************
*                                   Memory space for string management and setup WebServer service
*************************************************************************************************************************************************/

// For sending HTML to the client
#define STRING_BUFFER_SIZE 256
char buffer[STRING_BUFFER_SIZE];

// to store data from http request
#define STRING_from_http_request_SIZE 256
char from_http_request[STRING_from_http_request_SIZE];

// POST and GET variables
#define STRING_VARS_SIZE 256
char vars[STRING_VARS_SIZE];

/*************************************************************************************************************************************************
*                                   Strings stored in flash of the HTML we will be transmitting
*************************************************************************************************************************************************/

#define NUM_PAGES 2

// HTTP Request message
PROGMEM prog_char content_404[] = "HTTP/1.1 404 Not Found\nServer: tlc\nContent-Type: text/html\n\n<html><head><title>Arduino Web Server - Error 404</title></head><body><h1>Error 404: Sorry, that page cannot be found!</h1></body>";
PGM_P page_404[] PROGMEM = { content_404 }; // table with 404 page

// HTML Header for pages
PROGMEM prog_char content_main_header[] = "HTTP/1.0 200 OK\nServer: TLC\nCache-Control: no-store, no-cache, must-revalidate\nPragma: no-cache\nConnection: close\nContent-Type: text/html\n";
PROGMEM prog_char content_main_top[] = "<html><head><title>TLC Control</title><style type=\"text/css\">table{border-collapse:collapse;}td{padding:0.25em 0.5em;border:0.5em solid #C8C8C8;}</style></head><body><h1>Arduino Web Server</h1>";
PROGMEM prog_char content_main_menu[] = "<table width=\"500\"><tr><td align=\"center\"><a href=\"/\">Page 1</a></td><td align=\"center\"><a href=\"page2\">Page 2</a></td><td align=\"center\"><a href=\"page3\">Page 3</a></td><td align=\"center\"><a href=\"page4\">Page 4</a></td></tr></table>";
PROGMEM prog_char content_main_footer[] = "</body></html>";
PGM_P contents_main[] PROGMEM = { content_main_header, content_main_top, content_main_menu, content_main_footer }; // table with 404 page
#define CONT_HEADER 0
#define CONT_TOP 1
#define CONT_MENU 2
#define CONT_FOOTER 3

// Page 1
PROGMEM prog_char http_url1[] = "/";
PROGMEM prog_char content_title1[] = "<h2>Page 1</h2>";
PROGMEM prog_char content_page1[] = "<hr /><h3>Content of Page 1</h3><p>Nothing... yet.</p><br /><form action=\"/login\" method=\"POST\"><input type=\"text\" name=\"prova\"><input type=\"submit\" value=\"post\"></form>";

// Page 2
PROGMEM prog_char http_url2[] = "/page2";
PROGMEM prog_char content_title2[] = "<h2>Page 2</h2>";
PROGMEM prog_char content_page2[] = "<hr /><h3>Content of Page 2</h3><p>Nothing here.</p>";

// Page 3
PROGMEM prog_char http_url3[] = "/page3";
PROGMEM prog_char content_title3[] = "<h2>Page 3</h2>";
PROGMEM prog_char content_page3[] = "<hr /><h3>Content of Page 3</h3><p>No no no, white page here.</p>";

// Page 4
PROGMEM prog_char http_url4[] = "/page4";
PROGMEM prog_char content_title4[] = "<h2>Page 4</h2>";
PROGMEM prog_char content_page4[] = "<hr /><h3>Content of Page 4</h3><p>Ehm... no, nothing.</p>";

// Page 5
PROGMEM prog_char http_url5[] = "/login";
PROGMEM prog_char content_title5[] = "<h2>POST Page 5</h2>";
PROGMEM prog_char content_page5[] = "<hr /><h3>Content of Page 5</h3><p>received a POST request</p>";

// declare tables for the pages
PGM_P contents_titles[] PROGMEM = { content_title1, content_title2, content_title3, content_title4, content_title5 }; // titles
PGM_P http_urls[] PROGMEM = { http_url1, http_url2, http_url3, http_url4, http_url5 }; // urls
PGM_P contents_pages[] PROGMEM = { content_page1, content_page2, content_page3, content_page4, content_page5 }; // real content

/*************************************************************************************************************************************************
*                                        define HTTP return structure ID for parsing HTTP header request
*************************************************************************************************************************************************/
struct HTTP_DEF {
  int pages;
  char vars[20];
} ;

/*************************************************************************************************************************************************
*                                                        Pin Declarations
*************************************************************************************************************************************************/
const int inputpins[] = {22,23,24,25,26,27,28,29,30,31};
const int outputpins[] = {32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47};
const int relaypin = 49;

/*************************************************************************************************************************************************
*                                                        Shared variable
*************************************************************************************************************************************************/
Server server(80);

void setup() {
  if (EEPROM.read(0)==1) Ethernet.begin(mac, ipEEP, gateway, subnet);
  else Ethernet.begin(mac,ipEEP,gateway,subnet);
   
  for (int x = 0; x < 10; x++){ // setup the input pins
     pinMode(inputpins[x],INPUT);
  }
  
  for (int x = 0; x < 16; x++){ // setup the output pins
    pinMode(outputpins[x],OUTPUT);
    digitalWrite(outputpins[x],LOW);
  }

  pinMode(relaypin, OUTPUT); //declare relay output pin as output
  digitalWrite(relaypin, HIGH); //write relay pin high to turn on power to remote system
  
  //launch all services
  lcd.begin(16,2); // initialize the lcd screen 
  Ethernet.begin(mac, ip);
  server.begin();
  Serial.begin(9600); // DEBUG
}

/*************************************************************************************************************************************************
*                                                           Main loop
*************************************************************************************************************************************************/

void loop() {
  Client client = server.available();
  if (client) { // now client is connected to arduino

    // read HTTP header request... so select what page client are looking for
    HTTP_DEF http_def = readHTTPRequest(client);

    if (http_def.pages > 0) {
      sendPage(client,http_def);
    } else {
      contentPrinter(client,(char*)pgm_read_word(&(page_404[0])));
    }

    // give the web browser time to receive the data
    delay(1);
    client.stop();
  }

}

/*************************************************************************************************************************************************
*                                              Method for read HTTP Header Request from web client
*************************************************************************************************************************************************/
struct HTTP_DEF readHTTPRequest(Client client) {
  char c;
  int i;

  // use buffer, pay attenction!
  int bufindex = 0; // reset buffer
  int from_http_requestindex = 0; // reset from_http_request

  int contentLenght = 0; // reset POST content lenght
  char compare[50]; // page comparation (url selection)

  HTTP_DEF http_def; // use the structure for multiple returns

  http_def.pages = 0; // default page selection... error

  // reading all rows of header
  if (client.connected() && client.available()) { // read a row
    buffer[0] = client.read();
    buffer[1] = client.read();
    bufindex = 2;
    // read the first line to determinate the request page
    while (buffer[bufindex-2] != '\r' && buffer[bufindex-1] != '\n') { // read full row and save it in buffer
      c = client.read();
      if (bufindex<STRING_BUFFER_SIZE) buffer[bufindex] = c;
      bufindex++;
    }

    // select the page from the buffer (GET and POST) [start]
    for(i = 0; i < NUM_PAGES; i++) {
      strcpy_P(from_http_request, (char*)pgm_read_word(&(http_urls[i])));
      // GET
      strcpy(compare,"GET ");   //copy "get" into compare variable
      strcat(compare,from_http_request);   // contecate from_http_reqest and " " to compare
      strcat(compare," ");
      Serial.print("GET compare: "); Serial.println(compare); // DEBUG
      if (strncmp(buffer,compare, strlen(from_http_request)+5)==0) {
        http_def.pages = i+1;
        break;
      }

      // POST
      strcpy(compare,"POST ");
      strcat(compare,from_http_request);
      strcat(compare," ");
      Serial.print("POST compare: "); Serial.println(compare); // DEBUG
      if (strncmp(buffer,compare, strlen(from_http_request)+6)==0) {
        http_def.pages = i+1;
        break;
      }

    }
    // select the page from the buffer (GET and POST) [stop]

    // read other stuff (for POST requests) [start]
    if (strncmp(buffer, "POST /", 5)==0) {
      processRequest:
      from_http_requestindex = 2; // reset from_http_request

      memset(from_http_request,0,STRING_from_http_request_SIZE);
      from_http_request[0] = client.read();
      from_http_request[1] = client.read();
      while (from_http_request[from_http_requestindex-2] != '\r' && from_http_request[from_http_requestindex-1] != '\n') {
        c = client.read();
        if (from_http_requestindex<STRING_BUFFER_SIZE) from_http_request[from_http_requestindex] = c;
        from_http_requestindex++;
      }
      if (strncmp(from_http_request, "Content-Length: ",16)==0) {
        from_http_requestindex = 16;
        for(i = from_http_requestindex; i< strlen(from_http_request) ; i++) {
          if (from_http_request[i] != ' ' && from_http_request[i] != '\r' && from_http_request[i] != '\n') {
            vars[i-from_http_requestindex] = from_http_request[i];
          } else {
            break;
          }
        }

        contentLenght = atoi(vars);
        memset(vars,0,STRING_VARS_SIZE);
        client.read(); client.read(); // read null line
        i = 0;
        while (i<contentLenght) {
          c = client.read();
          vars[i] = c;
          ++i;
        }

      } else {
      	goto processRequest;
      }
    }
    // read other stuff (for POST requests) [stop]


    // clean buffer for next row
    bufindex = 0;
  }

//      delay(10); // removing this nothing work... if you understand why mail me a bebbo [at] bebbo [dot] it
  Serial.print("Grepped page: "); // DEBUG
  Serial.println(http_def.pages); // DEBUG

  strncpy(http_def.vars,vars,STRING_VARS_SIZE);

  return http_def;
}

/*************************************************************************************************************************************************
*                                                              Send Pages
*************************************************************************************************************************************************/
void sendPage(Client client,struct HTTP_DEF http_def) {

  // send html header
  // contentPrinter(client,(char*)pgm_read_word(&(contents_main[CONT_HEADER])));
  contentPrinter(client,(char*)pgm_read_word(&(contents_main[CONT_TOP])));

  // send menu
  contentPrinter(client,(char*)pgm_read_word(&(contents_main[CONT_MENU])));

  // send title
  contentPrinter(client,(char*)pgm_read_word(&(contents_titles[http_def.pages-1])));

  // send the body for the requested page
  sendContent(client,http_def.pages-1);

  client.print("<br />");
  // send POST variables
  client.print(vars);

  // send footer
  contentPrinter(client,(char*)pgm_read_word(&(contents_main[CONT_FOOTER])));
}

/*************************************************************************************************************************************************
*                                                              Seond content splittere by buffer size
*************************************************************************************************************************************************/
void contentPrinter(Client client, char *realword) {
  int total = 0;
  int start = 0;
  char buffer[STRING_BUFFER_SIZE];
  int realLen = strlen_P(realword);

  memset(buffer,0,STRING_BUFFER_SIZE);

  while (total <= realLen) {
    // print content
    strncpy_P(buffer, realword+start, STRING_BUFFER_SIZE-1);
    client.print(buffer);

    // more content to print?
    total = start + STRING_BUFFER_SIZE-1;
    start = start + STRING_BUFFER_SIZE-1;

  }
}

/*************************************************************************************************************************************************
*                                                              Send real page content
*************************************************************************************************************************************************/
void sendContent(Client client, int pageId) {
  contentPrinter(client,(char*)pgm_read_word(&(contents_pages[pageId])));
}

/*************************************************************************************************************************************************
*                                                          END OF CODE! WELL DONE!
*************************************************************************************************************************************************/
