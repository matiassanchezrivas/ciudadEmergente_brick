FWorld world;

int brickHeight = 60;
int brickWidth = 60;
int numArcBricks = 10;
int minVelocity = 500;
int sizeBall = 40;

//=================================================================

void setupFisica() {
  //WORLD
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();

  resetBall();
  resetPaleta();
  resetWindows();

}
//------------------------------------------------

void drawFisica() {

  FBody bola = getBody("bola");
  if (bola != null) {

    float velx = bola.getVelocityX();
    float vely = bola.getVelocityY();

    velx = (velx > 0) ? minVelocity : -minVelocity;
    vely = (vely > 0) ? minVelocity : -minVelocity;

    bola.setVelocity(velx, vely);
  }

  FBody paleta = getBody("paleta");

  if (paleta != null) paleta.setPosition(mouseX, height-100);


  world.step();
  world.draw();
} 

FBody getBody(String bodyName) {
  ArrayList<FBody> bodies=world.getBodies();
  for (FBody b : bodies) {
    try {
      if (b.getName().equals(bodyName)) {
        return b;
      }
    }
    catch(NullPointerException e) {
      //println(e);
    }
  }

  return null;
}



void contactResult(FContactResult result) {
  // Draw an ellipse where the contact took place and as big as the normal impulse of the contact
  //ellipse(result.getX(), result.getY(), result.getNormalImpulse(), result.getNormalImpulse());
  if (result.getBody1().getName()=="brick") {
    FBody b = result.getBody1();
    b.setFill(255, 255, 0);
    world.remove(b);
    //b.addImpulse(100, 100);
  };
  // Trigger your sound here
  // ...
}

void resetBall(){
//BOLA
  FCircle bola = new FCircle(sizeBall);
  bola.setPosition(width/2, height/2);
  bola.setVelocity(1000, 1000);
  bola.setDensity(0.01);
  bola.setDamping(-1);
  bola.setName("bola");
  world.add(bola);
}

void resetWindows(){
for (Ventana ventana : windows) {
    //VENTANA
    FPoly v = new FPoly();
    int numPoints=40;
    float angle=PI/(float)numPoints;

    v.vertex(ventana.x, ventana.y);
    for (int i=0; i<numPoints; i++)
    {
      v.vertex(ventana.x+ventana.ancho/2+ventana.ancho/2*sin(HALF_PI+PI+angle*i), ventana.y+ventana.altoArco/2*cos(HALF_PI+TWO_PI+angle*i));
    } 
    v.vertex(ventana.x+ventana.ancho, ventana.y);
    v.vertex(ventana.x+ventana.ancho, ventana.y+ventana.alto);
    v.vertex(ventana.x, ventana.y+ventana.alto);
    v.setStatic(true);
    world.add(v);

    //LADRILLOS
    int numberBricks = int(ventana.alto/brickHeight);
    for (int i=0; i<numberBricks; i++)
    {
      //IZQUIERDA
      FBox b = new FBox(brickWidth, brickHeight);
      b.setName("brick");
      b.setStatic(true);
      b.setPosition(ventana.x+brickWidth/2-brickWidth, ventana.y+brickHeight/2+brickHeight*i);
      b.setFill(random(255), 0, 0);
      world.add(b);

      //DERECHA
      FBox c = new FBox(brickWidth, brickHeight);
      c.setName("brick");
      c.setStatic(true);
      c.setPosition(ventana.x+ventana.ancho+brickWidth/2, ventana.y+brickHeight/2+brickHeight*i);
      c.setFill(random(255), 0, 0);
      world.add(c);
    }

    //ARCO
    int _numPoints=15;
    int _numBricksArc=numArcBricks;
    float _angleSep = PI/_numBricksArc;
    float _angle=PI/_numBricksArc/(float)_numPoints;
    for (int j=0; j<_numBricksArc; j++) {
      FPoly a = new FPoly();
      for (int i=0; i<=_numPoints; i++)
      {
        a.vertex(ventana.x+ventana.ancho/2+ventana.ancho/2*sin(HALF_PI+PI+_angleSep*j+_angle*i), ventana.y+ventana.altoArco/2*cos(HALF_PI+TWO_PI+_angleSep*j+_angle*i));
      } 
      for (int i=_numPoints; i>=0; i--)
      {
        a.vertex(ventana.x+ventana.ancho/2+(ventana.ancho/2+brickHeight)*sin(HALF_PI+PI+_angleSep*j+_angle*i), ventana.y+(ventana.altoArco/2+brickHeight)*cos(HALF_PI+TWO_PI+_angleSep*j+_angle*i));
      } 
      a.setFill(random(255), 0, 0);
      a.setName("brick");
      a.setStatic(true);
      world.add(a);
    }
  }
}

void resetPaleta(){
  //PALETA
  FBox paleta = new FBox(300, 30);
  paleta.setName("paleta");
  paleta.setStatic(true);
  world.add(paleta);
}

void resetAll(){
  world = new FWorld();
  world.setEdges();

  resetBall();
  resetPaleta();
  resetWindows();
}