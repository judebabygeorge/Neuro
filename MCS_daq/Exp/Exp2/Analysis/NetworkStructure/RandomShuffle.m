
display('Random Shuffle');
P = mean(Ps,3);

%%

if(0)
    % Modify the matrix for simplification
    th = 0.8;
    Q = zeros(size(P));
    Q(P>th)=P(P>th);
    Q(Q>0)=1;
    P = Q;
end
%%

Patterns = zeros(120,64,45);

for  i = 1:size(Patterns,3)
    R = rand(size(Patterns,1),size(Patterns,2));
    Patterns(:,:,i) = (R <= P);
end

%Patterns=Patterns*10*50; %Assign Spike time of 10ms to the spikes at
% electrodes for the pattern which fire with a probability > 0.8 for that
% pattern
%Patterns(Patterns==0)=nan;

P=Patterns;
