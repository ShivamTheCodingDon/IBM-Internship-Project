from fastapi import FastAPI
from pydantic import BaseModel
import sys
import os

# Add src to python path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'src'))
from ev_core import ModelHandler, EVOptimizer

app = FastAPI(title="EV Motor Telemetry API v2")
handler = ModelHandler(models_dir="models/")
handler.load_pretrained()
optimizer = EVOptimizer()

class Telemetry(BaseModel):
    u_q: float
    stator_winding: float
    u_d: float
    stator_tooth: float
    motor_speed: float
    i_d: float
    i_q: float
    pm: float
    stator_yoke: float
    ambient: float

class OptimizationRequest(BaseModel):
    target_torque: float
    current_speed: float
    pm_temp: float

@app.get("/")
def home():
    return {
        "message": "Welcome to the EV Motor Analysis & Optimization API",
        "version": "2.0.0",
        "status": "operational"
    }

@app.post("/predict")
def predict(data: Telemetry):
    """Predicts motor status based on telemetry snapshot."""
    features = data.dict()
    predictions = handler.predict_status(features)
    return {
        "input": features,
        "predictions": predictions
    }

@app.post("/optimize")
def optimize(data: OptimizationRequest):
    """Calculates optimal Control Points and Derating factors."""
    id_opt = optimizer.get_optimal_id(data.target_torque, data.current_speed, 25.0)
    derate = optimizer.thermal_derating_factor(data.pm_temp)
    
    return {
        "target_torque": data.target_torque,
        "optimal_id": id_opt,
        "thermal_limit": derate,
        "recommendation": "Limit current" if derate < 1.0 else "Full performance"
    }

@app.post("/range_impact")
def range_impact(data: Telemetry):
    """Estimates the efficiency and battery range impact."""
    eff = optimizer.calculate_efficiency(
        data.u_q, data.u_d, data.i_q, data.i_d, data.motor_speed
    )
    return {
        "efficiency": f"{eff*100:.2f}%",
        "loss_category": "High" if eff < 0.85 else "Optimal"
    }
