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
    int calle=40;
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
  float yoff = 0.0;
  Agua() {
  }

  void draw(float amount) {
  
    
    for (int i=0; i<windows.length; i++) {

      pushStyle();
      fill(colorJuegoAgua.elColor);
      rectMode(CORNERS);
      //rect(windows[i].x, windows[i].y+windows[i].alto, windows[i].x+windows[i].ancho, windows[i].y+map(amount, 0, 1, windows[i].alto, 0));
      
      beginShape(); 

      float xoff = 0;
      for (float x = 0; x <= windows[i].ancho; x += 10) {
        float y = map(noise(xoff, yoff), 0, 1, 0, 50);
        vertex(windows[i].x+x, windows[i].y+map(amount, 0, 1, windows[i].alto, -windows[i].altoArco/2)-y); 
        xoff += 0.05;
      }
      yoff += 0.01;
      vertex(windows[i].x+windows[i].ancho, windows[i].y+windows[i].alto);
      vertex(windows[i].x, windows[i].y+windows[i].alto);
      endShape(CLOSE);
      popStyle();
    }
  }
}