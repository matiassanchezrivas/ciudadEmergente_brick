//------------------------------------------------
int Y_PALETA = 668;

class Paleta {
  int x, y, ancho, alto;
  int xKinect;
  int alpha=0;
  int amount=5;
  FBox paleta;
  FBox paleta2;
  boolean escucharPaleta2 = false;

  Paleta () {
    reset();
    update();
    xKinect=width/2;
  }

  void sacarPaleta2() {
    escucharPaleta2=false;
    worldBola.remove(paleta2);
  }

  void jugar() {
    if (useKinect) {
      xKinect = (kinect.getPlayerPosition()!=null) ? xKinect = int(kinect.getPlayerPosition().x) : xKinect;
      paleta.setPosition(limitar(xKinect), Y_PALETA);
      if (!escucharPaleta2) {
        paleta2.setPosition(limitar(xKinect), Y_PALETA);
      }
    } else {
      paleta.setPosition(limitar(mouseX), Y_PALETA);
      if (!escucharPaleta2) {
        paleta2.setPosition(limitar(mouseX), Y_PALETA);
      }
    }
  }

  float limitar(float x) {
    return constrain(x, windows[0].x+windows[0].ancho, windows[1].x);
  }

  void update() {
    //PALETA
    this.x = int(paleta.getX()); 
    this.y = int(paleta.getY()); 
    this.ancho = int(paleta.getWidth());
    this.alto = int(paleta.getHeight());
  }

  void updateLive() {
    //PALETA
    this.x = int(paleta.getX()); 
    this.y = int(paleta.getY()); 
    this.ancho = PADDLE_WIDTH;
    this.alto = PADDLE_HEIGHT;
  }

  void updateBolaMedieval() {
    //PALETA
    this.x = int(paleta2.getX()); 
    this.y = int(paleta2.getY()); 
    this.ancho = PADDLE_WIDTH;
    this.alto = PADDLE_HEIGHT;
  }



  void draw(boolean seVe) {
    ancho = PADDLE_WIDTH;
    alto = PADDLE_HEIGHT;
    if (seVe) {
      alpha = (alpha<255) ? alpha+=amount : 255;
    } else {
      alpha = (alpha>0) ? alpha-=amount : 0;
    }
    if (!escucharPaleta2) {
      update();
    } else {
      updateBolaMedieval();
    }
    offscreen.pushStyle();
    offscreen.noFill();
    offscreen.stroke(255, alpha);
    offscreen.strokeWeight(20);
    //offscreen.rect (x-PADDLE_WIDTH/2, y-alto/2, ancho, alto, 978879879);
    offscreen.strokeWeight(1);
    //offscreen.rect (x-PADDLE_WIDTH/2, y-PADDLE_HEIGHT/2, PADDLE_WIDTH, PADDLE_HEIGHT);
    skate.setFill(color(255, alpha));
    offscreen.shapeMode(CENTER);
    offscreen.shape(skate, x, y-PADDLE_HEIGHT*1.0/92*20, PADDLE_WIDTH, PADDLE_HEIGHT);
    offscreen.popStyle();
  }

  void reset() {
    escucharPaleta2 = false; 
    paleta = new FBox(PADDLE_WIDTH, PADDLE_HEIGHT);
    paleta.setName("paleta");
    paleta.setStatic(true);
    paleta.setGrabbable(false);
    world.add(paleta);

    paleta2 = new FBox(PADDLE_WIDTH, PADDLE_HEIGHT);
    paleta2.setName("paleta");
    paleta2.setStatic(true);
    paleta2.setGrabbable(false);
    worldBola.add(paleta2);
  }

  void matarPorBola() {
    println("entra al matar x bola");
    escucharPaleta2=true;
    worldBola.remove(paleta2);
    paleta2 = new FBox(PADDLE_WIDTH, PADDLE_HEIGHT);
    paleta2.setName("paleta");
    paleta2.setPosition(x, y);
    paleta2.setGrabbable(false);
    worldBola.add(paleta2);
  }
}