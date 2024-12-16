import requests
import json
import sys

# 音声合成を行うメソッド
def synthesize_voice(temperature, humidity, weather, temp, hum, riskString, advise, outfit, outfit2, heavy, check, nickname, speaker=8, filename="../WIICR/python/output/output.wav"):
    #print(f"送信するテキスト: {text}")  # デバッグ用プリント文
    if check == "0":
     text = f"おはようございます!{nickname}さん、現在の気温は{temperature}度、湿度は{humidity}パーセントです。天気は{weather}です。室内温度は{temp}度、室内湿度は{hum}パーセントです。これらの情報から、{riskString}。{advise}。また、今日のおすすめの服装は{outfit}です。{outfit2}。また、{heavy}も身に着けると良いでしょう。今日も一日頑張りましょう。"
    else:
     text = f"こんばんは!{nickname}さん、明日の気温は{temperature}度、湿度は{humidity}パーセントです。天気は{weather}です。これらの情報から、{riskString}。{advise}。また、明日のおすすめの服装は{outfit}をおすすめします。{outfit2}。また、{heavy}も身に着けると良いでしょう。明日も一日頑張りましょう。おやすみなさい。"

    # テキストから音声合成のためのクエリを作成
    query_payload = {'text': text, 'speaker': speaker}
    query_response = requests.post(f'http://localhost:50021/audio_query', params=query_payload)

    if query_response.status_code != 200:
        print(f"ttsAbout1.py: Error in audio_query: {query_response.text}")
        return

    query = query_response.json()
    #print(f"audio_queryのレスポンス: {query}")  # デバッグ用プリント文

    # クエリを元に音声データを生成
    synthesis_payload = {
        'speaker': speaker,
        'speedScale': 1.0,
        'pitchScale': 0.0,
        'intonationScale': 1.0,
        'volumeScale': 1.0,
        'prePhonemeLength': 0.1,
        'postPhonemeLength': 0.1
    }
    synthesis_response = requests.post(f'http://localhost:50021/synthesis', params=synthesis_payload, json=query)

    if synthesis_response.status_code == 200:
        #print(f"synthesisのレスポンスの長さ: {len(synthesis_response.content)}")  # デバッグ用プリント文
        # 音声ファイルとして保存
        with open(filename, 'wb') as f:
            f.write(synthesis_response.content)
        print(f"ttsAbout.py: 音声が {filename} に保存されました。")
    else:
        print(f"ttsAbout.py: Error in synthesis: {synthesis_response.text}")

if __name__ == "__main__":
    
    # 引数の取得
    temperature = sys.argv[1]
    temperature = temperature[0:1]
    humidity = sys.argv[2]
    weather = sys.argv[3]
    if(weather == ("Clouds")):
       weather = "曇り"
    elif(weather == ("Thunderstorm")):
       weather = "雷雨"
    elif(weather == ("Drizzle")):
       weather = "霧雨"
    elif(weather == ("Rain")):
        weather = "雨"
    elif(weather == ("Snow")):
        weather = "雪"
    elif(weather == ("Mist")):
        weather = "霧"
    elif(weather == ("Smoke")):
        weather = "煙"
    elif(weather == ("Haze")):
        weather = "煙霧"
    elif(weather == ("Dust")):
        weather = "ほこり"
    elif(weather == ("Ash")):
        weather = "灰"
    elif(weather == ("Squall")):
        weather = "スコール"
    elif(weather == ("Tornado")):
        weather = "竜巻"
    else:
        weather = "晴れ"

    temp = sys.argv[4]
    hum = sys.argv[5]
    riskString = sys.argv[6]
    if riskString != "リスク情報はありません":
        riskString += "と注意報が発令されています。"
    advise = sys.argv[7]
    outfit = sys.argv[8]
    if outfit == "Short sleeves when outside, woven fabrics when indoors":
        outfit = "外出時は半袖、室内では、はおりもの"
    elif outfit == "short-sleeved shirt":
        outfit = "半袖シャツ"
    elif outfit == "long-sleeved shirt":
        outfit = "長袖シャツ"
    elif outfit == "cardigan":
        outfit = "カーディガン"
    elif outfit == "sweater":
        outfit = "セーター"
    elif outfit == "trench coat":
        outfit = "トレンチコート"
    elif outfit == "winter coat":
        outfit = "冬用コート"
    elif outfit == "down coat":
        outfit = "ダウンコート"
    elif outfit == "waterproof clothing":
        outfit = "防水の服"
    elif outfit == "lightweight winter clothing":
        outfit = "軽量の冬用服"
    elif outfit == "mask":
        outfit = "マスク"
    else:
        outfit = "不明な服装"

    outfit2 = sys.argv[9]
    if outfit2 == "waterproof clothing":
        outfit2 = "防水服を身に着けるのも良いでしょう"
    elif outfit2 == "waterproof coating":
        outfit2 = "防水コートを身に着けるのも良いでしょう"
    elif outfit2 == "lightweight winter clothing":
        outfit2 = "軽いジャンパーを身に着けるのも良いでしょう"
    elif outfit2 == "mask" :
        outfit2 = "マスクをつけることをおすすめします"
    else:
        outfit2 = "不明"
        
    heavy = sys.argv[10]
    if heavy == "glove and scarf":
        heavy = "手袋やマフラー"    
    elif heavy == "hat and sunglasses":
        heavy = "帽子やサングラス"
    else:
        heavy = "不明"
        
    check = sys.argv[11]
    nickname = sys.argv[12]

    # 音声合成の実行
    synthesize_voice(temperature,humidity,weather,temp,hum,riskString,advise,outfit,outfit2,heavy,check,nickname, speaker=8, filename="../WIICR/python/output/output.wav")