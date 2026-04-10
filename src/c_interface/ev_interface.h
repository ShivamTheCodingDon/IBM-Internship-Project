/**
 * @file ev_interface.h
 * @brief Embedded C++ Interface for the EV Motor Optimization Core.
 * 
 * This header serves as the bridge between the high-level Python models 
 * and the low-level Electronic Control Unit (ECU) software.
 */

#ifndef EV_INTERFACE_H
#define EV_INTERFACE_H

#include <vector>
#include <string>

namespace ev_performance {

struct TelemetryData {
    float u_q;
    float u_d;
    float i_q;
    float i_d;
    float speed;
    float torque;
    float stator_temp;
    float pm_temp;
    float ambient;
};

struct OptimizationResult {
    float optimal_id;
    float optimal_iq;
    float efficiency_score;
    float derating_factor;
};

/**
 * @brief Class to interface with the exported ML models.
 * Note: Implementation would typically wrap an ONNX Runtime 
 * or a TensorRT execution engine.
 */
class EVCounterpart {
public:
    virtual ~EVCounterpart() = default;

    /**
     * @brief Predicts component temperatures.
     */
    virtual float PredictPMTemp(const TelemetryData& data) = 0;

    /**
     * @brief Returns optimal current vectors for efficiency.
     */
    virtual OptimizationResult GetOptimalControl(float target_torque, float current_speed) = 0;
};

} // namespace ev_performance

#endif // EV_INTERFACE_H
