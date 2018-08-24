import fisica.*;

Ventana v;
boolean calibrador;
String modo;

void setup() {
  size( 1200, 900 );

  loadElements();
  setupFisica();
  initStateHandlers();
  calibrador = true; 
  modo = "elementos";
  smooth();
  loadConfig();
}

void draw() {
  background(50);
  if (calibrador) {
    drawElements();
  } else {
    drawFisica();
  }
}

void keyPressed() {
  if (key == 'c'|| key == 'C' ) {
    calibrador =!calibrador;
    resetAll();
  }
  if (key == 'r'|| key == 'R' ) resetAll();
  if (calibrador) calKeys();
}