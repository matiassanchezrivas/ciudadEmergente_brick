//------------------------------------------------
class Pelota {
  int x, y, tam;
  FCircle bola;
  Pelota () {
    reset();
    update();
  }
  
  void rest(Paleta p){
  bola.setPosition(p.x, p.y-p.alto/2-tam/2);
  }

  void jugar() {
    float velx = bola.getVelocityX();
    float vely = bola.getVelocityY();
    velx = (velx > 0) ? MIN_VELOCITY : -MIN_VELOCITY;
    vely = (vely > 0) ? MIN_VELOCITY : -MIN_VELOCITY;
    bola.setVelocity(velx, vely);
  }

  void update() {
    this.x = int(bola.getX()); 
    this.y = int(bola.getY()); 
    this.tam = SIZE_BALL;
  }

  void draw() {
    update();
    offscreen.pushStyle();
    offscreen.noStroke();
    offscreen.fill(255);
    offscreen.ellipse (x, y, tam, tam);
    offscreen.popStyle();
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