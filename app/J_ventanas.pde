class Ventanas {
  FPoly v;
  PShape windowShape [] = new PShape [2];

  Ventanas () {
  }
  void draw() {
    for (int i=0; i<windowShape.length; i++) {
      windowShape[i].setStroke(color(255));
      windowShape[i].setStrokeWeight(10);
      windowShape[i].setFill(0);
      shape(windowShape[i]);
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

      windowShape[i].endShape(CLOSE);
      v.setStatic(true);
      world.add(v);
    }
  }
}