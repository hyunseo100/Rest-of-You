/** 
 * BtSerial  Serial display
 Lists paired devices and connects to the first one on the list.
 Displays an incoming string from the serial connection.
 If it gets a newline, it clears the string
 
 Not working yet.
 
 created 27 June 2011
 modified 3 July 2011
 by Tom Igoe
 
 tweeked by dano to add ammending a file on the sd card
 */

import cc.arduino.btserial.*;

//For GUI
String[] fontList;
PFont androidFont;
// instance of the library:
BtSerial bt;
String inString = "";
FileWriter  user_data ;
BufferedWriter bw;
FileReader  fro ;
BufferedReader bro ;
String appName = "BTGrapher";
//String filename = "/data/processing.android.test." + appName + "/files/Player_Data.txt";
String filename = "/data/processing/logi.txt";
boolean exists_flag;


void setup() {
  // Setup Fonts:
  fontList = PFont.list();
  androidFont = createFont(fontList[0], 8, true);
  textFont(androidFont, 24);
  textAlign(CENTER);
  try {
    BufferedWriter writer = new BufferedWriter(new FileWriter("//sdcard//Doggy.txt", true));
  }
  catch(Exception e) {
    println("Couldn't say hi");
  }

  bt = new BtSerial( this );
  // get a list of paired devices:
  String[] pairedDevices = bt.list();
  if (pairedDevices.length > 0) {
    println(pairedDevices);
    // open a connection to the first one:
    bt.connect( pairedDevices[0] );
  } 
  else {
    text("Couldn't get any paired devices", 10, height/2);
  }
}

void draw() {
  // black with a nice light blue text:
  background(0);
  fill(#D3C7FE);
  char inByte = 'B';    // byte you'll read from serial connection

  // if you're connected, check for any incoming bytes:
  if ( bt != null ) {
    if ( bt.isConnected() ) {
      // put the connected device's name on the screen:
      // text(inByte + "connected to" + bt.getName(), screenWidth/2, screenHeight/3);
      // if there are incoming bytes available, read one:
      if (bt.available() > 0) {

        inByte = char(bt.read());
        if (inByte == '\n') {
          //separate out multiple values (if there are multiples.)
          String[] inputs = inString.split(",");
          
          String timestamp = month() +"-"+ day() +"-"+ year() +"-"+ hour() +"-"+ minute() +"-"+ millis();
          println(inString);
          try {
            BufferedWriter writer = new BufferedWriter(new FileWriter("//sdcard//Doggy.txt", true));
            writer.write(timestamp + "," );   //stamp it with a time
            for(int i = 0; i < inputs.length; i++){
              writer.write(inputs[i] + ",");  //separate the individual sensors by commas
            }
            writer.write("\n");// send new line after each set of sensor readings
            writer.flush();
            writer.close();
          }
          catch(Exception e) {
            println("Couldn't write the file");
          }

          // display the latest center screen:
          text(inString, screenWidth/2, screenHeight/2);
          inString = "";
        } 
        else {
          inString += inByte;
        }
      }
    }
  }
}

// disconnect on pause so you can reconnect:
void pause() {
  if (bt != null) {
    bt.disconnect();
  }
}

void resume() {
}
