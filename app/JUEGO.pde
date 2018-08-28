int tiempoCountdown;
int tiempoJuego;

int xReloj;
int yReloj;
int tamReloj;

int puntajeJuego;
int puntosLadrillo;

class Juego {
  String state;
  Paleta paleta;
  Pelota pelota;
  LadrillosGrilla ladrillosGrilla;
  LadrillosArcos ladrillosArcos;
  LadrillosVentana ladrillosVentana;
  Ventanas ventanas;
  Countdown countdown;

  Juego () {
    state = "countDown";
    paleta = new Paleta();
    pelota = new Pelota();
    ladrillosGrilla = new LadrillosGrilla();
    ladrillosArcos = new LadrillosArcos();
    ladrillosVentana = new LadrillosVentana();
    ventanas = new Ventanas();
    countdown = new Countdown();
  }

  void draw() {
    fill(0, 255);
    rect(0, 0, width, height);
    if (state=="countDown") {
      countdown.draw();
      if(countdown.fulfilled){
      state="juego";
      }
      pelota.rest(paleta);
      paleta.jugar();
      paleta.draw();
      pelota.draw();
      
    } else if (state == "juego") {
      paleta.jugar();
      pelota.jugar();
      paleta.draw();
      pelota.draw();
      ladrillosGrilla.draw();
      ladrillosVentana.draw();
      ventanas.draw();
      ladrillosArcos.draw();
    }
  }

  void reset() {
    pelota.reset();
    paleta.reset();
    ladrillosGrilla.reset();
    ladrillosArcos.reset();
    ladrillosVentana.reset();
    ventanas.reset();
  }
}
//------------------------------------------------

class Countdown {
  PShape reloj;
  int ultimoComienzo;
  int tiempoTotal;
  float porcentaje;
  boolean fulfilled;

  Countdown() {
    reloj = loadShape("reloj.svg");
    reset();
    tiempoTotal = tiempoCountdown;
  }

  void reset() {
    ultimoComienzo = millis();
  }

  void draw() {
    pushStyle();
    shapeMode(CENTER);
    fill(255, 100);
    arc(xReloj, yReloj, tamReloj*.55, tamReloj*.55, -HALF_PI, map(porcentaje, 0, 1, -HALF_PI, 3*HALF_PI));
    shape(reloj, xReloj, yReloj, tamReloj, tamReloj);
    popStyle();
    update();
  }

  void update() {
    porcentaje = map(millis()-ultimoComienzo, 0, tiempoTotal, 0, 1);
    if (porcentaje>1) {
      fulfilled=true;
    } else {
      fulfilled=false;
    }
  }
}

class Temporizador{
  Temporizador(){
  }

}