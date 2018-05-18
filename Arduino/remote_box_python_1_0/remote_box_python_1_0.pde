#include <EEPROM.h>
#include <LiquidCrystal.h>
#include <avr/pgmspace.h>
#include <Ethernet.h>
#include <String.h>
#include <SPI.h>


LiquidCrystal lcd(4, 5, 6, 7, 8, 9); // initialize the LCD library with the pin settings

//------------from led code -------------//
byte mac[] = {0x00, 0x1E, 0x2A, 0x77, 0x24, 0x02};
byte gateway[] = {192, 168, 0, 1};
byte subnet[] = {255, 255, 0, 0};
byte ip[] = {192,168,0,187};
byte ipEEP[] = {(EEPROM.read(1)),(EEPROM.read(2)),(EEPROM.read(3)),(EEPROM.read(4))};
Server server(80); // Port 80 is http.

String mode = "Normal"; // these lines set the box upon start up to a default normal mode
byte modeB = 1;

//--------------------------------------//


prog_char state_0[] PROGMEM = "None/Power Off";   // "String 0" etc are strings to store - change to suit.
prog_char state_1[] PROGMEM = "Resident Shutdown";
prog_char state_2[] PROGMEM = "NRB Shutdown";
prog_char state_3[] PROGMEM = "GHS Shutdown";
prog_char state_4[] PROGMEM = "Resident Initialization";
prog_char state_5[] PROGMEM = "Common Monitor";
prog_char state_6[] PROGMEM = "Evaluate RAM Loss/DRAM Initialization";   
prog_char state_7[] PROGMEM = "COM/MON Initial Sync";
prog_char state_8[] PROGMEM = "NRB Flash Copy";
prog_char state_9[] PROGMEM = "PUB Entry Sync";
prog_char state_10[] PROGMEM = "PUB State 1";
prog_char state_11[] PROGMEM = "PUB State 2";
prog_char state_12[] PROGMEM = "OPS Flash Copy";   // "String 0" etc are strings to store - change to suit.
prog_char state_13[] PROGMEM = "OPS DRAM Initialization";
prog_char state_14[] PROGMEM = "Scheduler Initial Sync";
prog_char state_15[] PROGMEM = "GHS Initialization";
prog_char state_16[] PROGMEM = "Scheduling State 1";
prog_char state_17[] PROGMEM = "Scheduling State 2";
prog_char state_18[] PROGMEM = "Dataload Initialization";   // "String 0" etc are strings to store - change to suit.
prog_char state_19[] PROGMEM = "Dataload Master Wait for Operation";
prog_char state_20[] PROGMEM = "Dataload Master Wait for Header";
prog_char state_21[] PROGMEM = "Dataload Master Load NRB";
prog_char state_22[] PROGMEM = "Dataload Master Load SLDB";
prog_char state_23[] PROGMEM = "Dataload Master Validate SLDB";
prog_char state_24[] PROGMEM = "Dataload Master Load OPS";   // "String 0" etc are strings to store - change to suit.
prog_char state_25[] PROGMEM = "Dataload Primitive Erase";
prog_char state_26[] PROGMEM = "Dataload Master Get Next File";
prog_char state_27[] PROGMEM = "Dataload Primitive Write";
prog_char state_28[] PROGMEM = "Dataload Master XDP Active";
prog_char state_29[] PROGMEM = "Dataload Information Download";
prog_char state_30[] PROGMEM = "Dataload Operator Download";
prog_char state_31[] PROGMEM = "Dataload Media Download";
prog_char state_32[] PROGMEM = "Dataload Abort";
prog_char state_33[] PROGMEM = "Dataload Validate";
prog_char state_34[] PROGMEM = "<html><body>";
prog_char state_35[] PROGMEM = "<h1> Remote Data Aquisition Box</h1><br>";
prog_char state_36[] PROGMEM = "<h4>Data Display Page</h4>";
prog_char state_37[] PROGMEM = "<table border=""1""><tr><td>";
prog_char state_38[] PROGMEM = "<h3>Mode Change Form:</h3><p><form name=""input"" action=""write"" method=""get"">";
//prog_char state_38[] PROGMEM = "
prog_char state_39[] PROGMEM = "<input type=""radio"" name=""mode"" value=""loader"" /> Loader Mode<br />";
prog_char state_40[] PROGMEM = "<input type=""radio"" name=""mode"" value=""common"" /> Common Mode<br />";
prog_char state_41[] PROGMEM = "<input type=""radio"" name=""mode"" value=""normal"" /> Normal Mode<br />";
prog_char state_42[] PROGMEM = "<input type=""submit"" value=""Submit"" /></form> ";
prog_char state_43[] PROGMEM = "<p>Clicking the Submit button will change the mode of the Remote Box.";
prog_char state_44[] PROGMEM = "</p><td>Current Mode:<br>";// send mode after this line
prog_char state_45[] PROGMEM = "</td></td></tr><tr><td><h3>Data In:</h3><br>Input Pins:<br>1,2,3,4,5,6,7,8,9,10<br><br>"; 
prog_char state_46[] PROGMEM = "Input Data from box:<br>"; //send data after this line
prog_char state_47[] PROGMEM = "</br><td>Remote Box status is:<br>"; // send human status after this line
prog_char state_48[] PROGMEM = "</td></td></tr></table></body></html>";
//added in 1.1
prog_char state_49[] PROGMEM ="<tr><td>  <h3> IP Change Form</h3><p><form name=""input"" action=""text"" method=""get""><input type=""IP"" name=""firstSector"" size = ""1"" value="""" >."; 
prog_char state_50[] PROGMEM = "<input type=""IP"" name=""secondSector"" size = ""1"" value="" "">.<input type=""IP"" name=""thirdSector"" size = ""1"" value="""">";
prog_char state_51[] PROGMEM =".<input type=""IP"" name=""fourthSector"" size =""1"" value=""""><p><i>i.e. 192 . 168 . 0 . 117</i><p><input type=""submit"" value=""Submit"" /></form>";
prog_char state_52[] PROGMEM ="<p>If you click the ""Submit"" button, the box IP address  will be updated and you <p> will need to type it to your browser's URL box to regain access.</p></td></tr>";
prog_char state_53[] PROGMEM ="<tr><td><h3>Relay Toggle</h3><form method=""get"" action=""toggle"" name=""relay""><input name=""relay"" value=""on"" type=""radio"">Relay On<br>";
prog_char state_54[] PROGMEM ="<input name=""relay"" value=""off"" type=""radio"">Relay Off<br><br><input value=""Submit"" type=""submit""></form></td></tr>";




PROGMEM const char *state_table[] = 	   // change "state_table" name to suit
{   
  state_0,
  state_1,
  state_2,
  state_3,
  state_4,
  state_5,
  state_6,
  state_7,
  state_8,
  state_9,
  state_10,
  state_11,
  state_12,
  state_13,
  state_14,
  state_15,
  state_16,
  state_17,
  state_18,
  state_19,
  state_20,
  state_21,
  state_22,
  state_23,
  state_24,
  state_25,
  state_26,
  state_27,
  state_28,
  state_29,
  state_30,
  state_31,
  state_32,
  state_33,
  state_34,
  state_35,
  state_36,
  state_37,
  state_38,
  state_39,
  state_40,
  state_41,
  state_42,
  state_43,
  state_44,
  state_45,
  state_46,
  state_47,
  state_48,
  state_49,
  state_50,
  state_51,
  state_52,
  state_53,
  state_54
};

char html_buffer[200]; //buffer to hold html lines  
char buffer[50];    // holds the string buffer for display of state

const int input[] = {        
  22,23,24,25,26,27,28,29,30,31};

const int output[] = {
  32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47};

const int output_relay = 49; //output to control relay to control 110v

int data; 

String human_status;

boolean client_connected;

unsigned long time;
int reset_client = 75000;

void setup() {
  if (EEPROM.read(0)==0){
      Ethernet.begin(mac, ip, gateway, subnet);
   }
  else if(EEPROM.read(0)==1){
      Ethernet.begin(mac,ipEEP,gateway,subnet);
  }
  
  for (int x = 0; x < 10; x++){
    pinMode(input[x],INPUT);
  }
  
  for (int x = 0; x < 16; x++){
    pinMode(output[x],OUTPUT);
    digitalWrite(output[x],LOW);
  }

  pinMode(output_relay, OUTPUT); //declare relay output pin as output
  digitalWrite(output_relay, HIGH); //write relay pin high to turn on power to remote system
  
  //----------from led code-----------//
  //Ethernet.begin(mac, ip, gateway, subnet);
  server.begin();
  //---------------------------------//
  writeNormal();  // set box to normal mode on start up
  Serial.begin(9600);
  lcd.begin(16, 2);
}

//-----------from led code ---------------//
#define bufferMax 200
int bufferSize;
char bufferLED[bufferMax];
//-----------------------------------------//

void loop() {
  for (int x=0; x < 10; x++){  
   int temp = digitalRead(input[x]);  //read the input pins to aquire a data state of 10 digits
    if (temp){
      bitWrite(data,x,1);
    }
    else{
      bitWrite(data,x,0);
    }  
    
    //--------------from led code----------------------//
    Client client = server.available();
    if (client)
    {
      client_connected = true;
      time = millis();
      WaitForRequest(client);  // waits for client and sees when the request has ended
      delay(5);
      client.stop(); 

    }
  //--------------------------------------------------------//
  }
    
  Serial.println(data,BIN);  //data is the binary number representing pins on1 or off0
  Serial.println(identifydata(data));  //identify data takes a binary number and returns a integer value based on it from 0-35,  35 being the default state
  Serial.println(buffer); //buffer is assigned a value(human readable string)from state table according to the identify data function
  human_status = buffer;
    
  Serial.println("the mode is");
  Serial.println(mode);
  
  String x;  
  if ( x!=human_status){
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(human_status);
    lcd.setCursor(0,1);
    lcd.print("Mode: ");
    lcd.print(mode);
    x = human_status;
  }
  
  //reset the client connected if we havent seen a client in 3 min
  if (millis() - time >= reset_client){
    client_connected = false;
  }
  
  if (client_connected == true){
    lcd.setCursor(15,1);
    lcd.print("Y");
  }

  //stop();
  delay(500);

}


