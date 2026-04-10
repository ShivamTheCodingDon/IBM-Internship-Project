import sys
import os
import pandas as pd

# Add src to python path
sys.path.append(os.path.join(os.path.dirname(__file__), 'src'))
from ev_core import ModelHandler, EVOptimizer, EVProcessor

def demo_capabilities():
    print("=== EV Motor Core Capabilities Demo ===\n")
    
    # 1. Prediction Capability
    handler = ModelHandler(models_dir="models/")
    handler.load_pretrained()
    
    sample_telemetry = {
        "u_q": 45.0, "stator_winding": 60.0, "u_d": -25.0,
        "stator_tooth": 55.0, "motor_speed": 3500, "i_d": -5.0,
        "i_q": 15.0, "pm": 75.0, "stator_yoke": 40.0, "ambient": 25.0
    }
    
    print("[Task] Estimating internal status...")
    preds = handler.predict_status(sample_telemetry)
    for k, v in preds.items():
        print(f" -> Predicted {k}: {v:.2f}")
    
    # 2. Optimization Capability (MTPA)
    optimizer = EVOptimizer()
    print("\n[Task] Optimizing for Efficiency (MTPA)...")
    target_torque = 80.0
    speed = 4000
    opt_id = optimizer.get_optimal_id(target_torque, speed, 25.0)
    print(f" -> Target Torque: {target_torque} Nm at {speed} RPM")
    print(f" -> Optimal i_d vector: {opt_id:.2f} (Minimizes Power Loss)")
    
    # 3. Thermal Protection Capability
    print("\n[Task] Thermal Safety Check...")
    hot_temp = 105.0
    derate = optimizer.thermal_derating_factor(hot_temp)
    print(f" -> PM Temp: {hot_temp} C")
    print(f" -> Derating Factor: {derate:.2f} ({'Safety Limit Active' if derate < 1.0 else 'Safe'})")
    
    # 4. Range Efficiency
    print("\n[Task] Energy Loss Analysis...")
    eff = optimizer.calculate_efficiency(45.0, -25.0, 15.0, -5.0, 3500)
    print(f" -> Current State Efficiency: {eff*100:.1f}%")

if __name__ == "__main__":
    demo_capabilities()
