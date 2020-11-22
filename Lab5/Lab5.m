clc 
clear all
close all

A = importdata("sin-data.txt");
groundtruth = A(:,1);
measured_data = A(:,2);

time = 1;                       
r = 0.1;                        %Measurement noise
q = 0.001;                      %Dynamic noise

%Partial derivatives
dfa = [0 0 0; 
       0 1 0; 
       0 0 0];
dgx = [0 0 1];
dgn = 1;

Q = [0 0 0; 
     0 q 0; 
     0 0 0];
R = r;
I = eye(3) ;
s_prev = I;  
x_prev = [0.001; 0.01; measured_data(1,1)];
output = zeros(1, length(measured_data));
delta = 0.001;

while(time <  length(measured_data))
    
    x_pred = [ (x_prev(1,1) + (delta*(time-1) * x_prev(2,1))) ;
                  x_prev(2,1);
                  sin( x_prev(1,1) * 0.1) ];
              
    dfx = [1 delta*time 0; 
           0 1 0; 
           0.1*cos(0.1 * x_pred(1,1)) 0 0];
       
    s_pred = (dfx * s_prev * dfx') + (dfa * Q * dfa');
  
    Yt = measured_data(time);
    Kt = (s_pred * dgx') / ( (dgx * s_pred * dgx') + (dgn * R * dgn') );
    
    x_next = x_pred + (Kt * (Yt - x_pred(3,1) ));
    s_t_t = (I - Kt * (dgx)) * s_pred;
    
    s_prev = s_t_t;
    x_prev = x_next;
    output(1,time) = x_next(3,1);
   
    time = time  + 1;

end


x = 1:length(measured_data);

figure
plot(x,measured_data, "k.", "LineWidth", 2)
hold on
plot(x, output(1,:), "k", "Linewidth",2)
plot(x, groundtruth, "k-*","Linewidth",2)
hold off
xlabel("Time");
ylabel("Amplitude");
set(gca, "FontSize",20);
legend("Measurement data", "Filter Output", "Ground Truth Position");
axis([0 780 -2 2]);