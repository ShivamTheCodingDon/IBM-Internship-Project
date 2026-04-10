% Constants and initial values
desired_temp = 22;   % Desired coolant temperature
ambient_temp = 20;   % Fixed ambient temperature
curr_temp = 35;      % Current coolant temperature (initially 33 degrees)
tolerance = 0.01;     % Tolerance for the desired temperature (smaller value for tighter control)
max_iterations = 100; % Maximum number of iterations for the control loop
time_step = 1;       % Time step for plotting

% Motor parameters (unchanged)
u_q = 230;           % Example value for the u_q parameter
stator_winding_temp = 50; % Example value for the stator winding temperature parameter
u_d = 0;             % Example value for the u_d parameter
stator_tooth_temp = 40;   % Example value for the stator tooth temperature parameter
motor_speed = 1000;  % Example value for the motor speed parameter

% PID controller parameters (unchanged)
Kp = 2.75;   % Proportional gain
Ki = 0.015;  % Integral gain
Kd = 0;  % Derivative gain
integral = 0;
prev_error = 0;

% Preallocate arrays for plotting and storing final values
time_steps = (1:max_iterations) * time_step;
temps = NaN(max_iterations, 1);
u_q_values = NaN(max_iterations, 1);
stator_winding_temp_values = NaN(max_iterations, 1);
motor_speed_values = NaN(max_iterations, 1);

final_u_q = u_q;
final_stator_winding_temp = stator_winding_temp;
final_motor_speed = motor_speed;

% Control loop
for iteration = 1:max_iterations
    % Calculate the average temperature of motor components
    avg_temp = (stator_winding_temp + stator_tooth_temp) / 2;
    
    % Calculate the difference between the desired temperature and the current average temperature
    error = desired_temp - avg_temp;
    
    % PID control
    integral = integral + error;
    derivative = error - prev_error;
    control_output = Kp * error + Ki * integral + Kd * derivative;
    
    % Adjust the parameters based on the control output
    u_q = u_q + control_output;
    stator_winding_temp = stator_winding_temp + 0.1 * control_output;
    motor_speed = motor_speed - 10 * control_output;
    
    % Calculate the new coolant temperature based on the average temperature
    curr_temp = avg_temp; % Use the average temperature as the coolant temperature
    
    % Update the current coolant temperature and previous error for the next iteration
    prev_error = error;
    
    % Store values for plotting
    temps(iteration) = curr_temp;
    u_q_values(iteration) = u_q;
    stator_winding_temp_values(iteration) = stator_winding_temp;
    motor_speed_values(iteration) = motor_speed;
end

% Plotting (updated x-axis to show time steps)
figure;

subplot(2, 2, 1);
plot(time_steps, temps, 'b-o');
hold on;
desired_line = plot([time_steps(1), time_steps(end)], [desired_temp, desired_temp], 'r--');
hold off;
xlabel('Time Steps');
ylabel('Coolant Temperature (°C)');
title('Coolant Temperature vs. Time Steps');
legend(desired_line, 'Desired Temperature');

subplot(2, 2, 2);
plot(time_steps, u_q_values, 'r-o');
xlabel('Time Steps');
ylabel('u_q');
title('u_q vs. Time Steps');

subplot(2, 2, 3);
plot(time_steps, stator_winding_temp_values, 'g-o');
xlabel('Time Steps');
ylabel('Stator Winding Temperature (°C)');
title('Stator Winding Temperature vs. Time Steps');

subplot(2, 2, 4);
plot(time_steps, motor_speed_values, 'm-o');
xlabel('Time Steps');
ylabel('Motor Speed');
title('Motor Speed vs. Time Steps');

sgtitle('Coolant Temperature and Motor Parameters Control');

% Display the final results
disp(['Final coolant temperature: ', num2str(curr_temp)]);
disp('Final motor parameters:');
disp(['u_q: ', num2str(u_q)]);
disp(['stator_winding_temp: ', num2str(stator_winding_temp)]);
disp(['motor_speed: ', num2str(motor_speed)]);