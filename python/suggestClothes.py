import pandas as pd
import pickle
import sys
import os

def suggest_clothes(temperature, weather, is_cold_sensitive, is_hot_sensitive):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    model_path = os.path.join(script_dir, "model/outfit_model.pkl")

    # ファイルの存在を確認
    if not os.path.exists(model_path):
        print(f"Error: Model file not found at {model_path}")
        sys.exit(1)

    # モデルと特徴量の順序の読み込み
    with open(model_path, "rb") as f:
        model, feature_order = pickle.load(f)

    # 入力データを準備
    input_data = pd.DataFrame([{
        "temperature": temperature,
        "is_cold_sensitive": is_cold_sensitive,
        "is_hot_sensitive": is_hot_sensitive,
        "weather_Thunderstorm": 1 if weather == "Thunderstorm" else 0,
        "weather_Drizzle": 1 if weather == "Drizzle" else 0,
        "weather_Rain": 1 if weather == "Rain" else 0,
        "weather_Snow": 1 if weather == "Snow" else 0,
        "weather_Clear": 1 if weather == "Clear" else 0,
        "weather_Clouds": 1 if weather == "Clouds" else 0,
        "weather_Mist": 1 if weather == "Mist" else 0,
        "weather_Haze": 1 if weather == "Haze" else 0,
        "weather_Dust": 1 if weather == "Dust" else 0,
        "weather_Fog": 1 if weather == "Fog" else 0,
        "weather_Ash": 1 if weather == "Ash" else 0,
        "weather_Squall": 1 if weather == "Squall" else 0,
        "weather_Tornado": 1 if weather == "Tornado" else 0
    }])

    # トレーニング時の特徴量の順序に合わせる
    input_data = input_data[feature_order]

    # 予測
    outfit = model.predict(input_data)[0]
    return outfit

if __name__ == "__main__":
    temperature = float(sys.argv[1])
    weather = sys.argv[2].capitalize()  # 天気の入力を小文字から大文字に変換
    is_cold_sensitive = int(sys.argv[3])
    is_hot_sensitive = int(sys.argv[4])

    if(is_cold_sensitive == 1 and is_hot_sensitive == 1):
        print(f"suggestClothes.py: エラー: 寒がりと暑がりの両方を満たすことはできません")
        sys.exit(1)

    # AIで服装提案
    outfit = suggest_clothes(temperature, weather, is_cold_sensitive, is_hot_sensitive)
    print(f"{outfit}")