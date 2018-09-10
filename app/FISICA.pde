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

int RANDOM_ANGLE_CHANGE;

int cadaCuantos=10;
int golpes=0;
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
  if (CALIBRADOR || juego.state=="juego") {
    world.step();
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
    sonidista.ejecutarSonido(0);
    generarRandomAngle();
    if (golpes%cadaCuantos ==0) generarRandomAngle(); 
    else resetRandomAngle();
    println(RANDOM_ANGLE);
    
    golpes++;
  } else if (result.getBody1().getName()=="brick" && result.getBody2().getName()=="bola") {
    FBody b = result.getBody1();
    b.setFill(255, 255, 0);
    b.setName("brick_dead");
    world.remove(b);
    if (golpes%cadaCuantos ==0) generarRandomAngle(); 
    else resetRandomAngle();
    golpes++;
  };
  // Trigger your sound here
  // ...
}

void resetAll(boolean game) {
  worldBola = new FWorld();
  world = new FWorld();
  world.setGravity(0, 2000);
  worldBola.setGravity(0, 2000);

  if (game) {
    world.setEdges(WORLD_TOP_X, WORLD_TOP_Y, WORLD_BOTTOM_X, WORLD_BOTTOM_Y+400);
    juego.reset();
  } else {
    world.setEdges(WORLD_TOP_X, WORLD_TOP_Y, WORLD_BOTTOM_X, WORLD_BOTTOM_Y);
  }
}

void generarRandomAngle() {
  RANDOM_ANGLE=int(random(-RANDOM_ANGLE_CHANGE, RANDOM_ANGLE_CHANGE));
  RANDOM_ANGLE2=int(random(-RANDOM_ANGLE_CHANGE, RANDOM_ANGLE_CHANGE));
}

void resetRandomAngle() {
  RANDOM_ANGLE=0;
  RANDOM_ANGLE2=0;
}