import csv
import random

# ランダムなデータを生成するための設定
temperature_weather_map = {
    "Thunderstorm": range(-5, 36),
    "Drizzle": range(10, 36),
    "Rain": range(-5, 36),
    "Snow": range(-5, 5),
    "Clear": range(-5, 36),
    "Clouds": range(-5, 36),
    "Mist": range(-5, 36),
    "Haze": range(-5, 36),
    "Dust": range(-5, 36),
    "Fog": range(-5, 36),
    "Ash": range(-5, 36),
    "Squall": range(10, 36),
    "Tornado": range(15, 36)
}
is_cold_sensitive_options = [0, 1]
is_hot_sensitive_options = [0, 1]

# 服装の決定ロジック
def determine_outfit(temp, is_cold_sensitive, is_hot_sensitive, weather):
    if is_cold_sensitive:
        temp -= 5  # 寒がりの場合は温度を5度下げて計算 
    if is_hot_sensitive:
        temp += 5 # 暑がりの場合は温度を5度上げて計算

    if temp >= 30:
        outfit = "Short sleeves when outside, woven fabrics when indoors"
    elif temp >= 25:
        outfit = "short-sleeved shirt"
    elif temp >= 20:
        outfit = "long-sleeved shirt"
    elif temp >= 16:
        outfit = "cardigan"
    elif temp >= 12:
        outfit = "sweater"
    elif temp >= 8:
        outfit = "trench coat"
    elif temp >= 5:
        outfit = "winter coat"
    else:
        outfit = "down coat"

    # 天気に基づく追加の服装
    if weather in ["Thunderstorm", "Rain", "Drizzle", "Squall"]:
        outfit += "/waterproof clothing"
    elif weather == "Snow":
        outfit += "/waterproof coating"
    elif weather in ["Fog", "Mist", "Haze"]:
        outfit += "/lightweight winter clothing"
    elif weather in ["Dust", "Ash", "Tornado"]:
        outfit += "/mask"

    return outfit
    
# CSVファイルの作成
with open('./python/csv/outfit_recommendations.csv', mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(["temperature", "weather", "is_cold_sensitive", "is_hot_sensitive","outfit"])

    for _ in range(2000):
        weather = random.choice(list(temperature_weather_map.keys()))
        temp = random.choice(temperature_weather_map[weather])
        is_cold_sensitive = random.choice([0,1])
        is_hot_sensitive = random.choice([0,1]) 
        if(is_cold_sensitive == 1 and is_hot_sensitive == 1):
            is_hot_sensitive = 0
            is_cold_sensitive = 0
        outfit = determine_outfit(temp, is_cold_sensitive, is_hot_sensitive, weather)
        writer.writerow([temp, weather, is_cold_sensitive, is_hot_sensitive, outfit])