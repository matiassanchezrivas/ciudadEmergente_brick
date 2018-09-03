PFont fuente;

int contCartel;
boolean primerFotogramaEnEsteModo = true;

String nombreFuenteBitacora = "Roboto-Light-30.vlw";

int xCartelPrimario = 50;
int yCartelPrimario = 80;
int xCartelSecundario = 50;
int yCartelSecundario = 110;

//--------------------------------------------

void reiniciarCartel() {
  contCartel = 60;
}
//--------------------------------------------

void iniciarCartel() {
  contCartel = 60;
  fuente = loadFont( nombreFuenteBitacora );
}
//---------------------------------------------------

void ejecutarTeclaCambioMenu() {
  if ( keyCode == CONTROL ) {
    primerFotogramaEnEsteModo = true;
    iniciarCartel();
  }
}
//---------------------------------------------------

void mostrarCartel() {
  if ( contCartel > 0 ) {
    offscreen.pushStyle();
    offscreen.textFont( fuente, 30 );
    contCartel--;
    offscreen.fill( colorCalibracionAcento.elColor );
    offscreen.text( br.get(), xCartelPrimario, yCartelPrimario );
    offscreen.popStyle();
  }
}
//--------------------------------------------