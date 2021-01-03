function [y, e] = CompareBurstVsInput( path , id ,pid)
%COMPAREBURSTVSINPUT Summary of this function goes here
%   Detailed explanation goes here


a = load(sprintf('%s/data_burst_PatternCheck_2_250_Dummy_%d.mat',path,id));
BurstPattern = a.PatternData ;
a = load(sprintf('%s/data_PatternCheck_2_250_paired_train_probe_%d.mat',path,id));
InputPattern = a.PatternData ;

S = zeros(120,1);

for i=1:numel(BurstPattern.Pattern)
    S = S + BurstPattern.Pattern{i}.SpikeCounts; 
end

[Patterns , ~ ]= EditPatterns(InputPattern);

P = ones(size(Patterns));
P(isnan(Patterns)) = 0;
P = mean(P,3);
%P = sum(P>0.3,2);



%e = unique(InputPattern.StimConfig.PatternDetails.electrodes)
e = InputPattern.StimConfig.PatternDetails.electrodes(pid);
y = S(e);
e = P(e,[2*pid]);
%e = P(e,[2*pid 2*(pid+5)]);

%y=0;e=0;
%[y, e] = ExtractBurstProfile(BurstPattern);
end

function [y, e] = ExtractBurstProfile(PatternData)
    window = 5;
    Pattern = PatternData.Pattern;
    y  = zeros((numel(Pattern))*1000/window,1);
    e  = zeros((numel(Pattern))*1000/window,120);
    for i=12:numel(Pattern)
        for j=1:1000/window
            t = [(j-1)*window j*window]*50;
            y((i-1)*(1000/window) + j )=sum(Pattern{i}.SpikeTimes >= t(1) & Pattern{i}.SpikeTimes < t(2));

            Offset = [0;cumsum(Pattern{i}.SpikeCounts)];
            for k=1:120
               S = Pattern{i}.SpikeTimes(Offset(k)+1:Offset(k+1));
               e((i-1)*(1000/window) + j,k ) = sum(S >= t(1) & S < t(2));
            end
        end
    end
end

function [Patterns , PatternConfig ]= EditPatterns(PatternData)
    %Extract The relevent patterns
    Patterns = PatternData.Pattern;
    PatternConfig = PatternData.StimConfig;
    %Patterns = Patterns(:,V,:);

    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow= 150;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
end