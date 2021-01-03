function  AnalysePairedStim_4(path,DIV,save_path)
%ANALYSEPAIREDSTIM Summary of this function goes here
%   Detailed explanation goes here

addpath('C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Analysis\PairAnalyse\')

path = [path '\' DIV '\'];
%path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G14082014A\DIV27\';
%path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G02072014C\DIV35\';

paired_probes = dir([path '\data_spiketrain_PatternCheck_2_250_paired_train_probe_*.mat']);


B = CreateBarGraphDisplay(6,1,12,[4 80]);
S = CreateSpikeShapeDisplay(6,1,12,[4 80]);

nProbes = numel(paired_probes);
selected_probes = 1:1:nProbes;

if(numel(selected_probes)>12)
    selected_probes = selected_probes(1:2:end);
end

for i=1:min(12,numel(selected_probes))
   
    a=load([path '\data_spiketrain_PatternCheck_2_250_paired_train_probe_' num2str(selected_probes(i)) '.mat']);
    PatternData =a.PatternData;
    a = load([path  '\spiketrain_wf_PatternCheck_2_250_paired_train_probe_' num2str(selected_probes(i)) '.mat']);
    
    
    StimConfigProbe = PatternData.StimConfig;
    Patterns = PatternData.Pattern;
    %[Patterns , StimConfigProbe ]= EditPatterns(PatternData);
    I = a.SpikeWF.SpikeIndex;
    T = a.SpikeWF.SpikeData;
    
    n = min(6,numel(StimConfigProbe.PatternDetails.vecs));
    for j=1:n
        ShowSpikeTimes(B,[j i 1],Patterns,StimConfigProbe,StimConfigProbe.PatternDetails.electrodes(j),StimConfigProbe.PatternDetails.vecs(j));
        ShowSpikeShape(S,[j i 1],I,T,StimConfigProbe,StimConfigProbe.PatternDetails.electrodes(j),StimConfigProbe.PatternDetails.vecs(j));
    end
    
end

% F = getframe(B.h);
% imwrite(F.cdata,[save_path  '/full/el_' DIV '.png']);
% F = getframe(S.h);
% imwrite(F.cdata,[save_path  '/full/s_' DIV '.png']);
% 
% close(B.h)
% close(S.h);
end

function ShowSpikeShape(S,loc,I,T,PatternConfig,E,Pid)
     id  = I(E,:,Pid,:);
     id  = id(:);
     id  = id(id >0);
     X   = repmat((1:1:size(T,1))',[1 numel(id)]);
     %size(X)
     %size(T(:,id))
     plot(S.SpikeAxis{loc(1),loc(2),loc(3)}.ax,X,T(:,id),'k');
     set(S.SpikeAxis{loc(1),loc(2),loc(3)}.ax,'XLim',[-25 75],'YLim',[-100 100],'XTick',[],'YTick',[]); 
     
     stim  = GetPatternDescription(PatternConfig,Pid);
     s =sprintf('(%s)',stim);
     set(S.SpikeAxis{loc(1),loc(2),loc(3)}.hl,'String',s);
end

function ShowSpikeTimes(B,loc,Patterns,PatternConfig,E,Pid)
        t = Patterns(E,:,Pid,:);
        t = reshape(t,[numel(t) 1])/50; 
        [n,~] = hist(B.BarAxis{loc(1),loc(2),loc(3)}.ax,t,B.x);                
        set(B.BarAxis{loc(1),loc(2),loc(3)}.bh,'YData',n);

        P=sum(~isnan(t))/numel(t);
        tm = mean(t(~isnan(t)));
        stim  = GetPatternDescription(PatternConfig,Pid);
        s =sprintf('P=%.2f,T_m = %2.1f ms  (%s)',P,tm,stim);
        set(B.BarAxis{loc(1),loc(2),loc(3)}.hl,'String',s);
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
function tm =  GetMeanFireTime(Patterns,El,Pid)
    tm = Patterns(El,Pid,:);
    tm=  tm(~isnan(tm));
    tm = mean(tm)/50;
end