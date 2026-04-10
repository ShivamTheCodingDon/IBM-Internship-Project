import pandas as pd
import json

files = [
    'measures_v2.csv', 
    'outlier_removed_org.csv', 
    'outlier_removed_data_up.csv', 
    'outlier_removed_data_temp.csv'
]

summary = {}

for f in files:
    try:
        df = pd.read_csv(f)
        summary[f] = {
            "shape": df.shape,
            "columns": list(df.columns),
            "sample": df.head(5).to_dict(orient="records"),
            "description": df.describe().to_dict()
        }
    except Exception as e:
        summary[f] = {"error": str(e)}

with open("dataset_summary.json", "w") as jf:
    json.dump(summary, jf, indent=4)
