//pythonスクリプトを呼び出す
void connectWithPython2(String tempMax, String tempMin,  String ics, String ihs) {
    //コマンドライン引数としてテキストを渡す
    String[] command = {"python", AI_PATH2, tempMax, tempMin, ics, ihs};
    
    try {
        ProcessBuilder pb = new ProcessBuilder(command);
        Process process = pb.start();
        
        BufferedReader outputReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line2;
        while((line2 = outputReader.readLine()) != null) {
            println("OUTPUT: " + line2);
            heavyOutfit = line2;
        }
        outputReader.close();
        
        BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
        while((line2 = errorReader.readLine()) != null) {
            println("ERROR: " + line2);
        }
        errorReader.close();
        
        int exitCode = process.waitFor();
        println("Python script exited with code: " + exitCode);
        
    } catch(Exception e) {
        e.printStackTrace();
    }
}

void drawHeavyOutfitRModule(Area area) {
    RModule module = RModule.HeavyOutfit;
    Size size = moduleSize(module);
    
    int x = layoutGuideX(area);
    int y = layoutGuideY(area);
    int w = moduleWidth(size);
    int h = moduleHeight(size);
    
    
    image(rmoduleShadowImage(size), x - SHADOW_PADDING, y - SHADOW_PADDING);
    
    if (heavyOutfitBackground != null) {
        image(heavyOutfitBackground, x, y, w, h);
    } else {
        println("RM_Clothes: heavyOutfitBackgroundが設定されていません.");
    }
    
    String clothesTitle = "おすすめのグッズ";
    drawText(CENTER,BASELINE,WHITE_COLOR,32,clothesTitle,x + 430,y + 50);

    if(heavyOutfit != null){
        if(heavyOutfit.equals("glove and scarf")){
            drawText(CENTER,BASELINE,WHITE_COLOR,32,"手袋やマフラーを着用しましょう",x + 430,h/2);
            image(clothesGlove, x + 130, y + 400, 200, 200);
            image(clothesScarf, x + 530, y + 400, 200, 200);
        } else if(heavyOutfit.equals("hat")){
            drawText(CENTER,BASELINE,WHITE_COLOR,32,"帽子やサングラスを着用しましょう",x + 430,h/2);
            image(clothesHat, x + 130, y + 400, 200, 200);
            image(sunglasses, x + 530, y + 400, 200, 200);
        }
    }
}
    