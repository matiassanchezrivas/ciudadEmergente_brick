float INCREMENTO_X;
float INCREMENTO_Y;

//------------------------------------------------
void rebote() {
  float ang = radians(random(35, 55));
  int velocidad = juego.nivel==0 ? MIN_VELOCITY_NIVEL1 : MIN_VELOCITY_NIVEL2;
  INCREMENTO_X = velocidad * cos( ang );
  INCREMENTO_Y = velocidad * sin( ang );
}
//------------------------------------------------
class Pelota {
  int x, y, tam;
  int alpha=0;
  int amount=5;
  float transp=1;

  FCircle bola;
  Pelota () {
    reset();
    update();
  }
  
    float limitar(float x) {
    return constrain(x, windows[0].x+windows[0].ancho, windows[1].x);
  }

  void rest(Paleta p) {
    bola.setPosition(limitar(juego.paleta.paleta.getX()), limitar(juego.paleta.paleta.getY()-p.alto/2-tam/2));
  }

  void jugar3(int nivel) {
    float velx = bola.getVelocityX();
    float vely = bola.getVelocityY();
    if (nivel==0) {
      velx = (velx > 0) ? MIN_VELOCITY_NIVEL1  : -MIN_VELOCITY_NIVEL1;
      vely = (vely > 0) ? MIN_VELOCITY_NIVEL1  : -MIN_VELOCITY_NIVEL1;
    } else {
      velx = (velx > 0) ? MIN_VELOCITY_NIVEL2  : -MIN_VELOCITY_NIVEL2;
      vely = (vely > 0) ? MIN_VELOCITY_NIVEL2  : -MIN_VELOCITY_NIVEL2;
    }
  }

  void jugar(int nivel) {
    float velx = bola.getVelocityX();
    float vely = bola.getVelocityY();
    if (nivel==0) {
      velx = (velx > 0) ? INCREMENTO_X  : -INCREMENTO_X;
      vely = (vely > 0) ? INCREMENTO_Y  : -INCREMENTO_Y;
    } else {
      velx = (velx > 0) ? INCREMENTO_X  : -INCREMENTO_X;
      vely = (vely > 0) ? INCREMENTO_Y  : -INCREMENTO_Y;
    }
    bola.setVelocity(velx, vely);
  }

  void jugar2(int nivel) {
    float velx = bola.getVelocityX();
    float vely = bola.getVelocityY();

    float angulo = atan2( vely, velx );

    velx = MIN_VELOCITY_NIVEL1 * cos( angulo );
    vely = MIN_VELOCITY_NIVEL1 * sin( angulo );

    bola.setVelocity(velx, vely);
  }

  void update() {
    this.x = int(bola.getX()); 
    this.y = int(bola.getY()); 
    this.tam = SIZE_BALL;
    transp=(map(y, WORLD_BOTTOM_Y, height, 1, 0));
  }

  void draw(boolean seVe) {
    update();
    if (seVe) {
      alpha = (alpha<255) ? alpha+=amount : 255;
    } else {
      alpha = (alpha>0) ? alpha-=amount : 0;
    }
    offscreen.pushStyle();
    offscreen.noStroke();
    offscreen.fill(255, alpha*transp);
    offscreen.ellipse (x, y, tam, tam);
    offscreen.popStyle();
  }

  void reset() {
    bola = new FCircle(tam);
    bola.setPosition(width/2, height/2);
    bola.setVelocity(1000, -1000);
    bola.setDensity(0.01);
    bola.setDamping(-1);
    bola.setName("bola");
    world.add(bola);
  }
}