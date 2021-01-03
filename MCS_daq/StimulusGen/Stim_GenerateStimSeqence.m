function Array = Stim_GenerateStimSeqence(Config)

ConfigList = Config.Sequence.ConfigList ;
SegmentList=Config.Sequence.SegmentList;
DelayList=Config.Sequence.DelayList;

nElements = numel(ConfigList);

Array = uint32(zeros(nElements + 1,1)) ;
Array(1) = nElements ;

%Convert Delay in ms to values
DelayList = uint32(DelayList/20e-3);

for i=1:nElements
    Array(1 + 2*(i-1)+1) = combine_halfwords(SegmentList(i),ConfigList(i)) ;
    Array(1 + 2*(i-1)+2) = DelayList(i) ;
end
end