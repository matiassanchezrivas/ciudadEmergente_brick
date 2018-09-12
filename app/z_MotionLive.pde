class MotionLive {
  Temporizador temporizador;
  int FPS;
  int cantFotogramas;
  String ruta;
  PImage i;
  int number=-1;

  MotionLive (int cantFotogramas, int FPS, String ruta, int sizeArraylist) {
    this.ruta=ruta;
    this.FPS=FPS;
    this.cantFotogramas=cantFotogramas-1;
    temporizador = new Temporizador(cantFotogramas*1000/FPS);
  }

  void draw(float x, float y, int ancho, int alto) {  
    if (!temporizador.isOver()) {
      if (number!=int(temporizador.normalized()*(cantFotogramas))) {
        number=int(temporizador.normalized()*(cantFotogramas));
        i = loadImage(ruta+nf(number, 5)+".png");
      }
      offscreen.pushStyle();
      offscreen.imageMode(CENTER);
      offscreen.image(i, x, y);
      offscreen.popStyle();
    }
  }


  void loop() {
    if (temporizador.isOver()) {
      temporizador.reset();
    }
  }

  boolean isOver() {
    return temporizador.isOver();
  }

  void reset() {
    temporizador.reset();
  }
}