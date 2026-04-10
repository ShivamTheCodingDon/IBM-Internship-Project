% Parameters
N = 1000;
dt = 1; % Time step [s]

% Motor dynamics (synthetic input)
ambient_temp = 25 * ones(N,1);                  
torque = 90 + 5 * randn(N,1);                  
motor_speed = 5500 + 100 * randn(N,1);       

% Target battery temperature
T_target = 35;

% Battery thermal model parameters
p.alpha = 0.001;     % Heat gen from torque
p.beta = 0.00005;    % Heat gen from speed
p.gamma = 0.01;      % Heat loss to ambient
p.C_batt = 1000;     % Heat capacity
p.R_batt = 0.5;      % Thermal resistance batt–coolant

% PID parameters (tune these)
Kp = 5;
Ki = 0.1;
Kd = 2;

% Initial conditions
battery_temp = zeros(N,1);
coolant_temp = zeros(N,1);
battery_temp(1) = ambient_temp(1);
coolant_temp(1) = ambient_temp(1);

% PID state
error_sum = 0;
prev_error = 0;

% Simulate
for t = 1:N-1
    % === PID Controller ===
    error = T_target - battery_temp(t);
    error_sum = error_sum + error * dt;
    d_error = (error - prev_error) / dt;
    prev_error = error;

    % PID output controls coolant temperature
    coolant_temp(t) = ambient_temp(t) + Kp * error + Ki * error_sum + Kd * d_error;

    % Heat generation
    Q_gen = p.alpha * torque(t)^2 + p.beta * motor_speed(t)^2;

    % Battery thermal dynamics
    dT = (1/p.C_batt) * ( ...
         (coolant_temp(t) - battery_temp(t))/p.R_batt + ...
          Q_gen - ...
          p.gamma * (battery_temp(t) - ambient_temp(t)) );

    % Integrate
    battery_temp(t+1) = battery_temp(t) + dt * dT;
end

% Last coolant temp
coolant_temp(end) = coolant_temp(end-1);

% Plot results
figure;
subplot(3,1,1);
plot(battery_temp, 'r'); ylabel('Battery Temp [°C]');
title('Battery Temp with PID Cooling');

subplot(3,1,2);
plot(coolant_temp, 'b'); ylabel('Coolant Temp [°C]');

subplot(3,1,3);
plot(torque, 'k'); hold on; plot(motor_speed, 'g');
legend('Torque [Nm]', 'Motor Speed [rpm]'); ylabel('Input'); xlabel('Time [s]');