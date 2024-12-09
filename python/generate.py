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

# 服装の決定ロジック
def determine_outfit(temp, is_cold_sensitive, weather):
    if is_cold_sensitive:
        temp -= 5  # 寒がりの場合は温度を5度下げて計算 #マジックナンバーの理由を説明しなければならない

    if temp >= 30:
        outfit = "外出時は半袖、 室内羽では織物"
    elif temp >= 25:
        outfit = "半袖シャツ"
    elif temp >= 20:
        outfit = "長袖シャツ"
    elif temp >= 16:
        outfit = "カーディガン"
    elif temp >= 12:
        outfit = "セーター"
    elif temp >= 8:
        outfit = "トレンチコート"
    elif temp >= 5:
        outfit = "冬物コート"
    else:
        outfit = "ダウンコート"

    # 天気に基づく追加の服装
    if weather in ["Thunderstorm", "Rain", "Drizzle", "Squall"]:
        outfit += " 防水性のある服装"
    elif weather == "Snow":
        outfit += " 防水コート"
    elif weather in ["Fog", "Mist", "Haze"]:
        outfit += " 軽い防寒具"
    elif weather in ["Dust", "Ash", "Tornado"]:
        outfit += " マスク"

    return outfit

# CSVファイルの作成
with open('./python/csv/outfit_recommendations.csv', mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(["temperature", "weather", "is_cold_sensitive", "outfit"])

    for _ in range(200):
        weather = random.choice(list(temperature_weather_map.keys()))
        temp = random.choice(temperature_weather_map[weather])
        is_cold_sensitive = random.choice(is_cold_sensitive_options)
        outfit = determine_outfit(temp, is_cold_sensitive, weather)
        writer.writerow([temp, weather, is_cold_sensitive, outfit])