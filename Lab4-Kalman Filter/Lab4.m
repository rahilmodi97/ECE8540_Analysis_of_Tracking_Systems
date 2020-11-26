%% Part 1
clc
clear all
close all
A = importdata('1D-data.txt');

T = 1;                 %Sample Time/ Time Interval
R = 1;                 %Measurement noise
q = 0.000001;              %Dynamic Noise

psi       = [1 T;
             0 1];                % State Transition Matrix
M         = [1 0];                % Observation Matrix
X_prev    = [-0.3317; 
                  0];             % Previous State matrix
Q         = [0 0; 
             0 q];                % Dynamic noise covariance
S_prev    = [1 0; 
             0 1];                % State covariance
pred_data = zeros(1, length(A));  % Output


for i = 1 : length(A)
    Yt(i)        = A(i);                 % Sensor Measurement
    X_next       = psi * X_prev;
    S_next       = (psi * S_prev * psi') + Q;
    Kt           = S_next * M'/((M * S_next * M') + R);
    X_update     = X_next + (Kt * (Yt(i) - M * X_next));
    S_update     = (eye(2) - Kt * M) * S_next;
    pred_data(i) = X_update(1,1);
    X_prev       = X_update;
    S_prev       = S_update;
end 

figure
X = 1:length(A);
hold on
%axis([100 190 -3 3])
plot(X, A, 'k');
plot(X, pred_data, 'k.-', 'markersize',10, 'linewidth', 1.5);
xlabel("Sampling Time (T)");
ylabel("Position (Xt)");
legend("Measured Values", "Predicted Values");
hold off

%% Part 2
clc
clear all
close all

A = importdata('2D-UWB-data.txt');

T = 1;                 %Sample Time/ Time Interval
r = 0.001;             %Measurement noise
q = 0.01;             %Dynamic Noise

psi       = [1 0 T 0;
             0 1 0 T;
             0 0 1 0;
             0 0 0 1];            % State Transition Matrix
M         = [1 0 0 0;
             0 1 0 0];            % Observation Matrix
X_prev    = [A(1,1); 
             A(1,2);
                  0;
                  0];             % Previous State matrix
R         = [r 1;
             1 r];                % Measurement noise covariance
Q         = [0 0 0 0; 
             0 0 0 0; 
             0 0 q 1; 
             0 0 1 q];            % Dynamic noise covariance
S_prev    = [1 0 0 0; 
             0 1 0 0;
             0 0 1 0;
             0 0 0 1];                % State covariance
pred_data = zeros(2, length(A(:,1)));  % Output
Yt = A';

for i = 1 : length(A)
    X_next       = psi * X_prev;
    S_next       = (psi * S_prev * psi') + Q;
    Kt           = S_next * M'/((M * S_next * M') + R)
    X_update     = X_next + (Kt * (Yt(:,i) - M * X_next));
    S_update     = (eye(4) - Kt * M) * S_next;
    pred_data(1,i) = X_update(1,1);
    pred_data(2,i) = X_update(2,1);
    X_prev       = X_update;
    S_prev       = S_update;
end 

figure
X = 1:length(A);
hold on
plot(X, A(:,1), 'k');
plot(X, pred_data(1,:), 'k.-','markersize',10, 'linewidth', 1.5);
xlabel("Sampling Time (T)");
ylabel("Position (Xt)");
legend("Measured Values", "Predicted Values");
hold off

figure
X = 1:length(A);
hold on
plot(X, A(:,2), 'k');
plot(X, pred_data(2,:), 'k.-', 'markersize',10, 'linewidth', 1.5);
xlabel("Sampling Time (T)");
ylabel("Position (Xt)");
legend("Measured Values", "Predicted Values");
hold off
