%Submitted by Rahil Modi - C14109603
clc
clear all
close all
%Order = A,C,G,T
H = log2( [0.2, 0.3, 0.3, 0.2] );
L = log2( [0.3, 0.2, 0.2, 0.3] );

%Initial probability
pl_0 = log2(0.5);
ph_0 = log2(0.5);

%Transition probabilities
phh = log2(0.5);
phl = log2(0.5);
pll = log2(0.6);
plh = log2(0.4);
    
%Input sequence  
%S = ['G', 'G', 'C', 'A', 'C', 'T', 'G', 'A', 'A' ]; %Sequence 1
S = ['T', 'C', 'A', 'G', 'C', 'G', 'G', 'C', 'T' ]; %Sequence 2
size = length(S);
S_a  = zeros(1,size);

%Probabilities 
p              = zeros(4, size);
most_prob_path = zeros(1, size);

%Convert sequence to array
for i = 1:length(S)
   if(S(i) == 'A')
       S_a(i) = 1;
   elseif(S(i) == 'C')
       S_a(i) = 2;
   elseif(S(i) == 'G')
       S_a(i) = 3;
   else
       S_a(i) = 4;
   end
end
%Calculating the forward Probabilities using Viterbi Algorithm
size = length(S_a);  
for i = 1:size
    if( i == 1)
        p(1,i) = ph_0 + H(S_a(i));
        p(2,i) = pl_0 + L(S_a(i));
        if( p(1,i) == p(2,i) )
            p(3,i) = p(1,i);        %Equal
            p(4,i) = 2;             
        elseif(p(1,i) > p(2,i))
            p(3,i) = p(1,i);        %High
            p(4,i) = 0;
        else
            p(3,i) = p(2,i);        %Low
            p(4,i) = 1; 
        end
    else
        p(1,i) = H(S_a(i)) + max ( (p(1, i-1) + phh), (p(2, i-1) + plh) );
        p(2,i) = L(S_a(i)) + max ( (p(1, i-1) + phl), (p(2, i-1) + pll) );
        if( p(1,i) == p(2,i) )
            p(3,i) = p(1,i);        %Equal
            p(4,i) = 2;             
        elseif(p(1,i) > p(2,i))
            p(3,i) = p(1,i);        %High
            p(4,i) = 0;
        else
            p(3,i) = p(2,i);        %Low
            p(4,i) = 1; 
        end
    end
end
%Backtracking
init       = 1;
final_prob = p(4,:);
size       = length(final_prob);
for i = size:-1:1
    if(final_prob(i) == 2)
        if(i == size)
            most_prob_path(i) = init; %If last prob is same, initialize
        else
            most_prob_path(i) = most_prob_path(i+1);
        end
    elseif(final_prob(i) == 0)
        most_prob_path(i) = 0;        %Low
    else
        most_prob_path(i) = 1;        %High
    end
end
disp("Best Probabilities: ");
disp(p(3,:))

for i = 1:size
    if(most_prob_path(i) == 1)
        Ans(i) = 'L';
    else
        Ans(i) = 'H';
    end
end
disp("The most probable path is:")
disp(Ans);