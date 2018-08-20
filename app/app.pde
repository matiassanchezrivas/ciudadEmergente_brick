import fisica.*;

Ventana v;

void setup() {
  size( 1200, 900 );
  setupFisica();
  setupElementos();
  smooth();
  
  
}

void draw() {
  background(50);
  drawFisica();
  drawElementos();

}