import wave
import pyaudio
import os

# 再生する.wavファイルのパス
script_dir = os.path.dirname(os.path.abspath(__file__))
model_path = os.path.join(script_dir, "output/output.wav")  
wav_file = model_path  

# .wavファイルを開く
wf = wave.open(wav_file, 'rb')

# PyAudioの設定
p = pyaudio.PyAudio()
stream = p.open(
    format=p.get_format_from_width(wf.getsampwidth()),
    channels=wf.getnchannels(),
    rate=wf.getframerate(),
    output=True
)

# 音声データを読み込んで再生
data = wf.readframes(1024)
while data:
    stream.write(data)
    data = wf.readframes(1024)

# ストリームを閉じる
stream.stop_stream()
stream.close()
p.terminate()
