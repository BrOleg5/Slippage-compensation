%% �������� ������
data = readtable("experimental_data.csv", 'HeaderLines', 1);
data.Properties.VariableNames = {'Time, ms', 'X axis speed, mm/s', ...
                              'Y axis speed, mm/s', 'Rotational speed, deg/s',...
                              'Motor 1 encoder, ticks', 'Motor 2 encoder, ticks',...	
                              'Motor 3 encoder, ticks', 'Motor 1 velocity, rpm',...
                              'Motor 2 velocity, rpm', 'Motor 3 velocity, rpm',...
                              'Motor 1 current, A', 'Motor 2 current, A',...
                              'Motor 3 current, A', 'Sum motor current, A',...
                              'Current X, A', 'Current Y, A', 'Current Z, A',...
                              'X gyro', 'Y gyro', 'Z gyro', 'X accel', 'Y accel',...
                              'Z accel', 'X coordinate, pixels', 'Y coodinate, pixels',...
                              'Angle, deg', 'Delta angle, deg',  'Delta X, mm', 'Delta Y, mm'};
Reference_X = table2array(data(:,2));
Reference_Y = table2array(data(:,3));
Reference_Z = table2array(data(:,4));
motor1_velocity = table2array(data(:,8));
motor2_velocity = table2array(data(:,9));
motor3_velocity = table2array(data(:,10));
motor1_current = table2array(data(:,11));
motor2_current = table2array(data(:,12));
motor3_current = table2array(data(:,13));
motor_current_sum = table2array(data(:,14));
current_X = table2array(data(:,15));
current_Y = table2array(data(:,16));
current_Z = (sign(motor1_velocity).*motor1_current + ...
             sign(motor2_velocity).*motor2_current + ...
             sign(motor3_velocity).*motor3_current)/3;;
delta_x = table2array(data(:,28));
delta_y = table2array(data(:,29));
delta_angle = table2array(data(:,27));
angle = table2array(data(:,26));
%% ������������� ������
velocity = sqrt((delta_x/0.5).^2 + (delta_y/0.5).^2);
current_vector = sqrt(current_X.^2 + current_Y.^2);

non_zero_speed_by_X_ind = Reference_X ~= 0;
non_zero_delta_x = delta_x(non_zero_speed_by_X_ind);
non_zero_current_X = current_X(non_zero_speed_by_X_ind);

non_zero_speed_by_Y_ind = Reference_Y ~= 0;
non_zero_delta_y = delta_y(non_zero_speed_by_Y_ind);
non_zero_current_Y = current_Y(non_zero_speed_by_Y_ind);

non_zero_speed_by_Z_ind = Reference_Z ~= 0;
non_zero_delta_Z = delta_angle(non_zero_speed_by_Z_ind);
non_zero_current_Z = current_Z(non_zero_speed_by_Z_ind);
%% ������ ����������� �������� ������ ����� ��� X �� �������� ������������� ����
% �� ��� X ��� �������� ��������
speed = [300, 400, 500];
speed_by_X_ind = abs(Reference_X) == speed(1);
delta_x_speed = delta_x(speed_by_X_ind);
current_X_speed = current_X(speed_by_X_ind);

figure('Name', ['������ ����������� �������� ������ ����� ��� X �� ��������'...
                '������������� ���� �� ��� X ��� �������� ��������']);
plot(current_X_speed, delta_x_speed/0.5, 'o');
grid on;
xlabel("��� �� ��� X, �");
ylabel("�������� �� ��� X, ��/�");
%% ������ ����������� �������� ������ ����� ��� X �� �������� ������������� ����
% �� ��� X ��� �������� ���������
speed_by_X_ind_300 = (abs(Reference_X) == 300) & (abs(Reference_X)>=abs(delta_x/0.5));
delta_x_speed_300 = delta_x(speed_by_X_ind_300);
current_X_speed_300 = current_X(speed_by_X_ind_300);

speed_by_X_ind_400 = (abs(Reference_X) == 400) & (abs(Reference_X)>=abs(delta_x/0.5));
delta_x_speed_400 = delta_x(speed_by_X_ind_400);
current_X_speed_400 = current_X(speed_by_X_ind_400);

