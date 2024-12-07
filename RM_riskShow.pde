void drawRiskRModule(Area area){
    RModule module = RModule.Risk;
    Size size = moduleSize(module);

    int x = layoutGuideX(area);
    int y = layoutGuideY(area);
    int w = moduleWidth(size);
    int h = moduleHeight(size);

    image(rmoduleShadowImage(size), x-SHADOW_PADDING, y-SHADOW_PADDING);
    
    image(riskBackground, x, y, w, h);

    String title = "リスク表示";
    drawText(CENTER,BASELINE,WHITE_COLOR,32,title,x+430,y+50);

    if(humidity < 40 && hum < 30){
        //湿度を40%~60%に
        //のどの粘膜が乾燥し、ウィルスへの抵抗機能が弱まる
        //静電気や皮膚のかゆみが発生
    }

    if(humidity > 70 && hum > 60){
        //湿度を40%~60%に
        //結露からカビやダニの発生リスクが上昇
    }

    if((temperature < 5 && humidity < 40) || (temperature > 22 && humidity < 30)){
        //室温を18度~25度に
        //湿度を40%~60%に
        //風邪やインフルエンザのリスクが上昇
    }

    if((temperature > 30 && humidity > 70) && temp > 28 && hum > 60){
        //室温を18度~25度に
        //湿度を40%~60%に
        //熱中症のリスクが上昇
    }

    //冬の場合
    if(month == December || month == January|| month == February){
        if(temp < 18){
          //室温を18度~20度に 
          //血圧上昇の恐れ 呼吸器系や心血管疾患の罹患・死亡リスクが上昇
          //睡眠の質が悪くなる(20:00以降に表示)
        }
        if(hum < 40){
            //湿度を40%~60%に
            //のどの粘膜が乾燥し、ウィルスへの抵抗機能が弱まる
        }
        if(hum > 60){
            //湿度を40%~60%に
            //結露からカビやダニの発生リスクが上昇
        }
        if(temperature < 10 && temp > 20){
            //急激な温度差で体調が崩れるリスクが上昇
        }
    }
}