void createVoicevox() {
    
    if (isThreadRunning) {
        return; // スレッドが既に実行中の場合は何もしない
    }
    
    isThreadRunning = true; 
    Thread thread = new Thread(new Runnable() {
        public void run() {
            try{
                if ((morningTimeHT[0].equals(String.valueOf(hour)) && morningTimeHT[1].equals(String.valueOf(minute))) && checkOpened == 0) {
                    if (outfit.length == 1) {
                        callTTSPythonScript(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),setRiskString(),setAdviseString(),outfit[0],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
                } else {
                        callTTSPythonScript2(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),setRiskString(),setAdviseString(),outfit[0],outfit[1],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
                    }
                    openWaveFile();
                    checkOpened = 1;
                } 
                
                if ((nightTimeHT[0].equals(String.valueOf(hour)) && nightTimeHT[1].equals(String.valueOf(minute))) && checkOpened == 0) {
                    checkMorningOrNight = 1;
                    updateWeather2(String.valueOf(year) + "-" + String.valueOf(month) + "-" + String.valueOf(day));
                    if (outfit.length == 1) {
                        callTTSPythonScript(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),setRiskString(),setAdviseString(),outfit[0],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
                } else {
                        callTTSPythonScript2(String.valueOf(temperature),String.valueOf(humidity),weatherString,String.valueOf(temp),String.valueOf(hum),setRiskString(),setAdviseString(),outfit[0],outfit[1],heavyOutfit,String.valueOf(checkMorningOrNight),nickname);
                    }
                    openWaveFile();
                    checkMorningOrNight = 0;
                    checkOpened = 1;
                }
            } finally {
                isThreadRunning = false;
            }
        }
    });

    thread.start();
}