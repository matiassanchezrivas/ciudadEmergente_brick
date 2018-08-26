Ventana [] windows;
PackLadrillos packLadrillos;

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

  //Inicializo ladrillos
  packLadrillos = new PackLadrillos( 100, 100, 900, 500, 10);
}

void drawElements() {
  for (Ventana ventana : windows) {
    ventana.draw();
  }
  packLadrillos.draw();
}

void saveElements() {
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
  PShape s; 

  Ventana (int x, int y, int ancho, int alto, int altoArco) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.altoArco=altoArco;
    this.s = createShape();
  }

  void draw() {
    pushStyle();
    noStroke();
    fill(255, 100);
    arc(x+ancho/2, y, ancho, altoArco, PI, TWO_PI);
    shape(s);
    rect (x, y, ancho, alto);
    popStyle();
  }
}

class PackLadrillos {
  ArrayList <FilaLadrillos> filas;
  int x, y, ancho, alto;
  int cantidad; 

  PackLadrillos (int x, int y, int ancho, int alto, int cantidad) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.filas = new ArrayList();
    this.cantidad = cantidad; 
    
    for (int i=0; i<cantidad; i++) {
      filas.add(new FilaLadrillos(x+ancho/cantidad*i/2, y+alto/cantidad*i, ancho-ancho/cantidad*(i), alto/cantidad, 10-i));
    }
  }

  void draw() {
    pushStyle();
    stroke(255);
    noFill();
    rect(x, y, ancho, alto);
    this.filas = new ArrayList();
    
    for (int i=0; i<cantidad; i++) {
      filas.add(new FilaLadrillos(x+ancho/cantidad*i/2, y+alto/cantidad*i, ancho-ancho/cantidad*(i), alto/cantidad, 10-i));
    }

    for (int i=0; i<filas.size(); i++) {
      FilaLadrillos fl = filas.get(i);
      fl.draw();
    }
    popStyle();
  }
}

class FilaLadrillos {
  int x, y, ancho, alto, cantidad;
  ArrayList <Ladrillo> ladrillos;

  FilaLadrillos (int x, int y, int ancho, int alto, int cantidad) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.cantidad=cantidad;
    this.ladrillos = new ArrayList();
    int anchoLadrillo = ancho/cantidad;
    for (int i=0; i<cantidad; i++) {
      ladrillos.add(new Ladrillo(x+i*anchoLadrillo, y, anchoLadrillo, alto));
    }
  }

  void draw() {
    pushStyle();
    stroke(255);
    noFill();
    rect(x, y, ancho, alto);
    for (int i=0; i<ladrillos.size(); i++) {
      Ladrillo l = ladrillos.get(i);
      l.draw();
    }
    popStyle();
  }
}

class Ladrillo {
  int x, y, ancho, alto, color1;

  Ladrillo (int x, int y, int ancho, int alto) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.color1= color (random(200));
  }

  void draw() {
    fill(color1);
    rect (x, y, ancho, alto);
  }
}