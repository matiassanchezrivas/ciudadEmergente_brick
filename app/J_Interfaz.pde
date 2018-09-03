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
      offscreen.rect(0, calle+textSize, juego.temporizadorJuego.normalized()*anchoString, textSize, 10923812);
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