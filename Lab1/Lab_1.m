clc ;
close all ;
%Part 1
X = [5 6 7 8 9];
Y = [1 1 2 3 5];
A = [X' ones(5,1)];
b = Y';
x = (inv(A'*A))*A'*b;
i = 4:0.1:16;
y = x(1)*i + x(2);                      % y = mx + c
figure
hold on
plot( i , y, 'r', X, Y,'bo')
axis ([4 15 0 15]);
xlabel('X-axis');
ylabel('Y-axis');
hold off
legend ('Fitted Line' , 'Data Points') ;
%% Part 2
X = [5 6 7 8 9 8];
Y = [1 1 2 3 5 14];
A = [X' ones(6,1)];
b = Y';
x = (inv(A'*A))*A'*b;
i = 4:0.1:16;
y = x(1)*i + x(2);                      % y = mx + c
figure
hold on
plot( i , y, 'r', X, Y,'bo')
axis ([4 15 0 15]);
xlabel('X-axis');
ylabel('Y-axis');
hold off
legend ('Fitted Line' , 'Data Points') ;
%% Part 3
g = importdata('83people-all-meals.txt');
j = [g(:,3) (g(1:3398,4)./g(1:3398,3))];
figure
scatter (j(:,1), j(:,2), 25, linspace(1,10,length(j(:,1))), '.');
xlabel('Number of Bites');
ylabel('Kilocalories per Bite');
legend('Data Points');
X1 = j(:, 1); 
Y1 = j(:, 2);
A1 = [ones(3398,1) log(X1)] ;
b1 = Y1;
h = 1:315;
x1 = (inv(A1'*A1))*A1'*b1;
y1 = x1(1) + x1(2)*log(h);          % y = a + b*log(x)
figure
hold on
axis ([0 250 0 100]);
k = plot(h, y1,'k');
l = plot(X1, Y1, 'g.');
uistack(k, 'top');
xlabel('Number of Bites');
ylabel('Kilo calories per Bite');
legend('Fitted Line', 'Data Points');
hold off
