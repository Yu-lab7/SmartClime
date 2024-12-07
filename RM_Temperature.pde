void drawTemperatureRModule(Area area){
    RModule module = RModule.Temperature;
    Size size = moduleSize(module);

    int x = layoutGuideX(area);
    int y = layoutGuideY(area);
    int w = moduleWidth(size);
    int h = moduleHeight(size);

    image(rmoduleShadowImage(size), x-SHADOW_PADDING, y-SHADOW_PADDING); 

    image(temperatureBackground, x, y, w, h);

    drawText(LEFT,BASELINE, WHITE_COLOR, 32, "室温", x+50,y+50);

    if(isUpdatedTemperature){
        //温度表示
        drawText(CENTER,BASELINE,WHITE_COLOR,96,nf(temp,0,1)+"℃",x+w/2,y+150);
    } else {
        fill(0,0,0,50);
        noStroke();
        rect(x,y,w,h,MODULE_RECT_ROUND);

        drawText(CENTER,CENTER,WHITE_COLOR,24,"TemperatureModule\nデータを取得できません",x+w/2, y+h/2);
    }
}

//ラズベリーパイとの通信用
/*boolean updateTemperature(){
  return false;
} */