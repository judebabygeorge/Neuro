function PatternData = Extract_PatternData(src_filename,StimConfig,mode)


fr = create_datastream(src_filename);

window  = 800e-3*50000;

switch(mode)
    case 1 
        [Pattern, FrameNumber, MarkTime]  = ExtractPatterns(fr,StimConfig,window);
    case 2 
        [Pattern, FrameNumber,  MarkTime, PatternId, DecoderResult] = ExtractPatterns_StimTrain(fr,StimConfig,window);
    case 3
        [Pattern, FrameNumber, MarkTime]  = ExtractPatterns_SpikeTrain(fr,StimConfig,window);
    case 4
        [Pattern] = ExtractSpikeData(fr);
        FrameNumber = [];
        MarkTime    = [];
    case 5
        [Pattern] = ExtractPatterns_CLTrain(fr,StimConfig,40e-3*50000);
        FrameNumber = [];
        MarkTime    = [];
    otherwise
        [Pattern, FrameNumber, MarkTime]  = ExtractPatterns(fr,StimConfig,window);
end

x = find(FrameNumber==0, 1);
if(~isempty(x))
    display('WARNING: Stimulus Missing')
end

%% Create the Data Structure to Store 
PatternData.src_filename = src_filename ;
PatternData.Config=StimConfig;
PatternData.window = window  ;
PatternData.Pattern=Pattern;
PatternData.FrameNumber = FrameNumber;
PatternData.MarkTime=MarkTime;

if(mode==2)
    PatternData.PatternId = PatternId;
    PatternData.DecoderResult=DecoderResult;
end

PatternData.StimConfig = StimConfig ;

save_filename = src_filename;
save_filename(end-2) = 'm';

if mode==3
    idx = find((save_filename=='\'),1,'last');
    save_filename = [save_filename(1:idx) 'data_spiketrain' save_filename(idx+5:end)];
end
if mode==4
    idx = find((save_filename=='\'),1,'last');
    save_filename = [save_filename(1:idx) 'data_burst' save_filename(idx+5:end)];
end
save( save_filename , 'PatternData');

display('Pattern Extraction Complete...')
end