import sys
import os
import pandas as pd

# Add src to python path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'src'))
from ev_core import EVProcessor

def test_data_loading():
    # Create a small dummy csv
    dummy_data = "data/dummy.csv"
    df = pd.DataFrame({'u_q': [1.0, 2.0], 'profile_id': [1, 2]})
    df.to_csv(dummy_data, index=False)
    
    loaded_df = EVProcessor.load_data(dummy_data)
    
    assert 'profile_id' not in loaded_df.columns
    assert 'u_q' in loaded_df.columns
    os.remove(dummy_data)

def test_feature_split():
    df = pd.DataFrame({'feature1': [1, 2], 'target': [0, 1]})
    X, y = EVProcessor.split_features_target(df, 'target')
    
    assert X.shape == (2, 1)
    assert y.shape == (2,)
    assert 'target' not in X.columns
