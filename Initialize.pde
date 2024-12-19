void initialize(){
  fetchLocation(); //緯度と経度の取得
    
  if(debugMode == false){
    //Arduinoからのデータ取得
    sensor = new Serial(this, SERIAL_PORT, 9600); //シリアル通信の設定
    sensor.clear(); //シリアル通信のバッファをクリア
    sensor.bufferUntil('\n'); //改行コードまでのバッファを設定
  }

  initializeDate();
  isInitializedDates = true; 

  initializeShadow();
  initializeRModuleBackground(); 
  isInitializedImages = true;
  isInitializedRoomTemperature = true;
  isInitializedRoomHumidity = true;
  isInitializedRisk = true;

  connectWithPython(String.valueOf(temperature),weatherString,is_cold_sensitive,is_hot_sensitive);
  connectWithPython2(String.valueOf(tempMax),String.valueOf(tempMin),is_cold_sensitive,is_hot_sensitive);
  isInitializedClothes = true;
  
  isUpdatedWeather = updateWeather();
  isInitializedWeather = true;
  /*if(outfit.length == 1){
            callTTSPythonScript(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),setRiskString(),setAdviseString(),outfit[0],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
            openWaveFile();
        } else {
            callTTSPythonScript2(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),setRiskString(),setAdviseString(),outfit[0],outfit[1],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
            openWaveFile();
        }*/
    if((morningTimeHT[0].equals(String.valueOf(hour)) && morningTimeHT[1].equals(String.valueOf(minute)))){
        if(outfit.length == 1){
            callTTSPythonScript(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),riskStringSummer,adviseStringSummer,outfit[0],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
            openWaveFile();
        } else {
            callTTSPythonScript2(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),riskStringSummer,adviseStringSummer,outfit[0],outfit[1],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
            openWaveFile();
        }
    } 

    if((nightTimeHT[0].equals(String.valueOf(hour)) && nightTimeHT[1].equals(String.valueOf(minute)))){
        checkMorningOrNight = 1;
        if(outfit.length == 1){
            callTTSPythonScript(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),riskStringSummer,adviseStringSummer,outfit[0],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
            openWaveFile();
        } else {
            callTTSPythonScript2(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),riskStringSummer,adviseStringSummer,outfit[0],outfit[1],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
            openWaveFile();
        }
        checkMorningOrNight = 0;
    }
  updateNowPageID(true);

    println("現在の緯度:"+latitude);
    println("現在の経度:"+longitude);
    println("現在の気温:"+temperature);
    println("現在の湿度:"+humidity);
    println("現在の天気:"+weatherString);
    println("現在の部屋の温度"+temp);
    println("現在の部屋の湿度"+hum);
    println("最高気温:"+tempMax);
    println("最低気温:"+tempMin);
  
}

void initializeGrid(){
  grid = createGraphics(width,height);
  
  grid.beginDraw();
  
  grid.colorMode(HSB,360,100,100,100);
  grid.stroke(0,0,50); //線や図形の輪郭線を設定 
  grid.strokeWeight(3); //幅を設定
  
  //垂直の基準線
  grid.line(layoutGuideX(Area.area1),0,layoutGuideX(Area.area1),height);
  grid.line(layoutGuideX(Area.area2),0,layoutGuideX(Area.area2),height);
  grid.line(layoutGuideX(Area.area3),0,layoutGuideX(Area.area3),height);
  grid.line(layoutGuideX(Area.area4),0,layoutGuideX(Area.area4),height);
  
  //水平の基準線
  grid.line(0,layoutGuideY(Area.area1),width,layoutGuideY(Area.area1));
  grid.line(0,layoutGuideY(Area.area5),width,layoutGuideY(Area.area5));
  
  grid.endDraw();
}

