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