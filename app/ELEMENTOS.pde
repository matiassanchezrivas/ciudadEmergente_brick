// ----- Elementos a calibrar

Ventana [] windows;
PackLadrillos packLadrillos;

// ----- Cargar desde DB

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
    windows[i]= new Ventana(x, y, ancho, alto, altoArco, i);
  }

  //Inicializo ladrillos
  JSONObject jsonLadrillos;
  jsonLadrillos = loadJSONObject("ladrillos.json");
  int x = jsonLadrillos.getInt("x");
  int y = jsonLadrillos.getInt("y");
  int ancho = jsonLadrillos.getInt("ancho");
  int alto = jsonLadrillos.getInt("alto");
  packLadrillos = new PackLadrillos( x, y, ancho, alto, 4);
}

// ----- Dibujar elementos

void drawElements() {
  for (Ventana ventana : windows) {
    ventana.draw();
  }
  packLadrillos.draw();
}

// ----- Guardar elementos

void saveElements() {
  saveWindows();
  saveBricks();
}

// ----- Guardar ventanas

void saveWindows() {
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

// ----- Guardar ladrillos

void saveBricks() {
  JSONObject jsonPackLadrillos;
  jsonPackLadrillos = new JSONObject();
  JSONArray jsonFilasLadrillos;
  jsonFilasLadrillos = new JSONArray();

  for (int i=0; i<packLadrillos.filas.size(); i++) {
    FilaLadrillos fl = packLadrillos.filas.get(i);

    JSONArray filas;
    filas = new JSONArray();

    for (int j=0; j<fl.ladrillos.size(); j++) {
      Ladrillo l = fl.ladrillos.get(j);
      JSONObject ladrillo;
      ladrillo = new JSONObject();
      ladrillo.setInt("x", l.x);
      ladrillo.setInt("y", l.y);
      ladrillo.setInt("ancho", l.ancho);
      ladrillo.setInt("alto", l.alto);
      filas.setJSONObject(j, ladrillo);
    }

    JSONObject jsonFilaLadrillo;
    jsonFilaLadrillo= new JSONObject();

    jsonFilaLadrillo.setInt("x", fl.x);
    jsonFilaLadrillo.setInt("y", fl.y);
    jsonFilaLadrillo.setInt("ancho", fl.ancho);
    jsonFilaLadrillo.setInt("alto", fl.alto);
    jsonFilaLadrillo.setJSONArray("ladrillos", filas);

    jsonFilasLadrillos.setJSONObject(i, jsonFilaLadrillo);
  }
  jsonPackLadrillos.setInt("x", packLadrillos.x);
  jsonPackLadrillos.setInt("y", packLadrillos.y);
  jsonPackLadrillos.setInt("ancho", packLadrillos.ancho);
  jsonPackLadrillos.setInt("alto", packLadrillos.alto);
  jsonPackLadrillos.setJSONArray("filas", jsonFilasLadrillos);


  saveJSONObject(jsonPackLadrillos, "data/ladrillos.json");
}

//CLASE VENTANA ELEMENTO

class Ventana {
  int x, y, ancho, alto, altoArco, id;
  PShape s; 

  Ventana (int x, int y, int ancho, int alto, int altoArco, int id) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.altoArco=altoArco;
    this.id = id;
    this.s = createShape();
  }

  void draw() {
    color c = color(255, 100);
    color cArco = c;
    color cRect = c;
    if (shElements.getState() == "ventana") {
      c = (selectedWindow != id) ? color(255, 100) : colorCalibracionAcento.elColor ;
      cArco = (shWindows.getState() == "altoArco") ? c : color(255, 100);
      cRect = (shWindows.getState() == "dimension") ? c : color(255, 100);
    }

    pushStyle();
    if (shElements.getState() == "ventana" && shWindows.getState() == "posicion" && selectedWindow == id) {
      strokeWeight(.5);
      stroke(c);
    } else {
      noStroke();
    }
    fill(cArco);
    arc(x+ancho/2, y, ancho, altoArco, PI, TWO_PI);

    fill(cRect);
    shape(s);
    rect (x, y, ancho, alto);
    if (shElements.getState() == "ventana" && shWindows.getState() == "posicion" && selectedWindow == id) {
      pushMatrix();
      translate(x, y);
      noStroke();
      fill(c);
      ellipse(0, 0, 10, 10);
      rotate(radians(frameCount*2));
      ellipse(0, 15, 10, 10);
      popMatrix();
    }
    popStyle();
  }
}

//CLASE GRILLA LADRILLOS

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
      if (i%2==0) {
        filas.add(new FilaLadrillos(x, y+alto/cantidad*i, ancho/9*8, alto/cantidad, 8));
      } else {
        filas.add(new FilaLadrillos(x+ancho/8/2, y+alto/cantidad*i, ancho/9*8, alto/cantidad, 8));
      }
    }
  }

  void draw() {
    pushStyle();
    stroke(255);
    noFill();
    rect(x, y, ancho, alto);
    for (int i=0; i<filas.size(); i++) {
      FilaLadrillos fl = filas.get(i);
      //fl.update(x, y, ancho, alto, 8);
      fl.draw();
    }
    popStyle();
  }
}

//FILA DE LADRILLOS

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

  void update(int x, int y, int ancho, int alto, int cantidad) {
    this.x=x;
    this.y=y;
    this.ancho=ancho;
    this.alto=alto;
    this.cantidad=cantidad;
  }

  void draw() {
    pushStyle();
    strokeWeight(4);
    stroke(255);
    noFill();
    rect(x, y, ancho, alto);
    for (int i=0; i<ladrillos.size(); i++) {
      Ladrillo l = ladrillos.get(i);
      int anchoLadrillo = ancho/cantidad;
      l.draw();
    }
    popStyle();
  }
}

//CLASE LADRILLOS

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
    strokeWeight(.5);
    fill(color1);
    rect (x, y, ancho, alto);
  }
}