void initializePlaceholder(){
  placeholder = createGraphics(width,height);
  if (placeholder == null) {
    println("Error: Failed to create placeholder graphics");
    return;
  }
  
  placeholder.beginDraw();
  
  placeholder.colorMode(HSB,360,100,100,100);
  for(Area area: Area.values()){
    // モジュール配置エリアに角丸四角の枠を描く
    placeholder.noFill();
    placeholder.stroke(0,0,50);
    placeholder.strokeWeight(5);
    placeholder.rect(layoutGuideX(area),layoutGuideY(area),moduleWidth(Size.S),moduleHeight(Size.S),MODULE_RECT_ROUND);
  }
  
  placeholder.endDraw();
}

void initializeDate(){
  updateDate();
  if(!updateIsHoliday()) println("initializeDate(); ネットワークに接続できているか確認してください.");
  youbi = calcYoubi(year(),month(),day());
  youbiString = youbiToString(youbi);
}

void initializeRModuleBackground() {
  RModule module;
  int w;
  int h;
  PImage back;
  //----------------------------------------//
  //1ページ目の背景画像の設定
  //----------------------------------------//

  //エリア5の背景画像の設定
  module = RModule.Temperature;
  w = moduleWidth( moduleSize(module) );
  h = moduleHeight( moduleSize(module) );
  back = loadImage(TEMPERATURE_PATH + "background.jpg");
  if (back == null) {
    println("Error: Could not load image from " + TEMPERATURE_PATH + "background.jpg");
  }
  temperatureBackground = createGraphics(w, h);

  temperatureBackground.beginDraw();
  temperatureBackground.colorMode(HSB, 360, 100, 100, 100);
  temperatureBackground.image( pImageCut(back, CENTER, CENTER, w, h) , 0, 0);
  temperatureBackground.fill(0, 0, 0, 40);
  temperatureBackground.noStroke();
  temperatureBackground.rect(0, 0, w, h);
  temperatureBackground.endDraw();
  temperatureBackground.mask( sizeToModuleMask( moduleSize(module) ) );
  

  //エリア1とエリア2の背景画像の設定
  module = RModule.Weather;
  w = moduleWidth( moduleSize(module) );
  h = moduleHeight( moduleSize(module) );
  back = loadImage(WEATHER_PATH + "background.jpg");
  if (back == null) {
    println("Error: Could not load image from " + WEATHER_PATH + "background.jpg");
  }
  weatherBackground = createGraphics(w, h);
 
  weatherBackground.beginDraw();
  weatherBackground.colorMode(HSB, 360, 100, 100, 100);
  weatherBackground.image( pImageCut(back, CENTER, CENTER, w, h) , 0, 0);
  weatherBackground.fill(0, 0, 0, 40);
  weatherBackground.noStroke();
  weatherBackground.rect(0, 0, w, h);
  weatherBackground.endDraw();
  weatherBackground.mask( sizeToModuleMask( moduleSize(module) ) );


  //エリア6の背景画像の設定
  module = RModule.Humidity;
  w = moduleWidth( moduleSize(module) );
  h = moduleHeight( moduleSize(module) );
  back = loadImage(HUMIDITY_PATH + "background.jpg");
  if (back == null) {
    println("Error: Could not load image from " + HUMIDITY_PATH + "background.jpg");
  }
  humidityBackground = createGraphics(w, h);

  humidityBackground.beginDraw();
  humidityBackground.colorMode(HSB, 360, 100, 100, 100);
  humidityBackground.image( pImageCut(back, CENTER, CENTER, w, h) , 0, 0);
  humidityBackground.fill(0, 0, 0, 40);
  humidityBackground.noStroke();
  humidityBackground.rect(0, 0, w, h);
  humidityBackground.endDraw();
  humidityBackground.mask( sizeToModuleMask( moduleSize(module) ) );

  //エリア3,4,7,8の背景画像の設定
  module = RModule.Risk;
  w = moduleWidth( moduleSize(module) );
  h = moduleHeight( moduleSize(module) );
  back = loadImage(RISK_PATH + "background.jpg");
  if (back == null) {
    println("Error: Could not load image from " + RISK_PATH + "background.jpg");
  }
  riskBackground = createGraphics(w, h);

  riskBackground.beginDraw();
  riskBackground.colorMode(HSB, 360, 100, 100, 100);
  riskBackground.image( pImageCut(back, CENTER, CENTER, w, h) , 0, 0);
  riskBackground.fill(0, 0, 0, 40);
  riskBackground.noStroke();
  riskBackground.rect(0, 0, w, h);
  riskBackground.endDraw();
  riskBackground.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(RISK_PATH + "riskShowSummer.png");
  if (back == null) {
    println("Error: Could not load image from " + RISK_PATH + "riskShowSummer.png");
  }
  riskShowSpring = createGraphics(w, h);

  riskShowSpring.beginDraw();
  riskShowSpring.colorMode(HSB, 360, 100, 100, 100);
  riskShowSpring.image(  pImageCut(back, CENTER, CENTER, w, h) , -850, -950, 3*w, 3*h);
  riskShowSpring.fill(0, 0, 0, 0);
  riskShowSpring.noStroke();
  riskShowSpring.rect(0, 0, w, h);
  riskShowSpring.endDraw();
  //riskShowSpring.mask( sizeToModuleMask( moduleSize(module) ) );

  back =loadImage(RISK_PATH + "riskShowSummer.png");
  if (back == null) {
    println("Error: Could not load image from " + RISK_PATH + "riskShowSummer.png");
  }
  riskShowSummer = createGraphics(w, h);
  
  riskShowSummer.beginDraw();
  riskShowSummer.colorMode(HSB, 360, 100, 100, 100);
  riskShowSummer.image( pImageCut(back, CENTER, CENTER, w, h) , -850, -950, 3*w, 3*h);
  riskShowSummer.fill(0, 0, 0, 0);
  riskShowSummer.noStroke();
  riskShowSummer.rect(0, 0, w, h);
  riskShowSummer.endDraw();
  //riskShowSummer.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(RISK_PATH + "riskShowWinter.png");
  if (back == null) {
    println("Error: Could not load image from " + RISK_PATH + "riskShowWinter.png");
  }
  riskShowAutumn = createGraphics(w, h);

  riskShowAutumn.beginDraw();
  riskShowAutumn.colorMode(HSB, 360, 100, 100, 100);
  riskShowAutumn.image( pImageCut(back, CENTER, CENTER, w, h) , -850, -950, 3*w, 3*h);
  riskShowAutumn.fill(0, 0, 0, 0);
  riskShowAutumn.noStroke();
  riskShowAutumn.rect(0, 0, w, h);
  riskShowAutumn.endDraw();
  //riskShowWinter.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(RISK_PATH + "riskShowWinter.png");
  if (back == null) {
    println("Error: Could not load image from " + RISK_PATH + "riskShowWinter.png");
  }
  riskShowWinter = createGraphics(w, h);

  riskShowWinter.beginDraw();
  riskShowWinter.colorMode(HSB, 360, 100, 100, 100);
  riskShowWinter.image(  pImageCut(back, CENTER, CENTER, w, h) , -850, -950, 3*w, 3*h);
  riskShowWinter.fill(0, 0, 0, 0);
  riskShowWinter.noStroke();
  riskShowWinter.rect(0, 0, w, h);
  riskShowWinter.endDraw();
  //riskShowWinter.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(RISK_PATH + "dry.png");
  if (back == null) {
    println("Error: Could not load image from " + RISK_PATH + "dry.png");
  }
  riskDry = createGraphics(w, h);

  riskDry.beginDraw();
  riskDry.colorMode(HSB, 360, 100, 100, 100);
  riskDry.image( pImageCut(back, CENTER, CENTER, w, h) , -850, -950, 3*w, 3*h);
  riskDry.fill(0, 0, 0, 0);
  riskDry.noStroke();
  riskDry.rect(0, 0, w, h);
  riskDry.endDraw();

  back = loadImage(RISK_PATH + "shikke.png");
  if (back == null) {
    println("Error: Could not load image from " + RISK_PATH + "shikke.png");
  }
  riskShikke = createGraphics(w, h);

  riskShikke.beginDraw();
  riskShikke.colorMode(HSB, 360, 100, 100, 100);
  riskShikke.image( pImageCut(back, CENTER, CENTER, w, h) , -850, -950, 3*w, 3*h);
  riskShikke.fill(0, 0, 0, 0);
  riskShikke.noStroke();
  riskShikke.rect(0, 0, w, h);
  riskShikke.endDraw();

  //----------------------------------------//
  //2ページ目の背景画像の設定
  //----------------------------------------//

  //エリア1の背景画像の設定
  module = RModule.Clothes;
  w = moduleWidth( moduleSize(module) );
  h = moduleHeight( moduleSize(module) );
  back = loadImage(CLOTHES_PATH + "background.jpg");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "background.jpg");
  }
  clothesBackground = createGraphics(w, h);

  clothesBackground.beginDraw();
  clothesBackground.colorMode(HSB, 360, 100, 100, 100);
  clothesBackground.image( pImageCut(back, CENTER, CENTER, w, h) , 0, 0);
  clothesBackground.fill(0, 0, 0, 0);
  clothesBackground.noStroke();
  clothesBackground.rect(0, 0, w, h);
  clothesBackground.endDraw();
  clothesBackground.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(HEAVY_PATH + "background.jpg");
  if (back == null) {
    println("Error: Could not load image from " + HEAVY_PATH + "background.jpg");
  }
  heavyOutfitBackground = createGraphics(w, h);

  heavyOutfitBackground.beginDraw();
  heavyOutfitBackground.colorMode(HSB, 360, 100, 100, 100);
  heavyOutfitBackground.image( pImageCut(back, CENTER, CENTER, w, h) , 0, 0);
  heavyOutfitBackground.fill(0, 0, 0, 0);
  heavyOutfitBackground.noStroke();
  heavyOutfitBackground.rect(0, 0, w, h);
  heavyOutfitBackground.endDraw();
  heavyOutfitBackground.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(HEAVY_PATH + "glove.png");
  if (back == null) {
    println("Error: Could not load image from " + HEAVY_PATH + "glove.png");
  }
  clothesGlove = createGraphics(w, h);

  clothesGlove.beginDraw();
  clothesGlove.colorMode(HSB, 360, 100, 100, 100);
  clothesGlove.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  clothesGlove.fill(0, 0, 0, 0);
  clothesGlove.noStroke();
  clothesGlove.rect(0, 0, w, h);
  clothesGlove.endDraw();
  //clothesGlove.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(HEAVY_PATH + "scarf.png");
  if (back == null) {
    println("Error: Could not load image from " + HEAVY_PATH + "scarf.png");
  }
  clothesScarf = createGraphics(w, h);

  clothesScarf.beginDraw();
  clothesScarf.colorMode(HSB, 360, 100, 100, 100);
  clothesScarf.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  clothesScarf.fill(0, 0, 0, 0);
  clothesScarf.noStroke();
  clothesScarf.rect(0, 0, w, h);
  clothesScarf.endDraw();
  //clothesScarf.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(HEAVY_PATH + "hat.png");
  if (back == null) {
    println("Error: Could not load image from " + HEAVY_PATH + "hat.png");
  }
  clothesHat = createGraphics(w, h);

  clothesHat.beginDraw();
  clothesHat.colorMode(HSB, 360, 100, 100, 100);
  clothesHat.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  clothesHat.fill(0, 0, 0, 0);
  clothesHat.noStroke();
  clothesHat.rect(0, 0, w, h);
  clothesHat.endDraw();

  back = loadImage(HEAVY_PATH + "sunglass.png");
  if (back == null) {
    println("Error: Could not load image from " + HEAVY_PATH + "sunglass.png");
  }
  sunglasses = createGraphics(w, h);

  sunglasses.beginDraw();
  sunglasses.colorMode(HSB, 360, 100, 100, 100);
  sunglasses.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  sunglasses.fill(0, 0, 0, 0);
  sunglasses.noStroke();
  sunglasses.rect(0, 0, w, h);
  sunglasses.endDraw();

  back = loadImage(CLOTHES_PATH + "hansode.png");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "hansode.png");
  }
  clothesHansode = createGraphics(w, h);

  clothesHansode.beginDraw();
  clothesHansode.colorMode(HSB, 360, 100, 100, 100);
  clothesHansode.image( pImageCut(back, CENTER, CENTER, w, h) ,-450, -550, 2*w, 2*h);
  clothesHansode.fill(0, 0, 0, 0);
  clothesHansode.noStroke();
  clothesHansode.rect(0, 0, w, h);
  clothesHansode.endDraw();
 // clothesHansode.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "nagasode.png");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "nagasode.png");
  }
  longsleevedshirt = createGraphics(w, h);

  longsleevedshirt.beginDraw();
  longsleevedshirt.colorMode(HSB, 360, 100, 100, 100);
  longsleevedshirt.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  longsleevedshirt.fill(0, 0, 0, 0);
  longsleevedshirt.noStroke();
  longsleevedshirt.rect(0, 0, w, h);
  longsleevedshirt.endDraw();
  //longsleevedshirt.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "cardigan.jpg");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "cardigan.jpg");
  }
  cardigan = createGraphics(w, h);

  cardigan.beginDraw();
  cardigan.colorMode(HSB, 360, 100, 100, 100);
  cardigan.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  cardigan.fill(0, 0, 0, 0);
  cardigan.noStroke();
  cardigan.rect(0, 0, w, h);
  cardigan.endDraw();
  //cardigan.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "seta_m.jpg");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "seta_m.jpg");
  }
  sweaterM = createGraphics(w, h);
  
  sweaterM.beginDraw();
  sweaterM.colorMode(HSB, 360, 100, 100, 100);
  sweaterM.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  sweaterM.fill(0, 0, 0, 0);
  sweaterM.noStroke();
  sweaterM.rect(0, 0, w, h);
  sweaterM.endDraw();
  //sweaterM.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "seta_w.jpg");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "seta_w.jpg");
  }
  sweaterW = createGraphics(w, h);

  sweaterW.beginDraw();
  sweaterW.colorMode(HSB, 360, 100, 100, 100);
  sweaterW.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  sweaterW.fill(0, 0, 0, 0);
  sweaterW.noStroke();
  sweaterW.rect(0, 0, w, h);
  sweaterW.endDraw();
  //sweaterW.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "torenchi.png");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "torenchi.png");
  }
  toren = createGraphics(w, h);

  toren.beginDraw();
  toren.colorMode(HSB, 360, 100, 100, 100);
  toren.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  toren.fill(0, 0, 0, 0);
  toren.noStroke();
  toren.rect(0, 0, w, h);
  toren.endDraw();
  //toren.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "wintercoat.jpg");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "wintercoat.jpg");
  }
  winterCoat = createGraphics(w, h);

  winterCoat.beginDraw();
  winterCoat.colorMode(HSB, 360, 100, 100, 100);
  winterCoat.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  winterCoat.fill(0, 0, 0, 0);
  winterCoat.noStroke();
  winterCoat.rect(0, 0, w, h);
  winterCoat.endDraw();
  //winterCoat.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "downCoat.png");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "downCoat.png");
  }
  downCoat = createGraphics(w, h);

  downCoat.beginDraw();
  downCoat.colorMode(HSB, 360, 100, 100, 100);
  downCoat.image( pImageCut(back, CENTER, CENTER, w, h) ,-450, -550, 2*w, 2*h);
  downCoat.fill(0, 0, 0, 0);
  downCoat.noStroke();
  downCoat.rect(0, 0, w, h);
  downCoat.endDraw();
  //downCoat.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "bousuisei.png");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "bousuisei.png");
  }
  waterProof = createGraphics(w, h);

  waterProof.beginDraw();
  waterProof.colorMode(HSB, 360, 100, 100, 100);
  waterProof.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  waterProof.fill(0, 0, 0, 0);
  waterProof.noStroke();
  waterProof.rect(0, 0, w, h);
  waterProof.endDraw();
  //waterProof.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "haorimono.jpg");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "haorimono.jpg");
  }
  lightWeight = createGraphics(w, h);

  lightWeight.beginDraw();
  lightWeight.colorMode(HSB, 360, 100, 100, 100);
  lightWeight.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  lightWeight.fill(0, 0, 0, 0);
  lightWeight.noStroke();
  lightWeight.rect(0, 0, w, h);
  lightWeight.endDraw();
  //lightWeight.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "haorimono_w.jpg");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "haorimono_w.jpg");
  }
  lightWeight2 = createGraphics(w, h);

  lightWeight2.beginDraw();
  lightWeight2.colorMode(HSB, 360, 100, 100, 100);
  lightWeight2.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  lightWeight2.fill(0, 0, 0, 0);
  lightWeight2.noStroke();
  lightWeight2.rect(0, 0, w, h);
  lightWeight2.endDraw();
  //lightWeight2.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(CLOTHES_PATH + "mask.jpg");
  if (back == null) {
    println("Error: Could not load image from " + CLOTHES_PATH + "mask.jpg");
  }
  mask = createGraphics(w, h);

  mask.beginDraw();
  mask.colorMode(HSB, 360, 100, 100, 100);
  mask.image( pImageCut(back, CENTER, CENTER, w, h) , -450, -550, 2*w, 2*h);
  mask.fill(0, 0, 0, 0);
  mask.noStroke();
  mask.rect(0, 0, w, h);
  mask.endDraw();
  //mask.mask( sizeToModuleMask( moduleSize(module) ) );
}

