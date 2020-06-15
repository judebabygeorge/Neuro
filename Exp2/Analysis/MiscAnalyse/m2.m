function m2( PatternData )
%TEST Summary of this function goes here
%   Detailed explanation goes here



Patterns = PatternData.Pattern;

DecodeCheckWindow= 100;
Patterns(Patterns<5*50) = nan;
Patterns(Patterns>DecodeCheckWindow*50) = nan;
    
V = 2:2:112;
[PatternId W e] = get_best_patterns(Patterns(:,V,:));

  
end