speed_by_X_ind_500 = (abs(Reference_X) == 500) & (abs(Reference_X)>=abs(delta_x/0.5));
delta_x_speed_500 = delta_x(speed_by_X_ind_500);
current_X_speed_500 = current_X(speed_by_X_ind_500);

figure('Name', ['������ ����������� �������� ������ ����� ��� X �� ��������'...
                '������������� ���� �� ��� X ��� �������� ���������']);
plot(abs(current_X_speed_300), abs(delta_x_speed_300/0.5), 'o');
grid on;
hold on;
plot(abs(current_X_speed_400), abs(delta_x_speed_400/0.5), 'o');
plot(abs(current_X_speed_500), abs(delta_x_speed_500/0.5), 'o');
xlabel("��� �� ��� X, �");
ylabel("�������� �� ��� X, ��/�");
legend("v_{set}=300 ��/�", "v_{set}=400 ��/�", "v_{set}=500 ��/�");
%% ������ ����������� ��������� �������� ������ � �������� �������� ����� ��� X
% �� �������� ������������� ���� �� ��� X ��� �������� ���������
speed_by_X_ind_300 = (abs(Reference_X) == 300) & (abs(Reference_X)>=abs(delta_x/0.5));
reference_x_300 = Reference_X(speed_by_X_ind_300);
delta_x_speed_300 = delta_x(speed_by_X_ind_300);
current_X_speed_300 = current_X(speed_by_X_ind_300);

speed_by_X_ind_400 = (abs(Reference_X) == 400) & (abs(Reference_X)>=abs(delta_x/0.5));
reference_x_400 = Reference_X(speed_by_X_ind_400);
delta_x_speed_400 = delta_x(speed_by_X_ind_400);
current_X_speed_400 = current_X(speed_by_X_ind_400);

speed_by_X_ind_500 = (abs(Reference_X) == 500) & (abs(Reference_X)>=abs(delta_x/0.5));
reference_x_500 = Reference_X(speed_by_X_ind_500);
delta_x_speed_500 = delta_x(speed_by_X_ind_500);
current_X_speed_500 = current_X(speed_by_X_ind_500);

current_X_all_speed = abs([current_X_speed_300; current_X_speed_400; current_X_speed_500]);
speed_x_all_speed = abs([delta_x_speed_300./(0.5*reference_x_300); ...
                         delta_x_speed_400./(0.5*reference_x_400); ...
                         delta_x_speed_500./(0.5*reference_x_500)]);
data_set_X = [current_X_all_speed, speed_x_all_speed];

figure('Name', ['������ ����������� ��������� �������� ������ � �������� �������� ����� ��� X'...
                '�� �������� ������������� ���� �� ��� X ��� �������� ���������']);
plot(abs(current_X_speed_300), abs(delta_x_speed_300./(0.5*reference_x_300)), 'o');
grid on;
hold on;
plot(abs(current_X_speed_400), abs(delta_x_speed_400./(0.5*reference_x_400)), 'o');
plot(abs(current_X_speed_500), abs(delta_x_speed_500./(0.5*reference_x_500)), 'o');
xlabel("��� �� ��� X, �");
ylabel("$\frac{v_{out}}{v_{set}}$", "Interpreter", "latex", "FontSize", 22);
legend("v_{set}=300 ��/�", "v_{set}=400 ��/�", "v_{set}=500 ��/�");
%% ������ ����������� �������� ������ ����� ��� Y �� �������� ������������� ����
% �� ��� Y ��� �������� ��������
speed = [300, 400, 500];
speed_by_Y_ind = abs(Reference_Y) == speed(1);
delta_y_speed = delta_y(speed_by_Y_ind);
current_Y_speed = current_Y(speed_by_Y_ind);

figure('Name', ['������ ����������� �������� ������ ����� ��� Y �� ��������'... 
                '������������� ���� �� ��� Y ��� �������� ��������']);
