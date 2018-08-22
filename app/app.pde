import fisica.*;

Ventana v;

void setup() {
  size( 1200, 900 );

  loadElements();
    setupFisica();
  smooth();
}

void draw() {
  background(50);
  drawFisica();
  drawElements();

}

void mousePressed() {

}