%% Подгодовка данных и запуск моделирования
load('Robotino_data.mat');
model_name = 'Motor_model_with_Matlab_interface';
open_system(model_name);
n = length(motor1_reference.time);
disturbance_torque = timeseries(M_dist*ones(n,1), motor1_reference.time);
set_param(model_name, 'StopTime', num2str(motor1_reference.time(end)));
set_param([model_name, '/Set speed'], 'VariableName', 'motor1_reference');
set_param([model_name, '/Disturbance torque'], 'VariableName', 'disturbance_torque');
simOut = sim(model_name);
speed = simOut.get('speed');
current = simOut.get('current');
%% Построение графиков
leg = ["Эксперимент", "Модель"];
lim_x_axis = [0, 58.5];
figure('Name', 'Speed');
plot(motor1_output);
grid on;
hold on;
plot(speed, 'LineWidth', 1);
xlabel('Время, с');
ylabel('Угловая скорость, рад/с');
legend(leg);
xlim(lim_x_axis);
ylim([-120, 120]);
yticks(-120:20:120);

figure('Name', 'Current');
plot(motor1_current);
grid on;
hold on;
plot(current, 'LineWidth', 2);
xlabel('Время, с');
ylabel('Ток, А');
legend(leg);
xlim(lim_x_axis);
%% Чистка данных
close_system(model_name);
clear model_name n disturbance_torque simOut speed current leg