plot(current_Y_speed, delta_y_speed/0.5, 'o');
grid on;
xlabel("��� �� ��� Y, �");
ylabel("�������� �� ��� Y, ��/�");
%% ������ ����������� �������� ������ ����� ��� Y �� �������� ������������� ����
% �� ��� Y ��� �������� ���������
speed_by_Y_ind_300 = abs(Reference_Y) == 300;
delta_y_speed_300 = delta_y(speed_by_Y_ind_300);
current_Y_speed_300 = current_Y(speed_by_Y_ind_300);

speed_by_Y_ind_400 = abs(Reference_Y) == 400;
delta_y_speed_400 = delta_y(speed_by_Y_ind_400);
current_Y_speed_400 = current_Y(speed_by_Y_ind_400);

speed_by_Y_ind_500 = abs(Reference_Y) == 500;
delta_y_speed_500 = delta_y(speed_by_Y_ind_500);
current_Y_speed_500 = current_Y(speed_by_Y_ind_500);

figure('Name', ['������ ����������� �������� ������ ����� ��� Y �� ��������'...
                '������������� ���� �� ��� Y ��� �������� ���������']);
plot(abs(current_Y_speed_300), abs(delta_y_speed_300/0.5), 'o');
grid on;
hold on;
plot(abs(current_Y_speed_400), abs(delta_y_speed_400/0.5), 'o');
plot(abs(current_Y_speed_500), abs(delta_y_speed_500/0.5), 'o');
xlabel("��� �� ��� Y, �");
ylabel("�������� �� ��� Y, ��/�");
legend("v_{set}=300 ��/�", "v_{set}=400 ��/�", "v_{set}=500 ��/�");
%% ������ ����������� ��������� �������� ������ � �������� �������� ����� ��� Y
% �� �������� ������������� ���� �� ��� Y ��� �������� ���������
speed_by_Y_ind_300 = abs(Reference_Y) == 300;
reference_y_300 = Reference_Y(speed_by_Y_ind_300);
delta_y_speed_300 = delta_y(speed_by_Y_ind_300);
current_Y_speed_300 = current_Y(speed_by_Y_ind_300);

speed_by_Y_ind_400 = abs(Reference_Y) == 400;
reference_y_400 = Reference_Y(speed_by_Y_ind_400);
delta_y_speed_400 = delta_y(speed_by_Y_ind_400);
current_Y_speed_400 = current_Y(speed_by_Y_ind_400);

speed_by_Y_ind_500 = abs(Reference_Y) == 500;
reference_y_500 = Reference_Y(speed_by_Y_ind_500);
delta_y_speed_500 = delta_y(speed_by_Y_ind_500);
current_Y_speed_500 = current_Y(speed_by_Y_ind_500);

current_Y_all_speed = abs([current_Y_speed_300; current_Y_speed_400; current_Y_speed_500]);
speed_y_all_speed = abs([delta_y_speed_300./(0.5*reference_y_300); ...
                         delta_y_speed_400./(0.5*reference_y_400); ...
                         delta_y_speed_500./(0.5*reference_y_500)]);
data_set_Y = [current_Y_all_speed, speed_y_all_speed];


figure('Name', ['������ ����������� ��������� �������� ������ � �������� �������� ����� ��� Y'...
                '�� �������� ������������� ���� �� ��� Y ��� �������� ���������']);
plot(abs(current_Y_speed_300), abs(delta_y_speed_300./(0.5*reference_y_300)), 'o');
grid on;
hold on;
plot(abs(current_Y_speed_400), abs(delta_y_speed_400./(0.5*reference_y_400)), 'o');
plot(abs(current_Y_speed_500), abs(delta_y_speed_500./(0.5*reference_y_500)), 'o');
xlabel("��� �� ��� Y, �");
ylabel("$\frac{v_{out}}{v_{set}}$", "Interpreter", "latex", "FontSize", 22);
legend("v_{set}=300 ��/�", "v_{set}=400 ��/�", "v_{set}=500 ��/�");
%% ������ ����������� �������� �������� ������ �� �������� ������������� ����
% �� ��� Z ��� �������� ��������
speed = [20, 30, 40];
speed_by_Z_ind = abs(Reference_Z) == speed(1);
delta_z_speed = delta_angle(speed_by_Z_ind);
current_Z_speed = current_Z(speed_by_Z_ind);

