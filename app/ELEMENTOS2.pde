Fijos fijos;
FisicaCalibracion fisicaCalibracion;

class FisicaCalibracion {
  FCircle pelotaNivel1;
  FCircle pelotaNivel2;

  int x1, y1, x2, y2;


  FisicaCalibracion () {
  }

  void reset() {
    pelotaNivel1 = new FCircle(SIZE_BALL);
    pelotaNivel2= new FCircle(SIZE_BALL);
    pelotaNivel1.setPosition(width/2-200, height/2);
    pelotaNivel2.setPosition(width/2+200, height/2);
    world.add(pelotaNivel1);
    world.add(pelotaNivel2);
  }

  void jugar() {
    {
      float velx = pelotaNivel1.getVelocityX();
      float vely = pelotaNivel1.getVelocityY();
      velx = (velx > 0) ? MIN_VELOCITY_NIVEL1 : -MIN_VELOCITY_NIVEL1;
      vely = (vely > 0) ? MIN_VELOCITY_NIVEL1 : -MIN_VELOCITY_NIVEL1;
      pelotaNivel1.setVelocity(velx, vely);
    }
    {
      float velx = pelotaNivel2.getVelocityX();
      float vely = pelotaNivel2.getVelocityY();
      velx = (velx > 0) ? MIN_VELOCITY_NIVEL2 : -MIN_VELOCITY_NIVEL2;
      vely = (vely > 0) ? MIN_VELOCITY_NIVEL2 : -MIN_VELOCITY_NIVEL2;
      pelotaNivel2.setVelocity(velx, vely);
    }
  }

  void update() {
    this.x1 = int(pelotaNivel1.getX()); 
    this.y1 = int(pelotaNivel1.getY()); 

    this.x2 = int(pelotaNivel2.getX()); 
    this.y2 = int(pelotaNivel2.getY());
  }

  void draw() {
    offscreen.pushStyle();
    offscreen.fill(255);
    offscreen.textAlign(CENTER, CENTER);
    offscreen.textFont(consolasBold30);
    offscreen.text("1", x1, y1);
    offscreen.ellipse(x1, y1, SIZE_BALL, SIZE_BALL);
    offscreen.text("2", x1, y1);
    offscreen.ellipse(x2, y2, SIZE_BALL, SIZE_BALL);
    offscreen.popStyle();
  }
}

void saveFijos() {
  JSONArray jsonFijos;
  jsonFijos = new JSONArray();
  for (int i=0; i<fijos.poligonos.length; i++) {
    JSONArray p;
    p= new JSONArray();
    for (int j=0; j<fijos.poligonos[i].vertices.size(); j++) {
      PVector pv = fijos.poligonos[i].vertices.get(j);
      JSONObject ov = new JSONObject();
      ov.setFloat("x", pv.x);
      ov.setFloat("y", pv.y);
      p.setJSONObject(j, ov);
    }
    jsonFijos.setJSONArray(i, p);
  }
  saveJSONArray(jsonFijos, "data/fijos.json");
}

void loadFijos() {
  JSONArray jsonFijos;
  jsonFijos = loadJSONArray("fijos.json");
  for (int i=0; i<jsonFijos.size(); i++) {
    JSONArray vertices = jsonFijos.getJSONArray(i);
    for (int j=0; j<vertices.size(); j++) {
      JSONObject ver = vertices.getJSONObject(j);
      fijos.addVertex(int(ver.getFloat("x")), int(ver.getFloat("y")), i);
    }
  }
}

void loadElements2() {
  fijos = new Fijos();
  fisicaCalibracion = new FisicaCalibracion();
  loadFijos();
}

void drawElements2() {
  drawFisica();
  juego.interfaz.draw();

  for (Ventana ventana : windows) {
    ventana.draw();
  }

  drawReloj();
  drawWorldEdges();
  fijos.draw();


  fisicaCalibracion.update();
  fisicaCalibracion.draw();
  fisicaCalibracion.jugar();
}

void drawReloj() {
  offscreen.pushStyle();
  offscreen.imageMode(CENTER);
  offscreen.fill(255);
  offscreen.image(juego.countdown.reloj, X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);
  offscreen.popStyle();
}

void drawWorldEdges() {
  offscreen.pushStyle();
  offscreen.noFill();
  offscreen.stroke(255);
  offscreen.strokeWeight(5);
  offscreen.rectMode(CORNERS);
  offscreen.rect(WORLD_TOP_X, WORLD_TOP_Y, WORLD_BOTTOM_X, WORLD_BOTTOM_Y);
  offscreen.popStyle();
}

class Fijos {
  int selected;
  Poligono poligonos [] = new Poligono [8];

  Fijos() {
    for (int i=0; i< poligonos.length; i++) {
      poligonos[i] = new Poligono();
      selected = 0;
    }
  }

  void draw() {
    for (int i=0; i< poligonos.length; i++) {
      poligonos[i].draw(i==selected);
    }
  }

  void addVertex(int x, int y) {
    poligonos[selected].addVertex(x, y);
  }

  void changeVertex() {
    poligonos[selected].changeVertex();
  }

  void addVertex(int x, int y, int number) {
    poligonos[number].addVertex(x, y);
  }

  void removeVertex() {
    poligonos[selected].removeVertex();
  }

  void updateVertex(PVector updated) {
    poligonos[selected].updateVertex(updated);
  }

  void change() {
    selected = (selected >= poligonos.length-1) ? 0 : selected+1;
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

  void draw(boolean select) {
    if (select) {
      offscreen.fill(colorCalibracionAcento.elColor);
      s.setFill(colorCalibracionAcento.elColor);
    } else {
      s.setFill(color(255, 100));
      offscreen.fill(255, 100);
    }

    offscreen.shape(this.s);
    this.s = createShape();
    this.s.beginShape();

    for (int i=0; i<vertices.size(); i++) {
      PVector v = vertices.get(i);
      this.s.vertex(v.x, v.y);
      offscreen.pushStyle();
      offscreen.noStroke();
      if (i==selected && select) offscreen.fill(0);
      offscreen.ellipse(v.x, v.y, 10, 10);
      offscreen.popStyle();
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