function  AnalysePairedStim_2(path,DIV,save_path)

addpath('C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Analysis\PairAnalyse\')

path = [path '\' DIV '\'];
%path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G14082014A\DIV27\';
%path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G02072014C\DIV35\';
paired_probes = dir([path '\data_PatternCheck_2_250_paired_train_probe_*.mat']);

h = PatternView ;
hO  = guidata(h);  

for i=1:min(8,numel(paired_probes))
    a=load([path '\' paired_probes(i).name]);
    PatternData =a.PatternData;
    [Patterns , StimConfigProbe ]= EditPatterns(PatternData);
    P = ones(size(Patterns)) ;
    P(isnan(Patterns)) = 0   ;
    P = mean(P,3);
    
    for j = 1:min(4,numel(StimConfigProbe.PatternDetails.vecs))
        Q = P(:,StimConfigProbe.PatternDetails.vecs(j));
        
        %Vis = zeros(size(Q));
        Vis = Q;            
        Act  = ones(size(Vis))*0;   
        Mark = zeros(size(Act));
        hO.ShowElectrodeActivity(hO,(j-1)*8+i,[Act Vis], Mark);            
    end
%     Q= zeros(2,numel(StimConfigProbe.PatternDetails.vecs));
%     for j=1:size(Q,2)
%         Q(1,j) = P(StimConfigProbe.PatternDetails.electrodes(j),StimConfigProbe.PatternDetails.vecs(j));
%         Q(2,j) =  GetMeanFireTime(Patterns,StimConfigProbe.PatternDetails.electrodes(j),StimConfigProbe.PatternDetails.vecs(j));
%     end
%     display(Q)
%     
%     for j=1:min(6,size(Q,2))
%         ShowSpikeTimes(B,[j i 1],Patterns,StimConfigProbe,StimConfigProbe.PatternDetails.electrodes(j),StimConfigProbe.PatternDetails.vecs(j));
%     end
    
end

F = getframe(hO.h);
imwrite(F.cdata,[save_path  '/cl/' DIV '.png']);
close(hO.h)
end