//CALIBRACION
stateHandler shCal;
String [] shCalStates = {"elementos", "kinect", "keystone"};
//ELEMENTOS
stateHandler shElements;
String [] shElementStates = {"ventana", "bola", ""};
//VENTANAS
stateHandler shWindows;
String [] shWindowStates = {"posicion", "dimension", "altoArco"};

int selectedWindow =0;
int amountChange = 3;


void initStateHandlers() {
  shCal = new stateHandler(shCalStates);
  shElements = new stateHandler(shElementStates);
  shWindows = new stateHandler(shWindowStates);
}

//MODO CALIBRACIÓN
void calKeys() {
  if (keyCode == 17) { //CTRL cambiar modo calibrador
    shCal.change();
  }
  if (shCal.getState() == "elementos") {
    elementsKeys();
  }
}

//CALIBRACION "ELEMENTOS"
void elementsKeys() {
  if (keyCode == 9) { //TAB
    shElements.change();
  } 
  if (shElements.getState() == "ventana") {
    ventanasKeys();
  }
}

void ventanasKeys() {
  if (keyCode == 10) { //ENTER 
    shWindows.change();
  }
  else if (keyCode == 32) { //BARRA ESPACIADORA
    selectedWindow = selectedWindow == 0 ? 1 : 0;
  }
  if(shWindows.getState() == "posicion"){
    windows[selectedWindow].x = changeVariable(windows[selectedWindow].x, 0, amountChange)[0];
    windows[selectedWindow].y = changeVariable(0, windows[selectedWindow].y, amountChange)[1];
  } else if(shWindows.getState() == "dimension"){
    windows[selectedWindow].ancho = changeVariable(windows[selectedWindow].ancho, 0, amountChange)[0];
    windows[selectedWindow].alto = changeVariable(0, windows[selectedWindow].alto, amountChange)[1];
  }else if(shWindows.getState() == "altoArco"){
    windows[selectedWindow].altoArco = changeVariable(0, windows[selectedWindow].altoArco, -amountChange)[1];
  }
}

int [] changeVariable(int hor, int ver, int amount){
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
    println("estado cambio a ",e[cursor]);
  }

  String getState() {
    return e[cursor];
  }
}