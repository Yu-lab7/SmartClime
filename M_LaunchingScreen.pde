void drawLaunchingScreenModule() {
  drawFullImageModule(background);
  
  drawText(CENTER, BASELINE, GREEN_COLOR, 148, "DIGITAL SIGNAGE", width/2, height/2-380);
  drawText(CENTER, BASELINE, BLACK_COLOR, 48, LOCATION, width/2, height/2-180);
  stroke(BLACK_COLOR);
  strokeWeight(5);
  noFill();
  line(300, height/2-200, width-300, height/2-200);

  if (isInitializedDates) {
    drawText(CENTER, BASELINE, GREEN_COLOR, 36, "カレンダー取得", width/2, height/2+40);
  } else {
    drawText(CENTER, BASELINE, BLACK_COLOR, 36, "カレンダー取得", width/2, height/2+40);
  }
  
  if (isInitializedImages) {
    drawText(CENTER, BASELINE, GREEN_COLOR, 36, "画像取得", width/2, height/2+100);
  } else {
    drawText(CENTER, BASELINE, BLACK_COLOR, 36, "画像取得", width/2, height/2+100);
  }
  
  if (isInitializedWeather) {
    drawText(CENTER, BASELINE, GREEN_COLOR, 36, "天気情報取得", width/2, height/2+160);
  } else {
    drawText(CENTER, BASELINE, BLACK_COLOR, 36, "天気情報取得", width/2, height/2+160);
  }

  updateNowPageID(true);
}