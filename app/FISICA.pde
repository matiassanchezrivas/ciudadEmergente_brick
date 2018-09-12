FWorld world;
FWorld worldBola;

int BRICK_HEIGHT;
int BRICK_WIDTH;
int NUM_ARC_BRICKS;
int MIN_VELOCITY_NIVEL1;
int MIN_VELOCITY_NIVEL2;
int SIZE_BALL;
int PADDLE_WIDTH;
int PADDLE_HEIGHT;

int WORLD_TOP_X;
int WORLD_TOP_Y;
int WORLD_BOTTOM_X;
int WORLD_BOTTOM_Y;



//=================================================================v
void initFisica() {
  //WORLD
  Fisica.init(this);
  WORLD_BOTTOM_X=width;
  WORLD_BOTTOM_Y=height*2;
  world = new FWorld();
  worldBola = new FWorld();
  world.setEdges(WORLD_TOP_X, WORLD_TOP_Y, WORLD_BOTTOM_X, WORLD_BOTTOM_Y);
  fisicaCalibracion.reset();
}

//------------------------------------------------
void drawFisica() {
  if (CALIBRADOR || juego.state=="juego" || juego.state=="gameOver" || juego.state=="muertePorBolaMedieval") {
    world.step();
    //world.draw();
    worldBola.step();
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
  if (juego.state=="juego" && result.getBody1().getName()!="brick" && result.getBody2().getName()=="bola") {
    //sonidista.ejecutarSonido(0);
    rebote();
  } else if (result.getBody1().getName()=="brick" && result.getBody2().getName()=="bola") {
    FBody b = result.getBody1();
    b.setFill(255, 255, 0);
    b.setName("brick_dead");
    world.remove(b);
    rebote();
  }
  
  if (juego.state=="juego" && (result.getBody1().getName()=="paleta" && result.getBody2().getName()=="bola") || (result.getBody1().getName()=="bola" && result.getBody2().getName()=="paleta")) {
    sonidista.ejecutarSonido(0);
  } else if (juego.state=="juego" && (result.getBody1().getName()=="bolaMedieval" && result.getBody2().getName()=="paleta") || (result.getBody1().getName()=="paleta" && result.getBody2().getName()=="bolaMedieval")) {
    juego.muertePorBolaMedieval=true;
  };
  // Trigger your sound here
  // ...
}

void resetWorld() {
  worldBola = new FWorld();
  world = new FWorld();
  world.setGravity(0, 1000);
  worldBola.setGravity(0, 2000);

  world.setEdges(WORLD_TOP_X, -500, WORLD_BOTTOM_X, WORLD_BOTTOM_Y+400);
}

void resetAll(boolean game) {
  resetWorld();

  if (game) {

    juego.reset();
  } else {
    world.setEdges(WORLD_TOP_X, WORLD_TOP_Y, WORLD_BOTTOM_X, WORLD_BOTTOM_Y);
  }
}