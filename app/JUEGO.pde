int TIEMPO_COUNTDOWN;
int TIEMPO_JUEGO;
int TIEMPO_GAME_OVER = 500;
int TIEMPO_ANIMACION = 500;
int TIEMPO_GANAR = 500;
int TIEMPO_APARICION_ELEMENTOS=3000;

float FPS = 24;

int X_RELOJ;
int Y_RELOJ;
int TAM_RELOJ;

int PUNTAJE_JUEGO;
int PUNTOS_LADRILLO;

boolean useKinect; 

class Juego {
  String state;
  Paleta paleta;
  Pelota pelota;
  LadrillosGrilla ladrillosGrilla;
  LadrillosArcos ladrillosArcos;
  LadrillosVentana ladrillosVentana;
  Ventanas ventanas;
  Countdown countdown;
  Temporizador temporizadorJuego;
  Temporizador temporizadorAnimacion;
  Temporizador temporizadorGameOver;
  Temporizador temporizadorGanar;
  Temporizador temporizadorAparicionElementos;
  Agua [] agua = new Agua [2]; 
  Barrotes [] barrotes = new Barrotes [2];
  Interfaz interfaz; 

  Juego () {
    state = "animacion";
    paleta = new Paleta();
    pelota = new Pelota();
    ladrillosGrilla = new LadrillosGrilla();
    ladrillosArcos = new LadrillosArcos();
    ladrillosVentana = new LadrillosVentana();
    ventanas = new Ventanas();
    countdown = new Countdown();
    temporizadorJuego = new Temporizador(TIEMPO_JUEGO);
    temporizadorGameOver = new Temporizador(TIEMPO_GAME_OVER);
    temporizadorAnimacion = new Temporizador(TIEMPO_ANIMACION);
    temporizadorGanar = new Temporizador(TIEMPO_GANAR);
    temporizadorAparicionElementos = new Temporizador(TIEMPO_APARICION_ELEMENTOS);
    for (int i=0; i<windows.length; i++) {
      agua[i] = new Agua(i);
      barrotes[i] = new Barrotes (i, 3);
    }
    interfaz = new Interfaz();
  }

  void draw() {
    offscreen.fill(0, 255);
    offscreen.rect(0, 0, width, height);
    if (state=="animacion") {
      offscreen.pushStyle();
      offscreen.fill(255);
      offscreen.textAlign(CENTER, CENTER);
      offscreen.text("Animacion", width/2, height/2);
      if (temporizadorAnimacion.isOver()) {
        temporizadorAparicionElementos.reset();
        state="aparicionElementos";
        for (int i=0; i<windows.length; i++) {
          barrotes[i].reset();
        }
      }
      offscreen.popStyle();
    } else if (state=="aparicionElementos") {
      float n = temporizadorAparicionElementos.normalized();

      for (int i=0; i<(ladrillosVentana.bricks.size()-1)*n; i++) {
        Brick b = ladrillosVentana.bricks.get(i);
        b.animate();
      }
      for (int i=0; i<(ladrillosGrilla.bricks.size()-1)*n; i++) {
        Brick b = ladrillosGrilla.bricks.get(i);
        b.animate();
      }

      if (temporizadorAparicionElementos.isOver()) {
        countdown.reset();
        state="countDown";
      }
      drawCelda(false);
      drawElementos(false);
      
    } else if (state=="countDown") {
      drawCelda(false);
      countdown.draw();
      if (countdown.temporizador.isOver()) {
        state="juego";
        temporizadorJuego.reset();
      }
      pelota.rest(paleta);
      println(pelota.y);
      paleta.jugar();
      drawElementos(true);
    } else if (state == "juego") {
      drawCelda(true);
      paleta.jugar();
      pelota.jugar();
      drawElementos(true);
      if (temporizadorJuego.isOver() || pelota.y>height) {
        state="gameOver";
        temporizadorGameOver.reset();
      }
      interfaz.draw();
    } else if (state == "gameOver") {
      offscreen.pushStyle();
      offscreen.fill(255);
      offscreen.textAlign(CENTER, CENTER);

      offscreen.text("GAME OVER", width/2, height/2);
      if (temporizadorGameOver.isOver()) {
        resetAll();
      }
      offscreen.popStyle();
    }
  }

