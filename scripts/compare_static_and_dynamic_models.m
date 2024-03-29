%% ���������� ������ � ������ �������������
model_name = 'Dynamic_motor_model_vs_static_motor_model';
open_system(model_name);
set_param(model_name, 'StopTime', '0.4');
set_param([model_name, '/Set speed'], 'Value', '100');
set_param([model_name, '/Disturbance torque'], 'Value', '0.018');
simOut = sim(model_name);
static_model_voltage = simOut.get('static_model_voltage');
dynamic_model_voltage = simOut.get('dynamic_model_voltage');
close_system(model_name);
abs_error = dynamic_model_voltage.data - static_model_voltage.data;
rel_error = abs_error/dynamic_model_voltage.data;
rmse = sqrt(sum((abs_error).^2)/length(abs_error));
%% ������ �������
figure('Name', 'Comparing static and dynamic models voltage');
plot(static_model_voltage);
grid on;
hold on;
plot(dynamic_model_voltage);
xlabel('�����, �');
ylabel('����������, �');
legend('����������� ������', '������������ ������');
ylim([0, 1.05*max([max(static_model_voltage), max(dynamic_model_voltage)])]);

figure('Name', 'Abs error');
plot(abs_error, 'Color', 'black');
grid on;
xlabel('�����, �');
ylabel('���������� ������, �');
title('');

figure('Name', 'Rel error');
plot(rel_error, 'Color', 'black');
grid on;
xlabel('�����, �');
ylabel('������������� ������, �');
title('');