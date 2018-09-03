int DURACION_BARROTES = 2000;

class Ventanas {
  FPoly v;
  PShape windowShape [] = new PShape [2];
  PShape negativeWindowShape [] = new PShape [2];

  Ventanas () {
  }

  void draw() {
    for (int i=0; i<windowShape.length; i++) {
      windowShape[i].setStroke(color(255));
      windowShape[i].setStrokeWeight(10);
      shape(windowShape[i]);
    }
  }

  void drawBehind() {
    for (int i=0; i<negativeWindowShape.length; i++) {
      negativeWindowShape[i].setFill(0);
      shape(negativeWindowShape[i]);
    }
  }

  void reset() {
    for (int i=0; i<windows.length; i++) {
      //VENTANA
      v = new FPoly();
      windowShape[i] = createShape();
      windowShape[i].beginShape();
      int numPoints=40;
      float angle=PI/(float)numPoints;
      windowShape[i].vertex(windows[i].x, windows[i].y);
      v.vertex(windows[i].x, windows[i].y);
      for (int j=0; j<numPoints; j++)
      {
        windowShape[i].vertex(windows[i].x+windows[i].ancho/2+windows[i].ancho/2*sin(HALF_PI+PI+angle*j), windows[i].y+windows[i].altoArco/2*cos(HALF_PI+TWO_PI+angle*j));
        v.vertex(windows[i].x+windows[i].ancho/2+windows[i].ancho/2*sin(HALF_PI+PI+angle*j), windows[i].y+windows[i].altoArco/2*cos(HALF_PI+TWO_PI+angle*j));
      } 
      windowShape[i].vertex(windows[i].x+windows[i].ancho, windows[i].y);
      v.vertex(windows[i].x+windows[i].ancho, windows[i].y);
      windowShape[i].vertex(windows[i].x+windows[i].ancho, windows[i].y+windows[i].alto);
      v.vertex(windows[i].x+windows[i].ancho, windows[i].y+windows[i].alto);
      windowShape[i].vertex(windows[i].x, windows[i].y+windows[i].alto);
      v.vertex(windows[i].x, windows[i].y+windows[i].alto);
      windowShape[i].noFill();
      windowShape[i].endShape(CLOSE);
      v.setStatic(true);
      world.add(v);
    }
    //NEGATIVE
    int calle=100;
    for (int i=0; i<windows.length; i++) {
      //VENTANA
      negativeWindowShape[i] = createShape();
      negativeWindowShape[i].beginShape();

      //negativeWindowShape[i].vertex(windows[i].x-calle, windows[i].y);
      negativeWindowShape[i].vertex(windows[i].x-calle, windows[i].y+windows[i].alto+calle);
      negativeWindowShape[i].vertex(windows[i].x+calle+windows[i].ancho, windows[i].y+windows[i].alto+calle);
      negativeWindowShape[i].vertex(windows[i].x+calle+windows[i].ancho, windows[i].y-windows[i].altoArco/2-calle);
      negativeWindowShape[i].vertex(windows[i].x-calle, windows[i].y-windows[i].altoArco/2-calle);
      negativeWindowShape[i].vertex(windows[i].x-calle, windows[i].y+windows[i].alto+calle);
      //negativeWindowShape[i].vertex(windows[i].x-calle, windows[i].y);

      negativeWindowShape[i].beginContour();
      int numPoints=40;
      float angle=PI/(float)numPoints;


      for (int j=0; j<numPoints; j++)
      {
        negativeWindowShape[i].vertex(windows[i].x+windows[i].ancho/2+windows[i].ancho/2*sin(HALF_PI+PI+angle*j), windows[i].y+windows[i].altoArco/2*cos(HALF_PI+TWO_PI+angle*j));
      } 
      negativeWindowShape[i].vertex(windows[i].x+windows[i].ancho, windows[i].y);
      negativeWindowShape[i].vertex(windows[i].x+windows[i].ancho, windows[i].y+windows[i].alto);
      negativeWindowShape[i].vertex(windows[i].x, windows[i].y+windows[i].alto);
      negativeWindowShape[i].vertex(windows[i].x, windows[i].y);


      negativeWindowShape[i].endContour();
      negativeWindowShape[i].noStroke();
      negativeWindowShape[i].endShape(CLOSE);
    }
  }
}

