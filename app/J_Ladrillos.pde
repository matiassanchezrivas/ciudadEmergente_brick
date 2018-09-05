class LadrillosArcos {
  ArrayList <Brick> bricks;

  LadrillosArcos () {
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
    for (Ventana ventana : windows) {
      //ARCO
      int _numPoints=15;
      int _numBricksArc=NUM_ARC_BRICKS;
      float _angleSep = PI/_numBricksArc;
      float _angle=PI/_numBricksArc/(float)_numPoints;

      for (int j=0; j<_numBricksArc; j++) {
        PVector [] pv;
        pv = new PVector [_numPoints*2+2];
        for (int i=0; i<=_numPoints; i++)
        {
          pv [i] = new PVector(ventana.x+ventana.ancho/2+ventana.ancho/2*sin(HALF_PI+PI+_angleSep*j+_angle*i), ventana.y+ventana.altoArco/2*cos(HALF_PI+TWO_PI+_angleSep*j+_angle*i));
        } 
        for (int i=_numPoints; i>=0; i--)
        {
          pv [_numPoints*2+1-i] = new PVector(ventana.x+ventana.ancho/2+(ventana.ancho/2+BRICK_HEIGHT)*sin(HALF_PI+PI+_angleSep*j+_angle*i), ventana.y+(ventana.altoArco/2+BRICK_HEIGHT)*cos(HALF_PI+TWO_PI+_angleSep*j+_angle*i));
        } 
        bricks.add(new Brick(pv));
      }
    }
  }
}

//------------------------------------------------
class LadrillosVentana {
  ArrayList <Brick> bricks;

  LadrillosVentana () {
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
    for (Ventana ventana : windows) {
      //LADRILLOS
      int numberBricks = int(ventana.alto/BRICK_HEIGHT);
      for (int i=numberBricks-1; i>=0; i--)
      {
        //IZQUIERDA
        bricks.add(new Brick (ventana.x-BRICK_WIDTH, ventana.y+BRICK_HEIGHT*i, BRICK_WIDTH, BRICK_HEIGHT, "ventana", "izquierda"));
      }
      for (int i=0; i<numberBricks; i++)
      {
        //DERECHA
        bricks.add(new Brick (ventana.x+ventana.ancho, ventana.y+BRICK_HEIGHT*i, BRICK_WIDTH, BRICK_HEIGHT, "ventana", "derecha"));
      }
    }
  }
}


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
        bricks.add(new Brick (l.x, l.y, l.ancho, l.alto, "grilla", "x"));
      }
    }
  }
}