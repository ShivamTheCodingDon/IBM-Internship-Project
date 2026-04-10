import joblib
import pandas as pd
import pathlib

class ModelHandler:
    """Handles model loading and multi-variable prediction."""
    
    def __init__(self, models_dir):
        self.models_dir = pathlib.Path(models_dir)
        self.coolant_model = None
        self.torque_model = None
        
    def load_pretrained(self):
        """Loads the standard models provided in the repository."""
        c_path = self.models_dir / 'coolant_pred.joblib'
        t_path = self.models_dir / 'torque_pred.joblib'
        
        if c_path.exists():
            self.coolant_model = joblib.load(c_path)
        if t_path.exists():
            self.torque_model = joblib.load(t_path)

    def predict_status(self, features_dict):
        """Perform predictions for multiple variables given a telemetry snapshot."""
        df = pd.DataFrame([features_dict])
        results = {}
        
        if self.coolant_model:
            results['coolant_temp'] = float(self.coolant_model.predict(df)[0])
        if self.torque_model:
            results['torque'] = float(self.torque_model.predict(df)[0])
            
        return results