  void drawElementos(boolean jugador) {
    ventanas.drawBehind();
    if (jugador) {
      paleta.draw();
      pelota.draw();
    }
    ladrillosGrilla.draw();
    ladrillosVentana.draw();
    ventanas.draw();
    ladrillosArcos.draw();
  }

  void drawCelda(boolean agua) {
    for (int i=0; i<windows.length; i++) {
      if (agua) this.agua[i].draw(temporizadorJuego.normalized());
      barrotes[i].draw();
    }
  }

  void reset() {
    pelota.reset();
    paleta.reset();
    ladrillosGrilla.reset();
    ladrillosArcos.reset();
    ladrillosVentana.reset();
    ventanas.reset();
    state = "animacion";
    temporizadorAnimacion.reset();
    PUNTAJE_JUEGO=0;
  }
}
//------------------------------------------------

class Countdown {
  PImage reloj;
  PImage entradaReloj [];
  PImage salidaReloj [];
  Temporizador temporizador;

  int fotogramasEntrada = 40;
  int fotogramasSalida = 12;
  int tiempoEntrada;
  int tiempoSalida;

  Countdown() {

    tiempoEntrada=int(1000/FPS*fotogramasEntrada);
    tiempoSalida=int(1000/FPS*fotogramasEntrada);

    entradaReloj = new PImage [fotogramasEntrada];
    for (int i=0; i<fotogramasEntrada; i++) {
      entradaReloj[i]=loadImage("img/entrada_reloj/entrada_reloj_"+nf(i, 5)+".png");
    }
    salidaReloj = new PImage [fotogramasSalida];
    for (int i=0; i<fotogramasSalida; i++) {
      salidaReloj[i]=loadImage("img/salida_reloj/salida_reloj_"+nf(242+i, 5)+".png");
    }
    reloj = loadImage("img/reloj.png");
    temporizador = new Temporizador(TIEMPO_COUNTDOWN+tiempoSalida+tiempoEntrada);
    reset();
  }

  void reset() {
    temporizador.reset();
  }

  void draw() {
    offscreen.pushStyle();
    offscreen.imageMode(CENTER);
    offscreen.fill(255, 100);
    //
    if (temporizador.progress()<tiempoEntrada) {
      offscreen.image(entradaReloj[constrain(temporizador.progress()/24, 0, fotogramasEntrada-1)], X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);
    } else if (temporizador.progress()<tiempoEntrada+TIEMPO_COUNTDOWN) {
      offscreen.arc(X_RELOJ, Y_RELOJ, TAM_RELOJ*.55, TAM_RELOJ*.55, -HALF_PI, map(temporizador.progress(), tiempoEntrada, tiempoEntrada+TIEMPO_COUNTDOWN, -HALF_PI, 3*HALF_PI));
      offscreen.image(entradaReloj[39], X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);
    } else {
      int f = constrain((temporizador.progress()-tiempoEntrada-TIEMPO_COUNTDOWN)/24, 0, fotogramasSalida-1);
      offscreen.image(salidaReloj[f], X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);
    }
    offscreen.popStyle();
  }
}

class Temporizador {
  int duration, lastReset;

  Temporizador(int duration) {
    this.duration = duration;
  }

  void reset() {
    lastReset = millis();
  }

  float normalized() {
    return constrain((map(millis()-lastReset, 0, duration, 0, 1)), 0, 1.01);
  }

  int progress() {
    return millis()-lastReset;
  }

  boolean isOver() {
    return normalized() > 1;
  }
}