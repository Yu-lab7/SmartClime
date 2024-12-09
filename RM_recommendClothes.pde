void callAiPythonScript(String ws, String nowTemp, String ics) {
  // コマンドライン引数としてテキストを渡す
  String[] command = {"python", AI_PATH, ws, nowTemp , ics};

  try {
    ProcessBuilder pb = new ProcessBuilder(command);
    Process process = pb.start();

    BufferedReader outputReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    String line;
    while ((line = outputReader.readLine()) != null) {
      println("OUTPUT: " + line);
    }
    outputReader.close();

    BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
    while ((line = errorReader.readLine()) != null) {
      println("ERROR: " + line);
    }
    errorReader.close();

    int exitCode = process.waitFor();
    println("Python script exited with code: " + exitCode);

  } catch (Exception e) {
    e.printStackTrace();
  }
}

void drawClothesRModule(Area area){
    RModule module = RModule.Clothes;
    Size size = moduleSize(module);

    int x = layoutGuideX(area);
    int y = layoutGuideY(area);
    int w = moduleWidth(size);
    int h = moduleHeight(size);

    image(rmoduleShadowImage(size), x-SHADOW_PADDING, y-SHADOW_PADDING);
    
    if (clothesBackground != null) {
    image(clothesBackground, x, y, w, h);
  } else {
    println("RM_Clothes: clothesBackgroundが設定されていません.");
  }

   String clothesTitle = "おすすめの服装";
   drawText(CENTER,BASELINE,WHITE_COLOR,32,clothesTitle,x+430,y+50);



}