class Agua {
  //SINUSOIDAL
  int xspacing = 16;   // How far apart should each horizontal location be spaced
  int w;              // Width of entire wave

  float theta = 0.0;  // Start angle at 0
  float minAmplitude = 10.0;  // Height of wave
  float maxAmplitude = 50.0;
  float period = 1000.0;  // How many pixels before the wave repeats
  float dx;  // Value for incrementing X, a function of period and xspacing
  float[] yvalues;  // Using an array to store height values for the wave

  int windowNumber;

  //IRREGULAR
  float yoff = 0.0;
  Agua(int windowNumber) {
    this.windowNumber = windowNumber;
    theta=random(10);
    w = windows[windowNumber].ancho+20;
    dx = (TWO_PI / period) * xspacing;
    yvalues = new float[w/xspacing];
  }

  void drawIrregular(float amount) {

    pushStyle();
    fill(colorJuegoAgua.elColor);
    rectMode(CORNERS);
    //rect(windows[i].x, windows[i].y+windows[i].alto, windows[i].x+windows[i].ancho, windows[i].y+map(amount, 0, 1, windows[i].alto, 0));

    beginShape(); 

    float xoff = 0;
    for (float x = 0; x <= windows[windowNumber].ancho; x += 10) {
      float y = map(noise(xoff, yoff), 0, 1, 0, 50);
      vertex(windows[windowNumber].x+x, windows[windowNumber].y+map(amount, 0, 1, windows[windowNumber].alto, -windows[windowNumber].altoArco/2)-y); 
      xoff += 0.05;
    }
    yoff += 0.01;
    vertex(windows[windowNumber].x+windows[windowNumber].ancho, windows[windowNumber].y+windows[windowNumber].alto);
    vertex(windows[windowNumber].x, windows[windowNumber].y+windows[windowNumber].alto);
    endShape(CLOSE);
    popStyle();
  }

  void draw(float amount) {
    calcWave(amount);

    pushStyle();
    fill(colorJuegoAgua.elColor);

    //rect(windows[i].x, windows[i].y+windows[i].alto, windows[i].x+windows[i].ancho, windows[i].y+map(amount, 0, 1, windows[i].alto, 0));

    beginShape(); 
    for (int x = 0; x < yvalues.length; x++) {
      vertex(windows[windowNumber].x+x*xspacing, windows[windowNumber].y+map(amount, 0, 1, windows[windowNumber].alto, -windows[windowNumber].altoArco/2)-yvalues[x]);
    }
    vertex(windows[windowNumber].x+windows[windowNumber].ancho, windows[windowNumber].y+windows[windowNumber].alto);
    vertex(windows[windowNumber].x, windows[windowNumber].y+windows[windowNumber].alto);
    endShape(CLOSE);
    popStyle();
  }

  void calcWave(float amount) {
    // Increment theta (try different values for 'angular velocity' here
    theta += 0.04;

    // For every x value, calculate a y value with sine function
    float x = theta;
    for (int i = 0; i < yvalues.length; i++) {
      yvalues[i] = sin(x)*map(amount, 0, 1, minAmplitude, maxAmplitude);
      x+=dx;
    }
  }
}

class Barrotes {
  int windowNumber;
  int numberBarrotes;
  int positions [];
  Temporizador temporizador;

  Barrotes(int windowNumber, int numberBarrotes) {
    this.windowNumber = windowNumber;
    this.numberBarrotes = numberBarrotes;
    positions = new int [numberBarrotes];
    for (int i=0; i<positions.length; i++) {
      positions[i] = int(windows[windowNumber].ancho/numberBarrotes*i);
    }
    temporizador = new Temporizador(DURACION_BARROTES);
  }
  
  void reset() {
    temporizador.reset();
  }

  void draw() {
    float amount = temporizador.normalized();
    pushStyle();
    stroke(255);
    strokeWeight(6);
    Ventana v = windows[windowNumber];
    for (int i=0; i<positions.length; i++) {
      line(v.x+positions[i], v.y-v.altoArco/2, v.x+positions[i], v.y-v.altoArco/2+(v.alto+v.altoArco/2)*amount);
    }
    line(v.x, v.y-v.altoArco/2+(v.alto+v.altoArco/2)*amount, v.x+v.ancho, v.y-v.altoArco/2+(v.alto+v.altoArco/2)*amount);
    popStyle();
  }
}