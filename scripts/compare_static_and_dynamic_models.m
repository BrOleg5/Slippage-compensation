load('comparing static and dynamic models voltage.mat');

figure('Name', 'Comparing static and dynamic models voltage');
plot(voltage.static_mode.static_model);
grid on;
hold on;
plot(voltage.static_mode.dynamic_model);
xlabel('Время, с');
ylabel('Напряжение, В');
legend('Статическая модель', 'Динамическая модель');

figure('Name', 'Error');
plot(voltage.static_mode.error, 'Color', 'black');
grid on;
xlabel('Время, с');
ylabel('Абсолютная ошибка, В');
title('');