L_a = 8.9e-3;
R_a = 5.3361;
c_m = 0.0514;
J_m = 71e-7;
%c_e = ((24-R_a*0.86)/(3600*2*pi))*60;
c_e = 0.0501;
k_p = 5.40;
k_i = 1.7e-3;
k_p1 = 4.87e-9;
k_i1 = 0.6387;
k_fric = 7.3e-3;
M_dist = 0.0205;
%A = [-R_a/L_a, -c_e/L_a; c_m/J_m, 0];
%B = [k_p/L_a; 0];
%C = [0, 1];
%K = [-10.26; 331.50];