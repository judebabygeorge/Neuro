

function CompressDataInFolder(path)

files = dir([path '\data_PatternCheck_*.mat']);

for i=1:numel(files)
    display(files(i).name)
    ind = find((files(i).name=='_'));
    %files(i).name(ind(2):end)
    %files(i).name(1:ind(2))
    e = [path '\data_spiketrain_PatternCheck_' files(i).name(ind(2)+1:end)];
    filename = [path '\' files(i).name];
    if (~exist(e,'file'))
        a=load(filename);
        PatternData =a.PatternData;        
        filename(end-2)='d';
        Extract_PatternData(filename,PatternData.StimConfig,3);        
    end
    
    if(~strcmp(files(i).name(1:end-6),'data_PatternCheck_2_250_CLTrain'));
        save_filename = [path '\spiketrain_wf_' files(i).name(ind(1)+1:end)];    
        if (~exist(save_filename,'file'))
            filename(end-2)='d';

            display(['Compressing file  : ' , filename]);

            a=load(e);
            PatternData =a.PatternData;

            Patterns = 1:size(PatternData.Pattern,3);
            electrodes=1:size(PatternData.Pattern,1);
            [SpikeIndex, SpikeData] = ExtractSpikeShapes_SpikeTrain( PatternData ,  filename , Patterns , electrodes);

            SpikeWF.SpikeIndex = SpikeIndex;
            SpikeWF.SpikeData = SpikeData;

            save_filename = [path '\spiketrain_wf_' files(i).name(ind(1)+1:end)];
            save( save_filename , 'SpikeWF');
        end
    end
end

display(['Done in path ' path])
end