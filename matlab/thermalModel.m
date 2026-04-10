% New thermal model parameters
R_stator = 0.05;              % Ohms
P_switching_loss = 100;       % W
hA = 50;                      % W/°C
C_motor = 500;                % J/°C

% Battery model
battery_capacity = 50e3;      % Wh
SOC = 100;                    % %
V_batt = 400;                 % Volts

% Simulation settings
sim_time = 300;               % total time in seconds
time_step = 1;                % 1 second per step
steps = sim_time / time_step;

% Initial states
T_motor = 40;                 % °C
T_coolant = 25;               % Constant coolant temp
I_q = 100;                    % Initial q-axis current

% Logging arrays
T_motor_log = zeros(steps,1);
SOC_log = zeros(steps,1);
time_array = (0:steps-1) * time_step;

for t = 1:steps
    % === Heat Generation ===
    P_copper = I_q^2 * R_stator;
    P_loss = P_copper + P_switching_loss;

    % === Newtonian Cooling ===
    dT_dt = (P_loss - hA * (T_motor - T_coolant)) / C_motor;
    T_motor = T_motor + dT_dt * time_step;

    % === Battery Energy Consumption ===
    P_total = P_loss + 500;  % add driving load
    energy_used_Wh = (P_total * time_step) / 3600;
    SOC = SOC - (energy_used_Wh / battery_capacity) * 100;
    SOC = max(SOC, 0);

    % === Log Data ===
    T_motor_log(t) = T_motor;
    SOC_log(t) = SOC;

end

figure;
subplot(2,1,1);
plot(time_array, T_motor_log, 'r-', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Motor Temperature (°C)');
title('Motor Temperature Over Time');

subplot(2,1,2);
plot(time_array, SOC_log, 'b-', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Battery SOC (%)');
title('Battery State of Charge Over Time');
