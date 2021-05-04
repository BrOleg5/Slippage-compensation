%% Тестовые значения
rng('shuffle');
OmniDriveID = OmniDrive_construct();
x_speed = 600*rand() - 300; %mm/s
y_speed = 600*rand() - 300; %mm/s
angular_speed = 200*rand() - 100; %deg/s
B_lib_robot_speed = [x_speed*1e-3; y_speed*1e-3; angular_speed*pi/180];
[A_lib_wheel_ang_speed(1), A_lib_wheel_ang_speed(2), A_lib_wheel_ang_speed(3)] = OmniDrive_getVelocities(OmniDriveID, x_speed, y_speed, angular_speed);
A_lib_wheel_ang_speed = A_lib_wheel_ang_speed*2*pi/60/16;
%% Проверка обратной кинематики
A_belyaev_wheel_ang_speed = 1/r*[-sin(pi/3), cos(pi/3), R; -sin(pi), cos(pi), R; -sin(5*pi/3), cos(5*pi/3), R]*B_lib_robot_speed;
A_oleg_wheel_ang_speed = 1/r*M*B_lib_robot_speed;
%% Проверка прямой кинематики
B_belyaev_robot_speed = r/3 * [-2*cos(-pi/6), 2*sin(0), 2*cos(pi/6); -2*sin(-pi/6), -2*cos(0), 2*sin(pi/6); 1/R, 1/R, 1/R] * A_lib_wheel_ang_speed';
B_oleg_robot_speed_1 = r * inv(M) * A_lib_wheel_ang_speed';
B_oleg_robot_speed_2 = r/3 * [-2*sin(pi/3), -2*sin(pi), 2*sin(pi/3); 2*cos(pi/3), 2*cos(pi), 2*cos(pi/3); 1/R, 1/R, 1/R] * A_lib_wheel_ang_speed';
%% Проверка прямой динамики
C_lib_wheel_torque = [10*rand() - 10; 10*rand() - 10; 10*rand() - 10]; %N
C_belyaev_robot_forces = 1/r * [-cos(-pi/6), sin(0), cos(pi/6); -sin(-pi/6), -cos(0), sin(pi/6); R, R, R]*C_lib_wheel_torque;
C_oleg_robot_forces = 1/r * KD * C_lib_wheel_torque;
%% Проверка обратной динамики
D_lib_robot_forces = C_oleg_robot_forces;
D_belyaev_wheel_torque = r * [-sin(pi/3), cos(pi/3), 1/R; -sin(pi), cos(pi), 1/R; -sin(5*pi/3), cos(5*pi/3), 1/R] * D_lib_robot_forces;
D_oleg_wheel_torque = r * inv(KD) * D_lib_robot_forces;
%% Деструктор
OmniDrive_destroy(OmniDriveID);