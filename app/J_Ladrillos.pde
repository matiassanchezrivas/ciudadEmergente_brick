int START_ANGLE_1=10;
int STOP_ANGLE_1=80;

int START_ANGLE_2=100;
int STOP_ANGLE_2=170;

class LadrillosArcos {
  ArrayList <Brick> bricks;
  int windowNumber;

  LadrillosArcos (int windowNumber) {
    bricks = new ArrayList();
    this.windowNumber=windowNumber;
  }

  void draw() {
    for (int i=0; i<bricks.size(); i++) {
      Brick b = bricks.get(i);
      b.draw();
    }
  }

  void reset() {

    bricks = new ArrayList();
    crearArco(START_ANGLE_1, STOP_ANGLE_1);
    crearArco(START_ANGLE_2, STOP_ANGLE_2);
  }
  void crearArco(int start, int stop) {

    //ARCO
    float startAngle, stopAngle;

    startAngle=radians(start);
    stopAngle=radians(stop);

    Ventana ventana = windows[windowNumber];

    int _numPoints=15;
    int _numBricksArc=NUM_ARC_BRICKS;
    float _angleSep = (stopAngle-startAngle)/_numBricksArc;
    float _angle=_angleSep/(float)_numPoints;

    for (int j=0; j<_numBricksArc; j++) {
      PVector [] pv;
      pv = new PVector [_numPoints*2+2];
      float centerx=0;
      float centery=0;
      float rotAngle=0;
      for (int i=0; i<=_numPoints; i++)
      {
        pv [i] = new PVector(ventana.x+ventana.ancho/2+ventana.ancho/2*sin(startAngle+HALF_PI+PI+_angleSep*j+_angle*i), ventana.y+ventana.altoArco/2*cos(startAngle+HALF_PI+TWO_PI+_angleSep*j+_angle*i));
      } 
      for (int i=_numPoints; i>=0; i--)
      {
        pv [_numPoints*2+1-i] = new PVector(ventana.x+ventana.ancho/2+(ventana.ancho/2+BRICK_HEIGHT)*sin(startAngle+HALF_PI+PI+_angleSep*j+_angle*i), ventana.y+(ventana.altoArco/2+BRICK_HEIGHT)*cos(startAngle+HALF_PI+TWO_PI+_angleSep*j+_angle*i));
      } 
      centerx=ventana.x+ventana.ancho/2+ventana.ancho/2*sin(startAngle+HALF_PI+PI+_angleSep*j+_angleSep/2);
      centery=ventana.y+ventana.altoArco/2*cos(startAngle+HALF_PI+TWO_PI+_angleSep*j+_angleSep/2);
      rotAngle=startAngle+HALF_PI+PI+_angleSep*j+_angleSep/2;
      bricks.add(new Brick(pv, centerx, centery, rotAngle));
    }
  }

  void explosion(int x, int y) {
    for (int i=0; i<bricks.size(); i++) {
      Brick b=bricks.get(i);
      b.explosion(x, y);
    }
  }

  void saltar() {
    for (int i=0; i<bricks.size(); i++) {
      Brick b=bricks.get(i);
      b.saltar();
    }
  }

  float porcentajeMuertos() {
    int cantMuertos=0;
    for (Brick b : bricks) {
      if ( !b.isAlive()) {
        cantMuertos++;
      }
    }
    return cantMuertos*1.0/bricks.size();
  }
}

////------------------------------------------------
//class LadrillosVentana {
//  ArrayList <Brick> bricks;

//  LadrillosVentana () {
//    bricks = new ArrayList();
//  }

//  void draw() {
//    for (int i=0; i<bricks.size(); i++) {
//      Brick b = bricks.get(i);
//      b.draw();
//    }
//  }

//  void reset() {
//    bricks = new ArrayList();
//    for (Ventana ventana : windows) {
//      //LADRILLOS
//      int numberBricks = int(ventana.alto/BRICK_HEIGHT);
//      for (int i=numberBricks-1; i>=0; i--)
//      {
//        //IZQUIERDA
//        bricks.add(new Brick (ventana.x-BRICK_WIDTH, ventana.y+BRICK_HEIGHT*i, BRICK_WIDTH, BRICK_HEIGHT, "ventana", "izquierda"));
//      }
//      for (int i=0; i<numberBricks; i++)
//      {
//        //DERECHA
//        bricks.add(new Brick (ventana.x+ventana.ancho, ventana.y+BRICK_HEIGHT*i, BRICK_WIDTH, BRICK_HEIGHT, "ventana", "derecha"));
//      }
//    }
//  }

//  void saltar() {
//    for (int i=0; i<bricks.size(); i++) {
//      Brick b=bricks.get(i);
//      b.saltar();
//    }
//  }
//}


//------------------------------------------------
class LadrillosGrilla {
  ArrayList <Brick> bricks;

  LadrillosGrilla () {
    bricks = new ArrayList();
  }

  void draw() {
    for (int i=0; i<bricks.size(); i++) {
      Brick b = bricks.get(i);
      b.draw();
    }
  }

  void reset() {
    bricks = new ArrayList();

    for (int i=0; i<packLadrillos.filas.size(); i++) {
      FilaLadrillos fila = packLadrillos.filas.get(i);
      for (int j=0; j<fila.ladrillos.size(); j++) {
        Ladrillo l = fila.ladrillos.get(j);
        int oro =int(random(fila.ladrillos.size()-1));
        String type = "grilla";
        if (i==3 && j==2) {
          type= "oro";
          println("ES OROOOO");
        }
        bricks.add(new Brick (l.x, l.y, l.ancho, l.alto, type, "x"));
      }
    }
  }
  void explosion(int x, int y) {
    for (int i=0; i<bricks.size(); i++) {
      Brick b=bricks.get(i);
      b.explosion(x, y);
    }
  }
  void saltar() {
    for (int i=0; i<bricks.size(); i++) {
      Brick b=bricks.get(i);
      b.saltar();
    }
  }
}