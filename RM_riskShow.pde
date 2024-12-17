void drawRiskRModule(Area area) {
    RModule module = RModule.Risk;
    Size size = moduleSize(module);
    
    int x = layoutGuideX(area);
    int y = layoutGuideY(area);
    int w = moduleWidth(size);
    int h = moduleHeight(size);
    
    image(rmoduleShadowImage(size), x - SHADOW_PADDING, y - SHADOW_PADDING);
    
    if (riskBackground != null) {
        image(riskBackground, x, y, w, h);
    } else {
        println("RM_Risk: riskBackgroundが設定されていません.");
    }
    
    String riskTitle = "リスク表示";
    drawText(CENTER,BASELINE,WHITE_COLOR,32,riskTitle,x + 430,y + 50);
    
    if (temp != 0.0 || hum != 0.0) { //実装時にはtemp == 0, hum == 0にする
        drawText(CENTER,BASELINE,WHITE_COLOR,32,"riskShowModule\nデータを取得できません",x + 430,y + 150);
    } else {

        //室内外の温度の差を求める
        if (temp >= temperature) {
            riskNum = temp - temperature;
        } else {
            riskNum = temperature - temp;
        }
        
        if (month == march || month == april || month == may) { //春の場合
            //朝晩や前日との温度差を確認するプログラムが必要
            //スプレッドシートに前日の温度などを記録する処理
        } else if (month == june || month == july || month == august) { //夏の場合
            if(riskNum >= 5 || riskNum <=7){
                riskSummer = setRiskString();
                adviseSummer = setAdviseString();
                drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                image(riskShowSummer, x + 280, y + 500, 300, 300);
            } else if(temp < 25 || temp > 29){
                riskSummer = setRiskString();
                adviseSummer = setAdviseString();
                drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                image(riskShowSummer, x + 280, y + 500, 300, 300);
            } else if(hum < 40){
                riskSummer = setRiskString();
                adviseSummer = setAdviseString();
                drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                image(riskShowSummer, x + 280, y + 500, 300, 300);
            } else if(hum > 60){
                riskSummer = setRiskString();
                adviseSummer = setAdviseString();
                drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                image(riskShowSummer, x + 280, y + 500, 300, 300);
            } else {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"リスク情報はありません",x + 430,y + 350);
            }
        } else if (month == september || month == october || month == november) { //秋の場合
            //朝晩や前日との温度差を確認するプログラムが必要
            //スプレッドシートに前日の温度などを記録する処理
        } else if (month == december || month == january || month == february || debugMode == true) { //冬の場合
            if (riskNum >= 10) {
                riskWinter = setRiskString();
                adviseWinter = setAdviseString();
                drawText(CENTER,BASELINE,RED_COLOR,32,riskWinter,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseWinter,x + 430,y + 350);
                image(riskShowWinter, x + 280, y + 500, 300, 300);
            } else if (temp < 18) {
                riskWinter = setRiskString();
                adviseWinter = setAdviseString();
                drawText(CENTER,BASELINE,RED_COLOR,32,riskWinter,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseWinter,x + 430,y + 350);
                image(riskShowWinter, x + 280, y + 500, 300, 300);
            } else if (hum < 40  || debugMode == true) {
                riskWinter = setRiskString();
                adviseWinter = setAdviseString();
                drawText(CENTER,BASELINE,RED_COLOR,32,riskWinter,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseWinter,x + 430,y + 350);
                image(riskDry, x + 280, y + 500, 300, 300);
            } else if (hum > 60) {
                riskWinter = setRiskString();
                adviseWinter = setAdviseString();
                drawText(CENTER,BASELINE,RED_COLOR,32,riskWinter,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseWinter,x + 430,y + 350);
                image(riskShikke, x + 280, y + 500, 300, 300);
            } else {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"リスク情報はありません",x + 430,y + 350);
            }
        } else {
            println("RM_riskShow: 月が正しく設定されていません.");
        }
    }
}

String setRiskString() {

     //室内外の温度の差を求める
        if (temp >= temperature) {
            riskNum = temp - temperature;
        } else {
            riskNum = temperature - temp;
        }

    if (month == june || month == july || month == august) { //夏の場合
        if(riskNum >= 5 || riskNum <=7){
            riskStringSummer = "温度差疲労に注意";
            return riskStringSummer;
        } else if (temp < 25 || temp > 29){
            riskStringSummer = "部屋の温度が快適ではありません";
            return riskStringSummer;
        } else if(hum < 40){
            riskStringSummer = "乾燥に注意";
            return riskStringSummer;
        } else if(hum > 60){
            riskStringSummer = "湿気に注意";
            return riskStringSummer;
        } else {
            return "リスク情報はありません";
        }
    } else if (month == december || month == january || month == february || debugMode == true) { //冬の場合
        if(riskNum >= 10){
            riskStringWinter = "ヒートショックに注意";
            return riskStringWinter;
        } else if(temp < 18){
            riskStringWinter = "部屋の温度が低すぎます";
            return riskStringWinter;
        } else if(hum < 40 || debugMode == true){
            riskStringWinter = "乾燥に注意";
            return riskStringWinter;
        } else if(hum > 60){
            riskStringWinter = "湿気に注意";
            return riskStringWinter;
        } else {
            return "リスク情報はありません";
        }
    }
     return "リスク情報はありません";
}

String setAdviseString(){

     //室内外の温度の差を求める
        if (temp >= temperature) {
            riskNum = temp - temperature;
        } else {
            riskNum = temperature - temp;
        }

    if (month == june || month == july || month == august) { //夏の場合
        if(riskNum >= 5 || riskNum <=7){
            adviseStringSummer = "室内外の温度差が大きいため、夏バテに\n注意しましょう";
            return adviseStringSummer;
        } else if(temp < 25 || temp > 29){
            adviseStringSummer = "部屋の温度を25度~28度以内にしましょう";
            return adviseStringSummer;
        } else if(hum < 40){
            adviseStringSummer = "加湿器を使用しましょう";
            return adviseStringSummer;
        } else if(hum > 60){
            adviseStringSummer = "除湿器を使用しましょう";
            return adviseStringSummer;
        } else {
            return "アドバイス情報はありません";
        }
    } else if (month == december || month == january || month == february || debugMode == true) { //冬の場合
        if(riskNum >= 10){
            adviseStringWinter = "室内外の温度差が大きいため、暖かい服装で\n外出しましょう";
            return adviseStringWinter;
        } else if(temp < 18){
            adviseStringWinter = "部屋の温度を18度以上にしましょう";
            return adviseStringWinter;
        } else if(hum < 40  || debugMode == true){
            adviseStringWinter = "加湿器を使用しましょう";
            return adviseStringWinter;
        } else if(hum > 60){
            adviseStringWinter = "除湿器を使用しましょう";
            return adviseStringWinter;
        } else {
            return "アドバイス情報はありません";
        }
    }
    return "アドバイス情報はありません";
}
