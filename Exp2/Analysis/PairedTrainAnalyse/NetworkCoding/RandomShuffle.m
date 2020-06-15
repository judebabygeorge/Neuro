
display('Random Shuffle');
[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;
P = mean(P,3);

%%

% Modify the matrix for simplification
th = 0.8;
Q = zeros(size(P));
Q(P>th)=P(P>th);
%Q(Q>0)=1;
P = Q;

%%

Patterns = zeros(size(Patterns));

for  i = 1:size(Patterns,3)
    R = rand(size(Patterns,1),size(Patterns,2));
    Patterns(:,:,i) = (R <= P);
end

Patterns=Patterns*10*50; %Assign Spike time of 10ms to the spikes at
% electrodes for the pattern which fire with a probability > 0.8 for that
% pattern
Patterns(Patterns==0)=nan;

PatternData.Pattern=Patterns;

