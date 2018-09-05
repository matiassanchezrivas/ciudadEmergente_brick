int TIEMPO_COUNTDOWN;
int TIEMPO_COUNTDOWN_INTRAVIDA;
int TIEMPO_JUEGO;
int TIEMPO_GAME_OVER = 500;
int TIEMPO_ANIMACION = 500;
int TIEMPO_GANAR = 500;
int TIEMPO_APARICION_ELEMENTOS=3000;
int CANTIDAD_VIDAS=2;

int FPS = 35;

int X_RELOJ;
int Y_RELOJ;
int TAM_RELOJ;

int PUNTAJE_JUEGO;
int PUNTOS_LADRILLO;

boolean useKinect; 
int vidasLeft;


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
        countdown.reset(TIEMPO_COUNTDOWN);
        state="countDown";
      }
      drawCelda(false);
      drawElementos(false);
    } else if (state=="countDown") {
      drawCelda(!(vidasLeft==CANTIDAD_VIDAS));
      countdown.draw((vidasLeft==CANTIDAD_VIDAS) ? TIEMPO_COUNTDOWN : TIEMPO_COUNTDOWN_INTRAVIDA);
      if (countdown.temporizador.isOver()) {
        state="juego";
        if (vidasLeft==CANTIDAD_VIDAS) {
          temporizadorJuego.reset();
        }
      }
      pelota.rest(paleta);
      paleta.jugar();
      drawElementos(true);
    } else if (state == "juego") {
      drawCelda(true);
      paleta.jugar();
      pelota.jugar();
      drawElementos(true);

      if (pelota.y>WORLD_BOTTOM_Y) {
        if (vidasLeft>0) {
          vidasLeft--;
          countdown.reset(TIEMPO_COUNTDOWN_INTRAVIDA);
          state="countDown";
        } else {
          temporizadorGameOver.reset();
          state="gameOver";
        }
      }

      if (temporizadorJuego.isOver()) {
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
    vidasLeft=CANTIDAD_VIDAS;
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
    tiempoSalida=int(1000/FPS*fotogramasSalida);

    entradaReloj = new PImage [fotogramasEntrada];
    for (int i=0; i<fotogramasEntrada; i++) {
      entradaReloj[i]=loadImage("img/entrada_reloj/entrada_reloj_"+nf(i, 5)+".png");
    }
    salidaReloj = new PImage [fotogramasSalida];
    for (int i=0; i<fotogramasSalida; i++) {
      salidaReloj[i]=loadImage("img/salida_reloj/salida_reloj_"+nf(242+i, 5)+".png");
    }
    reloj = loadImage("img/entrada_reloj/entrada_reloj_00040.png");
  }

  void reset(int tiempo) {
    temporizador = new Temporizador(tiempo+tiempoSalida+tiempoEntrada);
    temporizador.reset();
  }

  void draw(int time) {
    offscreen.pushStyle();
    offscreen.imageMode(CENTER);
    offscreen.fill(255);
    //
    if (temporizador.progress()<=tiempoEntrada) {

      int f=constrain(temporizador.progress()*FPS/1000, 0, fotogramasEntrada-1);
      offscreen.image(entradaReloj[f], X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);
    } else if (temporizador.progress()<=tiempoEntrada+time) {
      offscreen.arc(X_RELOJ-TAM_RELOJ/2+TAM_RELOJ*.516, Y_RELOJ-TAM_RELOJ/2+TAM_RELOJ*.577, TAM_RELOJ*.50, TAM_RELOJ*.50, -HALF_PI, map(temporizador.progress(), tiempoEntrada, tiempoEntrada+time, -HALF_PI, 3*HALF_PI));
      offscreen.image(reloj, X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);
    } else {
      int f = constrain(int((temporizador.progress()-time-tiempoEntrada)*FPS/1000), 0, fotogramasSalida-1);
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

void explode(int x, int y) {
  juego.ladrillosGrilla.explosion(x, y);
  juego.ladrillosArcos.explosion(x, y);
}

void saltar() {
  juego.ladrillosGrilla.saltar();
  juego.ladrillosArcos.saltar();
  juego.ladrillosVentana.saltar();
}