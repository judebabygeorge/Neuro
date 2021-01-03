function T = CreatemeanFireTimeMatrix ( PatternData )

 [Patterns , ~ ]= EditPatterns(PatternData);

  T = Patterns;
  
  P = ones(size(Patterns));
  P(isnan(Patterns)) = 0;
  T(isnan(Patterns)) = 0;
  
  T = sum(T,3);
  N = sum(P,3);
  
  T = T./N;  
end