figure('Name', ['������ ����������� �������� �������� ������ �� ��������'...
                '������������� ���� �� ��� Z ��� �������� ��������']);
plot(current_Z_speed, delta_z_speed/0.5, 'o');
grid on;
xlabel("��� �� ��� Z, �");
ylabel("�������� ��������, \circ/�");
%% ������ ����������� �������� �������� ������ �� �������� ������������� ����
% �� ��� Z ��� �������� ���������
speed_by_Z_ind_20 = (abs(Reference_Z) == 20) & (abs(Reference_Z)>=abs(delta_angle/0.5));
delta_z_speed_20 = delta_angle(speed_by_Z_ind_20);
current_Z_speed_20 = current_Z(speed_by_Z_ind_20);

speed_by_Z_ind_30 = abs(Reference_Z) == 30 & (abs(Reference_Z)>=abs(delta_angle/0.5));
delta_z_speed_30 = delta_angle(speed_by_Z_ind_30);
current_Z_speed_30 = current_Z(speed_by_Z_ind_30);

speed_by_Z_ind_40 = abs(Reference_Z) == 40 & (abs(Reference_Z)>=abs(delta_angle/0.5));
delta_z_speed_40 = delta_angle(speed_by_Z_ind_40);
current_Z_speed_40 = current_Z(speed_by_Z_ind_40);

figure('Name', ['������ ����������� �������� ������ ����� ��� Y �� ��������'...
                '������������� ���� �� ��� Y ��� �������� ���������']);
plot(abs(current_Z_speed_20), abs(delta_z_speed_20/0.5), 'o');
grid on;
hold on;
plot(abs(current_Z_speed_30), abs(delta_z_speed_30/0.5), 'o');
plot(abs(current_Z_speed_40), abs(delta_z_speed_40/0.5), 'o');
xlabel("��� �� ��� Z, �");
ylabel("�������� ��������, \circ/�");
legend("\omega_{set}=20 \circ/�", "\omega_{set}=30 \circ/�", "\omega_{set}=40 \circ/�");
%% ������ ����������� ��������� �������� �������� ������ � �������� �������� ��������
% �� �������� ������������� ���� �� ��� Z ��� �������� ���������
speed_by_Z_ind_20 = (abs(Reference_Z) == 20) & (abs(Reference_Z)>=abs(delta_angle/0.5));
reference_z_20 = Reference_Z(speed_by_Z_ind_20);
delta_z_speed_20 = delta_angle(speed_by_Z_ind_20);
current_Z_speed_20 = current_Z(speed_by_Z_ind_20);

speed_by_Z_ind_30 = abs(Reference_Z) == 30 & (abs(Reference_Z)>=abs(delta_angle/0.5));;
reference_z_30 = Reference_Z(speed_by_Z_ind_30);
delta_z_speed_30 = delta_angle(speed_by_Z_ind_30);
current_Z_speed_30 = current_Z(speed_by_Z_ind_30);

speed_by_Z_ind_40 = abs(Reference_Z) == 40 & (abs(Reference_Z)>=abs(delta_angle/0.5));
reference_z_40 = Reference_Z(speed_by_Z_ind_40);
delta_z_speed_40 = delta_angle(speed_by_Z_ind_40);
current_Z_speed_40 = current_Z(speed_by_Z_ind_40);

current_Z_all_speed = abs([current_Z_speed_20; current_Z_speed_30; current_Z_speed_40]);
speed_z_all_speed = abs([delta_z_speed_20./(0.5*reference_z_20); ...
                         delta_z_speed_30./(0.5*reference_z_30); ...
                         delta_z_speed_40./(0.5*reference_z_40)]);
data_set_Z = [current_Z_all_speed, speed_z_all_speed];

figure('Name', ['������ ����������� ��������� �������� �������� ������ � �������� �������� �������� '...
                '�� �������� ������������� ���� �� ��� Z ��� �������� ���������']);
