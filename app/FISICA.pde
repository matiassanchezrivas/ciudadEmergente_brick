FWorld world;

int BRICK_HEIGHT = 60;
int BRICK_WIDTH = 60;
int NUM_ARC_BRICKS = 10;
int MIN_VELOCITY = 500;
int SIZE_BALL = 40;
int PADDLE_WIDTH = 300;
int PADDLE_HEIGHT = 60;

int WORLD_TOP_X=0;
int WORLD_TOP_Y=0;
int WORLD_BOTTOM_X=width;
int WORLD_BOTTOM_Y=height;

//=================================================================v
void initFisica() {
  //WORLD
  Fisica.init(this);
  WORLD_BOTTOM_X=width;
  WORLD_BOTTOM_Y=height*2;
  world = new FWorld();
  world.setEdges(WORLD_TOP_X, WORLD_TOP_Y, WORLD_BOTTOM_X, WORLD_BOTTOM_Y);
}

//------------------------------------------------
void drawFisica() {
  world.step();
} 

void fisicaImpulse() {
  ArrayList <FBody> bodies = world.getBodies();
  for (int i=0; i<bodies.size(); i++) {
    FBody b = bodies.get(i);
    if (b.getName() == "brick") {
      b.addImpulse(random(-1000000, 10000000), random(-1000000, 1000000));
    }
  }
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
  if (result.getBody1().getName()=="brick" && result.getBody2().getName()=="bola") {
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
  world.setGravity(0,1000);
  world.setEdges(WORLD_TOP_X, WORLD_TOP_Y, WORLD_BOTTOM_X, WORLD_BOTTOM_Y+400);
  juego.reset();
}