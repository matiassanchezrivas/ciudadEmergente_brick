int TIEMPO_COUNTDOWN;
int TIEMPO_COUNTDOWN_INTRAVIDA;
int TIEMPO_JUEGO;
int TIEMPO_GAME_OVER = 500;
int TIEMPO_ANIMACION = 500;
int TIEMPO_GANAR = 500;
int TIEMPO_APARICION_ELEMENTOS=4000;
int CANTIDAD_VIDAS=2;
int TIEMPO_TRANSICION = 500;
float PORCENTAJE_DESTRUCCION_ARCOS=.7;

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
  LadrillosArcos [] ladrillosArcos;
  //LadrillosVentana ladrillosVentana;
  Ventanas ventanas;
  Countdown countdown;
  Temporizador temporizadorJuego;
  Temporizador temporizadorGameOver;
  Temporizador temporizadorGanar;
  Temporizador temporizadorAparicionElementos;
  Temporizador temporizadorTransicion;
  Agua [] agua = new Agua [2]; 
  Barrotes [] barrotes = new Barrotes [2];
  Interfaz interfaz; 
  MotionLive motionIntro;
  MotionLive motionPerdiste;
  MotionLive motionVictoria;
  MotionLive motionGanaPerro;
  MotionLive motionGanaAstronauta;
  int nivel;

  Juego () {
    state = "animacion";
    paleta = new Paleta();
    pelota = new Pelota();
    ladrillosGrilla = new LadrillosGrilla();
    ladrillosArcos = new LadrillosArcos [2];
    //ladrillosVentana = new LadrillosVentana();
    ventanas = new Ventanas();
    countdown = new Countdown();
    temporizadorJuego = new Temporizador(TIEMPO_JUEGO);
    temporizadorGameOver = new Temporizador(TIEMPO_GAME_OVER);
    temporizadorGanar = new Temporizador(TIEMPO_GANAR);
    temporizadorAparicionElementos = new Temporizador(TIEMPO_APARICION_ELEMENTOS);
    temporizadorTransicion = new Temporizador (TIEMPO_TRANSICION);
    for (int i=0; i<windows.length; i++) {
      agua[i] = new Agua(i);
      barrotes[i] = new Barrotes (i);
      ladrillosArcos [i] = new LadrillosArcos(i);
    }
    interfaz = new Interfaz();
    motionIntro= new MotionLive(FOTOGRAMAS_INTRO, FPS, "img/"+"intro_1024/"+"Intro_1024_");
    motionPerdiste= new MotionLive(FOTOGRAMAS_PERDISTE, FPS, "img/perdiste/perdiste_");
    motionVictoria= new MotionLive(FOTOGRAMAS_VICTORIA, FPS, "img/ganaste/ganaste_");
    motionGanaPerro= new MotionLive(FOTOGRAMAS_LIBERA_PERRO, FPS, "img/libera_perro/bien-hecho-perro_");
    motionGanaAstronauta= new MotionLive(FOTOGRAMAS_LIBERA_ASTRONAUTA, FPS, "img/libera_astronauta/bien-hecho-astronauta_");
  }

  void draw() {
    offscreen.fill(0, 255);
    offscreen.rect(0, 0, width, height);
    if (state=="animacion") {
      motionIntro.draw(width/2, height/2, width, height);     
      ventanas.drawBlack();
      ventanas.draw();
      if (motionIntro.temporizador.normalized()<.75) {
        barrotes[0].reset();
      } else {
        drawCeldaIntro(0);
      }
      if (motionIntro.temporizador.normalized()<.9) {
        barrotes[1].reset();
      } else {
        drawCeldaIntro(1);
      }
      
      
      if (motionIntro.isOver()) {
        detenerSonidoIntro();
        if (temporizadorTransicion.isOver()) {
          println("over");
          temporizadorAparicionElementos.reset();
          dispararSonidoLadrillos();
          state="aparicionElementos";
        }
      } else {
        temporizadorTransicion.reset();
      }
    } else if (state=="aparicionElementos") {
      float n = temporizadorAparicionElementos.normalized();

      for (int l=0; l<windows.length; l++) {
        for (int i=0; i<(ladrillosArcos[l].bricks.size()-1)*n; i++) {
          Brick b = ladrillosArcos[l].bricks.get(i);
          b.animate();
        }
      }
      for (int i=0; i<(ladrillosGrilla.bricks.size()-1)*n; i++) {
        Brick b = ladrillosGrilla.bricks.get(i);
        b.animate();
      }

      if (temporizadorAparicionElementos.isOver()) {
        iniciarSonidoJuego();
        countdown.reset(TIEMPO_COUNTDOWN);
        state="countDown";
        dispararSonidoReloj();
      }
      drawCelda(false);
      drawElementos(false);
    } else if (state=="countDown") {
      drawCelda(!(vidasLeft==CANTIDAD_VIDAS));
      countdown.draw((vidasLeft==CANTIDAD_VIDAS) ? TIEMPO_COUNTDOWN : TIEMPO_COUNTDOWN_INTRAVIDA);
      if (countdown.temporizador.isOver()) {
        state="juego";
        sonidista.ejecutarSonido(1); //DISPARAR PELOTA
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
      pelota.jugar(nivel);
      pelota.draw(true);

      drawElementos(true);

      if (pelota.y>width) {
        if (vidasLeft>0) {
          vidasLeft--;
          countdown.reset(TIEMPO_COUNTDOWN_INTRAVIDA);
          state="countDown";
          dispararSonidoReloj();
        } else {
          motionPerdiste.reset();
          iniciarSonidoGameOver();
          state="gameOver";
        }
      }
      sonarAgua(temporizadorJuego.normalized());
      if (temporizadorJuego.isOver()) {
        state="gameOver";
        motionPerdiste.reset();
        iniciarSonidoGameOver();
      }
      interfaz.draw();

      //GANAR
      if (nivel==0) {
        if (ladrillosArcos[1].porcentajeMuertos() >= PORCENTAJE_DESTRUCCION_ARCOS) {
          state = "liberaPerro";
          motionGanaPerro.reset();
          nivel=1;
        } else if (ladrillosArcos[0].porcentajeMuertos() >= PORCENTAJE_DESTRUCCION_ARCOS) {
          state = "liberaAstronauta";
          motionGanaAstronauta.reset();
          nivel=1;
        }
      } else if (nivel==1 && ladrillosArcos[0].porcentajeMuertos() >= PORCENTAJE_DESTRUCCION_ARCOS && ladrillosArcos[1].porcentajeMuertos() >= PORCENTAJE_DESTRUCCION_ARCOS) {
        state = "victoria";
        motionVictoria.reset();
        iniciarSonidoVictoria();
      }
    } else if (state == "gameOver") {
      pelota.draw(false);
      paleta.jugar();
      drawCelda(true);
      drawElementos(false);
      detenerSonidoJuego();
      detenerSonidoAgua();

      motionPerdiste.draw(X_RELOJ, Y_RELOJ, 0, 0);
      if (motionPerdiste.isOver()) {
        detenerSonidoGameOver();
        resetAll(true);
      }
    } else if (state == "liberaPerro") {
      pelota.draw(false);
      paleta.jugar();
      drawCelda(true);
      drawElementos(false);
      pelota.rest();
      motionGanaPerro.draw(X_RELOJ, Y_RELOJ, 0, 0);
      if (motionGanaPerro.isOver()) {
        countdown.reset(TIEMPO_COUNTDOWN_INTRAVIDA);
        state="countDown";
        dispararSonidoReloj();
      }
    } else if (state == "liberaAstronauta") {
      pelota.draw(false);
      paleta.jugar();
      pelota.rest();
      drawCelda(true);
      drawElementos(false);
      motionGanaAstronauta.draw(X_RELOJ, Y_RELOJ, 0, 0);
      if (motionGanaAstronauta.isOver()) {
        countdown.reset(TIEMPO_COUNTDOWN_INTRAVIDA);
        state="countDown";
        dispararSonidoReloj();
      }
    } else if (state == "victoria") {
      pelota.draw(false);
      paleta.jugar();
      detenerSonidoJuego();
      detenerSonidoAgua();
      drawCelda(true);
      drawElementos(false);
      motionVictoria.draw(X_RELOJ, Y_RELOJ, 0, 0);
      if (motionVictoria.isOver()) {
        detenerSonidoVictoria();
        resetAll(true);
      }
    }
  }

  void drawElementos(boolean dibujar) {
    ventanas.drawBehind();
    pelota.draw(dibujar);
    paleta.draw(dibujar);
    ladrillosGrilla.draw();
    //ladrillosVentana.draw();
    ventanas.draw();
    for (int i=0; i<windows.length; i++) {
      ladrillosArcos[i].draw();
    }
  }

  void drawCelda(boolean agua) {
    for (int i=0; i<windows.length; i++) {
      if (agua) this.agua[i].draw(temporizadorJuego.normalized());
      barrotes[i].draw();
    }
  }
  
  void drawCeldaIntro(int i) {
   
      barrotes[i].draw();
    
  }

  void reset() {
    pelota.reset();
    paleta.reset();
    ladrillosGrilla.reset();
    for (int i=0; i<windows.length; i++) {
      ladrillosArcos[i].reset();
    }
    //ladrillosVentana.reset();
    ventanas.reset();
    state = "animacion";
    iniciarSonidoIntro();
    PUNTAJE_JUEGO=0;
    vidasLeft=CANTIDAD_VIDAS;
    motionIntro.reset();
    nivel=0;
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
      iniciarLoopReloj();
      offscreen.arc(X_RELOJ-TAM_RELOJ/2+TAM_RELOJ*.516, Y_RELOJ-TAM_RELOJ/2+TAM_RELOJ*.577, TAM_RELOJ*.50, TAM_RELOJ*.50, -HALF_PI, map(temporizador.progress(), tiempoEntrada, tiempoEntrada+time, -HALF_PI, 3*HALF_PI));
      offscreen.image(reloj, X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);
    } else {
      detenerLoopReloj();
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
  for (int i=0; i<windows.length; i++) {
    juego.ladrillosArcos[i].explosion(x, y);
  }
}

void saltar() {
  juego.ladrillosGrilla.saltar();
  for (int i=0; i<windows.length; i++) {
    juego.ladrillosArcos[i].saltar();
  } 
  //juego.ladrillosVentana.saltar();
}