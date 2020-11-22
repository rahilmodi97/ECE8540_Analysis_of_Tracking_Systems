%ECE 8540 - Analysis of Tracking Systems 
%Author: Rahil Modi
clc;
clear
close all

data = importdata("magnets-data.txt");

gt_pos             = data(:,1);
gt_vel             = data(:,2);
sensor_measurement = data(:,3);

%Number of Particles
M   = 100;

%Magnet Position
xm1 = -10;
xm2 = 10;

%S.D
sigmaM = 4;

%State Transition
x_state     = zeros(1,M);
x_vel       = zeros(1,M);
xprev_state = zeros(1,M);
xprev_vel   = zeros(1,M);

%Weights
w_t      = ones(1,M) * 1/M;
w_t_prev = ones(1,M) * 1/M;
wts      = ones(1,M) * 1/M;
y_t      = zeros(1,M);

%Number of resampling 
counter_resample = 0;

%Flag to track weight plot
start = 0;

%Plots start when resampling count is:
resample = 10;

%Resample when particles go below RS percentage
threshold = 0.1;

output  = zeros(1,length(sensor_measurement));
X1      = 1 : length(sensor_measurement);
X2      = 1 : M;

for t = 1:length(sensor_measurement)
    
    for i = 1:M
            
            %State Transition
            x_state(i) = xprev_state(i) + xprev_vel(i) ;
            
            if( xprev_state(i) < -20)
                x_vel(i) = 2;
            
            elseif (xprev_state(i) > 20)
                x_vel(i) = -2;
            
            elseif (xprev_state(i) >= 0 && xprev_state(i) <= 20 ) 
                x_vel(i) = xprev_vel(i) - abs(randn * 0.0625);
            
            elseif (xprev_state(i) >= -20 && xprev_state(i) < 0)
                x_vel(i) = xprev_vel(i) + abs(randn * 0.0625);
            end
   
            %Update weight
            
            y_t(i)      = (1 / (sqrt(2*pi) * sigmaM))  * exp( -((xprev_state(i) - xm1  )^2) / (2 * (sigmaM^2) )) + (1 / (sqrt(2*pi) * sigmaM))  * exp( -((xprev_state(i) - xm2  )^2) / (2 * (sigmaM^2) ));
            
            prob        = ((1 / (sqrt(2*pi) * 0.003906)) * exp ( - ((y_t(i) - sensor_measurement(t) )^2) / (2 * (0.003906^2) )));
            
            wts(i) = w_t_prev(i) * prob;
            w_t_prev(i) = wts(i);

            xprev_state(i)  = x_state(i);
            xprev_vel(i)    = x_vel(i);
            
    end
    
    %Normalize weights
    Exp     = 0;
    Index   = zeros(1,M);
    w_t     = wts ./ sum(wts);
     
    %Calculated Expected Filter Output and Co-eff of variation
    for k = 1:M
        %Expected Filter Output
        Exp = Exp +  (w_t(k) *  x_state(k));
    end
    
    %Store Expected filter output for plotting
    output(t)   = Exp;
    CV          = var ( w_t ) /(mean( w_t ) ^2) ;
    %Effective Sampling Size
    ESS = M / (1 + CV);
    if(start)
        figure(t)
        bar(X2, w_t,'k')
        xlabel('No of Particles');
        ylabel('Weight');
        set(gca,'FontSize',24)
        disp(strcat('iteration = ',num2str(t), ' ESS = ', num2str(ESS) ))
        
    end
    %Resampling
    if (ESS<threshold*M)
        %Track the number of times Resampled
        counter_resample = counter_resample + 1;
        
        if (counter_resample == resample)
            start = 1;
        end
        %Cumulative Weights Q
        Q       = cumsum( w_t ) ;
        %Guesses
        T       = rand (M+1 ,1) ;
        %Sorting the guesses
        T       = sort(T) ;
        T(M+1)= 1.0;
        g       =1; 
        j       =1;
        while(g<=M)
            %Find good particle indices
            if (T(g) < Q(j))
                Index (g) = j;
                g = g+1;
            else
                j = j +1;
            end
        end
        %Replace bad particles with good particles
        for i = 1:M
            x_state(i)      = x_state(Index(i));
            xprev_state(i)  = xprev_state(Index(i));

            x_vel(i)        = x_vel(Index(i));
            xprev_vel(i)    = xprev_vel(Index(i)) ;

            w_t(i)          = 1/M;
            w_t_prev(i)     = 1/M;
        end
    end
    %Plot resampled weights
    if(start)
        figure(t)
        bar(X2, w_t, 'k');
        set(gca,'FontSize',24);
        title( [ 'Iterations ', num2str( t )]) ;
        xlabel('No of Particles');
        ylabel('Weights');
        axis([0, M, 0, (1/M)*10]);
        disp(strcat('iteration = ',num2str(t), ' ESS = ', num2str(ESS) ))
    end
    if(counter_resample == resample + 1)
        start = 0;
    end
end
figure
xlabel ('Time Step (T)');
ylabel ('Position');
hold on
plot(X1 ,gt_pos, ' kO ','MarkerSize', 5) ;
plot( X1 ,output, 'k ', 'Linewidth', 1.2 ) ;
legend ('Actual Measured Data' , 'Estimated Data');
set(gca,'FontSize',24)
hold off
    
  