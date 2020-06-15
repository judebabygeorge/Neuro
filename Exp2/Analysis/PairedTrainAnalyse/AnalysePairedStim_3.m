function  AnalysePairedStim_3(path,DIV,save_path)

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
    %P = ones(size(Patterns)) ;
    %P(isnan(Patterns)) = 0   ;
    %P = mean(P,3);
    t_max = 50*50;
    for j = 1:min(4,numel(StimConfigProbe.PatternDetails.vecs))
        
        R = ones(size(Patterns,1),1)*t_max;
        Vis = zeros(size(R));
        for k=1:size(Patterns,1)
             t = Patterns(k,StimConfigProbe.PatternDetails.vecs(j),:);            
             t = t(~isnan(t));                                      
             if numel(t) > 0.1*size(Patterns,3)                             
                 t = mean(t);
                 if t > t_max
                     t = t_max;
                 end
                 R(k) = t;
                 Vis(k) = 1;
             end             
        end
        
       R = R./max(R);
       %R = ones(size(R));
        %Vis = zeros(size(Q));
                    
        Act  = R;   
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
imwrite(F.cdata,[save_path  '/tl/' DIV '.png']);
close(hO.h)
end