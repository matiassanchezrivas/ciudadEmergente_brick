int tiempoCountdown;
int tiempoJuego;
int tiempoGameOver = 500;
int tiempoAnimacion = 500;
int tiempoGanar = 500;

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
  Temporizador temporizadorJuego;
  Temporizador temporizadorAnimacion;
  Temporizador temporizadorGameOver;
  Temporizador temporizadorGanar;
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
    for (int i=0; i<windows.length; i++) {
      agua[i] = new Agua(i);
      barrotes[i] = new Barrotes (i, 3);
    }
    interfaz = new Interfaz();
  }

  void draw() {
    fill(0, 255);
    rect(0, 0, width, height);
    
    if (state=="animacion") {
      pushStyle();
      fill(255);
      textAlign(CENTER, CENTER);
      text("Animacion", width/2, height/2);
      if (temporizadorAnimacion.isOver()) {
        countdown.reset();

        state="countDown";
      }
      popStyle();
    } else if (state=="countDown") {
      countdown.draw();
      if (countdown.temporizador.isOver()) {
        state="juego";
        temporizadorJuego.reset();
        for (int i=0; i<windows.length; i++) {
          barrotes[i].reset();
        }
      }
      pelota.rest(paleta);
      paleta.jugar();
      paleta.draw();
      pelota.draw();
    } else if (state == "juego") {
      
      for (int i=0; i<windows.length; i++) {
        agua[i].draw(temporizadorJuego.normalized());
        barrotes[i].draw();
      }
      ventanas.drawBehind();
      paleta.jugar();
      pelota.jugar();
      paleta.draw();
      pelota.draw();
      ladrillosGrilla.draw();
      ladrillosVentana.draw();
      ventanas.draw();
      ladrillosArcos.draw();
      if (temporizadorJuego.isOver()) {
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

  void reset() {
    pelota.reset();
    paleta.reset();
    ladrillosGrilla.reset();
    ladrillosArcos.reset();
    ladrillosVentana.reset();
    ventanas.reset();
    state = "animacion";
    temporizadorAnimacion.reset();
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