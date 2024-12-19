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
    
    if (temp == 0.0 || hum == 0.0) { //実装時にはtemp == 0, hum == 0にする
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

/*void risetRiskFlag(){
    for(int i=0;i<4;i++){
        RiskFlag[i] = 0;
    }
}*/

String setRiskString() {
     //室内外の温度の差を求める
        if (temp >= temperature) {
            riskNum = temp - temperature;
        } else {
            riskNum = temperature - temp;
        }

    if (month == june || month == july || month == august) { //夏の場合
        if((riskNum >= 5 || riskNum <=7) ){
            riskStringSummer = "温度差疲労に注意";
            return riskStringSummer;
        } else if ((temp < 25 || temp > 29) ) {
            riskStringSummer = "部屋の温度が快適ではない";
            return riskStringSummer;
        } else if(hum < 40 ){
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
            riskStringWinter = "部屋の温度が低い";
            return riskStringWinter;
        } else if((hum < 40 || debugMode == true )){
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
        } else if((hum < 40  || debugMode == true)){
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

/*void isUpdatedRiskSlideShow() {
    int currentTime = millis();
    if ((currentTime - lastRiskSlideTime) > riskSlideInterval) {
        riskSlideIndex = (riskSlideIndex + 1) % getRiskSlideCount(); 
        lastRiskSlideTime = currentTime;
        if (lastSlideIndex != riskSlideIndex) {
            for (int i = 0; i < 4; i++) {
                RiskFlag[i] = 0;
            }
            if (debugMode == true) {
                println("RM_riskShow: 実行されました1");
                for (int i = 0; i < 4; i++) {
                    println("RM_riskShow: WinterRiskCount[" + i + "] = " + WinterRiskCount[i]);
                }
            }
            drawRiskRModule(Area.area3, riskSlideIndex);
            lastSlideIndex = riskSlideIndex;
        }
    } else {
        if (debugMode == true) {
            println("RM_riskShow: 実行されました4");
            for (int i = 0; i < 4; i++) {
                println("RM_riskShow: WinterRiskCount[" + i + "] = " + WinterRiskCount[i]);
            }
        }
        drawRiskRModule(Area.area3, riskSlideIndex);
    }
}

int getRiskSlideCount() {
    int riskPageAllCount = 0;

    //室内外の温度の差を求める
    if (temp >= temperature) {
        riskNum = temp - temperature;
    } else {
        riskNum = temperature - temp;
    }

    if (month == march || month == april || month == may) { //春の場合

    } else if (month == june || month == july || month == august) { //夏の場合
        if (riskNum >= 5 || riskNum <= 7) {
            riskPageAllCount++;
            SummerRiskCount[0] = 1;
        }
        if (temp < 25 || temp > 29) {
            riskPageAllCount++;
            SummerRiskCount[1] = 1;
        }
        if (hum < 40) {
            riskPageAllCount++;
            SummerRiskCount[2] = 1;
        }
        if (hum > 60) {
            riskPageAllCount++;
            SummerRiskCount[3] = 1;
        } 
    } else if (month == september || month == october || month == november) { //秋の場合

    } else if (month == december || month == january || month == february || debugMode == true) { //冬の場合
        if (riskNum >= 10) {
            riskPageAllCount++;
            WinterRiskCount[0] = 1;
        }
        if (temp < 18) {
            riskPageAllCount++;
            WinterRiskCount[1] = 1;
        }
        if (hum < 40 || debugMode == true) {
            riskPageAllCount++;
            WinterRiskCount[2] = 1;
        }
        if (hum > 60) {
            riskPageAllCount++;
            WinterRiskCount[3] = 1;
        } 
    }
    if (debugMode == true) {
        println("RM_riskShow: riskPageAllCount = " + riskPageAllCount);
        for (int i = 0; i < 4; i++) {
            println("RM_riskShow: WinterRiskCount[" + i + "] = " + WinterRiskCount[i]);
        }
    }   
    return riskPageAllCount;
}

void drawRiskRModule(Area area, int index){
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
        
        switch(index){
            case 0:
                if (month == march || month == april || month == may) { //春の場合
                    //朝晩や前日との温度差を確認するプログラムが必要
                    //スプレッドシートに前日の温度などを記録する処理
                } else if (month == june || month == july || month == august) { //夏の場合
                    if(RiskFlag[0] == 1 || SummerRiskCount[0] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[0] = 1;
                    } else if(SummerRiskCount[1] == 1 || RiskFlag[1] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[1] = 1;
                    } else if(SummerRiskCount[2] == 1 || RiskFlag[2] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[2] = 1;
                    } else if(SummerRiskCount[3] == 1 || RiskFlag[3] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[3] = 1;
                    } else {
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,"リスク情報はありません",x + 430,y + 350);
                    }
                } else if (month == september || month == october || month == november){ //秋の場合
                    //朝晩や前日との温度差を確認するプログラムが必要
                    //スプレッドシートに前日の温度などを記録する処理
                } else if (month == december || month == january || month == february || debugMode == true) { //冬の場合
                    for (int i = 0; i < 4; i++) {
                        if (WinterRiskCount[i] == 1 && RiskFlag[i] == 0) {
                            riskWinter = setRiskString();
                            adviseWinter = setAdviseString();
                            drawText(CENTER, BASELINE, RED_COLOR, 32, riskWinter, x + 430, y + 250);
                            drawText(CENTER, BASELINE, WHITE_COLOR, 32, adviseWinter, x + 430, y + 350);
                            if (i == 0) {
                                image(riskShowWinter, x + 280, y + 500, 300, 300);
                            } else if (i == 1) {
                                image(riskShowWinter, x + 280, y + 500, 300, 300);
                            } else if (i == 2) {
                                image(riskDry, x + 280, y + 500, 300, 300);
                            } else if (i == 3) {
                                image(riskShikke, x + 280, y + 500, 300, 300);
                            }
                            RiskFlag[i] = 1;
                            break;
                        }
                    }
                } else {
                    println("RM_riskShow: 月が正しく設定されていません.");
                }
                break;
        case 1:
            if (month == march || month == april || month == may) { //春の場合
                    //朝晩や前日との温度差を確認するプログラムが必要
                    //スプレッドシートに前日の温度などを記録する処理
                } else if (month == june || month == july || month == august) { //夏の場合
                    if(SummerRiskCount[0] == 1 || RiskFlag[0] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[0] = 1;
                    } else if(SummerRiskCount[1] == 1 || RiskFlag[1] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[1] = 1;
                    } else if(SummerRiskCount[2] == 1 || RiskFlag[2] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[2] = 1;
                    } else if(SummerRiskCount[3] == 1 || RiskFlag[3] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[3] = 1;
                    } else {
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,"リスク情報はありません",x + 430,y + 350);
                    }
                } else if (month == september || month == october || month == november) { //秋の場合
                    //朝晩や前日との温度差を確認するプログラムが必要
                    //スプレッドシートに前日の温度などを記録する処理
                } else if (month == december || month == january || month == february || debugMode == true) { //冬の場合
                    for (int i = 0; i < 4; i++) {
                        if (WinterRiskCount[i] == 1 && RiskFlag[i] == 0) {
                            riskWinter = setRiskString();
                            adviseWinter = setAdviseString();
                            drawText(CENTER, BASELINE, RED_COLOR, 32, riskWinter, x + 430, y + 250);
                            drawText(CENTER, BASELINE, WHITE_COLOR, 32, adviseWinter, x + 430, y + 350);
                            if (i == 0) {
                                image(riskShowWinter, x + 280, y + 500, 300, 300);
                            } else if (i == 1) {
                                image(riskShowWinter, x + 280, y + 500, 300, 300);
                            } else if (i == 2) {
                                image(riskDry, x + 280, y + 500, 300, 300);
                            } else if (i == 3) {
                                image(riskShikke, x + 280, y + 500, 300, 300);
                            }
                            RiskFlag[i] = 1;
                            break;
                        }
                    }
                    println("RM_riskShow: 月が正しく設定されていません.");
                }
                break;

        case 2:
            if (month == march || month == april || month == may) { //春の場合
                    //朝晩や前日との温度差を確認するプログラムが必要
                    //スプレッドシートに前日の温度などを記録する処理
                } else if (month == june || month == july || month == august) { //夏の場合
                    if(SummerRiskCount[0] == 1 || RiskFlag[0] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[0] = 1;
                    } else if(SummerRiskCount[1] == 1 || RiskFlag[1] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[1] = 1;
                    } else if(SummerRiskCount[2] == 1 || RiskFlag[2] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[2] = 1;
                    } else if(SummerRiskCount[3] == 1 || RiskFlag[3] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[3] = 1;
                    } else {
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,"リスク情報はありません",x + 430,y + 350);
                    }
                } else if (month == september || month == october || month == november) { //秋の場合
                    //朝晩や前日との温度差を確認するプログラムが必要
                    //スプレッドシートに前日の温度などを記録する処理
                } else if (month == december || month == january || month == february || debugMode == true) { //冬の場合
                    for (int i = 0; i < 4; i++) {
                        if (WinterRiskCount[i] == 1 && RiskFlag[i] == 0) {
                            riskWinter = setRiskString();
                            adviseWinter = setAdviseString();
                            drawText(CENTER, BASELINE, RED_COLOR, 32, riskWinter, x + 430, y + 250);
                            drawText(CENTER, BASELINE, WHITE_COLOR, 32, adviseWinter, x + 430, y + 350);
                            if (i == 0) {
                                image(riskShowWinter, x + 280, y + 500, 300, 300);
                            } else if (i == 1) {
                                image(riskShowWinter, x + 280, y + 500, 300, 300);
                            } else if (i == 2) {
                                image(riskDry, x + 280, y + 500, 300, 300);
                            } else if (i == 3) {
                                image(riskShikke, x + 280, y + 500, 300, 300);
                            }
                            RiskFlag[i] = 1;
                            break;
                        }
                    }
                } else {
                    println("RM_riskShow: 月が正しく設定されていません.");
                }
                break;

        case 3:
            if (month == march || month == april || month == may) { //春の場合
                    //朝晩や前日との温度差を確認するプログラムが必要
                    //スプレッドシートに前日の温度などを記録する処理
                } else if (month == june || month == july || month == august) { //夏の場合
                    if(SummerRiskCount[0] == 1 || RiskFlag[0] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[0] = 1;
                    } else if(SummerRiskCount[1] == 1 || RiskFlag[1] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[1] = 1;
                    } else if(SummerRiskCount[2] == 1 || RiskFlag[2] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[2] = 1;
                    } else if(SummerRiskCount[3] == 1 || RiskFlag[3] == 1){
                        riskSummer = setRiskString();
                        adviseSummer = setAdviseString();
                        drawText(CENTER,BASELINE,RED_COLOR,32,riskSummer,x + 430,y + 250);
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseSummer,x + 430,y + 350);
                        image(riskShowSummer, x + 280, y + 500, 300, 300);
                        RiskFlag[3] = 1;
                    } else {
                        drawText(CENTER,BASELINE,WHITE_COLOR,32,"リスク情報はありません",x + 430,y + 350);
                    }
                } else if (month == september || month == october || month == november) { //秋の場合
                    //朝晩や前日との温度差を確認するプログラムが必要
                    //スプレッドシートに前日の温度などを記録する処理
                } else if (month == december || month == january || month == february || debugMode == true) { //冬の場合
                    for (int i = 0; i < 4; i++) {
                        if (WinterRiskCount[i] == 1 && RiskFlag[i] == 0) {
                            riskWinter = setRiskString();
                            adviseWinter = setAdviseString();
                            drawText(CENTER, BASELINE, RED_COLOR, 32, riskWinter, x + 430, y + 250);
                            drawText(CENTER, BASELINE, WHITE_COLOR, 32, adviseWinter, x + 430, y + 350);
                            if (i == 0) {
                                image(riskShowWinter, x + 280, y + 500, 300, 300);
                            } else if (i == 1) {
                                image(riskShowWinter, x + 280, y + 500, 300, 300);
                            } else if (i == 2) {
                                image(riskDry, x + 280, y + 500, 300, 300);
                            } else if (i == 3) {
                                image(riskShikke, x + 280, y + 500, 300, 300);
                            }
                            RiskFlag[i] = 1;
                            break;
                        }
                    }
                } else {
                    println("RM_riskShow: 月が正しく設定されていません.");
                }
                break;
        }
    }     
}
*/
