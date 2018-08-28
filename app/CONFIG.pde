void saveConfig() {
  JSONObject jsonConfig;
  jsonConfig = new JSONObject();
  JSONObject v;
  v= new JSONObject();
  v.setInt("minVelocity", minVelocity);
  v.setInt("brickHeight", brickHeight);
  v.setInt("brickWidth", brickWidth);
  v.setInt("numArcBricks", numArcBricks);
  v.setInt("sizeBall", sizeBall);

  v.setInt("xReloj", xReloj);
  v.setInt("yReloj", yReloj);
  v.setInt("tamReloj", tamReloj);
  v.setInt("tiempoCountdown", tiempoCountdown);

  v.setInt("puntosLadrillo", puntosLadrillo);
  v.setInt("tiempoJuego", tiempoJuego);

  jsonConfig.setJSONObject("config", v);
  saveJSONObject(jsonConfig, "data/config.json");
}

void loadConfig() {
  JSONObject jsonConfig;
  jsonConfig = loadJSONObject("config.json");
  JSONObject c = jsonConfig.getJSONObject("config");
  minVelocity = c.getInt("minVelocity");
  brickHeight = c.getInt("brickHeight");
  brickWidth = c.getInt("brickWidth");
  numArcBricks = c.getInt("numArcBricks");
  sizeBall = c.getInt("sizeBall");
  tamReloj= c.getInt("tamReloj");
  yReloj= c.getInt("yReloj");
  xReloj= c.getInt("xReloj");

  puntosLadrillo= c.getInt("puntosLadrillo");
  tiempoJuego= c.getInt("tiempoJuego");
  tiempoCountdown= c.getInt("tiempoCountdown");
}