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

    

}