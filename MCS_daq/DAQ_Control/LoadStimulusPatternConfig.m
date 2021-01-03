function [A_Econfig A_PBuff A_PSeq] = LoadStimulusPatternConfig(DS,Config)

display('Load Electrode Configuration')
A_Econfig = Create_ElectrodeConfig(Config.Electrodes);
for i=1:size(A_Econfig,2)
 SendCommand(DS,5,A_Econfig(:,i))           ;
end

display('Load Pattern Buffer')
A_PBuff = Create_PatternBuffer(Config);
%numel(A_PBuff) 
assert((numel(A_PBuff) < 1024) , 'Pattern Buffer cannot accomdate(>1024) : Reduce number of patterns')
SendCommand(DS,10,A_PBuff)          ;

display('Load Pattern Sequence')
A_PSeq = Create_PatternSequence(Config);
assert((numel(A_PSeq) < 256) , 'Pattern Sequence Buffer cannot accomdate(>256): Reduce number of Sequence')
SendCommand(DS,11,A_PSeq)          ;

end


function A = Create_PatternSequence(Config)

nElements = 2*numel(Config.PatternSequence);
A = zeros(nElements,1);
A(1:2:nElements) = Config.PatternSequence;


end

% function A = Create_PatternBuffer(Config)
% 
% % Find the number of elements
% 
% a         = size(Config.Patterns);
% nElements =  (a(1)*2 + 1)*(a(2)+1)  + (a(2)+1)    + 1 ; 
%           %   pattens x npatterns     offsets   npatterns
% 
% A = zeros(nElements,1) ;
% 
% id    = 1      ; %nPattens
% A(id) = a(2)+1 ;
% 
% Offsets = 1 + (a(2)+1) + (0:1:a(2))*(a(1)*2+1);
% A(2:((a(2)+1)+1))=Offsets ;
% id =  (a(2)+1)+1 + 1 ;
% 
% %Add dummy sample
% A(id) = 1 ; id = id + 1 ;   % nElements
% 
% A(id) = hex2dec('FF000000');id = id + 1;% Config
% A(id) = (Config.PatternInterval - Config.PulseInterval*a(1))*50 ; id = id + 1 ;%delay
% 
% 
% id    = id + 2*(a(1) - 1);
% 
% for i=1:a(2)    
%     A(id) = a(1);id = id + 1 ;
%     for j=1:a(1)        
%         A(id) = Config.Patterns(j,i) ; % Segment is zero 
%             Trigger = 0 ;
%             p = Config.Patterns(j,i);
%             if(p>0)
%                 for k=1:size(Config.Electrodes,1)
%                     if(Config.Electrodes(k,p) ~=0)
%                         Trigger = Trigger + 1*(2^(k-1));
%                     end
%                 end
%             end
%         A(id) = A(id) + Trigger*(2^16) ; %Trigger DAC 1
%         id = id + 1;              
%         %A(id) = Config.PulseInterval*50 ;id = id + 1;     
%         A(id) = (Config.PatternDelay(j,i))*50 ;id = id + 1; 
%     end
% end
% 
%  A = [0;A];
%  
%  
% end

function A = Create_ElectrodeConfig(Electrodes)

  % Adding a null config
  E        = zeros(size(Electrodes,1),size(Electrodes,2)+1);
  E(:,2:end)=Electrodes;
  Electrodes=E;
  
  A        = uint32(zeros(13,size(Electrodes,2)));
  
  for i=1:size(Electrodes,2)
      
    Config = uint32(zeros(8,1)) ;
    Enable = uint32(zeros(4,1)) ;  
      
    for l = 1:size(Electrodes,1)
      E = Electrodes(l,i) ;
      if(E>0)
          E = E - 1 ;
          j = floor(E/15) + 1 ;
          k = 2*rem(E,15)     ;
          Config(j)= Config(j)+ l*2^k;

          j = floor(E/30) + 1 ;
          k = rem(E,30)       ;
          Enable(j) = Enable(j) + 2^k;
      end
    end
      A(1,i)     = i-1           ; 
      A(2:end,i) = [Enable;Config];           
  end 
 
end