import fisica.*;
import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surf;

PGraphics offscreen;

boolean CALIBRADOR;
Juego juego;

void setup() {
  size( 1200, 900, P3D);

  //KEYSTONE
  ks = new Keystone(this);
  surf = ks.createCornerPinSurface(1200, 900, 20);
  offscreen = createGraphics(1200, 900);

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
  offscreen.beginDraw();
  //FRAMERATE
  surface.setTitle(str(frameRate));
 PVector surfaceMouse = surf.getTransformedMouse();

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
  offscreen.background(255);
  offscreen.fill(0, 255, 0);
  offscreen.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75);
  offscreen.endDraw();
  surf.render(offscreen);
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

  switch(key) {
  case 'p':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;
  }

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