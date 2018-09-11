int TIEMPO_COUNTDOWN;
int TIEMPO_COUNTDOWN_INTRAVIDA;
int TIEMPO_JUEGO_NIVEL1;
int TIEMPO_JUEGO_NIVEL2;
int TIEMPO_APARICION_ELEMENTOS=4000;
int CANTIDAD_VIDAS;
int TIEMPO_TRANSICION;
float PORCENTAJE_DESTRUCCION_ARCOS;
int TIEMPO_BOLA_MEDIEVAL = 5000;

int FPS = 24;

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
  Temporizador temporizadorJuego1;
  Temporizador temporizadorJuego2;
  Temporizador temporizadorAparicionElementos;
  Temporizador temporizadorTransicion;
  Temporizador temporizadorBola;
  Agua [] agua = new Agua [2]; 
  Barrotes [] barrotes = new Barrotes [2];
  Interfaz interfaz; 
  MotionLive motionInicioLoop;
  MotionLive motionIntro;
  MotionLive motionPerdiste;
  MotionLive motionVictoria;
  MotionLive motionGanaPerro;
  MotionLive motionGanaAstronauta;
  int nivel;
  BolaMedieval bolaMedieval; 
  boolean reinicioNivel = false;
  boolean [] salvado = new boolean [2];
  FBox topEdge;
  FBox bottomEdge;
  Transicion transicion;
  boolean skipAnimation;

  Juego () {
    state = "reinicio";
    paleta = new Paleta();
    pelota = new Pelota();
    ladrillosGrilla = new LadrillosGrilla();
    ladrillosArcos = new LadrillosArcos [2];
    //ladrillosVentana = new LadrillosVentana();
    ventanas = new Ventanas();
    countdown = new Countdown();
    temporizadorAparicionElementos = new Temporizador(TIEMPO_APARICION_ELEMENTOS);
    temporizadorTransicion = new Temporizador (TIEMPO_TRANSICION);
    temporizadorJuego1 = new Temporizador (TIEMPO_JUEGO_NIVEL1);
    temporizadorJuego2 = new Temporizador (TIEMPO_JUEGO_NIVEL2);
    temporizadorBola = new Temporizador (TIEMPO_BOLA_MEDIEVAL+int(random(500)));

    for (int i=0; i<windows.length; i++) {
      agua[i] = new Agua(i);
      barrotes[i] = new Barrotes (i);
      ladrillosArcos [i] = new LadrillosArcos(i);
    }
    interfaz = new Interfaz();
    motionInicioLoop= new MotionLive(FOTOGRAMAS_STANDBY, FPS, "img/"+"personajes_paseando"+"/personajes_paseando_");
    motionIntro= new MotionLive(FOTOGRAMAS_INTRO, FPS, "img/"+"intro_1024/"+"Intro_1024_nueva_");
    motionPerdiste= new MotionLive(FOTOGRAMAS_PERDISTE, FPS, "img/perdiste/perdiste_");
    motionVictoria= new MotionLive(FOTOGRAMAS_VICTORIA, FPS, "img/ganaste/ganaste_");
    motionGanaPerro= new MotionLive(FOTOGRAMAS_LIBERA_PERRO, FPS, "img/libera_perro/bien-hecho-perro_");
    motionGanaAstronauta= new MotionLive(FOTOGRAMAS_LIBERA_ASTRONAUTA, FPS, "img/libera_astronauta/bien-hecho-astronauta_");
    bolaMedieval = new BolaMedieval(new PVector(X_BOLA_MEDIEVAL, Y_BOLA_MEDIEVAL), 10, .1);

    for (int i=0; i<windows.length; i++) {
      salvado[i]=false;
    }

    topEdge = new FBox(width+100, 20);
    topEdge.setGrabbable(false);
    topEdge.setStatic(true);
    topEdge.setPosition(width/2, WORLD_TOP_Y);

    bottomEdge = new FBox(width+100, 10);
    bottomEdge.setGrabbable(false);
    bottomEdge.setStatic(true);
    bottomEdge.setPosition(width/2, WORLD_BOTTOM_Y);

    transicion= new Transicion();

    skipAnimation=false;
  }

  void triggerAparicion() {
    detenerSonidoIntro();
    temporizadorAparicionElementos.reset();
    dispararSonidoLadrillos();
    state="aparicionElementos";
  }

  void draw() {
    offscreen.fill(0, 255);
    offscreen.rect(0, 0, width, height);

    if (state=="inicio") {

      motionInicioLoop.loop();
      motionInicioLoop.draw(width/2, height/2, width, height);

      if (!skipAnimation) {
        temporizadorTransicion.reset();
      } else {
        transicion.update(temporizadorTransicion.normalized());
        transicion.draw();
        if (temporizadorTransicion.isOver()) {
          state="animacion";
          resetAll(true);
        }
      }
    } else if (state=="animacion") {
      motionIntro.draw(width/2, height/2, width, height);     
      //ventanas.drawBlack();
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
        skipAnimation=true;
      } 

      if (!skipAnimation) {
        temporizadorTransicion.reset();
      } else {
        if (!motionIntro.isOver()) {
          transicion.update(temporizadorTransicion.normalized());
          transicion.draw();
        }
        if (temporizadorTransicion.isOver()) {
          triggerAparicion();
          detenerSonidoIntro();
        }
      }
    } else if (state=="aparicionElementos") {
      interfaz.draw(true);
      float n = temporizadorAparicionElementos.normalized();

      for (int i=0; i<ladrillosArcos[0].bricks.size(); i++) {
        float s =map(n, 0, .5, 0, 1);

        if (i*1.0/ladrillosArcos[0].bricks.size() < s) {
          Brick b = ladrillosArcos[0].bricks.get(i);
          b.animate();
        }
      }

      for (int i=0; i<ladrillosArcos[1].bricks.size(); i++) {
        float s =map(n, .5, 1, 0, 1);

        if (i*1.0/ladrillosArcos[1].bricks.size() < s) {
          Brick b = ladrillosArcos[1].bricks.get(i);
          b.animate();
        }
      }

      for (int i=0; i<(ladrillosGrilla.bricks.size()-1)*n; i++) {
        Brick b = ladrillosGrilla.bricks.get(i);
        b.animate();
      }
      drawCelda(false);
      drawElementos(false);
      fijos.drawReboques();

      if (temporizadorAparicionElementos.isOver()) {
        iniciarSonidoJuego();
        countdown.reset(reinicioNivel ? TIEMPO_COUNTDOWN : TIEMPO_COUNTDOWN_INTRAVIDA);
        state="countDown";
        dispararSonidoReloj();
      }
      temporizadorJuego1.reset();
      temporizadorJuego2.reset();
    } else if (state=="countDown") {
      interfaz.draw(true);
      drawCelda(!(!reinicioNivel && nivel==0));


      pelota.rest(paleta);
      paleta.jugar();
      drawElementos(true);
      fijos.drawReboques();

      if (countdown.temporizador.isOver()) {
        state="juego";
        sonidista.ejecutarSonido(1); //DISPARAR PELOTA
        if (!reinicioNivel) {
          temporizadorJuego1.reset();
          reinicioNivel=true;
        }
      }
      if (nivel==1) bolaMedieval.draw();
      countdown.draw(reinicioNivel ? TIEMPO_COUNTDOWN : TIEMPO_COUNTDOWN_INTRAVIDA);
    } else if (state == "juego") {

      paleta.jugar();
      pelota.jugar(nivel);
      pelota.draw(true);

      drawElementos(true);
      drawCelda(true);
      if (nivel==1) bolaMedieval.draw();
      interfaz.draw(true);

      //CONDICIONES
      if (pelota.y>height) {
        if (vidasLeft>0) {
          vidasLeft--;
          countdown.reset(TIEMPO_COUNTDOWN_INTRAVIDA);
          state="countDown";
          dispararSonidoReloj();
        } else {
          motionPerdiste.reset();
          iniciarSonidoGameOver();
          state="gameOver";
          saltar();
          skipAnimation=false;
        }
      }
      sonarAgua(nivel==0 ? temporizadorJuego1.normalized() : temporizadorJuego2.normalized());
      if (nivel==0 ? temporizadorJuego1.isOver() : temporizadorJuego2.isOver()) {
        state="gameOver";
        motionPerdiste.reset();
        iniciarSonidoGameOver();
        saltar();
        skipAnimation=false;
      }
      if (nivel == 1 && temporizadorBola.isOver()) {
        bolaMedieval.soltar();
      }

      //GANAR
      if (nivel==0) {
        if (ladrillosArcos[0].porcentajeMuertos() >= PORCENTAJE_DESTRUCCION_ARCOS) {
          state = "liberaAstronauta";
          motionGanaAstronauta.reset();
          nivel=1;
          salvado[0]=true;
        } else if (ladrillosArcos[1].porcentajeMuertos() >= PORCENTAJE_DESTRUCCION_ARCOS) {
          state = "liberaPerro";
          motionGanaPerro.reset();
          nivel=1;
          salvado[1]=true;
        }
      } else if (nivel==1 && ladrillosArcos[0].porcentajeMuertos() >= PORCENTAJE_DESTRUCCION_ARCOS && ladrillosArcos[1].porcentajeMuertos() >= PORCENTAJE_DESTRUCCION_ARCOS) {
        state = "victoria";
        skipAnimation=false;
        motionVictoria.reset();
        iniciarSonidoVictoria();
      }
    } else if (state == "gameOver") {
      interfaz.draw(false);
      pelota.draw(false);
      paleta.jugar();
      drawCelda(true);
      drawElementos(false);
      detenerSonidoJuego();
      detenerSonidoAgua();

      motionPerdiste.draw(width/2, height/2, 0, 0);

      if (nivel==1)bolaMedieval.draw();

      if (motionPerdiste.isOver()) {  
        skipAnimation=true;
      } 

      if (!skipAnimation) {
        temporizadorTransicion.reset();
      } else {
        transicion.update(temporizadorTransicion.normalized());
        transicion.draw();
        if (temporizadorTransicion.isOver()) {
          detenerSonidoGameOver();
          resetInicio();
        }
      }
    } else if (state == "liberaPerro") {
      interfaz.draw(true);
      pelota.draw(false);
      paleta.jugar();
      drawCelda(true);
      drawElementos(false);
      motionGanaPerro.draw(width/2, height/2, 0, 0);
      if (motionGanaPerro.isOver()) {
        countdown.reset(TIEMPO_COUNTDOWN_INTRAVIDA);
        state="countDown";
        dispararSonidoReloj();
        reinicioNivel=false;
        temporizadorBola.reset();
      }

      temporizadorJuego1.reset();
      temporizadorJuego2.reset();
    } else if (state == "liberaAstronauta") {
      interfaz.draw(true);
      pelota.draw(false);
      paleta.jugar();
      drawCelda(true);
      drawElementos(false);
      motionGanaAstronauta.draw(width/2, height/2, 0, 0);
      if (motionGanaAstronauta.isOver()) {
        countdown.reset(TIEMPO_COUNTDOWN_INTRAVIDA);
        state="countDown";
        dispararSonidoReloj();
        reinicioNivel=false;
        temporizadorBola.reset();
      }
      temporizadorJuego1.reset();
      temporizadorJuego2.reset();
    } else if (state == "victoria") {
      interfaz.draw(false);
      pelota.draw(false);
      paleta.jugar();
      detenerSonidoJuego();
      detenerSonidoAgua();
      drawCelda(true);
      drawElementos(false);
      motionVictoria.draw(width/2, height/2, 0, 0);

      temporizadorJuego1.reset();
      temporizadorJuego2.reset();
      bolaMedieval.draw();
      for (int i=0; i<windows.length; i++) {
        salvado[i]=true;
      }

      if (motionVictoria.isOver()) {  
        skipAnimation=true;
      } 
      if (!skipAnimation) {
        temporizadorTransicion.reset();
      } else {
        
          transicion.update(temporizadorTransicion.normalized());
          transicion.draw();
        
        if (temporizadorTransicion.isOver()) {
          detenerSonidoVictoria();
          resetInicio();
        }
      }
    }
    fijos.drawReboques();
    ventanas.draw(salvado);
  }

  void drawElementos(boolean dibujar) {
    ventanas.drawBehind();
    pelota.draw(dibujar);
    paleta.draw(dibujar);
    ladrillosGrilla.draw();
    //ladrillosVentana.draw();
    ventanas.draw(salvado);
    for (int i=0; i<windows.length; i++) {
      ladrillosArcos[i].draw();
    }
  }

  void drawCelda(boolean agua) {
    for (int i=0; i<windows.length; i++) {
      if (agua) {
        this.agua[i].draw(nivel==0 ? temporizadorJuego1.normalized() : temporizadorJuego2.normalized());
      } else {
        this.agua[i].reset();
      }
      barrotes[i].draw();
    }
  }

  void drawCeldaIntro(int i) {
    barrotes[i].draw();
  }

  void resetInicio() {
    state = "inicio";
    for (int i=0; i<windows.length; i++) {
      salvado[i]=false;
    }
  }

  void reset() {
    resetWorld();
    pelota.reset();
    paleta.reset();
    ladrillosGrilla.reset();
    for (int i=0; i<windows.length; i++) {
      ladrillosArcos[i].reset();
    }
    //ladrillosVentana.reset();
    ventanas.reset();
    if (state != "reinicio") iniciarSonidoIntro();
    state = (state != "reinicio") ? "animacion" : "inicio";
    motionIntro.reset();
    PUNTAJE_JUEGO=0;
    vidasLeft=CANTIDAD_VIDAS;
    fijos.resetFisica();
    bolaMedieval.reset();
    nivel=0;
    reinicioNivel=false;
    temporizadorJuego1.reset();
    temporizadorJuego2.reset();
    temporizadorBola = new Temporizador (TIEMPO_BOLA_MEDIEVAL+int(random(500)));
    for (int i=0; i<windows.length; i++) {
      salvado[i]=false;
    }
    world.add(topEdge);
    skipAnimation=false;
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
  TextoInterfaz tnivel;

  Countdown() {
    tnivel = new TextoInterfaz();
    tiempoEntrada=int(1000/35*fotogramasEntrada);
    tiempoSalida=int(1000/35*fotogramasSalida);

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

      int f=constrain(temporizador.progress()*35/1000, 0, fotogramasEntrada-1);
      offscreen.image(entradaReloj[f], X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);
    } else if (temporizador.progress()<=tiempoEntrada+time) {
      iniciarLoopReloj();
      offscreen.arc(X_RELOJ-TAM_RELOJ/2+TAM_RELOJ*.516, Y_RELOJ-TAM_RELOJ/2+TAM_RELOJ*.577, TAM_RELOJ*.50, TAM_RELOJ*.50, -HALF_PI, map(temporizador.progress(), tiempoEntrada, tiempoEntrada+time, -HALF_PI, 3*HALF_PI));
      offscreen.image(reloj, X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);
    } else {
      detenerLoopReloj();
      int f = constrain(int((temporizador.progress()-time-tiempoEntrada)*35/1000), 0, fotogramasSalida-1);
      offscreen.image(salidaReloj[f], X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);
    }
    offscreen.popStyle();

    tnivel.drawAmount("NIVEL "+str(juego.nivel+1), X_RELOJ, Y_RELOJ-TAM_RELOJ/2, temporizador.normalized(), 28);
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

  void loop() {
    if (isOver()) {
      reset();
    }
  }
}

void explode(int x, int y) {
  juego.ladrillosGrilla.explosion(x, y);
  for (int i=0; i<windows.length; i++) {
    juego.ladrillosArcos[i].explosion(x, y);
  }
}

void saltar() {
  world.remove(juego.topEdge);
  world.add(juego.bottomEdge);
  juego.ladrillosGrilla.saltar();
  for (int i=0; i<windows.length; i++) {
    juego.ladrillosArcos[i].saltar();
  } 
  //juego.ladrillosVentana.saltar();
}