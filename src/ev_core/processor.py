import pandas as pd
import numpy as np

class EVProcessor:
    """Handles data loading and cleaning for the EV Motor Dataset."""
    
    @staticmethod
    def load_data(filepath):
        """Loads CSV data and removes profile_id which is not used for direct regression."""
        df = pd.read_csv(filepath)
        if 'profile_id' in df.columns:
            df = df.drop(columns=['profile_id'])
        return df

    @staticmethod
    def remove_stale_data(df):
        """Placeholder for logic to remove constants or faulty sensor readings."""
        # Industry standard: check for columns with zero variance
        return df.loc[:, (df != df.iloc[0]).any()]

    @staticmethod
    def split_features_target(df, target_col):
        """Splits the dataframe into features and the specified target."""
        if target_col not in df.columns:
            raise ValueError(f"Target column {target_col} not found in dataset.")
        X = df.drop(columns=[target_col])
        y = df[target_col]
        return X, y
