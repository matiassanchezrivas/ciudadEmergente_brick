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
}

//------------------------------------------------
void drawFisica() {
  world.step();
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
  if (result.getBody1().getName()=="brick") {
    FBody b = result.getBody1();
    b.setFill(255, 255, 0);
    b.setName("brick_dead");
    world.remove(b);
  };
  // Trigger your sound here
  // ...
}

void resetAll() {
  world = new FWorld();
  world.setEdges();
  juego.reset();
}