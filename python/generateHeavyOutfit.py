import csv
import random

temperature_limit_map = {
    "tempMax": range(0, 40),
    "tempMin": range(-10, 30)
}

def determine_heavyOutfit(tempMax, tempMin, is_cold_sensitive, is_hot_sensitive):
    if is_cold_sensitive:
        tempMax -= 5
        tempMin -= 5
    if is_hot_sensitive:
        tempMax += 5
        tempMin += 5

    if tempMax <= 15:
        outfit = "glove and scarf"
    elif tempMin <= 10:
        outfit = "glove and scarf"
    else:
        outfit = "no heavy outfit"

    return outfit

# CSVファイルの作成
with open('./python/csv/heavyOutfit_recommendations.csv', mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(["tempMax", "tempMin", "is_cold_sensitive", "is_hot_sensitive", "heavyOutfit"])

    for _ in range(200):
        tempMax = random.choice(temperature_limit_map["tempMax"])
        tempMin = random.choice(temperature_limit_map["tempMin"])
        is_cold_sensitive = random.choice([0, 1])
        is_hot_sensitive = random.choice([0, 1])
        
        # 寒がりと暑がりの両方が1の場合はランダムに1つを0にする
        if is_cold_sensitive == 1 and is_hot_sensitive == 1:
            if random.choice([True, False]):
                is_cold_sensitive = 0
            else:
                is_hot_sensitive = 0

        outfit = determine_heavyOutfit(tempMax, tempMin, is_cold_sensitive, is_hot_sensitive)
        writer.writerow([tempMax, tempMin, is_cold_sensitive, is_hot_sensitive, outfit])