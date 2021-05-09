%% Загрузка и предобработка данных
OmniDriveID = OmniDrive_construct();
file_name = ["gray", "blue", "red"];
no_load_current = 0.25;
MMPERPIX = 2.0757;
WRONGMMPERPIX = 1.84;
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
    s(i).X.speed = table2array(data(:,21))/(0.5)*MMPERPIX/WRONGMMPERPIX .* (s(i).X.reference ~= 0);
    s(i).Y.speed = table2array(data(:,22))/(0.5)*MMPERPIX/WRONGMMPERPIX .* (s(i).Y.reference ~= 0);
    s(i).Angle.speed = table2array(data(:,20))/(0.5)*MMPERPIX/WRONGMMPERPIX .* (s(i).Angle.reference ~= 0);
    
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
    s(i).X.reference = s(i).X.reference(inliers_inds);
    s(i).Y.reference = s(i).Y.reference(inliers_inds);
    s(i).Angle.reference = s(i).Angle.reference(inliers_inds);
    
    for j = 1:3
        s(i).motor(j).voltage = c_e * s(i).motor(j).speed * 2*pi/60 + s(i).motor(j).current .* ...
            sign(s(i).motor(j).speed) .* R_a;
        s(i).motor(j).power = s(i).motor(j).voltage .* s(i).motor(j).current;
        s(i).motor(j).torque = s(i).motor(j).power ./ (s(i).motor(j).speed * 2*pi/60);
    end
end
%% Строим графики
colors = ["black", "blue", "red"];
text = ["Movement across X-axis.", "Movement across Y-axis.", "Movement around Z-axis.", "Movement across XY-axis."];
for i = 1:3
    for j = 1:3
        X_idx = (s(j).X.reference ~= 0) & (s(j).Y.reference == 0) & (s(j).Angle.reference == 0);
        Y_idx = (s(j).X.reference == 0) & (s(j).Y.reference ~= 0) & (s(j).Angle.reference == 0);
        Ang_idx = (s(j).X.reference == 0) & (s(j).Y.reference == 0) & (s(j).Angle.reference ~= 0);
        XY_idx = (s(j).X.reference ~= 0) & (s(j).Y.reference ~= 0) & (s(j).Angle.reference == 0);
        ref_set = {X_idx, Y_idx, Ang_idx, XY_idx};
        for k = 1:4
            figure('Name', strcat(text(k), " Motor ", num2str(i)));
            grid on;
            hold on;
            xlabel('Ток, А');
            ylabel('Коэффициент проскальзывания');
            ylim([0, 1]);
            for l = 1:3
                if (l == j)
                    plot(s(l).motor(i).current(ref_set{k}), s(l).motor(i).slippage(ref_set{k}),...
                        'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 3, ...
                        'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
                    plot(s(l).motor(i).current(~ref_set{k}), s(l).motor(i).slippage(~ref_set{k}),...
                        'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 5, ...
                        'MarkerFaceColor', colors(l), 'MarkerEdgeColor', colors(l));
%                 else
%                     plot(s(l).motor(i).current, s(l).motor(i).slippage,...
%                         'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 5, ...
%                         'MarkerFaceColor', colors(l), 'MarkerEdgeColor', colors(l));
                end
            end
        end
    end
end