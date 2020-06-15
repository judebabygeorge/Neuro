function P = CreateFiringProbabilityMatrix( PatternData )
%CREATEFIRINGPROBABILITYMATRIX Summary of this function goes here
%   Detailed explanation goes here

 [Patterns , ~ ]= EditPatterns(PatternData);

  P = ones(size(Patterns));
  P(isnan(Patterns)) = 0;
  P = mean(P,3);
    
end

