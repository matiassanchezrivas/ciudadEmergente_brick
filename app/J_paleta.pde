//------------------------------------------------
class Paleta {
  int x, y, ancho, alto;
  int xKinect;
  FBox paleta;
  Paleta () {
    reset();
    update();
    xKinect=width/2;
  }

  void jugar() {
    if (useKinect) {
      xKinect = (kinect.getPlayerPosition()!=null) ? xKinect = int(kinect.getPlayerPosition().x) : xKinect;
      paleta.setPosition(xKinect, height-100);
    } else {
      paleta.setPosition(mouseX, height-100);
    }
  }

  void update() {
    //PALETA
    this.x = int(paleta.getX()); 
    this.y = int(paleta.getY()); 
    this.ancho = int(paleta.getWidth());
    this.alto = int(paleta.getHeight());
  }

  void draw() {
    update();
    offscreen.pushStyle();
    offscreen.noFill();
    offscreen.stroke(255);
    offscreen.strokeWeight(20);
    offscreen.rect (x-ancho/2, y-alto/2, ancho, alto, 978879879);
    offscreen.popStyle();
  }

  void reset() {
    paleta = new FBox(PADDLE_WIDTH, PADDLE_HEIGHT);
    paleta.setName("paleta");
    paleta.setStatic(true);
    world.add(paleta);
  }
}