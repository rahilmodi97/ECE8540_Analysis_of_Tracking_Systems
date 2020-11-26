clc 
clear all
close all 
%% Log Data A
A = importdata('log-data-A.txt') ;
figure;
scatter (A(:, 1), A(:, 2), 40, 'b.');
title ('Scatter Plot of Log Data A');
xlabel('X datapoints');
ylabel('Y datapoints');
fa = 0;
fan = 0;
an = 7 ;                                                 %initial guess
X = ['The estimated initial guess is ', num2str(an),'.'];
disp (X);
iter = 0;
for i =1:100
fa(i) = sum((A(:, 2) - log(an.*A(:, 1)))./an);
fan(i) = sum((log(an.*A(:, 1)) - 1 - A(:, 2))./an ^2);
an1 = an - (fa(i)./fan(i));
if(abs(an1 - an)<0.000001)
iter = i ;
break ;
end
an = an1 ;
end
Y = ['The final value of a is ', num2str(an1), '.'];
disp (Y)
Z = ['The number of iterations it took to reach is ', num2str(iter), '.'];
disp (Z)
x = 0 : 50;
y = log(an.*x);
figure
hold on
g = plot(x, y, 'r');
h = plot(A(:, 1), A(:,2), 'b.');
uistack(g, 'top');
title ('Curve Fitting of Log Data A');
xlabel('X datapoints');
ylabel('Y datapoints');
legend ('Data Points', 'Fitted Curve');
hold off
%% Log Data B
B = importdata('log-data-B.txt') ;
figure;
scatter (B(:, 1), B(:, 2), 40, 'k.');
title ('Scatter Plot of Log Data B');
xlabel('X datapoints');
ylabel('Y datapoints');
fa_2 = 0;
fan_2 = 0;
an_2 = 19 ;                                                 %initial guess
D = ['The estimated initial guess is ', num2str(an_2),'.'];
disp (D);
iter = 0;
for i =1:100
fa_2(i) = sum((B(:, 2) - log(an_2.*B(:, 1)))./an_2);
fan_2(i) = sum((log(an_2.*B(:, 1)) - 1 - B(:, 2))./an_2 ^2);
an1_2 = an_2 - (fa_2(i)./fan_2(i));
if(abs(an1_2 - an_2)<0.000001)
iter = i ;
break ;
end
an_2 = an1_2 ;
end
E = ['The final value of a is ', num2str(an1_2), '.'];
disp (E)
F = ['The number of iterations it took to reach is ', num2str(iter), '.'];
disp (F)
x = 0 : 50;
y = log(an_2.*x);
figure
hold on
g = plot(x, y, 'g');
h = plot(B(:, 1), B(:,2), 'k.');
uistack(g, 'top');
title ('Curve Fitting of Log Data B');
xlabel('X datapoints');
ylabel('Y datapoints');
legend ('Data Points', 'Fitted Curve');
hold off
%% Log Data C
C = importdata('log-data-C.txt') ;
figure;
scatter (C(:, 1), C(:, 2), 40, 'm.');
title ('Scatter Plot of Log Data C');
xlabel('X datapoints');
ylabel('Y datapoints');
fa_3 = 0;
fan_3 = 0;
an_3 = 0.30;                                                 %initial guess
G = ['The estimated initial guess is ', num2str(an_3),'.'];
disp (G);
iter = 0;
for i =1:100
fa_3(i) = sum((C(:, 2) - log(an_3.*C(:, 1)))./an_3);
fan_3(i) = sum((log(an_3.*C(:, 1)) - 1 - C(:, 2))./an_3^2);
an1_3 = an_3 - (fa_3(i)./fan_3(i));
if(abs(an1_3 - an_3)<0.000001)
iter = i ;
break ;
end
an_3 = an1_3 ;
end
H = ['The final value of a is ', num2str(an1_3), '.'];
disp (H)
I = ['The number of iterations it took to reach is ', num2str(iter), '.'];
disp (I)
x = 0 : 50;
y = log(an_3.*x);
figure
hold on
g = plot(x, y, 'c');
h = plot(C(:, 1), C(:,2), 'm.');
uistack(g, 'top');
title ('Curve Fitting of Log Data C');
xlabel('X datapoints');
ylabel('Y datapoints');
legend ('Data Points', 'Fitted Curve');
hold off
