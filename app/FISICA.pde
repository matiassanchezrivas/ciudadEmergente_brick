
FBody[] steps = new FBody[20];
FWorld world;

//=================================================================

void setupFisica() {
  Fisica.init(this);
  world = new FWorld();
}
//------------------------------------------------

void drawFisica() {
  world.step();
  world.draw();
} 