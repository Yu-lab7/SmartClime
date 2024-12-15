void drawRight(Area area){
    RModule module = RModule.Right;
    Size size = moduleSize(module);

    int x = layoutGuideX(area);
    int y = layoutGuideY(area);
    int w = moduleWidth(size);
    int h = moduleHeight(size);

    drawText(CENTER,BASELINE,WHITE_COLOR,32,"VOICEVOX:春日部つむぎ",x + 250,y + 415);
}