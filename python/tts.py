import requests
import json
import sys

# 音声合成を行うメソッド
def synthesize_voice(text, speaker=8, filename="../DigitalSignate/python/output/output.wav"):
    #print(f"送信するテキスト: {text}")  # デバッグ用プリント文

    # テキストから音声合成のためのクエリを作成
    query_payload = {'text': text, 'speaker': speaker}
    query_response = requests.post(f'http://localhost:50021/audio_query', params=query_payload)

    if query_response.status_code != 200:
        print(f"tts.py: Error in audio_query: {query_response.text}")
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
        print(f"tts.py: 音声が {filename} に保存されました。")
    else:
        print(f"tts.py: Error in synthesis: {synthesis_response.text}")

if __name__ == "__main__":
    
    # 引数の取得
    text = sys.argv[1]

    # 音声合成の実行
    synthesize_voice(text, speaker=8, filename="../DigitalSignate/python/output/output.wav")