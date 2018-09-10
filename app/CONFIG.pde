void saveConfig() {
  //JSONObject jsonConfig;
  //jsonConfig = new JSONObject();
  //JSONObject v;
  //v= new JSONObject();
  //v.setInt("MIN_VELOCITY_NIVEL1", MIN_VELOCITY_NIVEL1);
  //v.setInt("MIN_VELOCITY_NIVEL2", MIN_VELOCITY_NIVEL2);

  //v.setInt("BRICK_HEIGHT", BRICK_HEIGHT);
  //v.setInt("BRICK_WIDTH", BRICK_WIDTH);

  //v.setInt("NUM_ARC_BRICKS", NUM_ARC_BRICKS);

  //v.setInt("SIZE_BALL", SIZE_BALL);

  //v.setInt("X_RELOJ", X_RELOJ);
  //v.setInt("Y_RELOJ", Y_RELOJ);
  //v.setInt("TAM_RELOJ", TAM_RELOJ);

  //// v.setInt("INTERFAZ_PUNTOS_X", INTERFAZ_PUNTOS_X);

  ////v.setInt("INTERFAZ_TIEMPO_X", INTERFAZ_TIEMPO_X);
  //v.setInt("INTERFAZ__Y", INTERFAZ_Y);

  //v.setInt("TIEMPO_COUNTDOWN", TIEMPO_COUNTDOWN);
  //v.setInt("TIEMPO_COUNTDOWN_INTRAVIDA", TIEMPO_COUNTDOWN_INTRAVIDA);
  //v.setInt("TIEMPO_JUEGO", TIEMPO_JUEGO);

  //v.setInt("PADDLE_WIDTH", PADDLE_WIDTH);
  //v.setInt("PADDLE_HEIGHT", PADDLE_HEIGHT);

  //v.setInt("WORLD_TOP_X", WORLD_TOP_X);
  //v.setInt("WORLD_TOP_Y", WORLD_TOP_Y);
  //v.setInt("WORLD_BOTTOM_X", WORLD_BOTTOM_X);
  //v.setInt("WORLD_BOTTOM_Y", WORLD_BOTTOM_Y);

  //v.setInt("X_RELOJ", X_RELOJ);
  //v.setInt("Y_RELOJ", Y_RELOJ);
  //v.setInt("TAM_RELOJ", TAM_RELOJ);

  //v.setInt("PUNTOS_LADRILLO", PUNTOS_LADRILLO);
  //v.setInt("STROKE_BRICK", STROKE_BRICK);
  //v.setInt("FACTOR_RANDOM", FACTOR_RANDOM);

  //jsonConfig.setJSONObject("config", v);
  //saveJSONObject(jsonConfig, "data/config.json");
}

void loadConfig() {
  JSONObject jsonConfig;
  jsonConfig = loadJSONObject("config.json");
  JSONObject c = jsonConfig.getJSONObject("config");
  MIN_VELOCITY_NIVEL1 = c.getInt("MIN_VELOCITY_NIVEL1");
  MIN_VELOCITY_NIVEL2 = c.getInt("MIN_VELOCITY_NIVEL2");

  BRICK_HEIGHT = c.getInt("BRICK_HEIGHT");
  BRICK_WIDTH = c.getInt("BRICK_WIDTH");

  NUM_ARC_BRICKS = c.getInt("NUM_ARC_BRICKS");

  SIZE_BALL = c.getInt("SIZE_BALL");

  TAM_RELOJ= c.getInt("TAM_RELOJ");
  Y_RELOJ= c.getInt("Y_RELOJ");
  X_RELOJ= c.getInt("X_RELOJ");

  TIEMPO_COUNTDOWN = c.getInt("TIEMPO_COUNTDOWN");
  TIEMPO_COUNTDOWN_INTRAVIDA = c.getInt("TIEMPO_COUNTDOWN_INTRAVIDA");

  PADDLE_WIDTH = c.getInt("PADDLE_WIDTH");
  PADDLE_HEIGHT = c.getInt("PADDLE_HEIGHT");

  WORLD_TOP_X = c.getInt("WORLD_TOP_X");
  WORLD_TOP_Y = c.getInt("WORLD_TOP_Y");
  WORLD_BOTTOM_X = c.getInt("WORLD_BOTTOM_X");
  WORLD_BOTTOM_Y = c.getInt("WORLD_BOTTOM_Y");

  PUNTOS_LADRILLO= c.getInt("PUNTOS_LADRILLO");
  TIEMPO_COUNTDOWN= c.getInt("TIEMPO_COUNTDOWN");

  STROKE_BRICK= c.getInt("STROKE_BRICK");
  FACTOR_RANDOM= c.getInt("FACTOR_RANDOM");

  INTERFAZ_Y = c.getInt("INTERFAZ_Y");

  TIEMPO_JUEGO_NIVEL1  = c.getInt("TIEMPO_JUEGO_NIVEL1");
  TIEMPO_JUEGO_NIVEL2 = c.getInt("TIEMPO_JUEGO_NIVEL2");

  FPS = c.getInt("FPS");

  X_BOLA_MEDIEVAL = c.getInt("X_BOLA_MEDIEVAL");
  Y_BOLA_MEDIEVAL = c.getInt("Y_BOLA_MEDIEVAL");
  TAM_BOLA_MEDIEVAL = c.getInt("TAM_BOLA_MEDIEVAL");

  TIEMPO_TRANSICION = c.getInt("TIEMPO_TRANSICION");

  CANTIDAD_VIDAS = c.getInt("CANTIDAD_VIDAS");
  BRICK_HEIGHT = c.getInt("BRICK_HEIGHT");

  PORCENTAJE_DESTRUCCION_ARCOS = c.getInt("PORCENTAJE_DESTRUCCION_ARCOS");
  DISTANCIA_EXPLOSION = c.getInt("DISTANCIA_EXPLOSION");

  STOP_ANGLE_1 = c.getInt("STOP_ANGLE_1");
  START_ANGLE_2 = c.getInt("START_ANGLE_2");
  START_ANGLE_1 = c.getInt("START_ANGLE_1");
  STOP_ANGLE_2 = c.getInt("STOP_ANGLE_2");
  Y_PALETA = c.getInt("Y_PALETA");
  
  RANDOM_ANGLE_CHANGE = c.getInt("RANDOM_ANGLE_CHANGE");
}

//TIPOS
PFont consolasBold30;
void loadTipografias () {
  consolasBold30 = loadFont("Consolas-Bold-30.vlw");
}