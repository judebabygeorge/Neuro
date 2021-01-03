
function ShowFrame(fr,Frame,P,Pt,MarkTime)

if(nargin ==2)
    P  = ones(120,1);
    Pt = 120:-1:1 ;
    c = [1 50000];
else
    c = MarkTime + [-100 10000];
end

SpikeTimes = zeros(10000,1) ;
SpikeCounts = zeros(120,1)  ;
if((fr.type ==0)||(fr.type ==3))
     [Data,SpikeEncoded,StimTrigger] = get_stream(fr,Frame);
     [StimConfig StimEvents] = StimDecode(StimTrigger) ;
     SpikeDecode(SpikeTimes,SpikeCounts,SpikeEncoded);     
 else
      [SpikeCounts SpikeTimes StimConfig StimEvents ~] =  get_stream_compressed(fr,Frame);
end
%Data = CubicFitFilter(Data')';

%Sort the relevant ones in increasing order of firing time
I  = find(P==1) ;
ft = Pt(I) ;
[~,I2] = sort(ft);
I = I(I2);




t = 1:1:50000;



t = (t(c(1):c(2))- c(1))*20e-3 ;

offset = cumsum(SpikeCounts) ;
offset = [1 ; (1 + offset(1:end-1))];

hold on ;
for i=1:numel(I)

    if(fr.type == 0)
      D = Data(I(i),c(1):c(2));
      %I(i)    
      D = D + 2*i*75     ;
      plot(t,D);
    end
    
    times = SpikeTimes(offset(I(i)):(offset(I(i))+SpikeCounts(I(i))-1));
    times = (times((times > c(1))&(times < c(2) )) - c(1))*20e-3;
    scatter(times,(ones(size(times))*2*i*75 + 0.5),100,'filled','r');
    
    %waitforbuttonpress ; 
end

xlabel('Time(ms)')
set(gca,'YTick',[])
set(gcf, 'color', [1 1 1])
end

