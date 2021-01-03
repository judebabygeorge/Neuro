
function PatternData = ExtractSpikeTrainData(iPattern)


fr = create_datastream(iPattern.src_filename);

window  = 200e-3*50000;
[Pattern, FrameNumber MarkTime]  = ExtractSpikeTrains(fr,iPattern.StimConfig,window);

x = find(FrameNumber==0, 1);
if(~isempty(x))
    display('WARNING: Stimulus Missing')
end

%% Create the Data Structure to Store 
PatternData.src_filename = iPattern.src_filename ;
PatternData.window = window  ;
PatternData.Pattern=Pattern;
PatternData.FrameNumber = FrameNumber;
PatternData.MarkTime=MarkTime;

PatternData.StimConfig = iPattern.StimConfig ;

% save_filename = src_filename;
% save_filename(end-2) = 'm';
% save( save_filename , 'PatternData');

end