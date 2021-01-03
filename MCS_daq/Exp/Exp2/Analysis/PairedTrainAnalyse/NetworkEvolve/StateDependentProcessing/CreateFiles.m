
function  CreateFiles

path = 'E:\Data\Data\';
% Culture = 'G09102014C';
% dDIV = {'DIV36','DIV37','DIV38','DIV39'} ;

Culture = 'G05012015A';
%dDIV = {'DIV28','DIV29','DIV30','DIV31','DIV37','DIV38'} ;
dDIV = {'DIV25'};
% Culture = 'G28082014A';
% dDIV = {'DIV36','DIV37','DIV48','DIV49','DIV50'} ;

% Culture = 'G09102014A';
% dDIV = {'DIV28','DIV29'} ;

probe_file_tag = 'data_PatternCheck_2_250_paired_train_probe';

for j   = 1:numel(dDIV)
    DIV = dDIV{j} ;

    path0 = [[path Culture] '\' DIV '\'];
    paired_probes = dir([path0 '\' probe_file_tag '*.mat']);

    X = zeros(120,20,numel(paired_probes));
    Y = {};

    for i=1:numel(paired_probes)
        display(sprintf('DIV %s sequence %d',DIV,i));
        f = sprintf('\\%s_%d.mat',probe_file_tag,i);
        f = [path0  f];
        f
        a = load(f);     
        [Patterns , ~ ]= EditPatterns(a.PatternData);

        P = ones(size(Patterns));
        P(isnan(Patterns)) = 0;
        P = mean(P,3);

        X(:,:,i) = P;

        f = sprintf('\\data_burst_PatternCheck_2_250_Dummy_%d.mat',i);
        f = [path0  f];
        a=load(f); 
        Y{i}.T = ExtractSpontaneousSpikeTimes(a.PatternData);     
    end

      save(sprintf('%s_%s_statechange.mat',Culture,DIV),'X','Y')
end
end

function T = ExtractSpontaneousSpikeTimes(PatternData)
    for i=1:120
        T{i} = ExtractSpikeTimes(PatternData,i);
    end
end
function y = ExtractSpikeTimes(PatternData,ElectrodeNumber)
  nSpikes = 0; 
  for i=1:numel(PatternData.Pattern)
      nSpikes = nSpikes + PatternData.Pattern{i}.SpikeCounts(ElectrodeNumber);
  end
  y = zeros(nSpikes,1);
  idx = 1;
  for i=1:numel(PatternData.Pattern)
     off = sum(PatternData.Pattern{i}.SpikeCounts(1:ElectrodeNumber-1))+1; 
     y(idx:(idx + PatternData.Pattern{i}.SpikeCounts(ElectrodeNumber) - 1))=(i-1)*50000 + PatternData.Pattern{i}.SpikeTimes(off:(off + PatternData.Pattern{i}.SpikeCounts(ElectrodeNumber) - 1));
     idx = idx + PatternData.Pattern{i}.SpikeCounts(ElectrodeNumber);
  end
end
