function [Data SpikeEncoded StimTrigger Output] = get_stream(file,FrameNumber)

Data= [];
SpikeEncoded = [];
StimTrigger = [];
Output       = [];  

if(file.valid == 0)
    display('Not a valid file')
    return ;
end
if(FrameNumber > file.Frames)
  display('Frame does not exist')  
  return ;
end

h1_size = (1 + 6)*4 ;
h2_size = (1 + 1)*4 ;

if(file.type == 0)
  block_size = 50000*(60+4+2)*4 ; 
else
    if(file.type ==3)
        block_size = 50000*(60+4+2+10)*4 ; 
    end
    if(file.type ==4)
        block_size = 50000*(30+4+2+10)*4 ; 
    end
end  
%Go to start of frame

fid = fopen(file.filename,'r');

start = h1_size + (h2_size + block_size)*(FrameNumber-1) ;

fseek(fid,start,'bof');

h = fread(fid,[1 1],'uint32');
Fid = fread(fid,[1 1],'uint32');

if((h ~= 1) || (Fid ~= FrameNumber))
    display('Cannot Find Frame');
else
    if(file.type ==3)
        Data = fread(fid,[120 50000] ,'int16');
    else
        Data = fread(fid,[60 50000] ,'int16');
    end
    SpikeEncoded = fread(fid,[4 50000] ,'uint32');
    StimTrigger  = fread(fid,[2 50000] ,'int32');
    if(file.type ==3)
      Output       =  fread(fid,[10 50000] ,'uint32');
    end
end

fclose (fid);

end