/*
 OSC Message is structured like this:
 
 address: /BFollowKinect/init                   // inicio de lista de blobs
 address: /BFollowKinect/newBlob/ + ordered id  // datos de cada uno de los blobs de la lista
 address: /BFollowKinect/end + blob count       // fin de lista de blobs
 
 
 // MESSAGE newBlob
 
 argument 0: pid;                   //(int)persistent id from frame to frame
 argument 1: oid;                   //(int)ordered id, used for TUIO messaging
 argument 2: age;                   //(int)how many frames has this person been in the system
 argument 3: centroid.x;            //(float)center of mass NORMALIZED
 argument 4: centroid.y;
 argument 5: velocity.x;            //(float)most recent movement of centroid
 argument 6: velocity.y;
 argument 7: depth;                 // (float)raw depth from kinect
 argument 8: boundingRect.x;        //(float)enclosing area
 argument 9: boundingRect.y;
 argument 10: boundingRect.width;
 argument 11: boundingRect.height;
 argument 12: area                  //area as a scalar size
 argument 13: highest.x             // highest point in a blob NORMALIZED (brightest pixel, will really only work correctly with kinect)
 argument 14: highest.y
 argument 15: lowest.x              // lowest point in a blob NORMALIZED (dark pixel, will really only work correctly with kinect)
 argument 16: lowest.y
 argument 17: simpleContour.size    // number of points of the simplified contour
 argument 18+ : contours (if enabled)   //simplified shape contour
 */

 
import oscP5.*;
import netP5.*;

OscP5 oscManos, oscSilueta, oscSalida;
NetAddress myRemoteLocation;

String ip = "localhost";

int puertoManos = 12000;

int puertoSilueta = 12001;

int puertoSalida = 12002;

int datagramSize = 10000;

//-----------------------------------------
void iniciarOSCManos(){
  OscProperties myProperties = new OscProperties();
  myProperties.setDatagramSize(datagramSize);
  myProperties.setListeningPort(puertoManos); 
  oscManos = new OscP5(this, myProperties);
}

//-----------------------------------------
void iniciarOSCSilueta(){
  OscProperties myProperties = new OscProperties();
  myProperties.setDatagramSize(datagramSize);
  myProperties.setListeningPort(puertoSilueta); 
  oscSilueta = new OscP5(this, myProperties);
}

//-----------------------------------------
void iniciarOSCSalida(){
  
  oscSalida = new OscP5(this, puertoSalida);
  myRemoteLocation = new NetAddress(ip, puertoSalida);
}

//-----------------------------------------