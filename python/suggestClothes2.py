import pandas as pd
import pickle
import sys
import os

def suggest_clothes2(tempMax, tempMin, is_cold_sensitive, is_hot_sensitive):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    model_path = os.path.join(script_dir, "model/outfit_model2.pkl")

    # ファイルの存在を確認
    if not os.path.exists(model_path):
        print(f"Error: Model file not found at {model_path}")
        sys.exit(1)

    # モデルと特徴量の順序の読み込み
    with open(model_path, "rb") as f:
        model, feature_order = pickle.load(f)

    # 入力データを準備
    input_data = pd.DataFrame([{
        "tempMax": tempMax,
        "tempMin": tempMin,
        "is_cold_sensitive": is_cold_sensitive,
        "is_hot_sensitive": is_hot_sensitive,
    }])

    # トレーニング時の特徴量の順序に合わせる
    input_data = input_data[feature_order]

    # 予測
    outfit = model.predict(input_data)[0]
    return outfit

if __name__ == "__main__":
    tempMax = float(sys.argv[1])
    tempMin = float(sys.argv[2])
    is_cold_sensitive = int(sys.argv[3])
    is_hot_sensitive = int(sys.argv[4])

    if(is_cold_sensitive == 1 and is_hot_sensitive == 1):
        print(f"suggestClothes.py: エラー: 寒がりと暑がりの両方を満たすことはできません")
        sys.exit(1)

    # AIで服装提案
    outfit = suggest_clothes2(tempMax, tempMin, is_cold_sensitive, is_hot_sensitive)
    print(f"{outfit}")