
FBody[] steps = new FBody[20];
FWorld world;


//=================================================================

void setupFisica() {
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0,0);
  world.setEdges();
  
  FCircle bola = new FCircle(40);
  bola.setPosition(width/2, height/2);
  bola.setVelocity(1000,1000);
  bola.setDamping(0);
  world.add(bola);

}
//------------------------------------------------

void drawFisica() {
  world.step();
  world.draw();
} 