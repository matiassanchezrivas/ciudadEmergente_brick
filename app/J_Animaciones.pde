int FOTOGRAMAS_LADRILLO_DESAPARECE = 12;
int FOTOGRAMAS_LADRILLO_ORO = 35;

void saveAnim() {
  JSONObject jsonConfig;
  jsonConfig = new JSONObject();
  JSONObject v;
  v= new JSONObject();
  v.setInt("FOTOGRAMAS_LADRILLO_DESAPARECE", FOTOGRAMAS_LADRILLO_DESAPARECE);
  jsonConfig.setJSONObject("fotogramas", v);
  saveJSONObject(jsonConfig, "data/fotogramas.json");
}
PImage [] IMG_ladrilloDesaparece = new PImage [FOTOGRAMAS_LADRILLO_DESAPARECE];
PImage [] IMG_ladrilloOro = new PImage [FOTOGRAMAS_LADRILLO_ORO];

void loadImages() {
  for (int i=0; i<IMG_ladrilloDesaparece.length; i++) {
    IMG_ladrilloDesaparece[i]= loadImage("img/"+"ladrillo_desaparece"+"/ladrillo_desaparece_"+nf(i, 5)+".png");
  }
  for (int i=0; i<IMG_ladrilloOro.length; i++) {
    IMG_ladrilloOro[i]= loadImage("img/"+"ladrillo_oro"+"/ladrillo_oro_"+nf(i, 5)+".png");
  }
}

class Motion {
  Temporizador temporizador;
  int FPS;

  Motion (PImage [] images, int FPS) {
    this.FPS=FPS;
    temporizador = new Temporizador(images.length*1000/FPS);
  }

  void draw(PImage [] images, int x, int y, int ancho, int alto) {  
    if (!temporizador.isOver()) {
      offscreen.pushStyle();
      offscreen.imageMode(CENTER);
      int number= int(temporizador.normalized()*(images.length-1));
      offscreen.image(images[number], x, y, ancho, alto);
      offscreen.popStyle();
    }
  }

  void reset() {
    temporizador.reset();
  }
}