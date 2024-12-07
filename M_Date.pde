void updateDate(){
  year = year();
  month = month();
  day = day();
  hour = hour();
  minute = minute();
  second = second();
}

//曜日を計算する関数
Youbi calcYoubi(int year, int month, int day){
  final Youbi[] youbi = Youbi.values();
  if(month < 3){
    year--;
    month += 12;
  }
    return youbi[(year+year/4-year/100+year/400+(13*month+8)/5+day)%7];
}

String youbiToString(Youbi youbi) {
  String str = "";
  switch (youbi) {
    case Sun:
      str = "日";
      if(isHoliday) str += "・祝";
      break;
    case Mon:
      str = "月";
      if(isHoliday) str += "・祝";
      break;
    case Tue:
      str = "火";
      if(isHoliday) str += "・祝";
      break;
    case Wed:
      str = "水";
      if(isHoliday) str += "・祝";
      break;
    case Thu:
      str = "木";
      if(isHoliday) str += "・祝";
      break;
    case Fri:
      str = "金";
      if(isHoliday) str += "・祝";
      break;
    case Sat:
      str = "土";
      if(isHoliday) str += "・祝";
      break;
  }
  return str;
}

//祝日判定
boolean updateIsHoliday(){
  try{
    JSONObject json = loadJSONObject("https://holidays-jp.github.io/api/v1/date.json");
    
     // 現在の日付を取得
    String currentDate = year() + "-" + nf(month(), 2) + "-" + nf(day(), 2);
    
    // 休日情報の判定
    isHoliday = json.hasKey(currentDate); // 現在の日付がJSONキーに存在するか
    
    // 土曜日または日曜日も休日に追加判定
    //youbi2 = calcYoubi(year(),month(),day());
    //youbiString2 = youbiToString(youbi2);
    //if (youbiString2.equals("土") || youbiString2.equals("日")) {
      //isHoliday = true;
     //}
     
    } catch (Exception e){
    println("isHoliday():土日祝判定を取得できませんでした."+ e);
    return false;
  }
  
  print("isHoliday(): 土日祝判定を取得しました。");
  if (isHoliday) {
    println("今日は土日祝に含まれます。");
  } else {
    println("今日は平日です。");
  }
  return true;
}

void drawDateModule(){
  noStroke();
  String timeText = month + "月" + day + "日" + "（" + youbiString + "）" + nf(hour, 2) + ":" + nf(minute, 2) + ":" + nf(second, 2);
  drawText(LEFT, BASELINE, WHITE_COLOR, 36, timeText, 100, 30);
}
