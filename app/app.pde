import fisica.*;

boolean CALIBRADOR;
Juego juego;

void setup() {
  size( 1200, 900);
  
  //BREADCRUMB
  initBreadcrumb();
  
  //CARGAR TIPOGRAFÍAS
  loadTipografias();
  
  //CARGAR ELEMENTOS DE DB
  loadElements();
  
  //INIT FISICA
  initFisica();
  
  //INIT STATE HANDLERS
  initStateHandlers();
  
  //VARIABLES GLOBALES
  CALIBRADOR = true; 
  
  //CONF PROCESSING
  smooth();
  
  //CARGAR CONFIGURACIÓN
  loadConfig();
  
  //BIOPUS
  iniciarCartel();
  iniciarColores();
  iniciarKinect();

  //GUARDAR BRICKS
  saveBricks();
  
  //JUEGO
  juego = new Juego();
}

void draw() {
  //FRAMERATE
  surface.setTitle(str(frameRate));
  
  
  background(50);
  if (CALIBRADOR) {
    if (shCal.getState() == "color") {
      imprimirGestoresDeColores();
    } else if (shCal.getState() == "kinect") {
      drawKinect();
    } else {
      drawElements();
    }
    mostrarCartel();
  } else {
    kinect.actualizar();
    drawFisica();
    juego.draw();
  }
}

void keyPressed() {
  //println("keycode", keyCode);
  if (key == 'c'|| key == 'C' ) {
    CALIBRADOR =!CALIBRADOR;
    resetAll();
  }
  //RESET
  if (key == 'r'|| key == 'R' ) resetAll();
  //USAR KINECT
  if (key == 'k'|| key == 'K' ) useKinect=!useKinect;
  
  //CALIBRADOR
  if (CALIBRADOR) {
    calKeys();
  };
  
  //CTRL
  if (keyCode == 17) {
    reiniciarCartel();
  }
  
  //GUARDAR
  if (key == 's') {
    saveElements();
    saveConfig();
  }
}

void mouseDragged() {
  //COLOR
  if ( shCal.getState() == "color" ) {
    ejecutarClickEnColores();
  }
}

void mousePressed() {
  //COLOR
  if ( shCal.getState() == "color" ) {
    ejecutarClickEnColores();
  }
}