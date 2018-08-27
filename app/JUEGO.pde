class Juego {

  Paleta paleta;
  Pelota pelota;
  LadrillosGrilla ladrillosGrilla;
  LadrillosArcos ladrillosArcos;
  LadrillosVentana ladrillosVentana;
  Ventanas ventanas;

  Juego () {
    paleta = new Paleta();
    pelota = new Pelota();
    ladrillosGrilla = new LadrillosGrilla();
    ladrillosArcos = new LadrillosArcos();
    ladrillosVentana = new LadrillosVentana();
    ventanas = new Ventanas();
  }

  void draw() {
    fill(0, 255);
    rect(0, 0, width, height);
    paleta.draw();
    pelota.draw();
    ladrillosGrilla.draw();
    ladrillosArcos.draw();
    ladrillosVentana.draw();
    ventanas.draw();
  }

  void reset() {
    pelota.reset();
    paleta.reset();
    ladrillosGrilla.reset();
    ladrillosArcos.reset();
    ladrillosVentana.reset();
    ventanas.reset();
  }

  void updateInfo() {
  }
}
//------------------------------------------------
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
      int _numBricksArc=numArcBricks;
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
          println(i);
          pv [_numPoints*2+1-i] = new PVector(ventana.x+ventana.ancho/2+(ventana.ancho/2+brickHeight)*sin(HALF_PI+PI+_angleSep*j+_angle*i), ventana.y+(ventana.altoArco/2+brickHeight)*cos(HALF_PI+TWO_PI+_angleSep*j+_angle*i));
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
      int numberBricks = int(ventana.alto/brickHeight);
      for (int i=0; i<numberBricks; i++)
      {
        //IZQUIERDA
        bricks.add(new Brick (ventana.x-brickWidth, ventana.y+brickHeight*i, brickWidth, brickHeight, "ventana"));
        //DERECHA
        bricks.add(new Brick (ventana.x+ventana.ancho, ventana.y+brickHeight*i, brickWidth, brickHeight, "ventana"));
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
        bricks.add(new Brick (l.x, l.y, l.ancho, l.alto, "grilla"));
      }
    }
  }
}

class Brick {
  FPoly brickV;
  FBox brick;
  int x, y, ancho, alto;
  String type;
  PVector [] vertex;
  PShape brickShape;
  int [] factor = new int [8];
  boolean triggerAnimationDead = false;
  int  timeAnimationDead=500;
  int tiempoDesdeTriggerAnimation;
  int [] factorArc = new int [4];

  Brick(int x, int y, int ancho, int alto, String type) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.type=type;
    reset();
  }

  Brick (PVector [] vertex) {
    this.type="vertices";
    this.vertex = vertex;
    for (int i=0; i<4; i++) {
      factorArc[i] = int(random(0, 6));
    }
    reset();
  }

  void reset() {
    if (type=="grilla") {
      for (int i=0; i<8; i++) {
        factor[i] = int(random(-5, 5));
      }
      brick = new FBox(ancho, alto);
      brick.setName("brick");
      brick.setStatic(true);
      brick.setPosition(x+ancho/2, y+alto/2);
      brick.setFill(random(255), 0, 0);
      world.add(brick);
    } else if (type=="vertices") {
      brickV = new FPoly();
      brickShape = createShape();
      brickShape.beginShape();
      for (int i=0; i<vertex.length; i++)
      
      {
        println("SJDKNASKLDNLK", factorArc[0], vertex.length/2-factorArc[1], vertex.length/2+factorArc[2], vertex.length-factorArc[3]);
        if ((i>factorArc[0] && i<vertex.length/2-factorArc[1]) || i>vertex.length/2-factorArc[1] && i<vertex.length-factorArc[3]   ) {
          brickShape.vertex(vertex[i].x, vertex[i].y);
          brickV.vertex(vertex[i].x, vertex[i].y);
        }
      } 
      brickShape.noStroke();
      brickShape.endShape(CLOSE);
      brickV.setFill(random(255), 0, 0);
      brickV.setName("brick");
      brickV.setStatic(true);
      world.add(brickV);
    } else if (type=="ventana") {
      for (int i=0; i<8; i++) {
        factor[i] = int(random(3, 15));
      }
      brick = new FBox(ancho, alto);
      brick.setName("pared");
      brick.setStatic(true);
      brick.setPosition(x+ancho/2, y+alto/2);
      brick.setFill(random(255), 0, 0);
      world.add(brick);
    }
  }

  void draw() {

    pushStyle();
    if (type=="grilla") {
      if (isAlive()) {
        fill(0);
        stroke(255);
        strokeWeight(6);
        quad(x+factor[0], y+factor[1], x+ancho+factor[2], y+factor[3], x+ancho+factor[4], y+alto+factor[5], x+factor[6], y+alto+factor[7] );
      } else {
        animationDead(); 
        triggerAnimationDead=true;
        fill(0, 100);
      }
    } else if (type=="vertices") {
      if (isAlive()) {
        //brickShape.setStrokeWeight(6);
        //brickShape.setStroke(color(255));
        brickShape.setFill(color(255));
        shape(brickShape);
      } else {
        //brickShape.setFill(color(0, 100));
      }
      
    } else if (type=="ventana") {
      if (isAlive()) {
        noStroke();
        fill(153);
        quad(x, y+factor[1], x+ancho, y+factor[3], x+ancho, y+alto-factor[5], x, y+alto-factor[7] );
      }
    }
    popStyle();
  }

  void animationDead() {
    if (triggerAnimationDead==false) {
      triggerAnimationDead = true; 
      tiempoDesdeTriggerAnimation=millis();
    } else {
      fill(255, map(millis()-tiempoDesdeTriggerAnimation, 0, timeAnimationDead, 255, 0));
      textAlign(CENTER, CENTER);
      text("100", x+ancho/2, y+alto/2);
    }
  }

  boolean isAlive() {
    if (type=="grilla" && brick.getName() == "brick_dead") return false;
    if (type=="vertices" && brickV.getName() == "brick_dead") return false;
    return true;
  }
}


//------------------------------------------------
class Paleta {
  int x, y, ancho, alto;
  FBox paleta;
  Paleta () {
    reset();
    update();
  }

  void update() {
    this.x = int(paleta.getX()); 
    this.y = int(paleta.getY()); 
    this.ancho = int(paleta.getWidth());
    this.alto = int(paleta.getHeight());
  }

  void draw() {
    update();
    pushStyle();
    noFill();
    stroke(255);
    strokeWeight(20);
    rect (x-ancho/2, y-alto/2, ancho, alto, 978879879);
    popStyle();
  }

  void reset() {
    paleta = new FBox(paddleWidth, paddleHeight);
    paleta.setName("paleta");
    paleta.setStatic(true);
    world.add(paleta);
  }
}

//------------------------------------------------
class Pelota {
  int x, y, tam;
  FCircle bola;
  Pelota () {
    reset();
    update();
  }

  void update() {
    this.x = int(bola.getX()); 
    this.y = int(bola.getY()); 
    ;
    this.tam = sizeBall;
  }

  void draw() {
    update();
    pushStyle();
    noStroke();
    fill(255);
    ellipse (x, y, tam, tam);
    popStyle();
  }

  void reset() {
    bola = new FCircle(tam);
    bola.setPosition(width/2, height/2);
    bola.setVelocity(1000, 1000);
    bola.setDensity(0.01);
    bola.setDamping(-1);
    bola.setName("bola");
    world.add(bola);
  }
}