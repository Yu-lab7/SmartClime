from sklearn.ensemble import RandomForestClassifier
import pandas as pd
import pickle  # モデル保存用

def make_model():
    #データの読み込み
    df = pd.read_csv("python/csv/outfit_recommendations.csv")
    X = df[["temperature", "weather", "is_cold_sensitive"]]
    y = df["outfit"]

    # カテゴリ変数をエンコード
    X = pd.get_dummies(X, columns=["weather"])

    # モデル構築
    model = RandomForestClassifier(random_state=42)
    model.fit(X, y)

    # モデル保存
    with open("python/model/outfit_model.pkl", "wb") as f:
     pickle.dump(model, f)