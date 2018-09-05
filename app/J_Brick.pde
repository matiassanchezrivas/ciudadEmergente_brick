int STROKE_BRICK =5;
int FACTOR_RANDOM =4;

class Brick {
  FPoly brickV;
  FBox brick;
  int x, y, ancho, alto;
  float x1, y1, x2, y2, x3, y3, x4, y4;
  String type;
  PVector [] vertex;
  PShape brickShape;
  int [] factor = new int [8];
  boolean triggerAnimationDead = false;
  int  timeAnimationDead=1000;
  int tiempoDesdeTriggerAnimation;
  int [] factorArc = new int [4];
  float amount;
  String side;
  boolean animation;
  Motion motionDesaparece;
  Motion motionLadrilloOro;

  Brick(int x, int y, int ancho, int alto, String type, String side) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.type=type;
    this.side=side;
    animation=false; 
    reset();
    motionDesaparece= new Motion(IMG_ladrilloDesaparece, FPS);
    motionLadrilloOro = new Motion(IMG_ladrilloOro, FPS);
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
    animation=false; 
    resetAnimation();
    resetFisica();
  }

  void resetAnimation() {
    if (type=="grilla") {
      for (int i=0; i<8; i++) {
        factor[i] = int(random(-FACTOR_RANDOM, FACTOR_RANDOM));
      }
      x1=x2=x3=x4=x+ancho/2;
      y1=y2=y3=y4=y+alto/2;
    } else if (type=="ventana") {
      //DERECHA
      if (side=="derecha") {
        x1=x2=x;
        y1=y2=y+factor[1];
        x4=x3=x;
        y4=y3=y+alto-factor[7];
      }
      //IZQUIERDA
      else if (side=="izquierda") {
        x2=x1=(x+ancho);
        y2=y1=(y+factor[3]);
        x3=x4=(x+ancho);
        y3=y4=(y+alto-factor[5]);
      }
    }
  }

  void resetFisica() {
    if (type=="grilla") {
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
    } else if (type=="oro") {
      brick = new FBox(ancho, alto);
      brick.setName("brick");
      brick.setStatic(true);
      brick.setPosition(x+ancho/2, y+alto/2);
      brick.setFill(random(255), 0, 0);
      world.add(brick);
    }
  }

  void draw() {
    offscreen.pushStyle();
    if (type=="grilla") {
      if (isAlive()) {
        offscreen.fill(0);
        offscreen.stroke(255);
        offscreen.strokeWeight(STROKE_BRICK);
        if (animation) {
          x1=(x+factor[0])*(1-0.9)+x1*0.9;
          y1=(y+factor[1])*(1-0.9)+y1*0.9;
          x2=(x+ancho+factor[2])*(1-0.9)+x2*0.9;
          y2=(y+factor[3])*(1-0.9)+y2*0.9;
          x3=(x+ancho+factor[4])*(1-0.9)+x3*0.9;
          y3=(y+alto+factor[5])*(1-0.9)+y3*0.9;
          x4=(x+factor[6])*(1-0.9)+x4*0.9;
          y4=(y+alto+factor[7])*(1-0.9)+y4*0.9;
          offscreen.quad(x1, y1, x2, y2, x3, y3, x4, y4);
        }
      } else {
        animationDead(); 
        triggerAnimationDead=true;
        offscreen.fill(0, 100);
      }
    } else if (type=="vertices") {
      if (isAlive()) {
        brickShape.setFill(color(255));
        offscreen.shape(brickShape);
      } 
    } else if (type=="ventana") {
      if (isAlive()) {
        offscreen.noStroke();
        offscreen.fill(153);
        if (animation) {
          x1=x*(1-0.9)+x1*0.9;
          y1=(y+factor[1])*(1-0.9)+y1*0.9;
          x2=(x+ancho)*(1-0.9)+x2*0.9;
          y2=(y+factor[3])*(1-0.9)+y2*0.9;
          x3=(x+ancho)*(1-0.9)+x3*0.9;
          y3=(y+alto-factor[5])*(1-0.9)+y3*0.9;
          x4=x*(1-0.9)+x4*0.9;
          y4=(y+alto-factor[7])*(1-0.9)+y4*0.9;
        }
        offscreen.quad(x1, y1, x2, y2, x3, y3, x4, y4);
      }
    } else if (type=="oro") {
      if (isAlive()) {
        offscreen.fill(0);
        offscreen.stroke(255);
        offscreen.strokeWeight(STROKE_BRICK);
        if (animation) {

        }
      } else {
        animationDead(); 
        triggerAnimationDead=true;
        
      }
    }
    offscreen.popStyle();
  }

  void animate() {
    animation=true;
  }

  void animationDead() {
    if (triggerAnimationDead==false) {
      PUNTAJE_JUEGO+=PUNTOS_LADRILLO;
      triggerAnimationDead = true; 
      tiempoDesdeTriggerAnimation=millis();
      motionDesaparece.reset();
    } else {
      offscreen.pushStyle();
      motionDesaparece.draw(ladrilloDesaparece, x+ancho/2, y+alto/2, 150, 150);
      amount = map(millis()-tiempoDesdeTriggerAnimation, 0, timeAnimationDead, 0, 1);
      if (amount<=1) {
        verPuntaje();
      }
    }
  }

  void verPuntaje() {
    offscreen.rectMode(CENTER);
    offscreen.fill(0, map(amount, .75, 1, 255, 0));
    offscreen.noStroke();
    //offscreen.rect(x+ancho/2, y+alto/2+map(amount, 0, .75, 10, -20), offscreen.textWidth(str(PUNTOS_LADRILLO))+20, 60, 20);
    offscreen.fill(255, map(amount, 0, .75, 255, 0));
    offscreen.textFont(consolasBold30);
    offscreen.textAlign(CENTER, CENTER);
    offscreen.text(PUNTOS_LADRILLO, x+ancho/2, y+alto/2+map(amount, 0, .75, 10, -20));
    offscreen.popStyle();
  }

  boolean isAlive() {
    if (type=="grilla" && brick.getName() == "brick_dead") return false;
    if (type=="vertices" && brickV.getName() == "brick_dead") return false;
    return true;
  }
}