void initializeShadow() {
  Size size;
  int w;
  int h;
  
  // 影はモジュールよりも少し大きいサイズにする
  size = Size.S;
  w = moduleWidth(size) + SHADOW_PADDING * 2;
  h = moduleHeight(size) + SHADOW_PADDING * 2;
  
  // 影の画像を生成する
  moduleShadowS = createGraphics(w, h);
  moduleShadowS.beginDraw();
  moduleShadowS.colorMode(HSB, 360, 100, 100, 100);
  moduleShadowS.noStroke();
  moduleShadowS.fill(0, 0, 0, SHADOW_ALPHA);
  moduleShadowS.rect(SHADOW_PADDING, SHADOW_PADDING,
                     moduleWidth(size), moduleHeight(size),
                     MODULE_RECT_ROUND);
  moduleShadowS.filter(BLUR, 8); // にじませる
  moduleShadowS.endDraw();
  
  // 影はモジュールよりも少し大きいサイズにする
  size = Size.M;
  w = moduleWidth(size) + SHADOW_PADDING * 2;
  h = moduleHeight(size) + SHADOW_PADDING * 2;
  
  // 影の画像を生成する
  moduleShadowM = createGraphics(w, h);
  moduleShadowM.beginDraw();
  moduleShadowM.colorMode(HSB, 360, 100, 100, 100);
  moduleShadowM.noStroke();
  moduleShadowM.fill(0, 0, 0, SHADOW_ALPHA);
  moduleShadowM.rect(SHADOW_PADDING, SHADOW_PADDING,
                     moduleWidth(size), moduleHeight(size),
                     MODULE_RECT_ROUND);
  moduleShadowM.filter(BLUR, 8); // にじませる
  moduleShadowM.endDraw();
  
  // 影はモジュールよりも少し大きいサイズにする
  size = Size.L;
  w = moduleWidth(size) + SHADOW_PADDING * 2;
  h = moduleHeight(size) + SHADOW_PADDING * 2;
  
  // 影の画像を生成する
  moduleShadowL = createGraphics(w, h);
  moduleShadowL.beginDraw();
  moduleShadowL.colorMode(HSB, 360, 100, 100, 100);
  moduleShadowL.noStroke();
  moduleShadowL.fill(0, 0, 0, SHADOW_ALPHA);
  moduleShadowL.rect(SHADOW_PADDING, SHADOW_PADDING,
                     moduleWidth(size), moduleHeight(size),
                     MODULE_RECT_ROUND);
  moduleShadowL.filter(BLUR, 8); // にじませる
  moduleShadowL.endDraw();
}