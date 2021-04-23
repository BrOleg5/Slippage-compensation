L_a = 8.9e-3;
R_a = 5.3361;
c_m = 0.0514;
J_m = 71e-7;
%c_e = ((24-R_a*0.86)/(3600*2*pi))*60;
c_e = 0.0501;
k_p_s = 5.40;
k_i_s = 1.7e-3;
k_p_c = 4.87e-9;
k_i_c = 0.6387;
M_dist = 0.0205;

A = [0, 0, 0, 0;
     k_i_s, 0 , -k_i_s, 0;
     k_p_c/L_a, 1/L_a, -R_a/L_a, -c_e/L_a;
     0, 0, c_m/J_m, 0];
B = [k_i_s, 0;
     k_p_s*k_i_c, 0;
     k_p_s*k_p_c/L_a, 0;
     0, -1/J_m];
C = [0, 0, 1, 0;
     0, 0, 0, 1];
K = [0, 1;
     0, 0];
A_eq = A - B*K*C;
dt = 20e-3;
F = expm(A_eq * dt);
B_d = eye(4)/A_eq * (F - eye(4)) * B;

%Radius of omni-wheel
r = 40e-3; %m
%Radius of Robotino
R = 135e-3; %m
delta_1 = -pi/6;
delta_2 = -3*pi/2;
delta_3 = -5*pi/6;
M = [-cos(delta_1), -sin(delta_1), R;
     -cos(delta_2), -sin(delta_2), R;
     -cos(delta_3), -sin(delta_3), R];
%Weight of Robotino
m = 8; %kg
%Approximate Robotino moment of inertia
J_r = m*R^2/2; %kg/m^2
%Approximate wheel with reductor moment of inertia
J = 0.0019; %kg/m^2
KD = [-cos(-pi/6), cos(pi/2), -cos(-5*pi/6); -sin(-pi/6), -sin(pi/2), -sin(-5*pi/6); R, R, R];