plot(abs(current_Z_speed_20), abs(delta_z_speed_20./(0.5*reference_z_20)), 'o');
grid on;
hold on;
plot(abs(current_Z_speed_30), abs(delta_z_speed_30./(0.5*reference_z_30)), 'o');
plot(abs(current_Z_speed_40), abs(delta_z_speed_40./(0.5*reference_z_40)), 'o');
xlabel("��� �� ��� Z, �");
ylabel("$\frac{\omega_{out}}{\omega_{set}}$", "Interpreter", "latex", "FontSize", 22);
legend("\omega_{set}=20 \circ/�", "\omega_{set}=30 \circ/�", "\omega_{set}=40 \circ/�");
%% ������ ����������� �������� �������� ������ �� �������� ������������� ����
% �� ��� Z
figure('Name', ['������ ����������� �������� �������� ������ �� ��������'...
                '������������� ���� �� ��� Z']);
plot(abs(current_Z), abs(delta_angle./(0.5*Reference_Z)), 'o');
grid on;
xlabel("��� �� ��� Z, �");
ylabel("�������� ��������, \circ/�");
%% ������ ����������� �������� ������ ����� ��� X �� �������� ������������� ����
% �� ��� X
figure('Name', ['������ ����������� �������� ������ ����� ��� X �� ��������'...
                '������������� ���� �� ��� X']);
plot(abs(current_X), abs(delta_x./(0.5*Reference_X)), 'o');
grid on;
xlabel("��� �� ��� X, �");
ylabel("�������� �� ��� X, ��/�");
%% ������ ����������� �������� ������ ����� ��� Y �� �������� ������������� ����
% �� ��� Y
figure('Name', ['������ ����������� �������� ������ ����� ��� Y �� ��������'... 
                '������������� ���� �� ��� Y']);
plot(abs(current_Y), abs(delta_y./(0.5*Reference_Y)), 'o');
grid on;
xlabel("��� �� ��� Y, �");
ylabel("�������� �� ��� Y, ��/�");
%% ������ ����������� �������� ������ ����� ��� X �� ����� ����� ����������
figure('Name', ['������ ����������� �������� ������ ����� ��� X' ... 
                '�� ����� ����� ����������']);
plot(motor_current_sum, delta_x/0.5, 'o');
grid on;
xlabel("����� ����� 3-� �������, �");
ylabel("�������� �� ��� X, ��/�");
%% ������ ����������� �������� ������ ����� ��� Y �� ����� ����� ����������
figure('Name', ['������ ����������� �������� ������ ����� ��� Y' ... 
                '�� ����� ����� ����������']);
plot(motor_current_sum, delta_y/0.5, 'o');
grid on;
xlabel("����� ����� 3-� �������, �");
ylabel("�������� �� ��� Y, ��/�");
%% ������ ����������� �������� ������ ����� ��� X �� ����� ����� ����������
% � ������ �����
figure('Name', ['������ ����������� �������� ������ ����� ��� X'... 
                '�� ����� ����� ���������� � ������ �����']);
plot(current_Z, delta_x/0.5, 'o');
grid on;
xlabel("��� �� ��� Z, �");
ylabel("�������� �� ��� X, ��/�");
%% ������ ����������� �������� ������ ����� ��� Y �� ����� ����� ����������
% � ������ �����
figure('Name', ['������ ����������� �������� ������ ����� ��� Y' ...
                '�� ����� ����� ���������� � ������ �����']);
plot(current_Z, delta_y/0.5, 'o');
grid on;
xlabel("��� �� ��� Z, �");
ylabel("�������� �� ��� Y, ��/�");
%% ������ ����������� �������� ������ ����� ��� Y �� �������� ������������� ����
% �� ��� X
figure('Name', ['������ ����������� �������� ������ ����� ��� Y' ...
                '�� �������� ������������� ���� �� ��� X']);
