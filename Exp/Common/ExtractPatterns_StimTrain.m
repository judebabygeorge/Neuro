function [Pattern FrameNumber  MarkTime PatternId DecoderResult] = ExtractPatterns_StimTrain(fr,Config,window)
%% To Extract Patterns when the protocol does not have the standard structure of repeating stimulus trains

ConfigLoad = 1 ; 

% Variables For results
nElectrodes  = 120  ;
nStimulus    = 4*60*10  ;
cStimulus    = 0    ;



Pattern         = ones(nElectrodes,nStimulus)*NaN ;
FrameNumber     = zeros(1,nStimulus);
PatternId       = zeros(size(FrameNumber)) ;
MarkTime        = zeros(size(FrameNumber));
DecoderResult   = zeros(size(FrameNumber));
% For all frames 
% Gather response on the stimulation

Frame = 1 ;
Frame_stop = fr.Frames ;

SpikeTimes = zeros(10000,1) ;
SpikeCounts = zeros(120,1)  ;

nHistory = 3;
Eid = 1 ;
EHistory = zeros(120,nHistory);



while(Frame <= Frame_stop)
    
    if(rem(Frame,10)==0)
      display(['Frame :' num2str(Frame)]);
    end
    
    if((fr.type ==0)||((fr.type ==3)))
     [~,SpikeEncoded,StimTrigger,Output] = get_stream(fr,Frame);
     [StimConfig StimEvents] = StimDecode(StimTrigger) ;
     SpikeDecode(SpikeTimes,SpikeCounts,SpikeEncoded);  
     DecoderOut = OutputDecode(Output);
    else
      [SpikeCounts SpikeTimes StimConfig StimEvents ~] =  get_compressed_stream(fr,Frame);
    end
               
               %Mask for this frame
               E = zeros(120,1);                
               
%                for i=1:size(StimEvents,2)
%                     Event = StimEvents(2,i);            
%                     a = typecast(uint32(Event),'uint8');
%                     Event  = a(1);
%                     Id     = a(2);                    
%                     switch(Event)
%                         case 1 
%                             display(['**Sequence Start : '  num2str(Id)] )
%                             t1.ChannelStimResponse = zeros(120,1);
%                         case 2
%                             display(['**Sequence Start(L)'  num2str(Id)]) 
%                             t1.ChannelStimResponse = zeros(120,1);
%                         case 3
%                             display('**Sequence End')
%                         case 4
%                             display('**Pattern shift')  
%                         case 5
%                             display(['**Decoder Enable : '  num2str(typecast(a(3:4),'uint16'))]) 
%                         case 6
%                             display(['**Decoder Out : '  num2str(typecast(a(3:4),'uint16'))]) 
%                         otherwise
%                             display('ERROR : Unknown Event')
%                     end
%                end 
                
               DecoderOutValid = 0;
               if(size(DecoderOut,2) == size(StimConfig,2))
                   DecoderOutValid =1;
               end
               for i=1:size(StimConfig,2)
                    sConfig = StimConfig(2,i);
                    a = typecast(uint32(sConfig),'uint8'); 
                    %iPattern = a(1);
                    %Element = a(2);                       
                    Ei = Config.Electrodes(a(4));   
                    Ei = Ei(Ei~=0);
                    E(Ei) = E(Ei) + 1 ;                    
               end                               
                
               E(E>0) = 1 ;
               [Mask,EHistory,Eid]=StimElectrodeBlanking(E,EHistory,nHistory,Eid);
               
               for i=1:size(StimConfig,2)
                    sConfig = StimConfig(2,i);
                    a = typecast(uint32(sConfig),'uint8');
                    iPattern = a(1);
                    Element = a(2);   
                    
                    ExtractResponse = 0     ;
                    if(Element == 0)
                        ExtractResponse = 1 ;                      
                    end
                    %display(['** Pattern : '  num2str(iPattern) ' Element : ' num2str(Element) '  Config : ' num2str(a(3:4)) '  @ '  num2str(StimConfig(1,i))]);
                                       
                    
                    if(ExtractResponse==1)
                        cStimulus = cStimulus + 1;
                        iMarkTime = StimConfig(1,i);
                        P = Get_StimResponse_Delay(SpikeCounts,SpikeTimes,iMarkTime,window); 
                        P(Mask) = NaN ;
                        Pattern(:,cStimulus) = P;
                        PatternId(cStimulus)  = iPattern;
                        FrameNumber(cStimulus)= Frame ;
                        MarkTime(cStimulus)= iMarkTime ;
                        if(DecoderOutValid== 1)
                          a = typecast(uint32(DecoderOut(2,i)),'uint16');
                          DecoderResult(cStimulus) = a(2);
                        end
                        
                    end                    
               end
                
   Frame = Frame + 1 ;

end

Pattern     = Pattern(:,1:cStimulus);
FrameNumber = FrameNumber(:,1:cStimulus);
PatternId    = PatternId(:,1:cStimulus); 
MarkTime    = MarkTime(:,1:cStimulus); 
DecoderResult    = DecoderResult(:,1:cStimulus); 
end

function [Mask,EHistory,Id] = StimElectrodeBlanking(E,EHistory,nHistory,Id)
    EHistory(:,Id) =  E ;
    Id = Id  + 1 ;
    if(Id > nHistory)
        Id  = 1;
    end
    Mask = (sum(EHistory,2) > 0);
end
  