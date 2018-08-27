FWorld world;

int brickHeight = 60;
int brickWidth = 60;
int numArcBricks = 10;
int minVelocity = 500;
int sizeBall = 40;
int paddleWidth = 300;
int paddleHeight = 60;

//=================================================================v
void setupFisica() {
  //WORLD
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();

  resetWindows();
}
//------------------------------------------------

void drawFisica() {
  world.step();
  //PELOTA
  FBody bola = getBody("bola");
  if (bola != null) {
    float velx = bola.getVelocityX();
    float vely = bola.getVelocityY();
    velx = (velx > 0) ? minVelocity : -minVelocity;
    vely = (vely > 0) ? minVelocity : -minVelocity;
    bola.setVelocity(velx, vely);
  }

  //PALETA
  FBody paleta = getBody("paleta");
  if (paleta != null) {
    paleta.setPosition(mouseX, height-100);
  }   
  //world.draw();
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
    b.setName("brick_dead");
    world.remove(b);
    //b.addImpulse(100, 100);
  };
  // Trigger your sound here
  // ...
}

void resetWindows() {

}



void resetAll() {
  world = new FWorld();
  world.setEdges();

  juego.reset();

  resetWindows();
}