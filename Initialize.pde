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

  initializeImage();
  initializeGrid();
  initializePlaceholder();
  initializeShadow();
  initializeRModuleBackground(); 
  isInitializedImages = true;
  isInitializedRoomTemperature = true;
  isInitializedRoomHumidity = true;
  isInitializedRisk = true;
  isInitializedClothes = true;
  
  isUpdatedWeather = updateWeather();
  isInitializedWeather = true;

  updateNowPageID(true);
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

void initializeImage(){
  adImage = new PImage[AD_IMAGE_COUNT];
  for(int i= 0; i < AD_IMAGE_COUNT; i++){
    adImage[i] = loadImage(AD_PATH + "ad" + i + ".jpg");
  }
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
  riskShowSpring.image( pImageCut(back, CENTER, CENTER, w, h) , 0, 0);
  riskShowSpring.fill(0, 0, 0, 40);
  riskShowSpring.noStroke();
  riskShowSpring.rect(0, 0, w, h);
  riskShowSpring.endDraw();
  riskShowSpring.mask( sizeToModuleMask( moduleSize(module) ) );

  back =loadImage(RISK_PATH + "riskShowSummer.png");
  if (back == null) {
    println("Error: Could not load image from " + RISK_PATH + "riskShowSummer.png");
  }
  riskShowSummer = createGraphics(w, h);
  
  riskShowSummer.beginDraw();
  riskShowSummer.colorMode(HSB, 360, 100, 100, 100);
  riskShowSummer.image( pImageCut(back, CENTER, CENTER, w, h) , 0, 0);
  riskShowSummer.fill(0, 0, 0, 40);
  riskShowSummer.noStroke();
  riskShowSummer.rect(0, 0, w, h);
  riskShowSummer.endDraw();
  riskShowSummer.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(RISK_PATH + "riskShowWinter.png");
  if (back == null) {
    println("Error: Could not load image from " + RISK_PATH + "riskShowWinter.png");
  }
  riskShowWinter = createGraphics(w, h);

  riskShowWinter.beginDraw();
  riskShowWinter.colorMode(HSB, 360, 100, 100, 100);
  riskShowWinter.image( pImageCut(back, CENTER, CENTER, w, h) , 0, 0);
  riskShowWinter.fill(0, 0, 0, 40);
  riskShowWinter.noStroke();
  riskShowWinter.rect(0, 0, w, h);
  riskShowWinter.endDraw();
  riskShowWinter.mask( sizeToModuleMask( moduleSize(module) ) );

  back = loadImage(RISK_PATH + "riskShowWinter.png");
  if (back == null) {
    println("Error: Could not load image from " + RISK_PATH + "riskShowWinter.png");
  }
  riskShowWinter = createGraphics(w, h);

  riskShowWinter.beginDraw();
  riskShowWinter.colorMode(HSB, 360, 100, 100, 100);
  riskShowWinter.image( pImageCut(back, CENTER, CENTER, w, h) , 0, 0);
  riskShowWinter.fill(0, 0, 0, 40);
  riskShowWinter.noStroke();
  riskShowWinter.rect(0, 0, w, h);
  riskShowWinter.endDraw();
  riskShowWinter.mask( sizeToModuleMask( moduleSize(module) ) );
  

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
  clothesBackground.fill(0, 0, 0, 40);
  clothesBackground.noStroke();
  clothesBackground.rect(0, 0, w, h);
  clothesBackground.endDraw();
  clothesBackground.mask( sizeToModuleMask( moduleSize(module) ) );
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