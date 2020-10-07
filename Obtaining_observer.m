syms s k1 k2;
K = [k1; k2];
s_w_1 = -400 - i*400;
s_w_2 = -400 + i*400;
coeffs_1 = coeffs(collect(det(s*eye(2) - A + K*C)), s);
coeffs_2 = coeffs(collect((s - s_w_1)*(s - s_w_2)), s);
k2_num = double(vpasolve(coeffs_1(2) == coeffs_2(2), k2));
k1_sym = solve(coeffs_1(1) == coeffs_2(1), k1);
k1_num = double(vpa(subs(k1_sym, k2, vpa(k2_num))));
disp(k1_num);
disp(k2_num);
K = [k1_num; k2_num];