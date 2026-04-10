% Constants and parameters
desired_torque = 50;    % Desired torque (Nm)
Kp = 0.95;               % Proportional gain
dt = 0.05;             % Time step (s)
tolerance = 0.1;        % Tolerance for reaching the desired torque (Nm)
noise_std_dev = 0.5;      % Standard deviation of noise (Nm)

% Initial values
curr_torque = 25;        % Current torque (initialize to zero)
i_q = 5;                % Initial q-axis current

% Arrays to store data for plotting
time = [0];             % Time array for plotting
torque_values = [curr_torque];   % Array to store torque values for plotting
i_q_values = [i_q];     % Array to store q-axis current values for plotting

% Simulation loop
simulation_time = 5;    % Total simulation time (s)
while abs(desired_torque - curr_torque) > tolerance
    % Error calculation (desired_torque - current_torque)
    error = desired_torque - curr_torque;
    
    % Calculate the change in q-axis current using the P-controller
    delta_i_q = Kp * error;
    
    % Update the q-axis current
    i_q = i_q + delta_i_q;
    
    % Add noise to the measured torque
    noise = noise_std_dev * randn();  % Generate random noise sample
    curr_torque = i_q + noise;        % Add noise to the measured torque
    
    % Store data for plotting
    time = [time, time(end) + dt];
    torque_values = [torque_values, curr_torque];
    i_q_values = [i_q_values, i_q];
    
    % Ensure simulation doesn't run indefinitely
    if time(end) >= simulation_time
        break;
    end
end

% Display the q-axis current at which desired torque was achieved
disp(['Desired torque of ', num2str(desired_torque), ' Nm was achieved at i_q = ', num2str(i_q)]);

% Plot the results
figure;
plot(time, torque_values, 'b-', 'LineWidth', 2);
hold on;
plot(time, desired_torque*ones(size(time)), 'r--', 'LineWidth', 2);
hold off;
xlabel('Time (s)');
ylabel('Torque (Nm)');
legend('Current Torque', 'Desired Torque');
title('Torque Control with q-axis Current');

figure;
plot(time, i_q_values, 'b-', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('q-axis Current (A)');
title('q-axis Current Control');
