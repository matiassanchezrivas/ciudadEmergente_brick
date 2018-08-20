JSONObject ventanas;

Ventana [] windows;

void setupElementos(){
  //Inicializo ventanas
  windows = new Ventana [2];
  for(int i=0; i<windows.length; i++){
  windows[i]= new Ventana(200,200,200,200,200);
  }
}

void drawElementos(){
 for(Ventana ventana : windows){
  ventana.draw();
  }
}

void guardarElementos(){
  
}


class Ventana {
  int x, y, ancho, alto, altoArco;
  
    Ventana (int x, int y, int ancho, int alto, int altoArco) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.altoArco=altoArco;
  }
  
  void draw(){
    pushStyle();
    noStroke();
    fill(255, 100);
    arc(x+ancho/2, y, ancho, altoArco, PI, TWO_PI);
    rect (x, y, ancho, alto);
    popStyle();
  }
}