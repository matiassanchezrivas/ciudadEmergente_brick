int tiempoCountdown;
int tiempoJuego;
int tiempoGameOver = 500;
int tiempoAnimacion = 500;
int tiempoGanar = 500;
int tiempoAparicionElementos=3000;

int xReloj;
int yReloj;
int tamReloj;

int puntajeJuego;
int puntosLadrillo;

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
    temporizadorJuego = new Temporizador(tiempoJuego);
    temporizadorGameOver = new Temporizador(tiempoGameOver);
    temporizadorAnimacion = new Temporizador(tiempoAnimacion);
    temporizadorGanar = new Temporizador(tiempoGanar);
    temporizadorAparicionElementos = new Temporizador(tiempoAparicionElementos);
    for (int i=0; i<windows.length; i++) {
      agua[i] = new Agua(i);
      barrotes[i] = new Barrotes (i, 3);
    }
    interfaz = new Interfaz();
  }

  void draw() {
    fill(0, 100);
    rect(0, 0, width, height);
    if (state=="animacion") {
      pushStyle();
      fill(255);
      textAlign(CENTER, CENTER);
      text("Animacion", width/2, height/2);
      if (temporizadorAnimacion.isOver()) {
        temporizadorAparicionElementos.reset();
        state="aparicionElementos";
        for (int i=0; i<windows.length; i++) {
          barrotes[i].reset();
        }
      }
      popStyle();
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
      drawElementos(false);
      drawCelda(false);
    } else if (state=="countDown") {
      drawCelda(false);
      countdown.draw();
      if (countdown.temporizador.isOver()) {
        state="juego";
        temporizadorJuego.reset();
      }
      pelota.rest(paleta);
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
      pushStyle();
      fill(255);
      textAlign(CENTER, CENTER);

      text("GAME OVER", width/2, height/2);
      if (temporizadorGameOver.isOver()) {
        resetAll();
      }
      popStyle();
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
    puntajeJuego=0;
  }
}
//------------------------------------------------

class Countdown {
  PShape reloj;
  Temporizador temporizador;

  Countdown() {
    reloj = loadShape("reloj.svg");
    temporizador = new Temporizador(tiempoCountdown);
    reset();
  }

  void reset() {
    temporizador.reset();
  }

  void draw() {
    pushStyle();
    shapeMode(CENTER);
    fill(255, 100);
    arc(xReloj, yReloj, tamReloj*.55, tamReloj*.55, -HALF_PI, map(temporizador.normalized(), 0, 1, -HALF_PI, 3*HALF_PI));
    shape(reloj, xReloj, yReloj, tamReloj, tamReloj);
    popStyle();
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

  boolean isOver() {
    return normalized() > 1;
  }
}