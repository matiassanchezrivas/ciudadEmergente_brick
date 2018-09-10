int INTERFAZ_NIVEL_X = 196;

int INTERFAZ_Y=45;
int INTERFAZ_PUNTOS_X = 842;

int INTERFAZ_PUNTOS_TEXT_X = 768;

int INTERFAZ_VIDAS_X = 561;

int INTERFAZ_TIEMPO_X =335;

int INTERFAZ_SEPARADOR1_X = 280;
int INTERFAZ_SEPARADOR2_X = 718;

int INTERFAZ_PROGRESSBAR_X =421;
int INTERFAZ_PROGRESSBAR_ANCHO =86;
int INTERFAZ_PROGRESSBAR_ALTO= 20;

int INTERFAZ_CONTAINERVIDAS_X = 645;
int INTERFAZ_CONTAINERVIDAS_ANCHO = 91;
int INTERFAZ_CONTAINERVIDAS_ALTO = 20;


class Interfaz {
  TextoInterfaz tnivel;
  TextoInterfaz ttiempo;
  TextoInterfaz tvidas;
  TextoInterfaz tpuntos;
  TextoInterfaz tpuntosText;
  ProgressBar progressBar;
  Separador separador1;
  Separador separador2;
  Vidas vidas;

  Interfaz() {
    tnivel = new TextoInterfaz();
    ttiempo = new TextoInterfaz();
    tvidas = new TextoInterfaz();
    tpuntosText = new TextoInterfaz();
    tpuntos = new TextoInterfaz();
    progressBar= new ProgressBar();
    separador1 = new Separador();
    separador2 = new Separador();
    vidas = new Vidas();
  }

  void draw(boolean aparece) {
    tnivel.draw("NIVEL "+str(juego.nivel+1), INTERFAZ_NIVEL_X, INTERFAZ_Y, aparece, 28);
    ttiempo.draw("TIEMPO", INTERFAZ_TIEMPO_X, INTERFAZ_Y, aparece, 17);
    tvidas.draw("VIDAS", INTERFAZ_VIDAS_X, INTERFAZ_Y, aparece, 17);
    tpuntosText.draw("PUNTOS", INTERFAZ_PUNTOS_TEXT_X, INTERFAZ_Y, aparece, 17);
    tpuntos.draw(str(PUNTAJE_JUEGO), INTERFAZ_PUNTOS_X, INTERFAZ_Y, aparece, 28);
    progressBar.draw(INTERFAZ_PROGRESSBAR_X, INTERFAZ_Y, INTERFAZ_PROGRESSBAR_ANCHO, INTERFAZ_PROGRESSBAR_ALTO, aparece);
    separador1.draw(INTERFAZ_SEPARADOR1_X, INTERFAZ_Y, aparece);
    separador2.draw( INTERFAZ_SEPARADOR2_X, INTERFAZ_Y, aparece);
    vidas.draw(INTERFAZ_CONTAINERVIDAS_X, INTERFAZ_Y, INTERFAZ_CONTAINERVIDAS_ANCHO, INTERFAZ_CONTAINERVIDAS_ALTO, aparece);
  }
}

class Separador {
  PShape separador;
  float scale = 0;

  Separador() {
    separador = loadShape("separador.svg");
  }

  void draw( int x, int y, boolean aparece) {
    if (aparece) {
      appear();
    } else {
      disappear();
    }
    offscreen.pushMatrix();
    offscreen.pushStyle();
    offscreen.shapeMode(CENTER);
    offscreen.translate(x, y);
    offscreen.scale(scale);
    offscreen.shape(separador, 0, 0);
    offscreen.popStyle();
    offscreen.popMatrix();
  }

  void appear() {   
    scale=(1)*(1-0.9)+scale*0.9;
  }

  void disappear() {
    scale=(0)*(1-0.9)+scale*0.9;
  }

  void reset() {
    scale=0;
  }
}

class Vidas {
  PShape vida;
  float scale = 0;

  Vidas() {
    vida = loadShape("vida.svg");
  }

  void draw( int x, int y, int ancho, int alto, boolean aparece) {
    if (aparece) {
      appear();
    } else {
      disappear();
    }
    offscreen.pushMatrix();
    offscreen.pushStyle();
    offscreen.shapeMode(CENTER);
    offscreen.rectMode(CENTER);
    offscreen.translate(x, y);
    offscreen.scale(scale);
    float separacion=(ancho-((CANTIDAD_VIDAS+1)*vida.width))/CANTIDAD_VIDAS;
    for (int i=0; i<vidasLeft+1; i++) {
      offscreen.shape(vida, -ancho/2+separacion*i+vida.width/2+vida.width*i, 0);
    }
    offscreen.noFill();
    offscreen.stroke(255);
    offscreen.strokeWeight(1);
    //offscreen.rect(0, 0, ancho, alto);
    offscreen.popStyle();
    offscreen.popMatrix();
  }

  void appear() {   
    scale=(1)*(1-0.9)+scale*0.9;
  }

  void disappear() {
    scale=(0)*(1-0.9)+scale*0.9;
  }

  void reset() {
    scale=0;
  }
}

class ProgressBar {
  float scale=0;
  float relleno=0;
  ProgressBar() {
  }

