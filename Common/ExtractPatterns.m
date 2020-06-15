function [Pattern FrameNumber  MarkTime] = ExtractPatterns(fr,Config,window)
%TO extract first spike times
ConfigLoad = 1 ; 

% Variables For results
if fr.type==3
    nElectrodes  = 120  ;
else
    nElectrodes  = 60  ;
end
nPresentations = 50 ;
cPresentation  = 1  ;
nPatterns = size(Config.Patterns,2);

Pattern     = ones(nElectrodes,nPatterns,nPresentations)*NaN ;
FrameNumber = zeros(1,nPatterns,nPresentations);
MarkTime    = zeros(size(FrameNumber));
% For all frames 
% Gather response on the stimulation

Frame = 1 ;
Frame_stop = fr.Frames ;

SpikeTimes = zeros(10000,1) ;
if fr.type==3
    SpikeCounts = zeros(120,1)  ;
else
    SpikeCounts = zeros(60,1)  ;
end

nHistory = 3;
Eid = 1 ;
EHistory = zeros(120,nHistory);

PatternsPresented = zeros(nPatterns,1);
error_count=0;
while(Frame <= Frame_stop)
    
    if(rem(Frame,10)==0)
      display(['Frame :' num2str(Frame)]);
    end
    
    if((fr.type ==0)||((fr.type ==3))||((fr.type ==4)))
     [~,SpikeEncoded,StimTrigger] = get_stream(fr,Frame);
     [StimConfig StimEvents] = StimDecode(StimTrigger) ;
     SpikeDecode(SpikeTimes,SpikeCounts,SpikeEncoded);     
    else
      [SpikeCounts SpikeTimes StimConfig StimEvents ~] =  get_compressed_stream(fr,Frame);
    end
               
               %Mask for this frame
               E = zeros(120,1);                
               
               for i=1:size(StimEvents,2)
                    Event = StimEvents(2,i);            
                    a = typecast(uint32(Event),'uint8');
                    Event  = a(1);
                    Id     = a(2);                    
                    switch(Event)
                        case 1 
                            %display(['**Sequence Start : '  num2str(Id)] )
                            t1.ChannelStimResponse = zeros(120,1);
                        case 2
                            %display(['**Sequence Start(L)'  num2str(Id)]) 
                            t1.ChannelStimResponse = zeros(120,1);
                        case 3
                            %display('**Sequence End')
                        case 4
                            %display('**Pattern shift')                           
                        otherwise
                            display(['ERROR : Unknown Event ' num2str(Event)])
                            error_count=error_count+1;
                            if(error_count > 10)
                                return;
                            end
                    end
               end 
               for i=1:size(StimConfig,2)
                    sConfig = StimConfig(2,i);
                    a = typecast(uint32(sConfig),'uint8'); 
                    iPattern = a(1);
                    Element = a(2);                       
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
                        
                        if(PatternsPresented(iPattern) ~=0)                            
                            %assert((sum(PatternsPresented)==nPatterns),'Pattern presentation error : not all pattern in this iteration presented before next started')
                            PatternsPresented = PatternsPresented*0;
                            cPresentation= cPresentation + 1 ;
                            %display('New Pattern Sequence Started');                 
                        end
                        PatternsPresented(iPattern) = 1;
                    end
                    %display(['** Pattern : '  num2str(iPattern) ' Element : ' num2str(Element) '  Config : ' num2str(a(3:4)) '  @ '  num2str(StimConfig(1,i))]);
                    
                    %Start a new iteration of pattern presentation
                    
                    if(ExtractResponse==1)
                        iMarkTime = StimConfig(1,i);
                        P = Get_StimResponse_Delay(SpikeCounts,SpikeTimes,iMarkTime,window);
                        
                        Id = iPattern;
                        P(Mask) = NaN ;
                        Pattern(:,Id,cPresentation) = P;
                        FrameNumber(1,Id,cPresentation)= Frame ;
                        MarkTime(1,Id,cPresentation)= iMarkTime ;
                    end
                    
                end
                               
 
                
   Frame = Frame + 1 ;

end

Pattern     = Pattern(:,:,1:cPresentation);
FrameNumber = FrameNumber(:,:,1:cPresentation);
MarkTime    = MarkTime(:,:,1:cPresentation); 
end

function [Mask,EHistory,Id] = StimElectrodeBlanking(E,EHistory,nHistory,Id)
    EHistory(:,Id) =  E ;
    Id = Id  + 1 ;
    if(Id > nHistory)
        Id  = 1;
    end
    Mask = (sum(EHistory,2) > 0);
end
  