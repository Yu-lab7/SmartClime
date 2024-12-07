void drawClothesRModule(Area area){
    RModule module = RModule.Clothes;
    Size size = moduleSize(module);

    int x = layoutGuideX(area);
    int y = layoutGuideY(area);
    int w = moduleWidth(size);
    int h = moduleHeight(size);

    image(rmoduleShadowImage(size), x-SHADOW_PADDING, y-SHADOW_PADDING);
    
    image(clothesBackground, x, y, w, h);

    

}