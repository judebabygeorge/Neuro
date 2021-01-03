function Sequence = load_ConfigSequence(filename)

fid = fopen(filename,'r');

nC = fread(fid,1,'uint32') ;

Sequence{nC} = [] ;

for i=1:nC
  Sequence{i}.Config.nConfig=fread(fid,1,'uint32');
  Sequence{i}.Config.EConfig=fread(fid,[120 Sequence{i}.Config.nConfig],'uint32');
  
  Sequence{i}.Sequence.nElements=fread(fid,1,'uint32');
  Sequence{i}.Sequence.ConfigList=fread(fid,[Sequence{i}.Sequence.nElements 1],'uint32');
  Sequence{i}.Sequence.SegmentList=fread(fid,[Sequence{i}.Sequence.nElements 1],'uint32');
  Sequence{i}.Sequence.DelayList=fread(fid,[Sequence{i}.Sequence.nElements 1],'uint32');
end
fclose(fid)
end