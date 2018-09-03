class Interfaz {
  Info infoPuntos; 
  Info infoTiempo;
  int calle;

  Interfaz() {
    infoPuntos = new Info("puntos");
    infoTiempo = new Info("tiempo");
    calle=20;
  }
  void draw() {
    infoPuntos.draw(width, 0, calle);
    infoTiempo.draw(0, 0, calle);
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
    pushMatrix();
    pushStyle();
    fill(0);
    float anchoString = (textWidth(str(PUNTAJE_JUEGO)) > textWidth(type)) ? textWidth(str(PUNTAJE_JUEGO)) : textWidth(type);
    float alto= textSize*2+calle*3;
    ellipse(x, y, 10, 10);
    if (type=="puntos") {
      rect(x-anchoString-calle*2, y, calle*2 + anchoString, alto);
      fill(255);
      translate(x-calle, y+calle);
      stroke(255);
      strokeWeight(6);
      int tamLine=3;
      for (int i=0; i<anchoString/(tamLine*4); i++) {
        line(-tamLine*i*4, calle/2+textSize, -tamLine*i*4-tamLine, calle/2+textSize);
      }

      textAlign(RIGHT, TOP);
      textSize(textSize);
      textFont(consolasBold30);
      text(type, 0, 0);
      text(PUNTAJE_JUEGO, 0, calle+textSize);
    } else if (type=="tiempo") {
      fill(0);
      //CONTAINER
      rect(x, y, calle*2 + anchoString, alto);
      //TRANSLATE
      translate(x+calle, y+calle);
      //PROGESSBAR
      noStroke();
      fill(colorJuegoAgua.elColor);
      rect(0,calle+textSize,juego.temporizadorJuego.normalized()*anchoString,textSize,10923812);
      noFill();
      stroke(0);
      strokeWeight(8);
      rect(-4,calle+textSize-4,anchoString+8,textSize+8,10923812);
      stroke(255);
      strokeWeight(5);
      rect(0,calle+textSize,anchoString,textSize,10923812);
      //LINES
      fill(255);
      stroke(255);
      strokeWeight(6);
      int tamLine=3;
      for (int i=0; i<anchoString/(tamLine*4); i++) {
        line(tamLine*i*4, calle/2+textSize, tamLine*i*4+tamLine, calle/2+textSize);
      }
      //TEXT
      textAlign(LEFT, TOP);
      textSize(textSize);
      textFont(consolasBold30);
      text(type, 0, 0);
      
    }
    popMatrix();
    popStyle();
  }
}