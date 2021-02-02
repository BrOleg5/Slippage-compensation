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