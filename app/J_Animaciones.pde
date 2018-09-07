int FOTOGRAMAS_LADRILLO_DESAPARECE = 12;
int FOTOGRAMAS_LADRILLO_ORO = 35;
int FOTOGRAMAS_LADRILLO_ORO_DESAPARECE = 46;
int FOTOGRAMAS_INTRO = 482;
int FOTOGRAMAS_LADRILLO_VENTANA_DESAPARECE = 17;


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
PImage [] IMG_ladrilloDesapareceOro = new PImage [FOTOGRAMAS_LADRILLO_ORO_DESAPARECE];


PImage [] IMG_ladrilloDesapareceVentana = new PImage [FOTOGRAMAS_LADRILLO_VENTANA_DESAPARECE];

PImage [] IMG_ladrillosConnie = new PImage [5];

PShape skate;


void loadImages() {
  skate=loadShape("img/skate.svg");
  for (int i=0; i<IMG_ladrilloDesaparece.length; i++) {
    IMG_ladrilloDesaparece[i]= loadImage("img/"+"ladrillo_desaparece"+"/ladrillo_desaparece_"+nf(i, 5)+".png");
  }
  for (int i=0; i<IMG_ladrilloOro.length; i++) {
    IMG_ladrilloOro[i]= loadImage("img/"+"ladrillo_oro"+"/ladrillo oro_"+nf(i, 5)+".png");
  }
  for (int i=0; i<IMG_ladrilloDesapareceOro.length; i++) {
    IMG_ladrilloDesapareceOro[i]= loadImage("img/"+"ladrillo_explota"+"/ladrillo_explota_"+nf(i, 5)+".png");
  }

  for (int i=0; i<IMG_ladrillosConnie.length; i++) {
    IMG_ladrillosConnie[i]= loadImage("img/"+"ladrillos"+"/ladrillo_"+nf(i, 2)+".png");
  }

  for (int i=0; i<IMG_ladrilloDesapareceVentana.length; i++) {
    IMG_ladrilloDesapareceVentana[i]= loadImage("img/"+"explosion_ventana"+"/explosion_ventana_"+nf(i, 5)+".png");
  }
}

class Motion {
  Temporizador temporizador;
  int FPS;
  float angle;
  float transy;

  Motion (PImage [] images, int FPS) {
    this.FPS=FPS;
    temporizador = new Temporizador(images.length*1000/FPS);
    angle=0;
    transy=0;
  }

  void rot(float angle) {
    this.angle = angle;
  }

  void trans(float y) {
    transy=y;
  }

  void draw(PImage [] images, float x, float y, int ancho, int alto, float scale) {  
    if (!temporizador.isOver()) {
      offscreen.pushStyle();
      offscreen.pushMatrix();
      offscreen.imageMode(CENTER);
      int number= int(temporizador.normalized()*(images.length-1));
      offscreen.translate(x, y);
      if (angle != 0) offscreen.rotate(angle);
      if (scale!=1) offscreen.scale(scale);
      if (transy!=0) offscreen.translate(0, transy);
      offscreen.image(images[number], 0, 0, ancho, alto);
      offscreen.popMatrix();
      offscreen.popStyle();
    }
  }


  void loop() {
    if (temporizador.isOver()) {
      temporizador.reset();
    }
  }

  void reset() {
    temporizador.reset();
  }
}

class MotionLive {
  Temporizador temporizador;
  int FPS;
  int cantFotogramas;
  String ruta;
  PImage i;
  int number=-1;

  MotionLive (int cantFotogramas, int FPS, String ruta) {
    this.ruta=ruta;
    this.FPS=FPS;
    this.cantFotogramas=cantFotogramas-1;
    temporizador = new Temporizador(cantFotogramas*1000/FPS);
  }

  void draw(float x, float y, int ancho, int alto) {  
    if (!temporizador.isOver()) {
      offscreen.pushStyle();

      offscreen.imageMode(CENTER);
      if (number!=int(temporizador.normalized()*(cantFotogramas))) {
        number=int(temporizador.normalized()*(cantFotogramas));
        i = loadImage(ruta+nf(number+1, 5)+".png");
      }

      offscreen.image(i, x, y);
      offscreen.popStyle();
    }
  }


  void loop() {
    if (temporizador.isOver()) {
      temporizador.reset();
    }
  }

  void reset() {
    temporizador.reset();
  }
}