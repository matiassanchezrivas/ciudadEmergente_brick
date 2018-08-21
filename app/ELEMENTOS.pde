Ventana [] windows;

void loadElements() {
  //Inicializo ventanas
  windows = new Ventana [2];
  JSONArray jsonVentanas;
  jsonVentanas = loadJSONArray("ventanas.json");

  for (int i=0; i<windows.length; i++) {
    JSONObject v = jsonVentanas.getJSONObject(i);
    int x = v.getInt("x");
    int y = v.getInt("y");
    int ancho = v.getInt("ancho");
    int alto = v.getInt("alto");
    int altoArco = v.getInt("altoArco");
    windows[i]= new Ventana(x, y, ancho, alto, altoArco);
  }
}

void drawElements() {
  for (Ventana ventana : windows) {
    ventana.draw();
  }
}

void guardarElementos() {
  JSONArray jsonVentanas;
  jsonVentanas = new JSONArray();
  for (int i=0; i<windows.length; i++) {
    JSONObject v;
    v= new JSONObject();
    v.setInt("x", windows[i].x);
    v.setInt("y", windows[i].y);
    v.setInt("ancho", windows[i].ancho);
    v.setInt("alto", windows[i].alto);
    v.setInt("altoArco", windows[i].altoArco);
    jsonVentanas.setJSONObject(i, v);
  }
  saveJSONArray(jsonVentanas, "data/ventanas.json");
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

  void draw() {
    pushStyle();
    noStroke();
    fill(255, 100);
    arc(x+ancho/2, y, ancho, altoArco, PI, TWO_PI);
    rect (x, y, ancho, alto);
    popStyle();
  }
}