plot(current_X, delta_y/0.5, 'o');
grid on;
xlabel("��� �� ��� X, �");
ylabel("�������� �� ��� Y, ��/�");
%% ������ ����������� �������� ������ ����� ��� X �� �������� ������������� ����
% �� ��� Y
figure('Name', ['������ ����������� �������� ������ ����� ��� X' ...
                '�� �������� ������������� ���� �� ��� Y']);
plot(current_Y, delta_x/0.5, 'o');
grid on;
xlabel("��� �� ��� Y, �");
ylabel("�������� �� ��� X, ��/�");
%% ������ ����������� �������� �������� ������ �� �������� ������������� ����
% �� ��� Z. ��������� ������������, ��� �������� �� ���� ������.
figure('Name', ['������ ����������� �������� �������� ������ �� ��������' ...
                '������������� ���� �� ��� Z. ��������� ������������,' ...
                '��� �������� �� ���� ������.']);
plot(non_zero_current_Z, non_zero_delta_Z/0.5, 'o');
grid on;
xlabel("��� �� ��� Z, �");
ylabel("�������� ��������, \circ/�");
%% ������ ����������� �������� ������ ����� ��� X �� �������� ������������� ����
% �� ��� X. ��������� ������������, ��� �������� ����� ��� X �� ���� ������.
figure('Name', ['������ ����������� �������� ������ ����� ��� X �� ��������' ...
                '������������� ���� �� ��� X. ��������� ������������,' ...
                '��� �������� ����� ��� X �� ���� ������.']);
plot(non_zero_current_X, non_zero_delta_x/0.5, 'o');
grid on;
xlabel("��� �� ��� X, �");
ylabel("�������� �� ��� X, ��/�");
%% ������ ����������� �������� ������ ����� ��� Y �� �������� ������������� ����
% �� ��� Y. ��������� ������������, ��� �������� ����� ��� Y �� ���� ������.
figure('Name', ['������ ����������� �������� ������ ����� ��� Y �� ��������' ...
                '������������� ���� �� ��� Y. ��������� ������������,' ...
                '��� �������� ����� ��� Y �� ���� ������.']);
plot(non_zero_current_Y, non_zero_delta_y/0.5, 'o');
grid on;
xlabel("��� �� ��� Y, �");
ylabel("�������� �� ��� Y, ��/�");
%% ������ ����������� �������� ������ ����� ��� X �� �������� ������������� ����
% �� ��� X. �� ��� �������� ��������� ������� �������� ��������� �� 50
% �������� �� ��� ����.
[filtered_current_x, filtered_delta_x] = mean_on_intervals(current_X, delta_x, 50);
figure('Name', ['������ ����������� �������� ������ ����� ��� X �� ��������' ...
                '������������� ���� �� ��� X. �� ��� �������� ���������' ...
                '������� �������� ��������� �� 50 �������� �� ��� ����.']);
plot(filtered_current_x, filtered_delta_x/0.5, 'o');
grid on;
xlabel("��� �� ��� X, �");
ylabel("�������� �� ��� X, ��/�");
%% ������ ����������� �������� ������ ����� ��� Y �� �������� ������������� ����
% �� ��� Y. �� ��� �������� ��������� ������� �������� ��������� �� 50
% �������� �� ��� ����.
[filtered_current_y, filtered_delta_y] = mean_on_intervals(current_Y, delta_y, 50);
figure('Name', ['������ ����������� �������� ������ ����� ��� Y �� ��������' ...
                '������������� ���� �� ��� Y. �� ��� �������� ���������' ...
                '������� �������� ��������� �� 50 �������� �� ��� ����.']);
plot(filtered_current_y, filtered_delta_y/0.5, 'o');
grid on;
xlabel("��� �� ��� Y, �");
ylabel("�������� �� ��� Y, ��/�");
%% ������ ����������� �������� ������ ����� ��� Z �� �������� ������������� ����
% �� ��� Z. �� ��� �������� ��������� ������� �������� ��������� �� 50
% �������� �� ��� ����.
[filtered_current_z, filtered_delta_z] = mean_on_intervals(current_Z, delta_angle, 50);
figure('Name', ['������ ����������� �������� ������ ����� ��� Z �� ��������' ...
                '������������� ���� �� ��� Z. �� ��� �������� ���������' ...
                '������� �������� ��������� �� 50 �������� �� ��� ����.']);
