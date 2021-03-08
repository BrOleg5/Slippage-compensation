%% Загрузка данных
data = readtable("experimental_data.xlsx", 'Range','A1:AJ1453');
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
Speed_x = table2array(data(:,33))/0.5 .* (Reference_X ~= 0);
Speed_y = table2array(data(:,34))/0.5 .* (Reference_Y ~= 0);
Speed_angle = table2array(data(:,36))/0.5 .* (Reference_Z ~= 0);
%% Предобработка
OmniDriveID = OmniDrive_construct();
n = length(Speed_x);
m1 = zeros(n, 1);
m2 = zeros(n, 1);
m3 = zeros(n, 1);
for i=1:n
   [m1(i), m2(i), m3(i)] = OmniDrive_getVelocities( OmniDriveID, Speed_x(i), Speed_y(i), Speed_angle(i) );
end
inliers_inds = (abs(m1) < 3000) | (abs(m2) < 3000) | (abs(m3) < 300);
m1 = m1(inliers_inds);
m2 = m2(inliers_inds);
m3 = m3(inliers_inds);
motor1_velocity = motor1_velocity(inliers_inds);
motor2_velocity = motor2_velocity(inliers_inds);
motor3_velocity = motor3_velocity(inliers_inds);
motor1_current = motor1_current(inliers_inds);
motor2_current = motor2_current(inliers_inds);
motor3_current = motor3_current(inliers_inds);
slip1 = m1./motor1_velocity;
slip2 = m2./motor2_velocity;
slip3 = m3./motor3_velocity;
inliers_inds = (slip1 <= 1) & (slip1 >= 0);
slip1 = slip1(inliers_inds);
motor1_current = motor1_current(inliers_inds);
inliers_inds = (slip2 <= 1) & (slip2 >= 0) & (slip2 >= (-1 * motor2_current + 0.5));
slip2 = slip2(inliers_inds);
motor2_current = motor2_current(inliers_inds);
inliers_inds = (slip3 <= 1) & (slip3 >= 0);
slip3 = slip3(inliers_inds);
motor3_current = motor3_current(inliers_inds);
motor_current = [motor1_current; motor2_current; motor3_current];
slip = [slip1; slip2; slip3];
data_set = [motor_current, slip];
data_set1 = [motor1_current, slip1];
data_set2 = [motor2_current, slip2];
data_set3 = [motor3_current, slip3];
%% Первый двигатель
plot(motor1_current, slip1, 'o');
grid on;
xlabel("Ток, A");
ylabel("Проскальзывание");
%% Второй двигатель
plot(motor2_current, slip2, 'o');
grid on;
xlabel("Ток, A");
ylabel("Проскальзывание");
%% Третьий двигатель
plot(motor3_current, slip3, 'o');
grid on;
xlabel("Ток, A");
ylabel("Проскальзывание");
%% Общее
plot(motor_current, slip, 'o');
grid on;
xlabel("Ток, A");
ylabel("Проскальзывание");