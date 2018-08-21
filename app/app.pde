import fisica.*;

Ventana v;

void setup() {
  size( 1200, 900 );
  setupFisica();
  loadElements();
  smooth();
}

void draw() {
  background(50);
  drawFisica();
  drawElements();

}