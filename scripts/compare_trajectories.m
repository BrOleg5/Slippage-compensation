%% График сравнения полученных траекторий
load('square_trajectories.mat');
figure('Name', 'Robot path');
plot(square_without_controller.cam.position.X, square_without_controller.cam.position.Y,...
    'Color', 'blue', 'LineStyle', '-', 'LineWidth', 2);
axis ij;
grid on;
hold on;
xlabel('X, мм');
ylabel('Y, мм');
xlim([500, 2100]);
ylim([100, 1700]);
set(gca,'xtick',[500:200:2100]);
plot(square_without_controller_with_compensation.cam.position.X, ...
    square_without_controller_with_compensation.cam.position.Y, 'Color', 'green', ...
    'LineStyle', '-', 'LineWidth', 2);
plot(square_with_controller.cam.position.X, square_with_controller.cam.position.Y,...
    'Color', 'red', 'LineStyle', '-', 'LineWidth', 2);
legend('без компенсации проскальзывания', 'с учетом проскальзывания', 'с компенсацией проскальзывания');

rectangle('Position',[1600 800 150 150], 'LineWidth', 2);
text(1560, 870, '1');
rectangle('Position',[1600 970 150 200], 'LineWidth', 2);
text(1760, 1070, '2');
rectangle('Position',[800 900 200 500], 'LineWidth', 2);
text(760, 1150, '3');
rectangle('Position',[1100 800 200 500], 'LineWidth', 2);
text(1060, 900, '4');
%% Испытательный полигон с траекторией
figure('Name', 'Field');
I = imread('test site.jpg');
imshow(I);
%axis on;
MMPERPIX = 2.0757;
xcorrection = -100;
ycorrection = -30;
xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
X = [(square_with_controller.cam.position.X(1)+xcorrection)/MMPERPIX/(abs(diff(xLimits))), ...
     (square_with_controller.cam.position.X(1)+xcorrection)/MMPERPIX/(abs(diff(xLimits)))];
Y = [1-(square_with_controller.cam.position.Y(1)+ycorrection)/MMPERPIX/(abs(diff(yLimits))), ...
     1-(square_with_controller.cam.position.Y(1)+900+ycorrection)/MMPERPIX/(abs(diff(yLimits)))];
a = annotation('arrow',X,Y);
a.LineWidth = 3;

X = [(square_with_controller.cam.position.X(1)+xcorrection)/MMPERPIX/(abs(diff(xLimits))), ...
     (square_with_controller.cam.position.X(1)-400+xcorrection)/MMPERPIX/(abs(diff(xLimits)))];
Y = [1-(square_with_controller.cam.position.Y(1)+900+ycorrection)/MMPERPIX/(abs(diff(yLimits))), ...
     1-(square_with_controller.cam.position.Y(1)+900+ycorrection)/MMPERPIX/(abs(diff(yLimits)))];
a = annotation('arrow',X,Y);
a.LineWidth = 3;

X = [(square_with_controller.cam.position.X(1)-400+xcorrection)/MMPERPIX/(abs(diff(xLimits))), ...
     (square_with_controller.cam.position.X(1)-400+xcorrection)/MMPERPIX/(abs(diff(xLimits)))];
Y = [1-(square_with_controller.cam.position.Y(1)+900+ycorrection)/MMPERPIX/(abs(diff(yLimits))), ...
     1-(square_with_controller.cam.position.Y(1)+ycorrection)/MMPERPIX/(abs(diff(yLimits)))];
a = annotation('arrow',X,Y);
a.LineWidth = 3;

X = [(square_with_controller.cam.position.X(1)-400+xcorrection)/MMPERPIX/(abs(diff(xLimits))), ...
     (square_with_controller.cam.position.X(1)+xcorrection)/MMPERPIX/(abs(diff(xLimits)))];
Y = [1-(square_with_controller.cam.position.Y(1)+ycorrection)/MMPERPIX/(abs(diff(yLimits))), ...
     1-(square_with_controller.cam.position.Y(1)+ycorrection)/MMPERPIX/(abs(diff(yLimits)))];
a = annotation('arrow',X,Y);
a.LineWidth = 3;

rectangle('Position',[(1600+50+xcorrection)/MMPERPIX,  (800+ycorrection)/MMPERPIX, 150/MMPERPIX, 150/MMPERPIX], 'LineWidth', 2);
text((1560+50+xcorrection)/MMPERPIX, (870+ycorrection)/MMPERPIX, '1');
rectangle('Position',[(1600+50+xcorrection)/MMPERPIX, (970+ycorrection)/MMPERPIX, 150/MMPERPIX, 200/MMPERPIX], 'LineWidth', 2);
text((1760+50+xcorrection)/MMPERPIX, (1070+ycorrection)/MMPERPIX, '2');
rectangle('Position',[(800+xcorrection-50)/MMPERPIX, (900+ycorrection)/MMPERPIX, 200/MMPERPIX, 500/MMPERPIX], 'LineWidth', 2);
text((760+xcorrection-50)/MMPERPIX, (1150+ycorrection)/MMPERPIX, '3');
rectangle('Position',[(1100+50+xcorrection)/MMPERPIX, (800+ycorrection)/MMPERPIX, 200/MMPERPIX, 500/MMPERPIX], 'LineWidth', 2);
text((1060+50+xcorrection)/MMPERPIX, (900+ycorrection)/MMPERPIX, '4');