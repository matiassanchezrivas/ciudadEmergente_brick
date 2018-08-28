import fisica.*;

Ventana v;
boolean calibrador;
String modo;
Juego juego;

void setup() {
  size( 1200, 900);
  initBreadcrumb();
  loadElements();
  setupFisica();
  initStateHandlers();
  calibrador = true; 
  modo = "elementos";
  smooth();
  loadConfig();
  iniciarCartel();
  iniciarColores();
  saveBricks();
  juego = new Juego();
  
}

void draw() {
  background(50);
  if (calibrador) {
    if(shCal.getState() == "color"){
      imprimirGestoresDeColores();
    } else {
    drawElements();
    }
    mostrarCartel();
  } else {
    drawFisica();
    juego.draw();
  }
     
}

void keyPressed() {
  //println("keycode", keyCode);
  if (key == 'c'|| key == 'C' ) {
    calibrador =!calibrador;
    resetAll();
  }
  if (key == 'r'|| key == 'R' ) resetAll();
  if (calibrador) {
    calKeys();
  };
  if (keyCode == 17) {
    reiniciarCartel();
  }
  if (key == 's') {
    saveElements();
    saveConfig();
  }
}

void mouseDragged() {
  if ( shCal.getState() == "color" ) {
    ejecutarClickEnColores();
  }
}

void mousePressed() {
  if ( shCal.getState() == "color" ) {
    ejecutarClickEnColores();
  }
}