import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
import pickle
import os

# CSVファイルの読み込み
csv_path = os.path.join(os.path.dirname(__file__), 'csv', 'heavyOutfit_recommendations.csv')
df = pd.read_csv(csv_path)

# 特徴量とターゲットの設定
X = df[['tempMax', 'tempMin', 'is_cold_sensitive', 'is_hot_sensitive']]
y = df['heavyOutfit']

# データをトレーニングセットとテストセットに分割
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# ランダムフォレストモデルの作成とトレーニング
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# モデルと特徴量の順序を保存
model_path = os.path.join(os.path.dirname(__file__), 'model', 'outfit_model2.pkl')
with open(model_path, "wb") as f:
    pickle.dump((model, X.columns.tolist()), f)
    print("makeModel2.py: モデルを作成しました")