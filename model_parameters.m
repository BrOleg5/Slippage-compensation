L_a = 8.9e-3;
R_a = 5.95;
c_m = 0.0514;
J_m = 71e-7;
c_e = 2*pi*c_m;
k_p = 0.30465;
tay = 64.453e-3;
A = [-R_a/L_a, -c_e/L_a; c_m/J_m, 0];
B = [k_p/L_a; 0];
C = [0, 1];
K = [-10.26; 331.50];