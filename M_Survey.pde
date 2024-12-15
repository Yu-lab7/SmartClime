//pythonスクリプトを呼び出す
void connectWithPython3(){
    //コマンドライン引数としてテキストを渡す
    String[] command = {"python", FORM_PATH};
    try {
        ProcessBuilder pb = new ProcessBuilder(command);
        Process process = pb.start();
        
        BufferedReader outputReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line3;
        while((line3 = outputReader.readLine()) != null) {
            println("OUTPUT: " + line3);
            reserve = line3.split(",");
        }
        outputReader.close();
        
        BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
        while((line3 = errorReader.readLine()) != null) {
            println("ERROR: " + line3);
        }
        errorReader.close();
        
        int exitCode = process.waitFor();
        println("Python script exited with code: " + exitCode);

        } catch(Exception e) {
            e.printStackTrace();
            System.exit(0);
        }
}

void checkSubmitForm(){
    if(reserve == null){
        println("M_Survey.pde: アンケート画面にて強制終了が選択されました.");
        System.exit(0);
    }
    nickname = reserve[0];
    if(reserve[1].equals("True")){
        is_hot_sensitive = "1";
        println("M_Survey.pde: checkSubmitForm(): is_hot_sensitive = 1");
    } else if(reserve[2].equals("True")){
        is_cold_sensitive = "1";
        println("M_Survey.pde: checkSubmitForm(): is_cold_sensitive = 1");
    } else {
        is_hot_sensitive = "0";
        is_cold_sensitive = "0";
        println("M_Survey.pde: checkSubmitForm(): is_hot_sensitive = 0, is_cold_sensitive = 0");
    }
    morningTime = reserve[3];
    if(morningTime.startsWith("0")){
        morningTimeHT[0] = morningTime.substring(1, 2);
    } else {
        morningTimeHT[0] = morningTime.substring(0, 2);
    }
    if(morningTime.substring(3, 4).equals("0")){
        morningTimeHT[1] = morningTime.substring(4, 5);
    } else {
        morningTimeHT[1] = morningTime.substring(3, 5);
    }

    nightTime = reserve[4];
    if(nightTime.startsWith("0")){
        nightTimeHT[0] = nightTime.substring(1, 2);
    } else {
        nightTimeHT[0] = nightTime.substring(0, 2);
    }
    if(nightTime.substring(3, 4).equals("0")){
        nightTimeHT[1] = nightTime.substring(4, 5);
    } else {
        nightTimeHT[1] = nightTime.substring(3, 5);
    }
}