function  AnalysePairing_Train
%ANALYSEPAIRING Summary of this function goes here
%   Detailed explanation goes here
%close all
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data';
Culture ='Z09032015A';
DIV = 'DIV30';

path = [path '\' Culture '\' DIV '\'];

a = load( sprintf('%s\\StimConfigProbe.mat',path));
PatternConfig = a.StimConfigProbe;

files = dir([path '\data_PatternCheck_2_250_probe_scan_*.mat']);
nProbes = numel(files);

B = CreateBarGraphDisplay(9,2,4,[4 80]);

F = 1:1:ceil(nProbes/9)*9;
F(nProbes+1:end)=0;
F=reshape(F,[9 numel(F)/9]);

CombD=PatternConfig.PatternListDetails.SelectedCombDetails;
El = PatternConfig.PatternListDetails.CombDetails{CombD(1)}.E;

%El= El(CombD(2));
El=64
for Eid = 1:numel(El)
    E = El(Eid);
    display(sprintf('Selected Electrode %d',E));
    if(Eid == CombD(2))
        display('Probed Electrode')
    end
    for ff = 1:size(F,2)
        clear_BarGraphdisplay(B);
        for f = 1:9
           if F(f,ff) ~=0
             filename = sprintf('%s\\data_PatternCheck_2_250_probe_scan_%d.mat',path,F(f,ff));
             a = load(filename);
             PatternData = a.PatternData;

            [Patterns , ~ ]= EditPatterns(PatternData);

            for k=1:2
               for j=1:4
                    p = 2*((k-1)*4 + j);
                    ShowSpikeTimes(B,[f j k],Patterns,PatternConfig,E,p);
               end
            end
           end        
        end
        waitforbuttonpress;
    end
end

end

function ShowSpikeTimes(B,loc,Patterns,PatternConfig,E,Pid)
        t = Patterns(E,Pid,:);
        t = t(:)/50; 
        [n,~] = hist(B.BarAxis{loc(1),loc(2),loc(3)}.ax,t,B.x);                
        set(B.BarAxis{loc(1),loc(2),loc(3)}.bh,'YData',n);

        P=sum(~isnan(t))/numel(t);
        tm = mean(t(~isnan(t)));
        stim  = GetPatternDescription(PatternConfig,Pid);
        s =sprintf('P=%1.1f,T_m = %2.1f ms  (%s)',P,tm,stim);
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
    DecodeCheckWindow= 100;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
end
