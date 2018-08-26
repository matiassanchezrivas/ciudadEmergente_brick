import fisica.*;

Ventana v;
boolean calibrador;
String modo;

void setup() {
  size( 1200, 900 );
  initBreadcrumb();
  loadElements();
  setupFisica();
  initStateHandlers();
  calibrador = true; 
  modo = "elementos";
  smooth();
  loadConfig();
  iniciarCartel();
}

void draw() {
  background(50);
  if (calibrador) {

    drawElements();
    mostrarCartel();
  } else {
    drawFisica();
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
  }
}