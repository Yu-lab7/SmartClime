void callTTSPythonScript(String tempe, String humi, String weatherS, String tempe2, String humi2, String riskS, String adviseS, String outfit, String heavyOutfit, String checkMorningOrNight, String nickname) {
  // コマンドライン引数としてテキストを渡す
    String[] command = {"python", TTS_PATH, tempe, humi, weatherS, tempe2, humi2, riskS, adviseS, outfit, heavyOutfit, checkMorningOrNight, nickname};

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

void callTTSPythonScript2(String tempe, String humi, String weatherS, String tempe2, String humi2, String riskS, String adviseS, String outfit, String outfit2,  String heavyOutfit, String checkMorningOrNight, String nickname) {
  // コマンドライン引数としてテキストを渡す
  String[] command = {"python", TTS_PATH2, tempe, humi, weatherS, tempe2, humi2, riskS, adviseS, outfit, outfit2, heavyOutfit, checkMorningOrNight, nickname};

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

void openWaveFile(){
     String[] command = {"python", WAVE_PATH};

  try {
    ProcessBuilder pb = new ProcessBuilder(command);
    Process process = pb.start();

    BufferedReader outputReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    String line4;
    while ((line4 = outputReader.readLine()) != null) {
      println("OUTPUT: " + line4);
    }
    outputReader.close();

    BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
    while ((line4 = errorReader.readLine()) != null) {
      println("ERROR: " + line4);
    }
    errorReader.close();

    int exitCode = process.waitFor();
    println("Python script exited with code: " + exitCode);

  } catch (Exception e) {
    e.printStackTrace();
  }
}