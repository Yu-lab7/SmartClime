import java.io.*;
import java.net.*;
import processing.serial.Serial;

Serial sensor;
PGraphics grid;//gridを表す変数
PGraphics placeholder; //枠を表す変数

final String SERIAL_PORT = "COM6"; //シリアルポートの設定
final int RESOLUTION = 1024; //解像度の設定

final int MODULE_RECT_ROUND = 30;
final int PROGRESSBAR_HEIGHT = 55;

PImage background;
PImage[] adImage;

final int STAY_SECOND = 10; //1ページ当たりの滞在秒数

final int PAGE_ALL_COUNT = 2; //全てのページの枚数
final int AD_IMAGE_COUNT = 1; //広告画像の枚数

                    // 起動画面用の初期化済フラグ [削除予定]
boolean isInitializedImages = false;
boolean isInitializedDates = false;
boolean isInitializedWeather = false;
boolean isInitializedRoomTeperature = false;
boolean isInitializedRoomHumidity = false;

final String AD_PATH = "ad/"; //広告画像が格納されているフォルダのパス
final String WEATHER_PATH = "weather/"; //天気画像が格納されているフォルダのパス
final String TEMPERATURE_PATH = "temperature/"; //気温画像が格納されているフォルダのパス
final String HUMIDITY_PATH = "humidity/"; //湿度画像が格納されているフォルダのパス
final String RISK_PATH = "risk/"; //リスク画像が格納されているフォルダのパス
final String CLOTHES_PATH = "clothes/"; //服装画像が格納されているフォルダのパス
final String TTS_PATH = "..\\DigitalSignate\\python\\tts.py";

final String LOCATION =  "大阪府";// 現在位置を設定

//色の宣言
color WHITE_COLOR; 

color NEARLY_WHITE_COLOR;
color NEARLY_GREEN_COLOR; 
color BLACK_COLOR; 
color LIGHT_COLOR; 
color GRAY_COLOR;
color GREEN_COLOR;

//時間の宣言
int year;
int month;
int day;
int hour;
int minute;
int second;
int beforeDay = day(); //日の更新用
int beforeSecond = second(); //秒の更新用

String youbiString;
String youbiString2;
Youbi youbi;
Youbi youbi2;
boolean isHoliday;

//              [isUpdate系の要素を追加予定]
boolean isUpdatedWeather = false; //データが正しく取得できたか確認
float latitude = 0;
float longitude = 0;
PImage weatherIcon;
float temperature = 0.0;
int humidity = 0;
String  weatherString = "";
PGraphics weatherBackground;

//TemperatureRModuleの変数
boolean isUpdatedTemperature = true; //データが正しく取得できたか確認 
PGraphics temperatureBackground; //気温の背景画像
float temp = 0.0; //温度の変数

//HumidityRModuleの変数
boolean isHumidity = true; //データが正しく取得できたか確認
boolean isUpdatedHumidity = true; //データが正しく取得できたか確認
float hum = 0.0; //湿度の変数
PGraphics humidityBackground; //湿度の背景画像

//RiskRModuleの変数
boolean isUpdatedRisk = true; //データが正しく取得できたか確認
PGraphics riskBackground; //リスクの背景画像

//ClothesRModuleの変数
boolean isUpdatedClothes = true; //データが正しく取得できたか確認
PGraphics clothesBackground; //服装の背景画像

int nowPageID = -1; //現在のページを設定

//RMに影をつける
final int SHADOW_ALPHA = 60;
final int SHADOW_PADDING = 20;
PGraphics moduleShadowS;
PGraphics moduleShadowM;
PGraphics moduleShadowL;

//月の定義
int  March = 3;
int  April = 4;
int  May = 5;

int  June = 6;
int  July = 7;
int  August = 8;

int  September = 9;
int  October = 10;
int  November = 11;

int  December = 12;
int  January = 1;
int  February = 2;

boolean debugMode = true; //デバックモードを設定

//パソコン向けにスクリーンを設定
void settings() {
    size(1920,1080);
    //fullScreen(); //1980*1080
}

//初回描画時に実行
void setup() { 
    frameRate(1); //描画処理を毎秒一回更新する
    noCursor(); //マウスカーソルの削除
    colorMode(HSB,360,100,100,100); //色の設定をHSBに設定
    
    WHITE_COLOR = color(0,0,100);
    NEARLY_WHITE_COLOR = color(100,2,98);
    NEARLY_GREEN_COLOR = color(100,5,98);
    BLACK_COLOR = color(0,0,0);
    LIGHT_COLOR = color(0,0,80);
    GRAY_COLOR = color(0,0,50);
    GREEN_COLOR = color(150,100,60);
    
    textFont(createFont("Noto Sans CJK jp Bold" ,32)); //テキストフォントの追加
    
    background = loadImage("background.jpg");
    //background = pImageCut(loadImage("background.jpg"),CENTER,CENTER,width,height);
    
    callTTSPythonScript("はろー");
    initialize();
}

void draw() {
    if (nowPageID == -1) {
    drawLaunchingScreenModule();
  } else {
    updateDates();
    drawModules();
  }
}

void updateDates() {
    updateDate();
    
    final boolean isUpdatedDay = (day != beforeDay);
    final boolean isUpdatedSecond = (second != beforeSecond);
    
    //日付の変更
    if (isUpdatedDay) {
        println("日付が変わりました.");
        
        if (!updateIsHoliday()) {
            println("ネットワークに接続できていない可能性があります。接続できているか確認してください。");
        }
        
        youbi = calcYoubi(year, month, day);
        youbiString = youbiToString(youbi);
        
        beforeDay = day;
}
    
    //秒の変更
    if (isUpdatedSecond) {  
        if (second % STAY_SECOND == 0) {
            updateNowPageID(true);
        }
        
        if (minute + second == 0) {
            println(hour + "時になりました.");
            isUpdatedWeather = updateWeather();
        }
        beforeSecond = second;
}
}

