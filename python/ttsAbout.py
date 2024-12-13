import requests
import json
import sys

# 音声合成を行うメソッド
def synthesize_voice(temperature, humidity, weather, temp, hum, riskString, advise, outfit, heavy, check, nickname, speaker=8, filename="../DigitalSignate/python/output/output.wav"):
    #print(f"送信するテキスト: {text}")  # デバッグ用プリント文
    if check == "0":
     text = f"おはようございます!{nickname}さん、現在の気温は{temperature}度、湿度は{humidity}パーセントです。天気は{weather}です。室内温度は{temp}度、室内湿度は{hum}パーセントです。これらの情報から、{riskString}。{advise}。また、今日のおすすめの服装は{outfit}です。{heavy}も身に着けると良いでしょう。今日も一日頑張りましょう。"
    else:
     text = f"こんばんは!{nickname}さん、明日の気温は{temperature}度、湿度は{humidity}パーセントです。天気は{weather}です。これらの情報から、{riskString}。{advise}。また、明日のおすすめの服装は{outfit}です。{heavy}も身に着けると良いでしょう。明日も一日頑張りましょう。おやすみなさい。"

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
    temperature = temperature[0:2]
    humidity = sys.argv[2]
    weather = sys.argv[3]
    temp = sys.argv[4]
    temp = temp[0:2]
    hum = sys.argv[5]
    riskString = sys.argv[6]
    if riskString != "リスク情報はありません":
        riskString += "と注意報が発令されています。"
    advise = sys.argv[7]
    outfit = sys.argv[8]
    if outfit == "Short sleeves when outside, woven fabrics when indoors":
        outfit = "外出時は半袖、室内では、ジャンパー"
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
        outfit = "軽いジャンパー"
    elif outfit == "mask":
        outfit = "マスク"
    else:
        outfit = "不明な服装"

    heavy = sys.argv[9]
    if heavy == "glove and scarf":
        heavy = "手袋やマフラー"    
    elif heavy == "hat and sunglasses":
        heavy = "帽子やサングラス"
    else:
        heavy = "不明"
    check = sys.argv[10]
    nickname = sys.argv[11]

    # 音声合成の実行
    synthesize_voice(temperature,humidity,weather,temp,hum,riskString,advise,check, speaker=8, filename="../DigitalSignate/python/output/output.wav")