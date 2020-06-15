
function Y = test_US
    %path0 = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z06112015A\DIV26';
    path0 = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G28012016A\DIV22';
    spontaneours_rec = dir([path0 '\data_burst_PatternCheck_2_250_Dummy_*.mat']);
    numel(spontaneours_rec)
    Y = zeros(120,numel(spontaneours_rec));
    for i = 1:numel(spontaneours_rec)
        f = sprintf('\\data_burst_PatternCheck_2_250_Dummy_%d.mat',i);
        f = [path0  f];
        a=load(f); 
        PatternData=a.PatternData; 
        Y(:,i)=GetSpontaneousElectrodeActivity(PatternData);
    end
end

function X = GetSpontaneousElectrodeActivity(PatternData)
  X = zeros(120,1);
  for i=1:numel(PatternData.Pattern)
      X = X + PatternData.Pattern{i}.SpikeCounts;
  end
end

