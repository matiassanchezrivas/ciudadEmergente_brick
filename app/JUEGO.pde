class Juego {

  Paleta paleta;
  Pelota pelota;
  LadrillosGrilla ladrillosGrilla;
  LadrillosArcos ladrillosArcos;

  Juego () {
    paleta = new Paleta();
    pelota = new Pelota();
    ladrillosGrilla = new LadrillosGrilla();
    ladrillosArcos = new LadrillosArcos();
  }

  void draw() {
    fill(255, 50);
    rect(0, 0, width, height);
    paleta.draw();
    pelota.draw();
    ladrillosGrilla.draw();
    ladrillosArcos.draw();
  }

  void reset() {
    pelota.reset();
    paleta.reset();
    ladrillosGrilla.reset();
    ladrillosArcos.reset();
  }

  void updateInfo() {
  }
}
//------------------------------------------------
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
          println(i);
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
        bricks.add(new Brick (l.x, l.y, l.ancho, l.alto));
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
  Brick(int x, int y, int ancho, int alto) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.type="normal";
    reset();
   
  }

  Brick (PVector [] vertex) {
    this.type="vertices";
    this.vertex = vertex;
    reset();
  }

  void reset() {
    if (type=="normal") {
      for (int i=0; i<8; i++) {
        factor[i] = int(random(-5, 5));
      }
      brick = new FBox(ancho, alto);
      brick.setName("brick");
      brick.setStatic(true);
      brick.setPosition(x+ancho/2, y+alto/2);
      brick.setFill(random(255), 0, 0);
      world.add(brick);
    } else {
      brickV = new FPoly();
      brickShape = createShape();
      brickShape.beginShape();
      for (int i=0; i<vertex.length; i++)
      {
        brickShape.vertex(vertex[i].x, vertex[i].y);
        brickV.vertex(vertex[i].x, vertex[i].y);
      } 
      brickShape.endShape(CLOSE);
      brickV.setFill(random(255), 0, 0);
      brickV.setName("brick");
      brickV.setStatic(true);
      world.add(brickV);
    }
  }

  void draw() {

    pushStyle();
    if (type=="normal") {
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
    } else {
      if (isAlive()) {
        brickShape.setStroke(color(255, 0, 0, 100));
        brickShape.setFill(color(255, 0, 0, 100));
      } else {
        brickShape.setFill(color(0, 100));
      }
      shape(brickShape);
    }
    popStyle();
  }

  void animationDead() {
    if (triggerAnimationDead==false) {
      triggerAnimationDead = true; 
      tiempoDesdeTriggerAnimation=millis();
    }else{
      fill(255,map(millis()-tiempoDesdeTriggerAnimation, 0, timeAnimationDead, 255,0));
      textAlign(CENTER, CENTER);
      text("100",x+ancho/2,y+alto/2);
    }
  }

  boolean isAlive() {
    if (type=="normal" && brick.getName() == "brick_dead") return false;
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