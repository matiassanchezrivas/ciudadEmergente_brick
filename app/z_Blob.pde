/*
Corregido por Emiliano 22/05/2016
 
 */
class Blob {

  float ancho, alto = 0;
  float x, y = 0;

  int pid = 0;                   //(int)persistent id from frame to frame
  int oid = 0;                   //(int)ordered id, used for TUIO messaging
  int age = 0;                   //(int)how many frames has this person been in the system
  float centroidX = 0;            //(float)center of mass NORMALIZED
  float centroidY = 0;
  float velocityX = 0;            //(float)most recent movement of centroid
  float velocityY = 0;
  float depth = 0;                 // raw depth from kinect
  float boundingRectX = 0;        //(float)enclosing area
  float boundingRectY = 0;
  float boundingRectWidth = 0;
  float boundingRectHeight = 0;
  int area = 0;                  //area as a scalar size
  float highestX = 0;            // highest point in a blob NORMALIZED (brightest pixel, will really only work correctly with kinect)
  float highestY = 0;
  float lowestX = 0;             // lowest point in a blob NORMALIZED (dark pixel, will really only work correctly with kinect)
  float lowestY = 0;

  int simpleContourSize = 0;

  ArrayList<PVector> contours;

  Blob() {
    contours     = new ArrayList<PVector>();
  }

  void dibujar(float _x, float _y, float _ancho, float _alto) {

    x = _x;
    y = _y;
    ancho = _ancho;
    alto = _alto;

    offscreen.pushStyle();
    offscreen.noFill();
    offscreen.stroke(255, 0, 0);
    
    offscreen.rect( x + boundingRectX * ancho, 
    y + boundingRectY * alto, 
    boundingRectWidth * ancho, 
    boundingRectHeight * alto);
    offscreen.stroke(0, 255, 0);
    
    offscreen.line( x + centroidX * ancho - 5, 
    y + centroidY * alto, 
    x + centroidX * ancho + 5, 
    y + centroidY * alto);
    
    offscreen.line( x + centroidX * ancho, 
    y + centroidY * alto -5, 
    x + centroidX * ancho, 
    y + centroidY * alto + 5);

    float val = map(depth, 0, 1, 0, 255 );
    offscreen.stroke(val, 40, 40);
    offscreen.ellipse(x + highestX * ancho, y + highestY * alto, 15, 15);

    offscreen.fill(255, 0, 0);
    String t = "pid[" + pid + "] | " + "oid[" + oid + "] | " + "age[" + age + "]";
    offscreen.text(t, x + centroidX * ancho + 10, y + centroidY * alto);

    offscreen.stroke( 0 , 255 , 0 );
    offscreen.noFill();
    dibujarContorno( x, y, ancho, alto);
    offscreen.popStyle();
  }
  //---------------------------------------------------------------

  void dibujarContorno(float x, float y, float ancho, float alto) {

    if (contours.size() > 3) {

      /* Emiliano: lo quite de la función, para poder poner el color desde afuera
      stroke(0, 255, 0);
       noFill();
       stroke(0, 255, 0);*/
      offscreen.beginShape();

      for (int i = 0; i < contours.size (); i ++) {

        PVector point = contours.get(i);

        offscreen.vertex(x + point.x * ancho + boundingRectX, y + point.y * alto + boundingRectY);

        //println("punto xNorm:  " + point.x + " | punto yNorm: " + point.y);
        //println("punto    x:  " + point.x * ancho + boundingRectX+ " | punto     y: " + point.y * alto + boundingRectY);
      }
      offscreen.endShape(CLOSE);
    }
  }
}