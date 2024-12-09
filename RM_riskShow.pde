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
    
    String title = "リスク表示";
    drawText(CENTER,BASELINE,WHITE_COLOR,32,title,x + 430,y + 50);
    
    if (temp != 0.0) {
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
        } else if (month == june || month == july || month == august || debugMode == true) { //夏の場合
            if(riskNum >= 5 || riskNum <=7){
                riskStringSummer = "寒暖差疲労に注意";
                adviseStringSummer = "室内外の温度差が大きいため、夏バテに\n注意しましょう";
                drawText(CENTER,BASELINE,RED_COLOR,32,riskStringSummer,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseStringSummer,x + 430,y + 350);
                image(riskShowSummer, x + 280, y + 500, 300, 300);
            }
        } else if (month == september || month == october || month == november) { //秋の場合
            //朝晩や前日との温度差を確認するプログラムが必要
        } else if (month == december || month == january || month == february || debugMode == false) { //冬の場合
            if (riskNum >= 10) {
                riskStringWinter = "ヒートショックに注意";
                adviseStringWinter = "室内外の温度差が大きいため、暖かい服装で\n外出しましょう";
                drawText(CENTER,BASELINE,RED_COLOR,32,riskStringWinter,x + 430,y + 250);
                drawText(CENTER,BASELINE,WHITE_COLOR,32,adviseStringWinter,x + 430,y + 350);
                image(riskShowWinter, x + 280, y + 500, 300, 300);
            }
        } else {
            println("RM_riskShow: 月が正しく設定されていません.");
        }
    }
}
