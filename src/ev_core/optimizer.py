import numpy as np

class EVOptimizer:
    """Advanced engineering core for EV efficiency optimization."""

    @staticmethod
    def calculate_efficiency(voltage_q, voltage_d, current_q, current_d, speed):
        """
        Calculates the electrical efficiency of the motor state.
        P_out = Torque * Speed
        P_in = 3/2 * (u_d*i_d + u_q*i_q)
        """
        # Note: In our dataset, inputs are often scaled or normalized. 
        # This implementation assumes standard physical units.
        p_in = abs(voltage_d * current_d + voltage_q * current_q)
        if p_in == 0:
            return 0.0
        
        # Power Loss estimate (Simplified Copper Loss)
        # R_s is typically around 0.05 - 0.1 for these motors
        r_s = 0.07 
        p_loss = 1.5 * r_s * (current_d**2 + current_q**2)
        
        efficiency = (p_in - p_loss) / p_in
        return max(0, min(1, efficiency))

    def get_optimal_id(self, target_torque, current_speed, am_temp):
        """
        Generic MTPA (Maximum Torque Per Ampere) Search stub.
        In a production system, this would use a Look-Up Table (LUT) 
        derived from the XGBoost models.
        """
        # Industry heuristic: for PMSM, i_d is often kept at 0 
        # until base speed is reached (Field Weakening starts after).
        if current_speed < 3000:
            return 0.0
        else:
            # Field Weakening: negative i_d to counter back-emf
            return -0.05 * (current_speed - 3000)

    @staticmethod
    def thermal_derating_factor(pm_temp):
        """
        Calculates a power limit to prevent magnet damage.
        Magnets typically risk damage above 100-120 C.
        """
        if pm_temp < 80:
            return 1.0
        elif pm_temp > 110:
            return 0.0
        else:
            # Linear derating between 80C and 110C
            return 1.0 - (pm_temp - 80) / 30
