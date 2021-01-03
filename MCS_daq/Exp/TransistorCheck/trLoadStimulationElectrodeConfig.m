
function  trLoadStimulationElectrodeConfig(DS,SignalGen,Config)

%Just Using Config Zero
display('Load Electrode Configuration')

%NullConfig 0
A = zeros(13,1); %(Config=0,Enable=0)
SendCommand(DS,5,A)                     ;
A = trCreateElectrodeConfig(1,SignalGen);
SendCommand(DS,5,A)                     ;


%Create Pattern Buffer

display('Load Pattern Buffer')
A_PBuff = Create_PatternBuffer(Config);
assert((numel(A_PBuff) < 1024) , 'Pattern Buffer cannot accomdate(>1024) : Reduce number of patterns')
%dec2hex(uint32(A_PBuff))
SendCommand(DS,10,A_PBuff)          ;

%Create PatternSequence
display('Load Pattern Sequence')
A_PSeq = trCreate_PatternSequence(Config);
assert((numel(A_PSeq) < 256) , 'Pattern Sequence Buffer cannot accomdate(>256): Reduce number of Sequence')
SendCommand(DS,11,A_PSeq);


end

function A = trCreate_PatternSequence(Config)
    %Fill Alternating with dummy pattern which adjusts
    %for interpattern delay
    nElements = 2*numel(Config.PatternSequence);
    A = zeros(nElements,1);
    A(1:2:nElements) = Config.PatternSequence;
end

function A = trCreateElectrodeConfig(ConfigId,SignalGen)   
   
    Config = uint32(zeros(8,1)) ;
    Enable = uint32(zeros(4,1)) ; 
   
    for i=1:numel(SignalGen.SigAssignConfig)
        if SignalGen.SignalToElectrodeConfig(i) > 1
            
             E = SignalGen.SigAssignConfig{i}.ChannelId - 1; %Electrode Number
             
             %Enable
             j = floor(E/30) + 1 ;
             k = rem(E,30)       ;
             Enable(j) = Enable(j) + 2^k;
             
             %Stimulation Source
             l = SignalGen.SignalToElectrodeConfig(i) - 2;%DAC Source [GND 1,2,3](from none,nd,1,2,3 matlab indexed)
             j = floor(E/15) + 1 ;
             k = 2*rem(E,15)     ;
             Config(j)= Config(j)+ l*2^k;
        end
    end
    A = [ConfigId;Enable;Config];
end

