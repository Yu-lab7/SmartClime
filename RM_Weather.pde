void drawWeatherRModule(Area area){
  RModule module = RModule.Weather;
  Size size = moduleSize(module);
  
  int x = layoutGuideX(area);
  int y = layoutGuideY(area);
  int w = moduleWidth(size);
  int h = moduleHeight(size);

  image(rmoduleShadowImage(size), x-SHADOW_PADDING, y-SHADOW_PADDING); 

  if (weatherBackground != null) {
    image(weatherBackground, x, y, w, h);
  } else {
    println("RM_Weather: weatherBackgroundが設定されていません.");
  }
  
  
  drawText(LEFT, BASELINE, WHITE_COLOR, 32, "現在の大阪府の天気", x+50, y+50);
  drawText(LEFT, BASELINE, WHITE_COLOR, 16, "気象データ提供元: OpenWeather(TM)", x+50, y+100);
  
  if (isUpdatedWeather) {
    drawText(LEFT, BASELINE, WHITE_COLOR, 64, int(temperature)+"℃ / "+humidity+"%", x+50, y+160);
    drawText(LEFT, BASELINE, WHITE_COLOR, 42, weatherString, x+50, y+260);
    image(weatherIcon, x+w-h, y+50, h, h);
  } else {
    fill(0, 0, 0, 50);
    noStroke();
    rect(x, y, w, h, MODULE_RECT_ROUND);
    
    drawText(CENTER, CENTER, WHITE_COLOR, 24, "WeatherModule\nデータを取得できません", x+w/2, y+h/2);
  }
}

boolean updateWeather(){
  try{
    //現在の天気を取得
    final String url = openWeatherURL(latitude,longitude,WEATHER_API_KEY);
    final processing.data.JSONObject json = loadJSONObject(url);
    final processing.data.JSONArray weather = json.getJSONArray("weather");
    weatherString = weather.getJSONObject(0).getString("main");
  
    //天気の説明を取得
    JSONObject main = json.getJSONObject("main");
    temperature = main.getFloat("temp");
    humidity = main.getInt("humidity"); 
    tempMax = main.getFloat("temp_max");
    tempMin = main.getFloat("temp_min");

    //華氏温度を摂氏温度に変換
    temperature = temperature - 273.15;
    tempMax = tempMax - 273.15;
    tempMin = tempMin - 273.15;
  
    //現在の天気に対応する画像を取得
    final String iconCode = weather.getJSONObject(0).getString("icon");
    weatherIcon = loadImage("http://openweathermap.org/img/wn/" + iconCode + "@2x.png");
    
    if (weatherIcon == null) {
      println("Failed to load weather.png");
    }
    
    println("updateWeather():天気情報を取得しました.");
    return true;
  } catch (Exception e){
    println("updateWeather(): 天気情報を取得できませんでした。" + e);
    return false;
  }
}

String openWeatherURL(float latitude, float longitude, String apiKey){
  return "https://api.openweathermap.org/data/2.5/weather?lat="+ latitude + "&lon="+ longitude +"&appid="+apiKey;
}
