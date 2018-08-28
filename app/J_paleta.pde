//------------------------------------------------
class Paleta {
  int x, y, ancho, alto;
  FBox paleta;
  Paleta () {
    reset();
    update();
  }

  void jugar() {
    paleta.setPosition(mouseX, height-100);
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