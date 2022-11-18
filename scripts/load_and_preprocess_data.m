%% «агрузка и предобработка данных
OmniDriveID = OmniDrive_construct();
file_name = ["gray", "blue", "red"];
no_load_current = 0.25;
MMPERPIX = 2.0757; % «десь поставить откалиброванное значение
s = [struct, struct, struct];
for i = 1:3
    data = readtable(strcat("experimental_data_", file_name(i), ".csv"));
    s(i).X.reference = table2array(data(:,1));
    s(i).Y.reference = table2array(data(:,2));
    s(i).Angle.reference = table2array(data(:,3));
    s(i).motor(1).speed = table2array(data(:,7));
    s(i).motor(2).speed = table2array(data(:,8));
    s(i).motor(3).speed = table2array(data(:,9));
    s(i).motor(1).current = table2array(data(:,10));
    s(i).motor(2).current = table2array(data(:,11));
    s(i).motor(3).current = table2array(data(:,12));
    s(i).X.speed = table2array(data(:,21))/(0.5) .* (s(i).X.reference ~= 0);
    s(i).Y.speed = table2array(data(:,22))/(0.5) .* (s(i).Y.reference ~= 0);
    s(i).Angle.speed = table2array(data(:,20))/(0.5) .* (s(i).Angle.reference ~= 0);
    
    linear_movement_inds = s(i).Angle.reference == 0;
    for j = 1:3
        s(i).motor(j).speed = s(i).motor(j).speed(linear_movement_inds);
        s(i).motor(j).current = s(i).motor(j).current(linear_movement_inds);
    end
    s(i).X.speed = s(i).X.speed(linear_movement_inds);
    s(i).Y.speed = s(i).Y.speed(linear_movement_inds);
    s(i).Angle.speed = s(i).Angle.speed(linear_movement_inds);
    
    n = length(s(i).X.speed);
    for j = 1:3
        s(i).motor(j).estimated_speed = zeros(n, 1);
    end
    for j=1:n
       [s(i).motor(1).estimated_speed(j), s(i).motor(2).estimated_speed(j), s(i).motor(3).estimated_speed(j)] = ...
           OmniDrive_getVelocities( OmniDriveID, s(i).X.speed(j), s(i).Y.speed(j), s(i).Angle.speed(j) );
    end
    
    inliers_inds = (abs(s(i).motor(1).estimated_speed) < 1500) & (abs(s(i).motor(2).estimated_speed) < 1500) & (abs(s(i).motor(3).estimated_speed) < 1500);
    for j = 1:3
        s(i).motor(j).estimated_speed = s(i).motor(j).estimated_speed(inliers_inds);
        s(i).motor(j).speed = s(i).motor(j).speed(inliers_inds);
        s(i).motor(j).current = s(i).motor(j).current(inliers_inds);
        
        s(i).motor(j).slippage = 1 - s(i).motor(j).estimated_speed ./ s(i).motor(j).speed;
    end

    for j = 1:3
        inliers_inds = (s(i).motor(j).current > no_load_current);
        s(i).motor(j).current = s(i).motor(j).current(inliers_inds);
        s(i).motor(j).slippage = s(i).motor(j).slippage(inliers_inds);
        s(i).motor(j).estimated_speed = s(i).motor(j).estimated_speed(inliers_inds);
        s(i).motor(j).speed = s(i).motor(j).speed(inliers_inds);
    end

    for j = 1:3
        inliers_inds = (s(i).motor(j).slippage <= 1) & (s(i).motor(j).slippage > 0);
        s(i).motor(j).slippage = s(i).motor(j).slippage(inliers_inds);
        s(i).motor(j).current = s(i).motor(j).current(inliers_inds);
        s(i).motor(j).estimated_speed = s(i).motor(j).estimated_speed(inliers_inds);
        s(i).motor(j).speed = s(i).motor(j).speed(inliers_inds);
    end
    
    for j = 1:3
        s(i).motor(j).voltage = c_e * s(i).motor(j).speed * 2*pi/60 + s(i).motor(j).current .* ...
            sign(s(i).motor(j).speed) .* R_a;
        s(i).motor(j).power = s(i).motor(j).voltage .* s(i).motor(j).current;
        s(i).motor(j).torque = s(i).motor(j).power ./ (s(i).motor(j).speed * 2*pi/60);
    end
    
    for j = 1:3
        inliers_inds = s(i).motor(j).torque <= 0.5;
        s(i).motor(j).slippage = s(i).motor(j).slippage(inliers_inds);
        s(i).motor(j).current = s(i).motor(j).current(inliers_inds);
        s(i).motor(j).estimated_speed = s(i).motor(j).estimated_speed(inliers_inds);
        s(i).motor(j).speed = s(i).motor(j).speed(inliers_inds);
        s(i).motor(j).voltage = s(i).motor(j).voltage(inliers_inds);
        s(i).motor(j).power = s(i).motor(j).power(inliers_inds);
        s(i).motor(j).torque = s(i).motor(j).torque(inliers_inds);
    end
end
slippage_vs_current_motor_1 = [s(1).motor(1).current, s(1).motor(1).slippage;
                               s(2).motor(1).current, s(2).motor(1).slippage;
                               s(3).motor(1).current, s(3).motor(1).slippage;];
slippage_vs_current_motor_2 = [s(1).motor(2).current, s(1).motor(2).slippage;
                               s(2).motor(2).current, s(2).motor(2).slippage;
                               s(3).motor(2).current, s(3).motor(2).slippage;];
slippage_vs_current_motor_3 = [s(1).motor(3).current, s(1).motor(3).slippage;
                               s(2).motor(3).current, s(2).motor(3).slippage;
                               s(3).motor(3).current, s(3).motor(3).slippage;];
slippage_vs_torque_motor_1 = [s(1).motor(1).torque, s(1).motor(1).slippage;
                              s(2).motor(1).torque, s(2).motor(1).slippage;
                              s(3).motor(1).torque, s(3).motor(1).slippage;];
slippage_vs_torque_motor_2 = [s(1).motor(2).torque, s(1).motor(2).slippage;
                              s(2).motor(2).torque, s(2).motor(2).slippage;
                              s(3).motor(2).torque, s(3).motor(2).slippage;];
slippage_vs_torque_motor_3 = [s(1).motor(3).torque, s(1).motor(3).slippage;
                              s(2).motor(3).torque, s(2).motor(3).slippage;
                              s(3).motor(3).torque, s(3).motor(3).slippage;];