plot(filtered_current_z, filtered_delta_z/0.5, 'o');
grid on;
xlabel("��� �� ��� Z, �");
ylabel("�������� ��������, \circ/�");
%% ������ ����������� �������� ������ ����� ��� X �� �������� ������������� ����
% �� ��� X. �� ��� ���� ��������� ������� �������� ���� �� 50
% �������� �� ��� ��������.
[filtered_delta_x, filtered_current_x] = mean_on_intervals(delta_x, current_X, 50);
figure('Name', ['������ ����������� �������� ������ ����� ��� X �� ��������' ...
                '������������� ���� �� ��� X. �� ��� ���� ��������� �������' ...
                '�������� ���� �� 50 �������� �� ��� ��������.']);
plot(filtered_current_x, filtered_delta_x/0.5, 'o');
grid on;
xlabel("��� �� ��� X, �");
ylabel("�������� �� ��� X, ��/�");
%%  ������ ����������� �������� ������ ����� ��� Y �� �������� ������������� ����
% �� ��� Y. �� ��� ���� ��������� ������� �������� ���� �� 50
% �������� �� ��� ��������.
[filtered_delta_y, filtered_current_y] = mean_on_intervals(delta_y, current_Y, 50);
figure('Name', ['������ ����������� �������� ������ ����� ��� Y �� ��������' ...
                '������������� ���� �� ��� Y. �� ��� ���� ��������� �������' ...
                '�������� ���� �� 50 �������� �� ��� ��������.']);
plot(filtered_current_y, filtered_delta_y/0.5, 'o');
grid on;
xlabel("��� �� ��� Y, �");
ylabel("�������� �� ��� Y, ��/�");
%% ������ ����������� �������� ������ ����� ��� Z �� �������� ������������� ����
% �� ��� Z. �� ��� ���� ��������� ������� �������� ���� �� 50
% �������� �� ��� ��������.
[filtered_delta_z, filtered_current_z] = mean_on_intervals(delta_angle, current_Z, 50);
figure('Name', ['������ ����������� �������� ������ ����� ��� Z �� ��������' ...
                '������������� ���� �� ��� Z. �� ��� ���� ��������� �������' ... 
                '�������� ���� �� 50 �������� �� ��� ��������.']);
plot(filtered_current_z, filtered_delta_z/0.5, 'o');
grid on;
xlabel("��� �� ��� Z, �");
ylabel("�������� ��������, \circ/�");
%% ������ ����������� ������ �������� ������ � ��������� XY �� ������ ������������� ����
figure('Name', ['������ ����������� ������ �������� ������ � ��������� XY ��' ... 
                '������ ������������� ����']);
plot(current_vector, velocity, 'o');
grid on;
xlabel("���, �");
ylabel("��������, ��/�");
%% ������ ����������� �������� ������ ����� ��� X �� �������� ���� ������� ���������
figure('Name', ['������ ����������� �������� ������ ����� ��� X �� ��������' ...
                '���� ������� ���������']);
plot(motor1_current, abs(delta_x/0.5), 'o');
grid on;
xlabel("��� ������� ���������, �");
ylabel("�������� �� ��� X, ��/�");
%% ������ ����������� �������� ������ ����� ��� Y �� �������� ���� ������� ���������
figure('Name', ['������ ����������� �������� ������ ����� ��� Y �� ��������' ...
                '���� ������� ���������']);
plot(motor1_current, abs(delta_x/0.5), 'o');
grid on;
xlabel("��� ������� ���������, �");
ylabel("�������� �� ��� Y, ��/�");
%% ������ ����������� �������� �������� ������ �� �������� ���� ������� ���������
figure('Name', ['������ ����������� �������� �������� ������ �� ��������' ...
                '���� ������� ���������']);
plot(motor1_current, abs(delta_angle/0.5), 'o');
grid on;
xlabel("��� ������� ���������, �");
ylabel("�������� ��������, \circ/�");