void callTTSPythonScript(String text) {
  // コマンドライン引数としてテキストを渡す
  String[] command = {"python", TTS_PATH, text};

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

