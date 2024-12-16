import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

void updateWeather2(String targetDate){
  try{
    // 現在の天気を取得
    final String url = openWeatherURL2(latitude, longitude, WEATHER_API_KEY);
    final processing.data.JSONObject json = loadJSONObject(url);
    final processing.data.JSONArray list = json.getJSONArray("list");
    
    // ターゲットの日付を設定
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date date = sdf.parse(targetDate);
    Calendar cal = Calendar.getInstance();
    cal.setTime(date);
    cal.add(Calendar.DATE, 1); // 次の日に設定
    String tomorrowDate = sdf.format(cal.getTime());
    
    // 明日の天気データを取得
    for (int i = 0; i < list.size(); i++) {
      final processing.data.JSONObject weatherData = list.getJSONObject(i);
      String dt_txt = weatherData.getString("dt_txt").split(" ")[0];
      if (dt_txt.equals(tomorrowDate)) {
        final processing.data.JSONObject main = weatherData.getJSONObject("main");
        final processing.data.JSONArray weather = weatherData.getJSONArray("weather");
        
        temperature = main.getFloat("temp");
        humidity = main.getInt("humidity");
        weatherString = weather.getJSONObject(0).getString("main");
        
        // 華氏温度を摂氏温度に変換
        temperature = temperature - 273.15;
      }
    }
  } catch (Exception e){
    println("updateWeather2(): 明日の天気情報を取得できませんでした。" + e);
  }
}

String openWeatherURL2(float latitude, float longitude, String apiKey){
  return "https://api.openweathermap.org/data/2.5/forecast?lat="+ latitude + "&lon="+ longitude +"&appid="+apiKey;
}