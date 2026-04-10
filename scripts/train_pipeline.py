import sys
import os
import argparse
import xgboost as xgb
import joblib
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score

# Add src to python path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'src'))
from ev_core import EVProcessor

def main(target):
    print(f"Starting pipeline for target: {target}")
    
    # Load and process data
    data_path = "data/outlier_removed_org.csv"
    if not os.path.exists(data_path):
        print(f"Error: {data_path} not found. Please ensure CSVs are in Data folder.")
        return
        
    df = EVProcessor.load_data(data_path)
    X, y = EVProcessor.split_features_target(df, target)
    
    # Split
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Train
    print("Training XGBRegressor...")
    model = xgb.XGBRegressor(n_estimators=100, max_depth=6, learning_rate=0.1)
    model.fit(X_train, y_train)
    
    # Eval
    preds = model.predict(X_test)
    score = r2_score(y_test, preds)
    print(f"Model R2 Score: {score:.4f}")
    
    # Save
    save_path = f"models/{target}_new_v1.joblib"
    joblib.dump(model, save_path)
    print(f"Model saved to {save_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--target", default="motor_speed", help="The column to predict")
    args = parser.parse_args()
    main(args.target)
