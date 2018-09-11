import fisica.*;
import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surf;

PGraphics offscreen;

boolean CALIBRADOR;
Juego juego;

PVector surfaceMouse;

void setup() {
  size( 1024, 768, P3D);

  //IMAGENES ANIMACIONES
  loadImages();

  //SONIDO
  initSounds();

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
  loadElements2();

  //INIT FISICA
  initFisica();

  //INIT STATE HANDLERS
  initStateHandlers();

  //VARIABLES GLOBALES
  CALIBRADOR = false; 

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
  juego.reset();
}

void draw() {
  offscreen.beginDraw();
  //FRAMERATE
  surface.setTitle(str(frameRate));
  surfaceMouse = surf.getTransformedMouse();
  background(50);
  offscreen.background(50);
  if (CALIBRADOR) {
    if (shCal.getState() == "color") {
      imprimirGestoresDeColores();
    } else if (shCal.getState() == "kinect") {
      drawKinect();
    } else if (shCal.getState() == "keystone") {
      drawKeystone(20);
    } else if (shCal.getState() == "elementos 2") {
      drawElements2();
    } else {
      drawElements();
    }
  } else {
    kinect.actualizar();
    drawFisica();
    juego.draw();
  }
  mostrarCartel();
  offscreen.endDraw();
  surf.render(offscreen);
}

void keyPressed() {
  //println("keycode", keyCode);
  if (!CALIBRADOR && juego.state=="animacion" && key == ENTER) {
    juego.triggerAparicion();
  }
  if (!CALIBRADOR && juego.state=="inicio" && key == ENTER) {
    resetAll(true);
  }



  if (!CALIBRADOR && key == 'r' || key == 'R' ) {
    //resetAll(true);
    juego.resetInicio();
    detenerTodosLosSonidos();
  }

  if (key == 'c'|| key == 'C' ) {
    CALIBRADOR =!CALIBRADOR;
    juego.resetInicio();
  }
  //USAR KINECT
  if (key == 'k'|| key == 'K' ) useKinect=!useKinect;
  if (key == 'l'|| key == 'L' ) ks.load();

  if (!CALIBRADOR && key == 'b') {
    if (juego.state == "juego") {
      juego.bolaMedieval.soltar();
    }
  }

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
    saveFijos();
    saveConfig();
    ks.save();
  }

  if (key == 'e') {
    saltar();
  }

  //if (!CALIBRADOR) {
  //  println("MIN VELOC", MIN_VELOCITY, "paddle width", PADDLE_WIDTH);
  //  if (key == '+') {
  //    MIN_VELOCITY+=10;
  //  } else if (key == '-') {
  //    MIN_VELOCITY-=10;
  //  } else if (key == '1') {
  //    PADDLE_WIDTH-=10;
  //  } else if (key == '2') {
  //    PADDLE_WIDTH+=10;
  //  }
  //}
}

void end() {
}


void mouseDragged() {
  //COLOR
  if ( shCal.getState() == "color" ) {
    ejecutarClickEnColores(int(surfaceMouse.x), int(surfaceMouse.y));
  }
}



void mousePressed() {

  //COLOR
  if ( CALIBRADOR && shCal.getState() == "color" ) {
    ejecutarClickEnColores(int(surfaceMouse.x), int(surfaceMouse.y));
  }
  if ( CALIBRADOR && shCal.getState() == "elementos 2" && shElements2.getState() == "fijos") {
    fijos.poligonos[fijos.selected].addVertex(int(surfaceMouse.x), int(surfaceMouse.y));
  }
}