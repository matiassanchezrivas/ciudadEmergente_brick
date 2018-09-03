Kinect kinect;

float PASO_CHICO_CALIBRACION = 1;
float PASO_GRANDE_CALIBRACION = 5;
//=================================================================

void iniciarKinect() {
  kinect = new Kinect();
  kinect.levantarCalibracion();

  //iniciarOSCManos();
  iniciarOSCSilueta();
  iniciarOSCSalida();
}
//------------------------------------------------

void oscEvent(OscMessage theOscMessage) {
  kinect.recibirMensaje( theOscMessage );
}
//------------------------------------------------
//esta funcion hay que programarla en el cuerpo de la aplicación y comentar esta
/*
void ejecutarEnCadaMano( float x , float y , Blob blobMano ){
 }
 */
//=================================================================

class Kinect {

  float top, left, ancho, alto;
  float x, y;

  boolean modoEdicion = true;

  float paso = PASO_GRANDE_CALIBRACION;
  float aumento = 1.05;

  AdminMensajes adminSilueta;

  String archivo = "calibracionKinect.txt";

  //-------------------------------------------------

  Kinect() {
    resetCalibracion();
    //adminManos = new AdminMensajes("/BFollowKinect/Manos", false, false);
    adminSilueta = new AdminMensajes("/BFollowKinect/Silueta", false, false);
  }
  //-------------------------------------------------

  void actualizar() {

    //adminManos.actualizar();
    adminSilueta.actualizar();
  }
  //-------------------------------------------------

  void dibujar() {

    //adminManos.dibujarBlobs( left, top, ancho, alto);    
    adminSilueta.dibujarBlobs( left, top, ancho, alto);

    pushStyle();
    noFill();
    stroke( 255, 255, 0 );
    rect( left, top, ancho, alto);
    popStyle();
  }
  //-------------------------------------------------

  //void dibujarContornosManos() {

  //  if (adminManos.blobsNuevos != null) {
  //    for ( int i=0; i<adminManos.blobsNuevos.size (); i++) {
  //      Blob b = adminManos.blobsNuevos.get(i);
  //      b.dibujarContorno( left, top, ancho, alto  );
  //    }
  //  }
  //}
  //-------------------------------------------------

  void dibujarContornosSiluetas() {
    if (adminSilueta.blobsNuevos != null) {
      for ( int i=0; i<adminSilueta.blobsNuevos.size (); i++) {
        Blob b = adminSilueta.blobsNuevos.get(i);
        b.dibujarContorno( left, top, ancho, alto  );
      }
    }
  }
  //-------------------------------------------------
  void recibirMensaje(OscMessage theOscMessage) {

    //adminManos.recibeMensaje(theOscMessage);
    adminSilueta.recibeMensaje(theOscMessage);
  }
  //-------------------------------------------------

  void ejecutarTeclas() {
    if ( modoEdicion ) {
      if ( keyCode == RIGHT ) {
        x += paso;
      } else if ( keyCode == LEFT ) {
        x -= paso;
      } else if ( keyCode == UP ) {
        y -= paso;
      } else if ( keyCode == DOWN ) {
        y += paso;
      } else if ( key == 'p' ) {
        paso = ( paso == PASO_CHICO_CALIBRACION ? PASO_GRANDE_CALIBRACION :
          PASO_CHICO_CALIBRACION );
      } else if ( key == '+' ) {
        ancho *= aumento;
        alto *= aumento;
      } else if ( key == '-' ) {
        ancho /= aumento;
        alto /= aumento;
      } else if ( key == 'G' || key == 'g' ) {  
        guardarCalibracion();
      } else if ( key == 'R' || key == 'r' ) {  
        resetCalibracion();
      } else if ( key == 'L' || key == 'l' ) {
        levantarCalibracion();
      } else if ( key == TAB) {
        shKinect.change();
      }

      actualizarCoordenadas();
    }
  }
  //-------------------------------------------------

  void actualizarCoordenadas() {
    left = x-ancho/2;
    top = y-alto/2;
  }
  //-------------------------------------------------

  void guardarCalibracion() {

    PrintWriter output;
    output = createWriter("data/"+archivo); 

    output.println( x );
    output.println( y );
    output.println( ancho );
    output.println( alto );

    output.flush(); 
    output.close();
  }
  //-------------------------------------------------

  void resetCalibracion() {
    top = 0;
    left = 0;
    ancho = width;
    alto = height;
    x = width/2;
    y = height/2;
  }  
  //-------------------------------------------------

  void levantarCalibracion() {
    String lines[] = loadStrings(archivo);

    if ( lines.length >= 4 ) {
      x = float( lines[0] );
      y = float( lines[1] );
      ancho = float( lines[2] );
      alto = float( lines[3] );
    }
    actualizarCoordenadas();
  }
  //-------------------------------------------------

  ArrayList <Blob> entregarSilueta() {
    return adminSilueta.entregarListaBlobs();
  }
  //-------------------------------------------------

  PVector traducirCoordenadas( Blob este ) {

    PVector nuevasCoordenadas = new PVector(
      este.centroidX * ancho + left, 
      este.centroidY * alto + top );

    return nuevasCoordenadas;
  }
  //-------------------------------------------------

  PVector getPlayerPosition() {

    ArrayList <Blob> punteros = entregarSilueta();
    if ( punteros != null && punteros.size()>0) {
      println("ENTRA");
      Blob silueta = punteros.get(0);
      PVector coordenadas = kinect.traducirCoordenadas( silueta ); 
      return coordenadas;
    } else {
     return null;
    }
    
   
  } 

  //-------------------------------------------------
}

// void ejecutarEnCadaMano( float x, float y, Blob blobMano ) {
//   ellipse( x, y, 70, 70 );
// }

void drawKinect() {
  if ( shKinect.getState() == "normal" ) {
    ejecutarModoNormal();
  } else if ( shKinect.getState() == "calibracion" ) {
    ejecutarModoCalibracion();
  }
}
//--------------------------------------------

void ejecutarModoNormal() {
  background( 0 );

  pushStyle();
  noFill();
  kinect.actualizar();

  stroke( 155 );
  strokeWeight( 3 );
  kinect.dibujarContornosSiluetas();

  // stroke( 255 );
  // kinect.dibujarContornosManos();

  // kinect.ejecutarAccionesEnManos();

  popStyle();
}
//--------------------------------------------

void ejecutarModoCalibracion() {

  background( 100 );
  drawElements();
  kinect.actualizar();
  kinect.dibujar();
}
//--------------------------------------------