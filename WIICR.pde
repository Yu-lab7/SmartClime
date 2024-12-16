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

boolean isInitializedImages = false;
boolean isInitializedDates = false;
boolean isInitializedWeather = false;
boolean isInitializedRoomTemperature = false;
boolean isInitializedRoomHumidity = false;
boolean isInitializedRisk = false;
boolean isInitializedClothes = false;

final String AD_PATH = "ad/"; //広告画像が格納されているフォルダのパス
final String WEATHER_PATH = "weather/"; //天気画像が格納されているフォルダのパス
final String TEMPERATURE_PATH = "temperature/"; //気温画像が格納されているフォルダのパス
final String HUMIDITY_PATH = "humidity/"; //湿度画像が格納されているフォルダのパス
final String RISK_PATH = "risk/"; //リスク画像が格納されているフォルダのパス
final String CLOTHES_PATH = "clothes/"; //服装画像が格納されているフォルダのパス
final String HEAVY_PATH = "heavy/"; //防寒具画像が格納されているフォルダのパス
final String TTS_PATH = "..\\WIICR\\python\\ttsAbout.py";
final String TTS_PATH2 = "..\\WIICR\\python\\ttsAbout2.py";
final String AI_PATH = "..\\WIICR\\python\\suggestClothes.py";
final String AI_PATH2 = "..\\WIICR\\python\\suggestClothes2.py";
final String FORM_PATH = "..\\WIICR\\python\\form.py";
final String WAVE_PATH = "..\\WIICR\\python\\openWav.py";

String LOCATION =  "";// 現在位置を設定

//色の宣言
color WHITE_COLOR; 

color NEARLY_WHITE_COLOR;
color NEARLY_GREEN_COLOR; 
color BLACK_COLOR; 
color LIGHT_COLOR; 
color GRAY_COLOR;
color GREEN_COLOR;
color RED_COLOR;

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

boolean isUpdatedWeather = false; //データが正しく取得できたか確認
float latitude = 0;
float longitude = 0;
PImage weatherIcon;
float temperature = 0.0;
int humidity = 0;
String  weatherString = "";
float tempMax = 0.0;
float tempMin = 0.0;
PGraphics weatherBackground;

//TemperatureRModuleの変数
boolean isUpdatedTemperature = false; //データが正しく取得できたか確認 
PGraphics temperatureBackground; //気温の背景画像
float temp = 0.0; //温度の変数

//HumidityRModuleの変数
float hum = 0.0; //湿度の変数
PGraphics humidityBackground; //湿度の背景画像

//RiskRModuleの変数
float riskNum = 0.0; //室内外温度の差
PGraphics riskBackground; //リスクの背景画像
PGraphics riskShowSpring; //春のリスクの背景画像
PGraphics riskShowSummer; //夏のリスクの背景画像
PGraphics riskShowAutumn; //秋のリスクの背景画像
PGraphics riskShowWinter; //冬のリスクの背景画像
String riskStringSpring;
String riskStringSummer;
String riskStringAutumn;
String riskStringWinter;
String adviseStringSpring;
String adviseStringSummer;
String adviseStringAutumn;
String adviseStringWinter;
String riskSpring;
String riskSummer;
String riskAutumn;
String riskWinter;
String adviseSpring;
String adviseSummer;
String adviseAutumn;
String adviseWinter;

//ClothesRModuleの変数
PGraphics clothesBackground; //服装の背景画像
PGraphics heavyOutfitBackground; //防寒具の背景画像
String[] outfit; //服装の変数
String heavyOutfit; //防寒具の変数
PGraphics clothesGlove; //手袋の画像
PGraphics clothesScarf; //マフラーの画像
PGraphics clothesHansode;//半袖シャツ
PGraphics longsleevedshirt; //長袖シャツ
PGraphics cardigan; //カーディガン
PGraphics sweaterM; //セーター
PGraphics sweaterW; //セーター
PGraphics toren; //トレンチコート
PGraphics winterCoat; //冬コートの半袖
PGraphics downCoat; //ダウンコート
PGraphics waterProof; //防水
PGraphics lightWeight; //軽量
PGraphics lightWeight2; //軽量
PGraphics mask; //マスク
PGraphics clothesHat; //帽子
PGraphics sunglasses; //サングラス
 
//AI作成のための変数
String is_cold_sensitive = "0"; //寒がりかどうか
String is_hot_sensitive = "0"; //暑がりかどうか

