import processing.net.*; 
Server s;
Client c;
OPC opc;
PImage dot;
String data[] = new String[4];
PVector blob;

EasingFloat x = new EasingFloat(width,1);
EasingFloat y = new EasingFloat(height,1);
EasingFloat z = new EasingFloat(.6,1);

int xMin = -16;
int xMax = 16;
int yMin = -10;
int yMax = 10;
int zMin = 1;
int zMax = 10;

void setup()
{
  size(200, 200);

  dot = loadImage("dot.png");

  // Connect to the local instance of fcserver. You can change this line to connect to another computer's fcserver
  opc = new OPC(this, "127.0.0.1", 7890);
  opc.ledGrid8x8(3 * 64, width/2, height/2, height/8, 0, false);
  
  s = new Server(this, 5000);
  
}

void draw()
{
  background(0);
   // Receive data from client
  c = s.available();
  if ((c != null)) {
    data = split(c.readString(), ' ');
    if(data.length==4){
      println("before x "  + data[1] + " y " + data[2] + " z " + data[3]);
      x.setTarget(int(map(int(data[2]),xMin,xMax,0,width*2)));
      y.setTarget(int(map(int(data[1]),yMin,yMax,0,height*2)));
      //z.setTarget(map(int(data[3]),zMin,zMax,2,8)/10);
      println("after x "  + x._target + " y " + y._target + " z " + z._target);
    }
    
  
  }
  
  x.update();
  y.update();
  z.update();
  
  // Change the dot size as a function of time, to make it "throb"
  float dotSize = height * z._val * (1.0 + 0.2 * sin(millis() * 0.01));
  // Draw it centered at the desired location
  image(dot, x._val - dotSize/2, y._val - dotSize/2, dotSize, dotSize);
  
 
 
  
}