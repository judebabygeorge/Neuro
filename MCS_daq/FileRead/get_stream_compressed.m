
function [SpikeCounts SpikeTimes StimConfig StimEvents Segments DecoderOut] =  get_stream_compressed(file,FrameNumber)

SpikeCounts = [];
SpikeTimes = [];
StimConfig = [];
StimEvents = [];
Segments   = [];

if(file.valid == 0)
    display('Not a valid file')
    return ;
end
if(FrameNumber > file.Frames)
  display('Frame does not exist')  
  return ;
end

fid = fopen(file.filename,'r')

h = fread(fid,[1 1],'uint32')

start = (1 + 6 )*4 ;
fseek(fid,start,'bof');

%Go to the start of segment
FrameId = 0 ;
switch(file.type)
    case  0
     channels   = 120;
     block_size = (50000*(channels/2+4+2)*4);     
    case  3    
     channels   = 120;
     block_size = (50000*(channels/2+4+2+10)*4);
    case  4
     channels   = 60;
     block_size = (50000*(channels/2+4+2+10)*4);

end

while(1)
    %ftell(fid)
    h = fread(fid,[1 1],'uint32');
    if(h ~= 1)
        display('Error in file0');
        return;
    end
    id= fread(fid,[1 1],'uint32')
    
    if(id ~= (FrameId+1))
        display('Error in file1');
        return;
    end
    FrameId = FrameId + 1 ; 
    if(FrameId<FrameNumber)
        s = fseek(fid,block_size,'cof');
        if(s==-1)
            display('Error in file');
            return;
        end
    else
        break;
    end
end
   


fclose(fid);
end