run('load_and_preprocess_data.m');
load('slippage_vs_torque_rsvm_models.mat');

b1 = slippage_vs_torque_motor_1(:, 1)\slippage_vs_torque_motor_1(:, 2);
lin_model.gray.y = b1 * s(1).motor(1).torque;
lin_model.blue.y = b1 * s(2).motor(1).torque;
lin_model.red.y = b1 * s(3).motor(1).torque;
lin_model.y = [lin_model.gray.y; lin_model.blue.y; lin_model.red.y];
lin_model.gray.mse = mean((lin_model.gray.y - s(1).motor(1).slippage).^2);
lin_model.gray.rmse = sqrt(lin_model.gray.mse);
lin_model.blue.mse = mean((lin_model.blue.y - s(2).motor(1).slippage).^2);
lin_model.blue.rmse = sqrt(lin_model.blue.mse);
lin_model.red.mse = mean((lin_model.red.y - s(3).motor(1).slippage).^2);
lin_model.red.rmse = sqrt(lin_model.red.mse);
lin_model.mse = mean((lin_model.y - slippage_vs_torque_motor_1(:, 2)).^2);
lin_model.rmse = sqrt(lin_model.mse);

quad_model.gray.y = slippage_vs_torque_quadratic_rsvm_model_motor_1.predictFcn(s(1).motor(1).torque);
quad_model.blue.y = slippage_vs_torque_quadratic_rsvm_model_motor_1.predictFcn(s(2).motor(1).torque);
quad_model.red.y = slippage_vs_torque_quadratic_rsvm_model_motor_1.predictFcn(s(3).motor(1).torque);
quad_model.y = [quad_model.gray.y; quad_model.blue.y; quad_model.red.y];
quad_model.gray.mse = mean((quad_model.gray.y - s(1).motor(1).slippage).^2);
quad_model.gray.rmse = sqrt(quad_model.gray.mse);
quad_model.blue.mse = mean((quad_model.blue.y - s(2).motor(1).slippage).^2);
quad_model.blue.rmse = sqrt(quad_model.blue.mse);
quad_model.red.mse = mean((quad_model.red.y - s(3).motor(1).slippage).^2);
quad_model.red.rmse = sqrt(quad_model.red.mse);
quad_model.mse = mean((quad_model.y - slippage_vs_torque_motor_1(:, 2)).^2);
quad_model.rmse = sqrt(quad_model.mse);

T = table;
T = [T; array2table([lin_model.gray.mse, lin_model.gray.rmse, lin_model.blue.mse,...
                     lin_model.blue.rmse, lin_model.red.mse, lin_model.red.rmse,...
                     lin_model.mse, lin_model.rmse])];
T = [T; array2table([quad_model.gray.mse, quad_model.gray.rmse, quad_model.blue.mse,...
                     quad_model.blue.rmse, quad_model.red.mse, quad_model.red.rmse,...
                     quad_model.mse, quad_model.rmse])];
T.Properties.RowNames = {'Linear model', '2nd order model'};
T.Properties.VariableNames = {'gray mse', 'gray rmse', 'blue mse', 'blue rmse', ...
                              'red mse', 'red rmse', 'total mse', 'total rmse'};