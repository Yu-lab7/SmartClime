//pythonスクリプトを呼び出す
void connectWithPython(String nowTemp, String ws,  String ics, String ihs) {
    //コマンドライン引数としてテキストを渡す
    String[] command = {"python", AI_PATH, nowTemp, ws, ics, ihs};
    
    try {
        ProcessBuilder pb = new ProcessBuilder(command);
        Process process = pb.start();
        
        BufferedReader outputReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line;
        while((line = outputReader.readLine()) != null) {
            println("OUTPUT: " + line);
            outfit = line.split("/");
        }
        outputReader.close();
        
        BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
        while((line = errorReader.readLine()) != null) {
            println("ERROR: " + line);
        }
        errorReader.close();
        
        int exitCode = process.waitFor();
        println("Python script exited with code: " + exitCode);
        
    } catch(Exception e) {
        e.printStackTrace();
    }
}

void drawClothesRModule(Area area) {
    RModule module = RModule.Clothes;
    Size size = moduleSize(module);
    
    int x = layoutGuideX(area);
    int y = layoutGuideY(area);
    int w = moduleWidth(size);
    int h = moduleHeight(size);
    
    
    image(rmoduleShadowImage(size), x - SHADOW_PADDING, y - SHADOW_PADDING);
    
    if (clothesBackground != null) {
        image(clothesBackground, x, y, w, h);
    } else {
        println("RM_Clothes: clothesBackgroundが設定されていません.");
    }
    
    String clothesTitle = "おすすめの服装";
    drawText(CENTER,BASELINE,WHITE_COLOR,32,clothesTitle,x + 430,y + 50);

    if(outfit!= null && outfit.length == 2){
        if(outfit[1].equals("lightweight winter clothing") && !(weatherString.equals("Fog")) && !(weatherString.equals("Mist")) && !(weatherString.equals("Haze"))){
            if (outfit[0].equals("Short sleeves when outside, woven fabrics when indoors")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"外出時は半袖、室内ではジャンパーを着ましょう",x + 430,h/2);
                image(clothesHansode, x + 280, y + 400, 200, 200);
                image(lightWeight, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("short-sleeved shirt")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"半袖シャツを着ましょう",x + 430,h/2);
                image(clothesHansode, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("long-sleeved shirt")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"長袖シャツを着ましょう",x + 430,h/2);
                image(longsleevedshirt, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("cardigan")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"カーディガンを着ましょう",x + 430,h/2);
                image(cardigan, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("sweater")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"セーターを着ましょう",x + 430,h/2);
                image(sweaterM, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("trench coat")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"トレンチコートを着ましょう",x + 430,h/2);
                image(toren, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("winter coat")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"冬用コートを着ましょう",x + 430,h/2);
                image(winterCoat, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("down coat")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"ダウンコートを着ましょう",x + 430,h/2);
                image(downCoat, x + 330, y + 400, 200, 200);
            } else {
                println("RM_Clothes: pythonからoutFitが返されていません.");
            }
        }
    }
    else if (outfit != null && outfit.length == 1) {
        if (outfit[0].equals("Short sleeves when outside, woven fabrics when indoors")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"外出時は半袖、室内ではジャンパーを着ましょう",x + 430,h/2);
                image(clothesHansode, x + 280, y + 400, 200, 200);
                image(lightWeight, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("short-sleeved shirt")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"半袖シャツを着ましょう",x + 430,h/2);
                image(clothesHansode, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("long-sleeved shirt")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"長袖シャツを着ましょう",x + 430,h/2);
                image(longsleevedshirt, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("cardigan")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"カーディガンを着ましょう",x + 430,h/2);
                image(cardigan, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("sweater")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"セーターを着ましょう",x + 430,h/2);
                image(sweaterM, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("trench coat")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"トレンチコートを着ましょう",x + 430,h/2);
                image(toren, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("winter coat")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"冬用コートを着ましょう",x + 430,h/2);
                image(winterCoat, x + 330, y + 400, 200, 200);
            } else if (outfit[0].equals("down coat")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"ダウンコートを着ましょう",x + 430,h/2);
                image(downCoat, x + 330, y + 400, 200, 200);
            } else {
                println("RM_Clothes: pythonからoutFitが返されていません.");
        }
    } else if (outfit != null && heavyOutfit != null && outfit.length == 2) {      
            if (outfit[0].equals("Short sleeves when outside, woven fabrics when indoors")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"外出時は半袖、室内ではジャンパーを着ましょう",x + 430,y + 100);
                image(clothesHansode, x + 280, y + 200, 200, 200);
                image(lightWeight, x + 330, y + 200, 200, 200);
            } else if (outfit[0].equals("short-sleeved shirt")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"半袖シャツを着ましょう",x + 430,y + 100);
                image(clothesHansode, x + 330, y + 200, 200, 200);
            } else if (outfit[0].equals("long-sleeved shirt")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"長袖シャツを着ましょう",x + 430,y + 100);
                image(longsleevedshirt, x + 330, y + 200, 200, 200);
            } else if (outfit[0].equals("cardigan")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"カーディガンを着ましょう",x + 430,y + 100);
                image(cardigan, x + 330, y + 200, 200, 200);
            } else if (outfit[0].equals("sweater")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"セーターを着ましょう",x + 430,y + 100);
                image(sweaterM, x + 330, y + 200, 200, 200);
            } else if (outfit[0].equals("trench coat")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"トレンチコートを着ましょう",x + 430,y + 100);
                image(toren, x + 330, y + 200, 200, 200);
            } else if (outfit[0].equals("winter coat")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"冬用コートを着ましょう",x + 430,y + 100);
                image(winterCoat, x + 330, y + 200, 200, 200);
            } else if (outfit[0].equals("down coat")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"ダウンコートを着ましょう",x + 430,y + 100);
                image(downCoat, x + 330, y + 200, 200, 200);
            } 
            
            if (outfit[1].equals("waterproof clothing")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"外出時は、防水の服を着ましょう",x + 430,y + 500);
                image(waterProof, x + 330, y + 600, 200, 200);
            } else if (outfit[1].equals("lightweight winter clothing")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"外出時は、軽いジャンパーを着ましょう",x + 430,y + 500);
                image(lightWeight, x + 330, y + 600, 200, 200);
            } else if (outfit[1].equals("mask")) {
                drawText(CENTER,BASELINE,WHITE_COLOR,32,"外出時は、マスクをつけましょう!",x + 430,y + 500);
                image(mask, x + 330, y + 600, 200, 200);
            } else {
                println("RM_Clothes: pythonからoutFitが返されていません.");
            }
    }
  }
