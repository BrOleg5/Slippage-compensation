load('square_trajectories.mat');
side_ind_without_slippage_comp = [1, 216; 217, 285; 286, 502; 503, 744];
side_ind_with_slippage_comp = [1, 268; 269, 359; 360, 604; 605, 1017];
side_ind_with_slippage_characteristic = [1, 324; 325, 422; 423, 636; 637, 1039];
path_without_slippage_comp = zeros(1, 4);
path_with_slippage_comp = zeros(1, 4);
path_with_slippage_characteristic = zeros(1, 4);
set_square_side_length = [900, 400, 900, 400];
for i = 1:4
    dX = new_square_without_controller.cam.delta.X(side_ind_without_slippage_comp(i, 1):side_ind_without_slippage_comp(i, 2));
    dY = new_square_without_controller.cam.delta.Y(side_ind_without_slippage_comp(i, 1):side_ind_without_slippage_comp(i, 2));
    path_without_slippage_comp(i) = sum(sqrt(dX.^2 + dY.^2));
    
    dX = square_with_controller.cam.delta.X(side_ind_with_slippage_comp(i, 1):side_ind_with_slippage_comp(i, 2));
    dY = square_with_controller.cam.delta.Y(side_ind_with_slippage_comp(i, 1):side_ind_with_slippage_comp(i, 2));
    path_with_slippage_comp(i) = sum(sqrt(dX.^2 + dY.^2));
    
    dX = square_without_controller_with_compensation.cam.delta.X(side_ind_with_slippage_characteristic(i, 1):side_ind_with_slippage_characteristic(i, 2));
    dY = square_without_controller_with_compensation.cam.delta.Y(side_ind_with_slippage_characteristic(i, 1):side_ind_with_slippage_characteristic(i, 2));
    path_with_slippage_characteristic(i) = sum(sqrt(dX.^2 + dY.^2));
end
abs_error_without_slippage_comp = path_without_slippage_comp - set_square_side_length;
rel_error_without_slippage_comp = abs_error_without_slippage_comp ./ set_square_side_length;
abs_error_with_slippage_comp = path_with_slippage_comp - set_square_side_length;
rel_error_with_slippage_comp = abs_error_with_slippage_comp ./ set_square_side_length;
abs_error_with_slippage_characteristic = path_with_slippage_characteristic - set_square_side_length;
rel_error_with_slippage_characteristic = abs_error_with_slippage_characteristic ./ set_square_side_length;
Experiments = {'Without slippage compensation', 'With slippage characteristics', 'With slippage compensation'};
T = table;
T = [T; array2table([path_without_slippage_comp, abs_error_without_slippage_comp, rel_error_without_slippage_comp])];
T = [T; array2table([path_with_slippage_characteristic, abs_error_with_slippage_characteristic, rel_error_with_slippage_characteristic])];
T = [T; array2table([path_with_slippage_comp, abs_error_with_slippage_comp, rel_error_with_slippage_comp])];
T.Properties.VariableNames = {'1st line', '2nd line', '3rd line', '4th line',...
                              '1 abs error', '2 abs error', '3 abs error', '4abs error', ...
                              '1 rel error', '2 rel error', '3 rel error', '4 rel error'};
T.Properties.RowNames = Experiments;