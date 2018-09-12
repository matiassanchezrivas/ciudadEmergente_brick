int STROKE_BRICK =3;
int FACTOR_RANDOM =4;
int DISTANCIA_EXPLOSION = 100;

class Brick {
  FPoly brickV;
  FBox brick;
  int x, y, ancho, alto;
  float x1, y1, x2, y2, x3, y3, x4, y4;
  float centerx, centery;
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
  Motion motionDesapareceOro;
  Motion motionDesapareceVentana;
  boolean ladrillosConnie;
  float scale;
  int numeroImagenLadrillo;
  float rotAngle;

  Brick(int x, int y, int ancho, int alto, String type, String side) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.type=type;
    this.side=side;
    animation=false; 
    this.scale=0;
    motionDesaparece= new Motion(IMG_ladrilloDesaparece, FPS);
    motionLadrilloOro = new Motion(IMG_ladrilloOro, FPS);
    motionDesapareceOro = new Motion(IMG_ladrilloDesapareceOro, FPS);

    reset();
  }

  Brick (PVector [] vertex, float centerx, float centery, float rotAngle ) {
    this.type="vertices";
    this.vertex = vertex;
    this.centerx = centerx;
    this.centery = centery;
    this.rotAngle = rotAngle;
    for (int i=0; i<4; i++) {
      factorArc[i] = 1;
    }
    motionDesapareceVentana = new Motion(IMG_ladrilloDesapareceVentana, FPS);
    reset();
  }

  void reset() {
    animation=false; 
    resetAnimation();
    resetFisica(true, false);
  }

  void followFisica() {
    if (type!="vertices") {
      this.x=int(brick.getX()-ancho/2);
      this.y=int(brick.getY()-alto/2);
    }
  }

  void resetAnimation() {
    if (type=="grilla") {
      for (int i=0; i<8; i++) {
        factor[i] = int(random(-FACTOR_RANDOM, FACTOR_RANDOM));
      }
      x1=x2=x3=x4=0;
      y1=y2=y3=y4=0;
      numeroImagenLadrillo=int(random(5));
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
    } else  if (type=="grilla") {
      scale=0;
    }
  }

  void explotar() {
  }
  void resetFisica(boolean estatico, boolean saltar) {
    if (type=="grilla") {
      brick = new FBox(ancho, alto);
      brick.setName("brick");
      brick.setStatic(estatico);

      brick.setPosition(x+ancho/2, y+alto/2);
      if (saltar) brick.setPosition (random(width/4, width/4*3), -200);
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
      brickV.setStatic(estatico);
      world.add(brickV);
    } else if (type=="ventana") {
      for (int i=0; i<8; i++) {
        factor[i] = int(random(3, 15));
      }
      brick = new FBox(ancho, alto);
      brick.setName("pared");
      brick.setStatic(estatico);
      brick.setPosition(x+ancho/2, y+alto/2);
      brick.setFill(random(255), 0, 0);
      world.add(brick);
    } else if (type=="oro") {
      brick = new FBox(ancho, alto);
      brick.setName("brick");
      brick.setStatic(estatico);
      brick.setPosition(x+ancho/2, y+alto/2);
      brick.setFill(random(255), 0, 0);
      world.add(brick);
    }
  }

  void saltar() {
    if (isAlive() && brick != null && type!="oro") {
      world.remove(brick);
      resetFisica(false, false);
      brick.addForce(random(-100000, 100000), random(100000));
    } else if (brick != null && type!="oro") {
      resetFisica(false, true);     
      brick.addForce(random(-100000, 100000), random(100000));
    }
  }

  void draw() {
    followFisica();
    offscreen.pushStyle();
    if (type=="grilla") {
      if (isAlive()) {
        if (animation) {
          if (!ladrillosConnie) {
            offscreen.fill(0);
            offscreen.stroke(255);
            offscreen.strokeWeight(STROKE_BRICK);
            x1=(-ancho/2+factor[0])*(1-0.9)+x1*0.9;
            y1=(-alto/2+factor[1])*(1-0.9)+y1*0.9;
            x2=(ancho/2+factor[2])*(1-0.9)+x2*0.9;
            y2=(-alto/2+factor[3])*(1-0.9)+y2*0.9;
            x3=(ancho/2+factor[4])*(1-0.9)+x3*0.9;
            y3=(alto/2+factor[5])*(1-0.9)+y3*0.9;
            x4=(-ancho/2+factor[6])*(1-0.9)+x4*0.9;
            y4=(alto/2+factor[7])*(1-0.9)+y4*0.9;
            offscreen.pushMatrix();
            offscreen.translate(x, y);
            offscreen.translate(ancho/2, alto/2);
            offscreen.rotate(brick.getRotation());
            offscreen.quad(x1, y1, x2, y2, x3, y3, x4, y4);
            //offscreen.rectMode(CENTER);
            //offscreen.rect(ancho/2,alto/2,10,10);
            offscreen.popMatrix();
          } else {
            scale=1*(1-0.9)+scale*0.9;
            offscreen.pushMatrix();
            offscreen.translate(x+ancho/2, y+ancho/2);
            offscreen.scale(scale*2);
            offscreen.imageMode(CENTER);
            offscreen.image(IMG_ladrillosConnie[numeroImagenLadrillo], 0, 0, ancho, alto);
            offscreen.popMatrix();
          }
        }
      } else {
        animationDead(); 
        triggerAnimationDead=true;
      }
    } else if (type=="vertices") {
      if (isAlive()) {
        if (animation) {
          scale=1*(1-0.9)+scale*0.9;
        }
        offscreen.pushMatrix();
        offscreen.translate(centerx, centery);
        offscreen.scale(scale);
        //brickShape.setFill(color(255, scale*255));
        offscreen.shape(brickShape, -centerx, -centery);
        offscreen.popMatrix();
      } else {
        animationDead(); 
        triggerAnimationDead=true;
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
        if (animation) {
          scale=1*(1-0.9)+scale*0.9;
        }
        motionLadrilloOro.draw(IMG_ladrilloOro, x+ancho/2, y+alto/2, int(ancho*1.4), int(ancho*1.4), scale);
        motionLadrilloOro.loop();
      } else {
        animationDead();
      }
    }
    offscreen.popStyle();
  }

  void animate() {
    animation=true;
  }

  void explosion(int x, int y) {
    if (dist(this.x, this.y, x, y)<DISTANCIA_EXPLOSION) {
      if (brick != null) {
        brick.setName("brick_dead");
        world.remove(brick);
      }
    }
  }

  void pasarNivel() {
    if (brickV != null) {
      brickV.setName("brick_dead");
      world.remove(brickV);
    }
  }

  void animationDead() {
    if (triggerAnimationDead==false) {
      sonidista.ejecutarSonido(2);
      PUNTAJE_JUEGO+=PUNTOS_LADRILLO;
      triggerAnimationDead = true; 
      tiempoDesdeTriggerAnimation=millis();
      if (type!="vertices") {
        motionDesaparece.reset();
        motionDesapareceOro.reset();
      } else {
        motionDesapareceVentana.reset();
      }
      if (type=="oro") {
        sonidista.ejecutarSonido(3);
        explode(this.x, this.y);
      }
    } else {
      offscreen.pushStyle();
      if (type=="oro") {
        motionDesapareceOro.draw(IMG_ladrilloDesapareceOro, x+ancho/2, y+alto/2, 150, 150, 1);
      } else if (type=="vertices") {
        motionDesapareceVentana.rot(rotAngle);
        motionDesapareceVentana.trans(-70);
        motionDesapareceVentana.draw(IMG_ladrilloDesapareceVentana, centerx, centery, 150, 150, 1);
      } else {
        motionDesaparece.draw(IMG_ladrilloDesaparece, x+ancho/2, y+alto/2, 150, 150, 1);
      }
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
    offscreen.fill(255, map(amount, .5, 1, 255, 0));
    offscreen.textFont(consolasBold30);
    offscreen.textAlign(CENTER, CENTER);
    if (type!="vertices") {
      offscreen.text(PUNTOS_LADRILLO, x+ancho/2, y+alto/2+map(amount, 0, 1, 10, -20));
    } else {
      offscreen.pushMatrix();
      offscreen.translate(centerx, centery);
      offscreen.rotate(rotAngle);
      offscreen.text(PUNTOS_LADRILLO, 0, map(amount, 0, 1, -70+10, -70-20));
      offscreen.popMatrix();
    }
    offscreen.popStyle();
  }

  boolean isAlive() {
    if ((type=="grilla" || type=="oro") && brick.getName() == "brick_dead") return false;
    if (type=="vertices" && brickV.getName() == "brick_dead") return false;
    return true;
  }
}