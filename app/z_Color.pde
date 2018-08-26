//colores UNO
GestorColor colorCalibracionAcento;

void iniciarColores() {
  int FACTOR_TAMANIO=1;
  int d = int(150 * FACTOR_TAMANIO);

  colorCalibracionAcento = new GestorColor("color_calibracion_acento" );
  colorCalibracionAcento.abrir();
  colorCalibracionAcento.ubicar( 50, d );
}

void ejecutarClickEnColores() {
  colorCalibracionAcento.hacerClick( mouseX, mouseY );
}

void imprimirGestoresDeColores() {
  colorCalibracionAcento.imprimir();
}

class GestorColor {

  color elColor;
  color colorOriginal;

  color colorBordes;  
  color colorInverso;  
  String etiqueta;

  float left;
  float top;

  float m = 20;

  boolean pressUndo = false;
  boolean pressGuardar = false;
  //-----------------------------------------------------

  GestorColor( String etiqueta_ ) {
    etiqueta = etiqueta_;

    elColor = color( 0, 255, 0 );

    colorBordes = color(0);
    colorInverso = color(255);
  }
  //-----------------------------------------------------

  GestorColor( String etiqueta_, float tinte, float saturacion, float brillo, 
  float alfa ) {
    etiqueta = etiqueta_;
    pushStyle();
    colorMode( HSB );
    elColor = color( tinte, saturacion, brillo, alfa );
    popStyle();
    colorOriginal = elColor;
    colorBordes = color(0);
    colorInverso = color(255);
  }
  //-----------------------------------------------------

  void guardar() {
    pushStyle();
    colorMode( HSB );

    PrintWriter output = createWriter( "data/"+etiqueta+".txt" );
    output.println( hue( elColor ) );
    output.println( saturation( elColor ) );
    output.println( brightness( elColor ) );
    output.println( alpha( elColor ) );
    output.flush();  // Writes the remaining data to the file
    output.close(); 
    popStyle();
  }
  //-----------------------------------------------------

  void abrir() {
    String lines[] = loadStrings(etiqueta+".txt");    
    if ( lines.length>=4 ) {
      pushStyle();
      colorMode( HSB );

      float tinte = float( lines[0] );
      float saturacion = float( lines[1] );
      float brillo = float( lines[2] );
      float alfa = float( lines[3] );
      elColor = color( tinte, saturacion, brillo, alfa );
      colorOriginal = elColor;
      popStyle();
    }
  }
  //-----------------------------------------------------

  void ubicar( float left_, float top_ ) {
    left = left_;
    top = top_;
  }
  //-----------------------------------------------------

  void imprimir() {

    pushStyle();
    colorMode( HSB );

    fill( colorBordes );
    textSize( m*0.8 );

    text( etiqueta, left+m*6, top+m*0.8 );
    text( int( hue( elColor )), left+m*6+255, top+m*1.8 );
    text( int( saturation( elColor )), left+m*6+255, top+m*2.8 );
    text( int( brightness( elColor )), left+m*6+255, top+m*3.8 );
    text( int( alpha( elColor )), left+m*6+255, top+m*4.8 );


    pushStyle();
    noFill();
    strokeWeight( 15 );
    stroke( colorBordes );
    ellipse( left+m*2.5, top+m*2.5, m*4, m*4 );
    stroke( colorInverso );
    ellipse( left+m*2.5, top+m*2.5, m*2, m*2 );

    popStyle();

    fill( elColor );
    rect( left, top, m*5, m*5 );

    for ( int i=0; i<256; i++ ) {
      stroke( i, 255, 255 );
      line( left+m*5+i, top+m, left+m*5+i, top+m*2 );
    }
    noFill();
    stroke( colorBordes );
    rect( left+m*5, top+m, 256, m );

    for ( int i=0; i<256; i++ ) {
      stroke( hue( elColor ), i, 255 );
      line( left+m*5+i, top+m*2, left+m*5+i, top+m*3 );
    }
    stroke( colorBordes );
    rect( left+m*5, top+m*2, 256, m );

    for ( int i=0; i<256; i++ ) {
      stroke( 0, 0, i );
      line( left+m*5+i, top+m*3, left+m*5+i, top+m*4 );
    }
    stroke( colorBordes );
    rect( left+m*5, top+m*3, 256, m );

    for ( int i=0; i<256; i++ ) {
      stroke( 0, 0, i );
      line( left+m*5+i, top+m*4, left+m*5+i, top+m*5 );
    }
    stroke( colorBordes );
    rect( left+m*5, top+m*4, 256, m );

    dibujarCruzCirculo( hue(elColor), m );
    dibujarCruzCirculo( saturation(elColor), m*2 );
    dibujarCruzCirculo( brightness(elColor), m*3 );
    dibujarCruzCirculo( alpha(elColor), m*4 );

    fill( (!pressUndo ? colorInverso : colorBordes ) );
    rect( left+m*8+255, top, m*3, m );
    fill( (pressUndo ? colorInverso : colorBordes ) );
    text( "undo", left+m*8.25+255, top+m*0.8);
    fill( (!pressGuardar ? colorInverso : colorBordes ) );
    rect( left+m*8+255, top+m*2, m*3, m );
    fill( (pressGuardar ? colorInverso : colorBordes ) );
    text( "guardar", left+m*8.25+255, top+m*2.8);

    popStyle();

    pressUndo = false;
    pressGuardar = false;
  }
  //-----------------------------------------------------

  void dibujarCruzCirculo( float valor, float altura ) {
    pushStyle();
    float x = left+m*5+valor;
    float y = top+altura+m/2;
    stroke( colorBordes );
    noFill();
    ellipse( x, y, m, m );
    stroke( colorInverso );
    ellipse( x, y, m-3, m-3 );
    popStyle();
  }
  //-----------------------------------------------------

  boolean hacerClick( float mx, float my ) {
    pushStyle();
    colorMode( HSB );

    boolean exito = false;

    if ( mx>left+m*8+255 && mx<left+m*8+255+m*3 && my>top && my<top+m ) {
      deshacer();
      pressUndo = true;
      exito = true;
    }

    if ( mx>left+m*8+255 && mx<left+m*8+255+m*3 && my>top+m*2 && my<top+m*3 ) {
      guardar();
      pressGuardar = true;
      exito = true;
    }

    if ( mx>left+m*4.5 && mx<=left+m*5.5+255 &&
      my>top+m && my<top+m*5 ) {



      float valor = mx-(left+m*5);
      //print( valor );
      valor = constrain( valor, 0, 255 );
      //println( "->"+valor );

      //print(valor + " " );

      if ( my>top+m*4 ) {
        elColor = color( hue(elColor), saturation( elColor ), brightness( elColor ), 
        valor );
      } else if ( my>top+m*3 ) {
        elColor = color( hue(elColor), saturation( elColor ), valor, 
        alpha( elColor ) );
      } else if ( my>top+m*2 ) {
        elColor = color( hue(elColor), valor, brightness( elColor ), 
        alpha( elColor ) );
      } else if ( my>top+m ) {
        elColor = color( valor, saturation( elColor ), brightness( elColor ), 
        alpha( elColor ) );
      }
      exito = true;
    }
    popStyle();
    return exito;
  }
  //-----------------------------------------------------

  void deshacer() {
    elColor = colorOriginal;
  }
  //-----------------------------------------------------
  
  color alfaNormalizado( float valor ){
    pushStyle();
    colorMode( RGB );
    color nuevo = color( red(elColor) , green( elColor ) , blue( elColor ),
    alpha( elColor )*valor );
    popStyle();
    return nuevo;
  }
  //-----------------------------------------------------
}