int nowPageID = -1; //現在のページを設定

//RMに影をつける
final int SHADOW_ALPHA = 60;
final int SHADOW_PADDING = 20;
PGraphics moduleShadowS;
PGraphics moduleShadowM;
PGraphics moduleShadowL;

//月の定義
int march = 3;
int april = 4;
int may = 5;

int june = 6;
int july = 7;
int august = 8;

int september = 9;
int october = 10;
int november = 11;

int december = 12;
int january = 1;
int february = 2;

//アンケート画面の設定
String[] reserve;
boolean isFirstLaunch = true; //初回起動かどうか
String nickname = ""; //ニックネーム
String morningTime = "7:00";
String[] morningTimeHT = new String[2];  //朝の時間
String nightTime = "20:00";
String[] nightTimeHT = new String[2]; //夜の時間
int checkMorningOrNight = 0;
int currentDate = -1; 
int lastExecutionDate = -1;
int checkOpened = 0;

boolean debugMode = true; //デバックモードを設定

//パソコン向けにスクリーンを設定
void settings() {
    size(1920,1080);
    //fullScreen(); //1980*1080
}

//初回描画時に実行
void setup() { 
    frameRate(1); //描画処理を毎秒一回更新する
    //noCursor(); //マウスカーソルの削除
    colorMode(HSB,360,100,100,100); //色の設定をHSBに設定
    
    WHITE_COLOR = color(0,0,100);
    NEARLY_WHITE_COLOR = color(100,2,98);
    NEARLY_GREEN_COLOR = color(100,5,98);
    BLACK_COLOR = color(0,0,0);
    LIGHT_COLOR = color(0,0,80);
    GRAY_COLOR = color(0,0,50);
    GREEN_COLOR = color(150,100,60);
    RED_COLOR = color(0,100,100);
    
    textFont(createFont("Noto Sans CJK jp Bold" ,32)); //テキストフォントの追加
    
    background = loadImage("background.jpg");
    
    connectWithPython3();
    checkSubmitForm();

    thread("initialize");
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
    currentDate = day();
    if(currentDate != lastExecutionDate){
        checkOpened = 0;
        lastExecutionDate = currentDate;
    }

    if (nowPageID == 0) {
        drawFullImageModule(background);
        drawWeatherRModule(Area.area1);
        drawTemperatureRModule(Area.area5);
        drawHumidityRModule(Area.area6);
        drawRiskRModule(Area.area3);
    } else if (nowPageID == 1) {
        drawFullImageModule(background);
        drawClothesRModule(Area.area1);
        drawHeavyOutfitRModule(Area.area3);
    }
    drawDateModule();
    drawLocationModule();
    drawProgressBarModule();
    drawPageControlModule();
    drawRight(Area.area8);
    if((morningTimeHT[0].equals(String.valueOf(hour)) && morningTimeHT[1].equals(String.valueOf(minute))) && checkOpened == 0){
        if(outfit.length == 1){
            callTTSPythonScript(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),setRiskString(),setAdviseString(),outfit[0],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
        } else {
            callTTSPythonScript2(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),setRiskString(),setAdviseString(),outfit[0],outfit[1],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
        }
        openWaveFile();
        checkOpened = 1;
    } 

    if((nightTimeHT[0].equals(String.valueOf(hour)) && nightTimeHT[1].equals(String.valueOf(minute))) && checkOpened == 0){
        checkMorningOrNight = 1;
        updateWeather2(String.valueOf(year) + "-" + String.valueOf(month) + "-" + String.valueOf(day));
        if(outfit.length == 1){
            callTTSPythonScript(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),setRiskString(),setAdviseString(),outfit[0],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
        } else {
            callTTSPythonScript2(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),setRiskString(),setAdviseString(),outfit[0],outfit[1],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
        }
        openWaveFile();
        checkMorningOrNight = 0;
        checkOpened = 1;
    }
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
    Clothes,
    HeavyOutfit,
    Right
}

Size moduleSize(RModule module) {
    if(module == RModule.Weather) return Size.M;
    if(module == RModule.Temperature) return Size.S;
    if(module == RModule.Humidity) return Size.S;
    if(module == RModule.Risk) return Size.L;
    if(module == RModule.Clothes) return Size.L;
    if(module == RModule.HeavyOutfit) return Size.L;
    if(module == RModule.Right) return Size.S;
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
        LOCATION = json.getString("state_prov");    
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