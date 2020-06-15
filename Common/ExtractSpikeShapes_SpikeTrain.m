function [SpikeIndex SpikeData] = ExtractSpikeShapes_SpikeTrain( PatternData ,  datafilename , Patterns , electrodes)
%EXTRACTSPIKESHAPES Summary of this function goes here
%   Detailed explanation goes here

Window  = [-0.5 1.5]*50;
Window  = Window(1):1:Window(2);

SpikeIndex = zeros(size(PatternData.Pattern));

SpikeToExtract = zeros(size(PatternData.Pattern));
SpikeToExtract(electrodes,:,Patterns,:) = 1;
%SpikeToExtract(electrodes,Patterns,:) = 1;

SpikeToExtract = SpikeToExtract.*(~isnan(PatternData.Pattern));

nSpikes = sum(sum(sum(sum(SpikeToExtract))))

SpikeData = zeros (numel(Window), nSpikes);

%Frames  = PatternData.FrameNumber(1,Patterns,:);
Frames  = PatternData.FrameNumber(1,1,Patterns,:);
uFrames = sort(unique(Frames(:)));

fr = create_datastream(datafilename);

SIndex = 0 ;

%FrameNumber = repmat(PatternData.FrameNumber,[size(SpikeToExtract,1),1 1]);
%MarkTime    = repmat(PatternData.MarkTime,[size(SpikeToExtract,1),1 1]);
FrameNumber = repmat(PatternData.FrameNumber,[size(SpikeToExtract,1),size(SpikeToExtract,2),1 1]);
MarkTime    = repmat(PatternData.MarkTime,[size(SpikeToExtract,1),size(SpikeToExtract,2),1 1]);

display(sprintf('Total spikes to Extract : %d',nSpikes));
ii = 0;

for i=1:numel(uFrames)
 if(uFrames(i)>0)
     [Data, ~ ,~ ,~] = get_stream(fr,uFrames(i)); 

     %There are some spikes in  here
     X = (FrameNumber == uFrames(i)).*SpikeToExtract;
     [r,c] = find(X==1);


     for j=1:numel(r)
         SIndex = SIndex + 1;

         %size(SpikeData(:,SIndex))
         %size(Data)
         %size(Window+MarkTime(r(i),c(i)))
         %size( Data(r(j),Window+MarkTime(r(j),c(j)))')
         SpikeData(:,SIndex) = Data(r(j),Window+MarkTime(r(j),c(j))+PatternData.Pattern(r(j),c(j)))';
         SpikeIndex(r(j),c(j)) = SIndex ;     
     end

     if(((SIndex/nSpikes)- ii)>0.1)
        display(sprintf('Spikes Extracted : %2.1f ',(SIndex)*100/nSpikes));
        ii = SIndex/nSpikes;
     end
 end
 
end


end

