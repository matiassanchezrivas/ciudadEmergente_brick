//CALIBRACION
stateHandler shCal;
String [] shCalStates = {"elementos", "color", "kinect", "keystone"};
//CALIBRACION ---> ELEMENTOS
stateHandler shElements;
String [] shElementStates = {"ventana", "ladrillos"};
//CALIBRACION ---> ELEMENTOS ---> VENTANAS
stateHandler shWindows;
String [] shWindowStates = {"posicion", "dimension", "altoArco"};
//CALIBRACION ---> ELEMENTOS ---> LADRILLOS
stateHandler shBricks;
String [] shBrickStates = {"posicion total", "dimension total", "posicion fila", "dimension fila", "posicion ladrillo", "fila ladrillo"};
//CALIBRACION ---> KINECT
stateHandler shKinect;
String [] shKinectStates = {"normal", "calibracion"};

int selectedWindow =0;
int selectedBrickRow =0;
int selectedBrick =0;
int amountChange = 3;

Breadcrumb br;

class Breadcrumb {
  int menuDepth = 0;
  String [] breadcrumb;

  Breadcrumb (int number) {
    breadcrumb = new String [number];
  }

  String get() {
    String g = "MENU";
    for (int i=0; i<=menuDepth; i++) {
      g+= " > "+(breadcrumb[i] !=null ? breadcrumb[i] : "");
    }
    return g;
  }

  void add(String s) {
    breadcrumb[menuDepth]=s;
  }
}

boolean backBread;

void initStateHandlers() {
  shCal = new stateHandler(shCalStates);
  shElements = new stateHandler(shElementStates);
  shWindows = new stateHandler(shWindowStates);
  shBricks = new stateHandler(shBrickStates);
  shKinect = new stateHandler(shKinectStates);
}

void initBreadcrumb() {
  br = new Breadcrumb(10);
}

//CALIBRACION
void calKeys() {
  backBread=false; 
  if (shCal.getState() == "elementos") {
    elementsKeys();
  } else if (shCal.getState() == "kinect") {
    kinect.ejecutarTeclas();
  } else if (shCal.getState() == "kinect") {
    kinect.ejecutarTeclas();
  }
  if (br.menuDepth == 0) {
    if (keyCode == 17) { //CTRL cambiar modo calibrador
      shCal.change();
      br.add(shCal.getState().toUpperCase());
    }
    changeBread(false);
  }
}

//CALIBRACION ---> ELEMENTOS
void elementsKeys() {
  if (shElements.getState() == "ventana") {
    ventanasKeys();
  } else if (shElements.getState() == "ladrillos") {
    ladrillosKeys();
  }
  if (br.menuDepth == 1) {
    if (keyCode == 17) { //CTRL
      shElements.change();
      br.add(shElements.getState().toUpperCase());
    } 
    changeBread(false);
  }
}

//CALIBRACION ---> ELEMENTOS ---> VENTANAS
void ventanasKeys() {
  if (keyCode == 9) { //BARRA ESPACIADORA
    selectedWindow = selectedWindow == 0 ? 1 : 0;
  }
  if (shWindows.getState() == "posicion") {
    windows[selectedWindow].x = changeVariable(windows[selectedWindow].x, 0, amountChange)[0];
    windows[selectedWindow].y = changeVariable(0, windows[selectedWindow].y, amountChange)[1];
  } else if (shWindows.getState() == "dimension") {
    windows[selectedWindow].ancho = changeVariable(windows[selectedWindow].ancho, 0, amountChange)[0];
    windows[selectedWindow].alto = changeVariable(0, windows[selectedWindow].alto, amountChange)[1];
  } else if (shWindows.getState() == "altoArco") {
    windows[selectedWindow].altoArco = changeVariable(0, windows[selectedWindow].altoArco, -amountChange)[1];
  }
  if (br.menuDepth == 2) {
    if (keyCode == 17) { //CTRL
      shWindows.change();
      br.add(shWindows.getState().toUpperCase());
    } 
    changeBread(true);
  }
}

//CALIBRACION ---> ELEMENTOS ---> LADRILLOS
void ladrillosKeys() {
  if (shBricks.getState() == "posicion total") {
    packLadrillos.x = changeVariable(packLadrillos.x, 0, amountChange)[0];
    packLadrillos.y = changeVariable(0, packLadrillos.y, amountChange)[1];
  } else if (shBricks.getState() == "dimension total") {
    packLadrillos.ancho = changeVariable(packLadrillos.ancho, 0, amountChange)[0];
    packLadrillos.alto = changeVariable(0, packLadrillos.alto, amountChange)[1];
  } else if (shBricks.getState() == "posicion fila") {
    FilaLadrillos r = packLadrillos.filas.get(selectedBrickRow);
    r.x=changeVariable(r.x, 0, amountChange)[0];
    r.y = changeVariable(0, r.y, amountChange)[1];
  } else if (shBricks.getState() == "dimension fila") {
    FilaLadrillos r = packLadrillos.filas.get(selectedBrickRow);
    r.ancho=changeVariable(r.ancho, 0, amountChange)[0];
    r.alto = changeVariable(0, r.alto, amountChange)[1];
  } else if (shBricks.getState() == "posicion ladrillo") {
    FilaLadrillos r = packLadrillos.filas.get(selectedBrickRow);
    Ladrillo l = r.ladrillos.get(selectedBrick);
    l.x=changeVariable(l.x, 0, amountChange)[0];
    l.y = changeVariable(0, l.y, amountChange)[1];
  } else if (shBricks.getState() == "dimension ladrillo") {
    FilaLadrillos r = packLadrillos.filas.get(selectedBrickRow);
    Ladrillo l = r.ladrillos.get(selectedBrick);
    l.ancho = changeVariable(packLadrillos.ancho, 0, amountChange)[0];
    l.alto = changeVariable(0, packLadrillos.alto, amountChange)[1];
  }



  if (br.menuDepth == 2) {
    if (keyCode == 17) { //CTRL
      shBricks.change();
      br.add(shBricks.getState().toUpperCase());
    } 
    changeBread(false);
  }
}

int [] changeVariable(int hor, int ver, int amount) {
  if (keyCode == UP ) {
    ver-=amount;
  } else if (keyCode == DOWN ) {
    ver+=amount;
  } else if (keyCode == LEFT ) {
    hor-=amount;
  } else if (keyCode == RIGHT ) {
    hor+=amount;
  }
  int res [] = {hor, ver};
  return res;
}

class stateHandler {
  String [] e;
  int cursor;

  stateHandler(String [] e) {
    this.e = e;
    this.cursor = 0;
  }

  void change() {
    cursor = cursor >= e.length-1 ? 0 : cursor+1;
    //println("estado cambio a ", e[cursor]);
  }

  String getState() {
    return e[cursor];
  }
}

void changeBread(boolean last) {
  if (keyCode == 10 && !last) { //ENTER 
    br.menuDepth ++;
    //println("menuDepth++", br.menuDepth);
  }
  if (keyCode == 8 && !backBread) { // backSpace
    br.menuDepth = (br.menuDepth > 0) ? br.menuDepth-1 : 0;
    //println("menuDepth--", br.menuDepth);
    backBread=true;
  }
}