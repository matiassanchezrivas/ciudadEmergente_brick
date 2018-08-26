PFont fuente;

int contCartel;
boolean primerFotogramaEnEsteModo = true;

String nombreFuenteBitacora = "Roboto-Light-20.vlw";

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
    pushStyle();
    textFont( fuente, 30 );
    contCartel--;
    fill( 255, 255, 0 );
    text( br.get(), xCartelPrimario, yCartelPrimario );
    popStyle();
  }
}
//--------------------------------------------