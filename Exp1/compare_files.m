

f1 = create_datastream('C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\data_2.dat');
f2 = create_datastream('C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\data0_1.dat');
%f2 = create_datastream('C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\C1\data_2.dat');


SpikeTimes1 = zeros(120,1);
SpikeCounts1=zeros(10000,1);
SpikeTimes2 = zeros(120,1);
SpikeCounts2=zeros(10000,1);

% for i=1:1:120
    i = 17 ;
    
    if(rem(i,10)==0)
        display(['Frame ' num2str(i)]);
    end
    
    [Data1 SpikeEncoded1 StimTrigger1] = get_stream(f1,i); 
    [Data2 SpikeEncoded2 StimTrigger2] = get_stream(f2,i); 
   
     
    j = sum(sum(Data1~=Data2));
    if(j~=0)
        display(['Data mismatch in Frame ' num2str(i)])
        break;
    end
         
    j = sum(sum(SpikeEncoded1~=SpikeEncoded2));
    if(j~=0)
        display(['Spike mismatch in Frame ' num2str(i)])
        SpikeDecode(SpikeTimes1,SpikeCounts1,SpikeEncoded1);  
        SpikeDecode(SpikeTimes2,SpikeCounts2,SpikeEncoded2);   
        
        find(SpikeCounts1 ~= SpikeCounts2)
        find(SpikeTimes1 ~= SpikeTimes2)
        break;
    end
         
    j = sum(sum(StimTrigger1~=StimTrigger2));
    if(j~=0)
        display(['Stim mismatch in Frame ' num2str(i)])
        break;
    end
%end