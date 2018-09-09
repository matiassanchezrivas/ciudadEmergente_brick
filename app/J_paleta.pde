//------------------------------------------------
int Y_PALETA = 668;

class Paleta {
  int x, y, ancho, alto;
  int xKinect;
  int alpha=0;
  int amount=5;
  FBox paleta;
  Paleta () {
    reset();
    update();
    xKinect=width/2;
  }

  void jugar() {
    if (useKinect) {
      xKinect = (kinect.getPlayerPosition()!=null) ? xKinect = int(kinect.getPlayerPosition().x) : xKinect;
      paleta.setPosition(limitar(xKinect), Y_PALETA);
    } else {
      paleta.setPosition(limitar(mouseX), Y_PALETA);
      
    }
  }
  
  float limitar(float x){
  return constrain(x, windows[0].x+windows[0].ancho, windows[1].x);
    
  }

  void update() {
    //PALETA
    this.x = int(paleta.getX()); 
    this.y = int(paleta.getY()); 
    this.ancho = int(paleta.getWidth());
    this.alto = int(paleta.getHeight());
  }

  void draw(boolean seVe) {
    if (seVe) {
      alpha = (alpha<255) ? alpha+=amount : 255;
    } else {
      alpha = (alpha>0) ? alpha-=amount : 0;
    }
    update();
    offscreen.pushStyle();
    offscreen.noFill();
    offscreen.stroke(255, alpha);
    offscreen.strokeWeight(20);
    //offscreen.rect (x-ancho/2, y-alto/2, ancho, alto, 978879879);
    skate.setFill(color(255,alpha));
    offscreen.shape(skate, x-ancho/2, y-alto/2, ancho*1.5, ancho*skate.height/skate.width*1.5);
    offscreen.popStyle();
  }

  void reset() {
    paleta = new FBox(PADDLE_WIDTH, PADDLE_HEIGHT);
    paleta.setName("paleta");
    paleta.setStatic(true);
    world.add(paleta);
  }
}