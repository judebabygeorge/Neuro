function CompressFile(filename,outfilename,compresstype)

fr = create_datastream(filename) ;

if(fr.valid==0)
    display('Cannot Open for read')
    return ;
end

% if(fr.type>=compresstype)
%     display('Cannot Compress');
%     return ;
% end
%File Format

%Header(Word)
%Date(6 Words)

% FrameCount

% Frames (1 second frames)
% Frame Id
% TotalFrame Size 
% StimConfig  : Size , array
% Stim Events : Size , array
% SpikeCounts (120 Words)
%(Spike Times) in the offset format 16bit number
% Data Segment Samples(16bit X 112 Samples)Xnumber of spikes

fid = fopen(outfilename,'w');

if(fid==-1)
    display('Cannot open for write')
end

fwrite(fid,compresstype,'uint32');
fwrite(fid,fr.date,'uint32');

fwrite(fid,fr.Frames,'uint32');

u_SpikeTimes  = zeros(10000,1);
u_SpikeCounts = zeros(120,1)  ;

pre_spike = 36 ;
post_spike= 76 ;
interval = [(-pre_spike) (post_spike-1)];

for i=1:fr.Frames
  if(rem(i,10)==0)
     display(['Frame : ' num2str(i)]);    
  end
  
  if((fr.type==0)||(fr.type==3))
      [Data SpikeEncoded StimTrigger Output] = get_stream(fr,i)  ;
      
      if(1)
          Data = CubicFitFilter(Data')';  
      end
     
      SpikeDecode(u_SpikeTimes,u_SpikeCounts,SpikeEncoded);
      [StimConfig StimEvents] = StimDecode(StimTrigger)   ;
      DecoderOut = OutputDecode(Output);
  end
  if(fr.type==1)
      [u_SpikeCounts u_SpikeTimes StimConfig StimEvents ~] =  get_stream_compressed(fr,i);
  end
  
  %Calculate the total frame size 
  FrameSize = 4*3 ; %FrameSize
  FrameSize = FrameSize + 4*2 + 4*numel(StimConfig) ;   
  FrameSize = FrameSize + 4*2 + 4*numel(StimEvents)  ;  
  FrameSize = FrameSize + 4*2 + 2*numel(u_SpikeCounts); 
  FrameSize = FrameSize + 4*2 + 2*sum(u_SpikeCounts)   ;
  FrameSize = FrameSize + 4*2 + 4*numel(DecoderOut)    ;
  
  if(compresstype == 1)
      FrameSize = FrameSize + 4*2 + sum(u_SpikeCounts)*(pre_spike+post_spike)*2 ;
  end
  
  %display(['Frame : ' num2str(i) ' : ' num2str(FrameSize)]);
  fwrite(fid,1,'uint32'); % Data Frame
  fwrite(fid,i,'uint32');
  fwrite(fid,FrameSize,'uint32');
  
  fwrite(fid,size(StimConfig),'uint32');
  fwrite(fid,StimConfig,'uint32');
  fwrite(fid,size(StimEvents),'uint32');
  fwrite(fid,StimEvents,'uint32');
  
  fwrite(fid,size(u_SpikeCounts),'uint32'); 
  fwrite(fid,u_SpikeCounts,'uint16');
  
  fwrite(fid,[sum(u_SpikeCounts) 1],'uint32');   
  fwrite(fid,u_SpikeTimes(1:sum(u_SpikeCounts)),'uint16');  
  
  fwrite(fid,size(DecoderOut),'uint32');
  fwrite(fid,DecoderOut,'uint32');
  
  if(compresstype == 1)
      %[(pre_spike+post_spike) sum(u_SpikeCounts)]
      fwrite(fid,[(pre_spike+post_spike) sum(u_SpikeCounts)],'uint32');  
      Offset = 1 ;
      for j=1:numel(u_SpikeCounts)
          for k=1:u_SpikeCounts(j)
              id = u_SpikeTimes(Offset);
              Offset = Offset + 1 ;
              id = id + interval  ;

              D = Data(j,id(1):id(2));      
                                     
              fwrite(fid,D,'int16'); 
          end
      end
  end
  
  
end

fwrite(fid,2,'uint32'); % End Frame
fclose(fid);

end