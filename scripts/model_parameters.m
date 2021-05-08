L_a = 8.9e-3;
R_a = 5.3361;
c_m = 0.0514;
J_m = 1.044843950562466e-05;
c_e = 0.0501;
k_p_s = 4.607165361973858;
k_i_s = 3.801265150379840e-04;
k_p_c = 2.918134709032944e-09;
k_i_c = 0.193471903605565;
k_fb_c = 0.472461703184479;
M_dist = 0.0205;
tay = 0.100636196945577;

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
R = 125e-3; %m
delta_1 = pi/3;
delta_2 = pi;
delta_3 = 5*pi/3;
M = [-sin(delta_1), cos(delta_1), R;
     -sin(delta_2), cos(delta_2), R;
     -sin(delta_3), cos(delta_3), R];
%Approximate weight of Robotino
m = 8; %kg
%Approximate Robotino moment of inertia
J_r = m*R^2/2; %kg/m^2
%Approximate wheel with reductor moment of inertia
J = 0.0019; %kg/m^2
KD = [-sin(pi/3), -sin(pi), -sin(5*pi/3); cos(pi/3), cos(pi), cos(5*pi/3); R, R, R];