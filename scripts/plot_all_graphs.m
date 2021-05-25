%% Загрузка данных
run('model_parameters.m');
run('load_and_preprocess_data.m');
%% Цветные графики зависимости коэффициента проскальзывания от тока двигателя
window_name = ["Slippage coefficient vs current motor 1",...
    "Slippage coefficient vs current motor 2", "Slippage coefficient vs current motor 3"];
load('slippage_vs_current_models.mat');
for j = 1:3
    figure('Name', window_name(j));
    plot(dwf.motor(j).current, dwf.motor(j).slippage, 'LineStyle', 'none', 'Marker', '.', ...
    'MarkerSize', 5, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue');
    grid on;
    hold on;
    if (j == 1)
        xLimits = get(gca,'XLim');
        I = [0, xLimits(2)];
        plot(I, slippage_vs_current_model_motor_1.predictFcn(I'),...
            'Color', 'black', 'LineWidth', 2);
    end
    ylim([0, 1]);
    xlim([0, 2]);
    xlabel("Ток, А");
    ylabel("Коэффициент проскальзывания");
    legend('Экспериментальные данные', 'Модель');
end
%% Черно-белый графики зависимости коэффициента проскальзывания от тока двигателя
for j = 1:3
    figure('Name', window_name(j));
    plot(dwf.motor(j).current, dwf.motor(j).slippage, 'LineStyle', 'none', 'Marker', '.', ...
    'MarkerSize', 5, 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black');
    grid on;
%     hold on;
%     if (j == 1)
%         xLimits = get(gca,'XLim');
%         I = [0, xLimits(2)];
%         plot(I, slippage_vs_current_model_motor_1.predictFcn(I'),...
%              'Color', 'black', 'LineWidth', 2);
%     end
    ylim([0, 1]);
    xlim([0, 2]);
    xlabel("Ток, А");
    ylabel("Коэффициент проскальзывания");
%     legend('Экспериментальные данные', 'Модель');
end
%% Цветные графики зависимости коэффициента проскальзывания от тока двигателя
window_name = ["Slippage coefficient vs current motor 1",...
    "Slippage coefficient vs current motor 2", "Slippage coefficient vs current motor 3"];
color = ["black", "blue", "red"];
% load('linear_slippage_models_with_no_load_current.mat');
% linear_slippage_models = [linear_slippage_model_1; linear_slippage_model_2; linear_slippage_model_3];
for j = 1:3
    figure('Name', window_name(j));
    grid on;
    hold on;
    for i = 1:3
        plot(s(i).motor(j).current, s(i).motor(j).slippage, 'LineStyle', 'none', 'Marker', '.', ...
        'MarkerSize', 5, 'MarkerFaceColor', color(i), 'MarkerEdgeColor', color(i));
    end
%     I = 0.2:0.01:(-linear_slippage_models(j, 2)/linear_slippage_models(j, 1));
%     plot(I, slippage_mdl(I, linear_slippage_models(j, :), 0.4),...
%         'Color', 'green', 'LineWidth', 2);
    ylim([0, 1]);
    xlabel("Ток, А");
    ylabel("Коэффициент проскальзывания");
    legend('Тип 1', 'Тип 2', 'Тип 3');
end
%% Черно-белый графики зависимости коэффициента проскальзывания от тока двигателя
markers = 'x.+';
marker_sizes = [4, 5, 3];
for j = 1:3
    figure('Name', window_name(j));
    grid on;
    hold on;
    for i = 1:3
        plot(s(i).motor(j).current, s(i).motor(j).slippage, 'LineStyle', 'none', 'Marker', markers(i), ...
        'MarkerSize', marker_sizes(i), 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black');
    end
%     I = 0.2:0.01:(-linear_slippage_models(j, 2)/linear_slippage_models(j, 1));
%     plot(I, slippage_mdl(I, linear_slippage_models(j, :), 0.4),...
%         'Color', 'black', 'LineWidth', 2);
    ylim([0, 1]);
    xlabel("Ток, А");
    ylabel("Коэффициент проскальзывания");
    legend('Тип 1', 'Тип 2', 'Тип 3');
end
%% Цветные графики зависимости коэффициента проскальзывания от момента двигателя
window_name = ["Slippage coefficient vs torque motor 1",...
    "Slippage coefficient vs torque motor 2", "Slippage coefficient vs torque motor 3"];
load('slippage_vs_torque_rsvm_models.mat');
for j = 1:3
    figure('Name', window_name(j));
    grid on;
    hold on;
    for i = 1:3
        plot(s(i).motor(j).torque, s(i).motor(j).slippage, 'LineStyle', 'none', 'Marker', '.', ...
        'MarkerSize', 5, 'MarkerFaceColor', color(i), 'MarkerEdgeColor', color(i));
    end
    if j == 1
        b1 = slippage_vs_torque_motor_1(:, 1)\slippage_vs_torque_motor_1(:, 2);
        plot([0, 0.5], b1*[0, 0.5], 'Color', 'green', 'LineWidth', 2);
        I = 0:0.01:0.5;
        plot(I, slippage_vs_torque_quadratic_rsvm_model_motor_1.predictFcn(I'), ...
             'Color', [0.8 0.1 0.8], 'LineWidth', 2);
    end
    ylim([0, 1]);
    xlabel("Момент, Нм");
    ylabel("Коэффициент проскальзывания");
    legend('Тип 1', 'Тип 2', 'Тип 3', 'Модель');
    if j == 1
        legend('Тип 1', 'Тип 2', 'Тип 3', 'Модель 1-го порядка', 'Модель 2-го порядка');
    end
end
%% Черно-белые графики зависимости коэффициента проскальзывания от момента двигателя
for j = 1:3
    figure('Name', window_name(j));
    grid on;
    hold on;
    for i = 1:3
        plot(s(i).motor(j).torque, s(i).motor(j).slippage, 'LineStyle', 'none', 'Marker', markers(i), ...
        'MarkerSize', marker_sizes(i), 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black');
    end
    if j == 1
        b1 = slippage_vs_torque_motor_1(:, 1)\slippage_vs_torque_motor_1(:, 2);
        plot([0, 0.5], b1*[0, 0.5], 'LineStyle', ':', 'Color', 'black', 'LineWidth', 2);
        I = 0:0.01:0.5;
        plot(I, slippage_vs_torque_quadratic_rsvm_model_motor_1.predictFcn(I'), ...
             'Color', 'black', 'LineWidth', 2);
    end
%     h = plot(slippage_vs_torque_models{j});
%     set(h, 'Color',  'black', 'LineWidth',2);
%     xlim([0, 0.5]);
    ylim([0, 1]);
    xlabel("Момент, Нм");
    ylabel("Коэффициент проскальзывания");
    legend('Тип 1', 'Тип 2', 'Тип 3', 'Модель');
    if j == 1
        legend('Тип 1', 'Тип 2', 'Тип 3', 'Модель 1-го порядка', 'Модель 2-го порядка');
    end
end
%% Удаление данных из работчей области
clear;
clc;