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
    
    if (temp != 0.0) { //実装時にはtemp == 0にする
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
            //スプレッドシートに前日の温度などを記録する処理を追加するのがめんどくさい
            //時間があれば追加する
        } else if (month == june || month == july || month == august) { //夏の場合
            if(riskNum >= 5 || riskNum <=7){
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
            //スプレッドシートに前日の温度などを記録する処理を追加するのがめんどくさい
            //時間があれば追加する
        } else if (month == december || month == january || month == february) { //冬の場合
            if (riskNum >= 10) {
                riskWinter = setRiskString();
                adviseWinter = setAdviseString();
                drawText(CENTER,BASELINE,RED_COLOR,32,riskWinter,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseWinter,x + 430,y + 350);
                image(riskShowWinter, x + 280, y + 500, 300, 300);
            } else {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"リスク情報はありません",x + 430,y + 350);
            }
        } else {
            println("RM_riskShow: 月が正しく設定されていません.");
        }
    }
}

String setRiskString() {
    if (month == june || month == july || month == august) { //夏の場合
        if(riskNum >= 5 || riskNum <=7){
            riskStringSummer = "温度差疲労に注意";
            return riskStringSummer;
        } else {
            return "リスク情報はありません";
        }
    } else if (month == december || month == january || month == february) { //冬の場合
        if(riskNum >= 10){
            riskStringWinter = "ヒートショックに注意";
            return riskStringWinter;
        } else {
            return "リスク情報はありません";
        }
    }
     return "リスク情報はありません";
}

String setAdviseString(){
    if (month == june || month == july || month == august) { //夏の場合
        if(riskNum >= 5 || riskNum <=7){
            adviseStringSummer = "室内外の温度差が大きいため、夏バテに\n注意しましょう";
            return adviseStringSummer;
        }
    } else if (month == december || month == january || month == february) { //冬の場合
        if(riskNum >= 10){
            adviseStringWinter = "室内外の温度差が大きいため、暖かい服装で\n外出しましょう";
            return adviseStringWinter;
        }
    }
    return "アドバイス情報はありません";
}
