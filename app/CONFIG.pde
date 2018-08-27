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
}