void drawElements2() {
  juego.interfaz.draw();
  offscreen.pushStyle();
  offscreen.imageMode(CENTER);
  offscreen.fill(255);
  offscreen.image(juego.countdown.reloj, X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);

  offscreen.noFill();
  offscreen.stroke(255);
  offscreen.strokeWeight(5);
  offscreen.rectMode(CORNERS);
  offscreen.rect(WORLD_TOP_X, WORLD_TOP_Y, WORLD_BOTTOM_X, WORLD_BOTTOM_Y);

  offscreen.popStyle();
}

class decorativos {
  int selected;
  Poligono poligonos [] = new Poligono [8];

  decorativos() {
    for (int i=0; i< poligonos.length; i++) {
      poligonos[i] = new Poligono();
      selected = 0;
    }
  }

  void draw() {
    for (int i=0; i< poligonos.length; i++) {
      poligonos[i].draw();
    }
  }

  void addVertex(int x, int y) {
    poligonos[selected].addVertex(x, y);
  }

  void changeVertex() {
    poligonos[selected].changeVertex();
  }

  void removeVertex() {
    poligonos[selected].removeVertex();
  }

  void updateVertex(PVector updated) {
    poligonos[selected].updateVertex(updated);
  }
}

class Poligono {
  ArrayList <PVector> vertices;
  PShape s; 
  int selected;

  Poligono (ArrayList vertices) {
    this.vertices = vertices;
    this.s = createShape();
    selected = 0;
  }

  Poligono () {
    this.vertices = new ArrayList();
    this.s = createShape();
    selected = 0;
  }

  void addVertex(int x, int y) {
    this.vertices.add(new PVector(x, y));
  }

  void draw() {

    shape(this.s);
    this.s = createShape();
    this.s.beginShape();

    for (int i=0; i<vertices.size(); i++) {
      PVector v = vertices.get(i);
      this.s.vertex(v.x, v.y);
      pushStyle();
      noStroke();
      if (i==selected) fill(255, 0, 0);
      ellipse(v.x, v.y, 10, 10);
      popStyle();
    }
    this.s.endShape(CLOSE);
  }

  void updateVertex(PVector updated) {
    println(updated);
    PVector v = vertices.get(selected);
    v.x = updated.x;
    v.y = updated.y;
  }

  void changeVertex() {
    selected = (selected >= this.vertices.size()-1) ? 0 : selected+1;
  }

  void removeVertex() {
    if (vertices.size() > 1 ) {
      PVector r = vertices.get(selected);
      vertices.remove(r);
      selected = (selected <= 0) ? this.vertices.size()-1 : selected-1;
    }
  }
}