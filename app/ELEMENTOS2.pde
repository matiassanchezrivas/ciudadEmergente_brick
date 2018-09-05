void drawElements2() {
  juego.interfaz.draw();
  offscreen.pushStyle();
  offscreen.imageMode(CENTER);
  offscreen.fill(255);
  offscreen.image(juego.countdown.reloj, X_RELOJ, Y_RELOJ, TAM_RELOJ, TAM_RELOJ);

  offscreen.noFill();
  offscreen.stroke(255);
  offscreen.strokeWeight(5);
  offscreen.rectMode(CORNERS);
  offscreen.rect(WORLD_TOP_X, WORLD_TOP_Y, WORLD_BOTTOM_X, WORLD_BOTTOM_Y);

  offscreen.popStyle();
}