void drawPageControlModule() {
  for (int page = 0; page < PAGE_ALL_COUNT; page++) {
    float x = width/2 + 30 * (page-(PAGE_ALL_COUNT-1)/2.0);
    float y = 1000;

    if (page == nowPageID) {
      fill(WHITE_COLOR);
      stroke(GREEN_COLOR);
      strokeWeight(5);
      circle(x, y, 20);
    } else {
      fill(GREEN_COLOR);
      noStroke();
      circle(x, y, 15);
    }

  }
}
