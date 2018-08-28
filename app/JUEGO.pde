class Juego {
  String state;
  Paleta paleta;
  Pelota pelota;
  LadrillosGrilla ladrillosGrilla;
  LadrillosArcos ladrillosArcos;
  LadrillosVentana ladrillosVentana;
  Ventanas ventanas;

  Juego () {
    state = "countDown";
    paleta = new Paleta();
    pelota = new Pelota();
    ladrillosGrilla = new LadrillosGrilla();
    ladrillosArcos = new LadrillosArcos();
    ladrillosVentana = new LadrillosVentana();
    ventanas = new Ventanas();
  }

  void draw() {
    fill(0, 255);
    rect(0, 0, width, height);
    paleta.draw();
    pelota.draw();
    ladrillosGrilla.draw();
    ladrillosVentana.draw();
    ventanas.draw();
    ladrillosArcos.draw();
  }

  void reset() {
    pelota.reset();
    paleta.reset();
    ladrillosGrilla.reset();
    ladrillosArcos.reset();
    ladrillosVentana.reset();
    ventanas.reset();
  }
}
//------------------------------------------------