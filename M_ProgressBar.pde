void drawProgressBarModule(){
  float progressRate = (second % STAY_SECOND) / float(STAY_SECOND-1);
  
  noStroke();
  fill(WHITE_COLOR);
  rect(0,height-PROGRESSBAR_HEIGHT,width,PROGRESSBAR_HEIGHT);
  fill(GREEN_COLOR);
  rect(0,height-PROGRESSBAR_HEIGHT, width * progressRate, PROGRESSBAR_HEIGHT);
}
