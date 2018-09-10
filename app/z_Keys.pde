//CALIBRACION
stateHandler shCal;
String [] shCalStates = {"elementos", "elementos 2", "color", "kinect", "keystone"};
//CALIBRACION ---> ELEMENTOS
stateHandler shElements;
String [] shElementStates = {"ventana", "ladrillos"};
//CALIBRACION ---> ELEMENTOS ---> VENTANAS
stateHandler shWindows;
String [] shWindowStates = {"posicion", "dimension", "altoArco", "barrotes"};
//CALIBRACION ---> ELEMENTOS ---> LADRILLOS
stateHandler shBricks;
String [] shBrickStates = {"posicion total", "dimension total", "posicion fila", "dimension fila", "posicion ladrillo", "fila ladrillo"};
//CALIBRACION ---> KINECT
stateHandler shKinect;
String [] shKinectStates = {"normal", "calibracion"};
//CALIBRACION ---> ELEMENTOS 2
stateHandler shElements2;
String [] shElementStates2 = {"tiempo", "puntos", "reloj", "worldTop", "worldBottom", "pastilla", "fijos"};

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
  shElements2 = new stateHandler(shElementStates2);
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
  } else if (shCal.getState() == "elementos 2") {
    elements2Keys();
  }
  if (br.menuDepth == 0) {
    if (keyCode == 17) { //CTRL cambiar modo calibrador
      if (shCal.getState()=="elementos") {
        println("RESEEEEEET");
        resetAll(false); //PARA VER PELOTAS
        fisicaCalibracion.reset();
      }
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

void elements2Keys() {
  if (shElements2.getState() == "puntos") {
    puntosKeys();
  } else if (shElements2.getState() == "tiempo") {
    tiempoKeys();
  } else if (shElements2.getState() == "worldTop") {
    worldTopKeys();
  } else if (shElements2.getState() == "worldBottom") {
    worldBottomKeys();
  } else if (shElements2.getState() == "reloj") {
    relojKeys();
  } else if (shElements2.getState() == "pastilla") {
    pastillaKeys();
  } else if (shElements2.getState() == "fijos") {
    fijosKeys();
  }
  if (br.menuDepth == 1) {
    if (keyCode == 17) { //CTRL
      shElements2.change();
      br.add(shElements2.getState().toUpperCase());
    } 
    changeBread(false);
  }
}

void pastillaKeys() {
  println(PADDLE_WIDTH, PADDLE_HEIGHT);
  PADDLE_WIDTH = changeVariable(PADDLE_WIDTH, 0, 0, 0, amountChange)[0];
  PADDLE_HEIGHT = changeVariable(0, PADDLE_HEIGHT, 0, 0, amountChange)[1];
  Y_PALETA = changeVariable(0, 0, Y_PALETA, 0, amountChange)[2];
}

void fijosKeys() {
  if (key==ENTER) fijos.changeVertex();
  if (keyCode==8) fijos.removeVertex();
  if (fijos.poligonos[fijos.selected].vertices.size() > 0) {
    PVector pv = fijos.poligonos[fijos.selected].vertices.get(fijos.poligonos[fijos.selected].selected);
    fijos.poligonos[fijos.selected].updateVertex(changeVariableV( int(pv.x), int(pv.y), 1));
  }
  if (keyCode==9) {
    fijos.change();
  }
}

PVector changeVariableV(int hor, int ver, int amount) {
  if (keyCode == UP ) {
    ver-=amount;
  } else if (keyCode == DOWN ) {
    ver+=amount;
  } else if (keyCode == LEFT ) {
    hor-=amount;
  } else if (keyCode == RIGHT ) {
    hor+=amount;
  }
  PVector pv = new PVector(hor, ver);
  return pv;
}

void tiempoKeys() {
  INTERFAZ_TIEMPO_X = changeVariable(INTERFAZ_TIEMPO_X, 0, 0, 0, amountChange)[0];
  INTERFAZ_Y = changeVariable(0, INTERFAZ_Y, 0, 0, amountChange)[1];
}

void worldTopKeys() {
  WORLD_TOP_X = changeVariable(WORLD_TOP_X, 0, 0, 0, amountChange)[0];
  WORLD_TOP_Y = changeVariable(0, WORLD_TOP_Y, 0, 0, amountChange)[1];
}

void worldBottomKeys() {
  WORLD_BOTTOM_X = changeVariable(WORLD_BOTTOM_X, 0, 0, 0, amountChange)[0];
  WORLD_BOTTOM_Y = changeVariable(0, WORLD_BOTTOM_Y, 0, 0, amountChange)[1];
}

void puntosKeys() {
  INTERFAZ_PUNTOS_X = changeVariable(INTERFAZ_PUNTOS_X, 0, 0, 0, amountChange)[0];
  INTERFAZ_Y = changeVariable(0, INTERFAZ_Y, 0, 0, amountChange)[1];
}

void relojKeys() {
  X_RELOJ = changeVariable(X_RELOJ, 0, 0, 0, amountChange)[0];
  Y_RELOJ = changeVariable(0, Y_RELOJ, 0, 0, amountChange)[1];
  TAM_RELOJ = changeVariable(0, 0, TAM_RELOJ, 0, amountChange)[2];
}

//CALIBRACION ---> ELEMENTOS ---> VENTANAS
void ventanasKeys() {
  if (keyCode == 9) { //BARRA ESPACIADORA
    selectedWindow = selectedWindow == 0 ? 1 : 0;
  }
  if (shWindows.getState() == "posicion") {
    windows[selectedWindow].x = changeVariable(windows[selectedWindow].x, 0, 0, 0, amountChange)[0];
    windows[selectedWindow].y = changeVariable(0, windows[selectedWindow].y, 0, 0, amountChange)[1];
  } else if (shWindows.getState() == "dimension") {
    windows[selectedWindow].ancho = changeVariable(windows[selectedWindow].ancho, 0, 0, 0, amountChange)[0];
    windows[selectedWindow].alto = changeVariable(0, windows[selectedWindow].alto, 0, 0, amountChange)[1];
  } else if (shWindows.getState() == "altoArco") {
    windows[selectedWindow].altoArco = changeVariable(0, windows[selectedWindow].altoArco, -0, 0, amountChange)[1];
    BRICK_HEIGHT = changeVariable(0, 0, BRICK_HEIGHT, 0, amountChange)[2];
  } else if (shWindows.getState() == "barrotes") {
    CANTIDAD_BARROTES = changeVariable(0, CANTIDAD_BARROTES, -0, 0, 1)[1];
    STROKE_BARROTE = changeVariable(0, 0, STROKE_BARROTE, 0, 1)[2];
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
    packLadrillos.x = changeVariable(packLadrillos.x, 0, 0, 0, amountChange)[0];
    packLadrillos.y = changeVariable(0, packLadrillos.y, 0, 0, amountChange)[1];
  } else if (shBricks.getState() == "dimension total") {
    packLadrillos.ancho = changeVariable(packLadrillos.ancho, 0, 0, 0, amountChange)[0];
    packLadrillos.alto = changeVariable(0, packLadrillos.alto, 0, 0, amountChange)[1];
  } else if (shBricks.getState() == "posicion fila") {
    FilaLadrillos r = packLadrillos.filas.get(selectedBrickRow);
    r.x=changeVariable(r.x, 0, 0, 0, amountChange)[0];
    r.y = changeVariable(0, r.y, 0, 0, amountChange)[1];
  } else if (shBricks.getState() == "dimension fila") {
    FilaLadrillos r = packLadrillos.filas.get(selectedBrickRow);
    r.ancho=changeVariable(r.ancho, 0, 0, 0, amountChange)[0];
    r.alto = changeVariable(0, r.alto, 0, 0, amountChange)[1];
  } else if (shBricks.getState() == "posicion ladrillo") {
    FilaLadrillos r = packLadrillos.filas.get(selectedBrickRow);
    Ladrillo l = r.ladrillos.get(selectedBrick);
    l.x=changeVariable(l.x, 0, 0, 0, amountChange)[0];
    l.y = changeVariable(0, l.y, 0, 0, amountChange)[1];
  } else if (shBricks.getState() == "dimension ladrillo") {
    FilaLadrillos r = packLadrillos.filas.get(selectedBrickRow);
    Ladrillo l = r.ladrillos.get(selectedBrick);
    l.ancho = changeVariable(packLadrillos.ancho, 0, 0, 0, amountChange)[0];
    l.alto = changeVariable(0, packLadrillos.alto, 0, 0, amountChange)[1];
  }



  if (br.menuDepth == 2) {
    if (keyCode == 17) { //CTRL
      shBricks.change();
      br.add(shBricks.getState().toUpperCase());
    } 
    changeBread(false);
  }
}

int [] changeVariable(int hor, int ver, int ancho, int alto, int amount) {
  if (keyCode == UP ) {
    ver-=amount;
  } else if (keyCode == DOWN ) {
    ver+=amount;
  } else if (keyCode == LEFT ) {
    hor-=amount;
  } else if (keyCode == RIGHT ) {
    hor+=amount;
  } else if (key == '+' ) {
    ancho+=amount;
  } else if (key == '-' ) {
    ancho-=amount;
  }
  int res [] = {hor, ver, ancho, alto};
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