  void draw(int x, int y, int ancho, int alto, boolean aparece) {
    if (aparece) {
      appear();
    } else {
      disappear();
    }
    float nuevo = juego.nivel==0 ? juego.temporizadorJuego1.normalized()*ancho : juego.temporizadorJuego2.normalized();
    relleno= nuevo*(1-0.9)+relleno*.9;
    //PROGESSBAR
    offscreen.pushStyle();
    offscreen.pushMatrix();
    offscreen.translate(x,y);
    offscreen.scale(scale);
    offscreen.rectMode(CENTER);
    offscreen.noStroke();
    offscreen.fill(colorJuegoAgua.elColor);
    offscreen.rectMode(CORNER);
    offscreen.rect(-ancho/2, -alto/2, relleno*ancho, alto, 10923812);
    offscreen.noFill();
    offscreen.stroke(0);
    offscreen.strokeWeight(10);
    offscreen.rectMode(CENTER);
    offscreen.rect(0, 0, ancho+6, alto+6, 10923812);
    offscreen.stroke(255);
    offscreen.strokeWeight(5);
    offscreen.rect(0, 0, ancho, alto, 10923812);
    offscreen.popMatrix();
    offscreen.popStyle();
  }

  void appear() {   
    scale=(1)*(1-0.9)+scale*0.9;
  }

  void disappear() {
    scale=(0)*(1-0.9)+scale*0.9;
  }

  void reset() {
    scale=0;
    relleno=0;
  }
}

class TextoInterfaz {
  float scale=0;

  TextoInterfaz() {
  }

  void draw(String texto, int x, int y, boolean aparece, int size) {
    if (aparece) {
      appear();
    } else {
      disappear();
    }
    offscreen.pushMatrix();
    offscreen.pushStyle();
    offscreen.translate(x, y);
    offscreen.scale(scale);
    offscreen.textAlign(CENTER, CENTER);
    offscreen.textFont(consolasBold30);
    offscreen.textSize(size);

    offscreen.fill(255);
    offscreen.text(texto, 0, 0);
    offscreen.popStyle();
    offscreen.popMatrix();
  }

  void appear() {   
    scale=(1)*(1-0.9)+scale*0.9;
  }

  void disappear() {
    scale=(0)*(1-0.9)+scale*0.9;
  }

  void reset() {
    scale=0;
  }
}

class Info {
  String type;
  int textSize;

  Info(String type) {
    this.type=type;
    this.textSize=30;
  }

  void draw(int x, int y, int calle) {
    offscreen.pushMatrix();
    offscreen.pushStyle();
    offscreen.fill(0);
    float anchoString = (offscreen.textWidth(str(PUNTAJE_JUEGO)) > offscreen.textWidth(type)) ? offscreen.textWidth(str(PUNTAJE_JUEGO)) : offscreen.textWidth(type);
    float alto= textSize*2+calle*3;
    offscreen.ellipse(x, y, 10, 10);
    if (type=="puntos") {
      offscreen.rect(x-anchoString-calle*2, y, calle*2 + anchoString, alto);
      offscreen.fill(255);
      offscreen.translate(x-calle, y+calle);
      offscreen.stroke(255);
      offscreen.strokeWeight(6);
      int tamLine=3;
      for (int i=0; i<anchoString/(tamLine*4); i++) {
        offscreen.line(-tamLine*i*4, calle/2+textSize, -tamLine*i*4-tamLine, calle/2+textSize);
      }

      offscreen.textAlign(RIGHT, TOP);
      offscreen.textSize(textSize);
      offscreen.textFont(consolasBold30);
      offscreen.text(type, 0, 0);
      offscreen.text(PUNTAJE_JUEGO, 0, calle+textSize);
    } else if (type=="tiempo") {
      offscreen.fill(0);
      //CONTAINER
      offscreen.rect(x, y, calle*2 + anchoString, alto);
      //TRANSLATE
      offscreen.translate(x+calle, y+calle);
      //PROGESSBAR
      offscreen.noStroke();
      offscreen.fill(colorJuegoAgua.elColor);
      //offscreen.rect(0, calle+textSize, juego.temporizadorJuego.normalized()*anchoString, textSize, 10923812);
      offscreen.noFill();
      offscreen.stroke(0);
      offscreen.strokeWeight(8);
      offscreen.rect(-4, calle+textSize-4, anchoString+8, textSize+8, 10923812);
      offscreen.stroke(255);
      offscreen.strokeWeight(5);
      offscreen.rect(0, calle+textSize, anchoString, textSize, 10923812);
      //LINES
      offscreen.fill(255);
      offscreen.stroke(255);
      offscreen.strokeWeight(6);
      int tamLine=3;
      for (int i=0; i<anchoString/(tamLine*4); i++) {
        offscreen.line(tamLine*i*4, calle/2+textSize, tamLine*i*4+tamLine, calle/2+textSize);
      }
      //TEXT
      offscreen.textAlign(LEFT, TOP);
      offscreen.textSize(textSize);
      offscreen.textFont(consolasBold30);
      offscreen.text(type, 0, 0);
    }
    offscreen.popMatrix();
    offscreen.popStyle();
  }
}