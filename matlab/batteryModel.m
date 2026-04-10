function battery_temp_sim = simulateBatteryTemp(coolant_temp, torque, speed, ambient_temp, dt, p)
    % Simulates battery temperature over time considering:
    % - motor heat load,
    % - heat exchange with coolant,
    % - ambient heat loss

    N = length(coolant_temp);
    battery_temp_sim = zeros(N, 1);
    battery_temp_sim(1) = ambient_temp(1);  % Initial battery temp set to ambient

    for t = 1:N-1
        % Heat generation from torque and speed
        Q_gen = p.alpha * torque(t)^2 + p.beta * speed(t)^2;

        % Net heat transfer
        dT = (1/p.C_batt) * ( ...
            (coolant_temp(t) - battery_temp_sim(t)) / p.R_batt + ... % exchange with coolant
            Q_gen - ...                                              % internal generation
            p.gamma * (battery_temp_sim(t) - ambient_temp(t)) );     % ambient heat loss

        % Temperature update via Euler integration
        battery_temp_sim(t+1) = battery_temp_sim(t) + dt * dT;
    end
end

% Parameters
N = 1000;                             % Number of timesteps
dt = 0.1;                             % Time step [s]

% Synthetic input data
ambient_temp = 25 * ones(N, 1);                   % Ambient temperature [°C]
coolant_temp = 29.12 + 0.2 * randn(N, 1);         % Coolant temp with small fluctuations [°C]
torque = 90 + 5 * randn(N, 1);                    % Motor torque [Nm]
motor_speed = 5500 + 100 * randn(N, 1);           % Motor speed [RPM]

% Thermal parameters
p.C_batt = 5000;        % Battery thermal capacity [J/°C]
p.R_batt = 0.2;         % Thermal resistance between battery and coolant [°C/W]
p.alpha = 0.01;         % Torque heating coefficient
p.beta = 0.00001;       % Speed heating coefficient
p.gamma = 0.02;         % Ambient heat loss coefficient

% Simulate battery temperature
battery_temp = simulateBatteryTemp(coolant_temp, torque, motor_speed, ambient_temp, dt, p);

% Plot results
time = (0:N-1) * dt;
plot(time, battery_temp, 'LineWidth', 1.5);
xlabel('Time [s]');
ylabel('Battery Temperature [°C]');
title('Battery Temperature Simulation');
grid on;