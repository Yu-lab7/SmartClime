void drawPlaceholderModule() {
  if (placeholder != null) {
    image(placeholder, 0, 0);
  } else {
    println("M_placeHolder: placeholderが設定されていません.");
  }
}
