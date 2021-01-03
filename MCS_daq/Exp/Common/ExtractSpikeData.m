function [Pattern] = ExtractSpikeData(fr)



% Variables For results



Frame = 1 ;
Frame_stop = fr.Frames ;

display('Extracting Spike Data...');

Pattern{Frame_stop}=[];

SpikeTimes = zeros(10000,1) ;
SpikeCounts = zeros(120,1)  ;

Window  = [-0.5 1.5]*50;
Window  = Window(1):1:Window(2);

while(Frame <= Frame_stop)


    if(rem(Frame,10)==0)
      display(['Frame :' num2str(Frame)]);
    end
    
    if((fr.type ==0)||((fr.type ==3))||(fr.type==4))
     [Data,SpikeEncoded,~,~] = get_stream(fr,Frame);
     %[~ ,~] = StimDecode(StimTrigger) ;
     SpikeDecode(SpikeTimes,SpikeCounts,SpikeEncoded);  
     %DecoderOut = OutputDecode(Output);
    end
    
    Pattern{Frame}.SpikeCounts = SpikeCounts(1:end);
%     if sum(SpikeCounts) > 0
%         [Frame sum(SpikeCounts)]
%     end
    Pattern{Frame}.SpikeTimes = SpikeTimes(1:sum(SpikeCounts));

    Pattern{Frame}.SpikeData  = zeros(numel(Window),numel(Pattern{Frame}.SpikeTimes));  
    
    SIndex = 0;
    for i=1:numel(SpikeCounts)
        for j=1:SpikeCounts(i)
            SIndex = SIndex + 1;
            Pattern{Frame}.SpikeData(:,SIndex) = Data(i,Window + SpikeTimes(SIndex))';
        end
    end
    
    
    Frame = Frame + 1 ;

end

end

