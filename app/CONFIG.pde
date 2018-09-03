void saveConfig() {
  JSONObject jsonConfig;
  jsonConfig = new JSONObject();
  JSONObject v;
  v= new JSONObject();
  v.setInt("MIN_VELOCITY", MIN_VELOCITY);
  
  v.setInt("BRICK_HEIGHT", BRICK_HEIGHT);
  v.setInt("BRICK_WIDTH", BRICK_WIDTH);
  
  v.setInt("NUM_ARC_BRICKS", NUM_ARC_BRICKS);
  
  v.setInt("SIZE_BALL", SIZE_BALL);
  
  v.setInt("X_RELOJ", X_RELOJ);
  v.setInt("Y_RELOJ", Y_RELOJ);
  v.setInt("TAM_RELOJ", TAM_RELOJ);
  
  v.setInt("TIEMPO_COUNTDOWN", TIEMPO_COUNTDOWN);
  
  v.setInt("PADDLE_WIDTH", PADDLE_WIDTH);
  v.setInt("PADDLE_HEIGHT", PADDLE_HEIGHT);

  v.setInt("WORLD_TOP_X", WORLD_TOP_X);
  v.setInt("WORLD_TOP_Y", WORLD_TOP_Y);
  v.setInt("WORLD_BOTTOM_X", WORLD_BOTTOM_X);
  v.setInt("WORLD_BOTTOM_Y", WORLD_BOTTOM_Y);

  v.setInt("PUNTOS_LADRILLO", PUNTOS_LADRILLO);
  v.setInt("TIEMPO_JUEGO", TIEMPO_JUEGO);

  jsonConfig.setJSONObject("config", v);
  saveJSONObject(jsonConfig, "data/config.json");
}

void loadConfig() {
  JSONObject jsonConfig;
  jsonConfig = loadJSONObject("config.json");
  JSONObject c = jsonConfig.getJSONObject("config");
  MIN_VELOCITY = c.getInt("MIN_VELOCITY");
  
  BRICK_HEIGHT = c.getInt("BRICK_HEIGHT");
  BRICK_WIDTH = c.getInt("BRICK_WIDTH");
  
  NUM_ARC_BRICKS = c.getInt("NUM_ARC_BRICKS");
  
  SIZE_BALL = c.getInt("SIZE_BALL");
  
  TAM_RELOJ= c.getInt("TAM_RELOJ");
  Y_RELOJ= c.getInt("Y_RELOJ");
  X_RELOJ= c.getInt("X_RELOJ");
  
  TIEMPO_COUNTDOWN = c.getInt("TIEMPO_COUNTDOWN");
  
  PADDLE_WIDTH = c.getInt("PADDLE_WIDTH");
  PADDLE_HEIGHT = c.getInt("PADDLE_HEIGHT");
  
  WORLD_TOP_X = c.getInt("WORLD_TOP_X");
  WORLD_TOP_Y = c.getInt("WORLD_TOP_Y");
  WORLD_BOTTOM_X = c.getInt("WORLD_BOTTOM_X");
  WORLD_BOTTOM_Y = c.getInt("WORLD_BOTTOM_Y");
  
  PUNTOS_LADRILLO= c.getInt("PUNTOS_LADRILLO");
  TIEMPO_JUEGO= c.getInt("TIEMPO_JUEGO");
  TIEMPO_COUNTDOWN= c.getInt("TIEMPO_COUNTDOWN");
}

//TIPOS
PFont consolasBold30;
void loadTipografias () {
  consolasBold30 = loadFont("Consolas-Bold-30.vlw");
}