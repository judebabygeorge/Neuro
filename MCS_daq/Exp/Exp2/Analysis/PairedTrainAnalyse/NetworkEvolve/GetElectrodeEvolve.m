function [X,Y] = GetElectrodeEvolve( path ,DIV,probe_file_tag)

%data_PatternCheck_2_250_paired_train_probe

path0 = [path '\' DIV '\'];
%[path0 '\' probe_file_tag '*.mat']
paired_probes = dir([path0 '\' probe_file_tag '*.mat']);

X = [];
numel(paired_probes)
if numel(paired_probes) > 0
    f = sprintf('\\%s_%d.mat',probe_file_tag,1);
    f = [path0  f];
    a=load(f);         
    X = zeros(120,size(a.PatternData.Pattern,2),numel(paired_probes));
    for i = 1:numel(paired_probes)
        f = sprintf('\\%s_%d.mat',probe_file_tag,i);
        f = [path0  f];
        a=load(f); 
        P = CreateFiringProbabilityMatrix( a.PatternData );
        X(:,:,i) = P; 
    end
end

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
