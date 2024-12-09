import pandas as pd
import pickle  # モデル保存用
import sys

def suggest_clothes(temperature,weather,is_cold_sensitive):
    #モデルの読み込み
    with open("python/model/outputfit.pkl", "rb") as f:
        model = pickle.load(f)

         # 入力データを準備
        input_data = pd.DataFrame([{
            "temperature": temperature,
            "weather_clear": 1 if weather == "clear" else 0,
            "weather_rain": 1 if weather == "rain" else 0,
            "weather_snow": 1 if weather == "snow" else 0,
            "is_cold_sensitive": is_cold_sensitive
        }])

        # 予測
        outfit = model.predict(input_data)[0]
        return outfit
    
if __name__ == "__main__":

    weather = sys.argv[1]
    temperature = sys.argv[2]
    is_cold_sensitive = sys.argv[3]
    
    # AIで服装提案
    outfit = suggest_clothes(temperature, weather, is_cold_sensitive)
    print("suggest_clothes.py: outfitが返されました")


    