void drawModules() {
    if (nowPageID == 0) {
        drawFullImageModule(background);
        drawGridModule();
        drawPlaceholderModule();
        drawWeatherRModule(Area.area1);
        drawTemperatureRModule(Area.area5);
        drawHumidityRModule(Area.area6);
        drawRiskRModule(Area.area3);
} else if (nowPageID == 1) {
        drawFullImageModule(background);
        drawGridModule();
        drawPlaceholderModule();
}
    drawDateModule();
    drawLocationModule();
    drawProgressBarModule();
    drawPageControlModule();
}

//エリア数の定義
enum Area{
    area1,
    area2,
    area3,
    area4,
    area5,
    area6,
    area7,
    area8
}

//曜日の定義
enum Youbi{
    Sun,
    Mon,
    Tue,
    Wed,
    Thu,
    Fri,
    Sat
}

enum RModule{
    Weather,
    Temperature,
    Humidity,
    Risk,
    Clothes
}

Size moduleSize(RModule module) {
    if(module == RModule.Weather) return Size.M;
    if(module == RModule.Temperature) return Size.S;
    if(module == RModule.Humidity) return Size.S;
    if(module == RModule.Risk) return Size.L;
    if(module == RModule.Clothes) return Size.L;
    return Size.S;
}

//x座標の定義
int layoutGuideX(Area area) {
    if (area == Area.area1 || area == Area.area5) return 90;
    if (area == Area.area2 || area == Area.area6) return 535;
    if (area == Area.area3 || area == Area.area7) return 980;
    if (area == Area.area4 || area == Area.area8) return 1425;
    return 0;
}

//y座標の定義
int layoutGuideY(Area area) {
    if (area == Area.area1 || area == Area.area2 || area == Area.area3 || area == Area.area4) return 130;
    if (area == Area.area5 || area == Area.area6 || area == Area.area7 || area == Area.area8) return 560;
    return 0;
}

//モジュールのサイズ
enum Size{
    S,
    M,
    L
}

//モジュールの幅を定義
int moduleWidth(Size size) {
    if (size == Size.S) return 405;
    if (size == Size.M || size == Size.L) return 850;
    return 0;
}

//モジュールの高さを定義
int moduleHeight(Size size) {
    if (size == Size.S || size == Size.M) return 400;
    if (size == Size.L) return 830;
    return 0;
}

PImage pImageCut(PImage image, int modeX, int modeY, int afterWidth, int afterHeight) {
    int w = image.width;
    int h = image.height;
    
    //横方向の切り取り処理
    if(modeX == LEFT) image = image.get(0, 0, afterWidth, h);
    if(modeX == CENTER) image = image.get(w / 2 - afterWidth / 2, 0, afterWidth, h);
    if(modeX == RIGHT) image = image.get(w - afterWidth, 0, afterWidth, h);
    
    //縦方向の切り取り処理
    if(modeY == TOP) image = image.get(0, 0, afterWidth, afterHeight);
    if(modeY == CENTER) image = image.get(0, h / 2 - afterHeight / 2, afterWidth, afterHeight);
    if(modeY == BOTTOM) image = image.get(0, h - afterHeight, afterWidth, afterHeight);
    
    return image;
}

//現在のページを表示
void updateNowPageID(boolean isIncrement) {
    if(isIncrement) {
        nowPageID = (nowPageID + 1) % PAGE_ALL_COUNT; 
} else {
        nowPageID = (nowPageID + PAGE_ALL_COUNT - 1) % PAGE_ALL_COUNT; 
}
}
//テキストを描画
void drawText(int alignX, int alignY, color c, int size, String text, int x, int y) {
    pushStyle();
    textAlign(alignX,alignY);
    textSize(size);
    fill(c);
    if (alignY == BASELINE) {
        text(text,x,y + size);
} else {
        text(text,x,y);
}
    popStyle();
}

//緯度と経度の特定
void fetchLocation() {
    try {
        JSONObject json = loadJSONObject(ipgeolocation_API_KEY);
        latitude = json.getFloat("latitude");
        longitude = json.getFloat("longitude");
    } catch(Exception e) {
        println("Error: " + e.getMessage());
    }
}

PGraphics sizeToModuleMask(Size size) {
    int w = moduleWidth(size);
    int h = moduleHeight(size);
    PGraphics moduleBackgroundMask = createGraphics(w, h);
    
    moduleBackgroundMask.beginDraw();
    
    moduleBackgroundMask.noStroke();
    moduleBackgroundMask.fill(255);
    moduleBackgroundMask.rect(0, 0, w, h, MODULE_RECT_ROUND);
    
    moduleBackgroundMask.endDraw();
    
    return moduleBackgroundMask;
}

//Arduinoから温度と湿度の取得
void serialEvent(Serial serial) {
  if (serial != sensor) return;
  if (serial == null) return;

  String line = serial.readStringUntil('\n');
  line = trim(line);
  if (line == null || line.length() == 0) return;

  String[] tokens = split(line, ',');
  if (tokens.length < 2) return;

  temp = float(tokens[0]);
  hum = float(tokens[1]);
}

PGraphics rmoduleShadowImage(Size size) {
  if (size == Size.S) return moduleShadowS;
  if (size == Size.M) return moduleShadowM;
  if (size == Size.L) return moduleShadowL;
  return null;
}