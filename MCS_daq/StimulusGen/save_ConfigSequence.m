
function save_ConfigSequence(filename,Sequence)

fid = fopen(filename,'w');

fwrite(fid,numel(Sequence),'uint32')

for i=1:numel(Sequence)
  fwrite(fid,Sequence{i}.Config.nConfig,'uint32');
  fwrite(fid,Sequence{i}.Config.EConfig,'uint32');
  
  fwrite(fid,Sequence{i}.Sequence.nElements,'uint32');
  fwrite(fid,Sequence{i}.Sequence.ConfigList,'uint32');
  fwrite(fid,Sequence{i}.Sequence.SegmentList,'uint32');
  fwrite(fid,Sequence{i}.Sequence.DelayList,'uint32');
end

fclose(fid);
end