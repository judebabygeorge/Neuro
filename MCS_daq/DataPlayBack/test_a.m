
%Data2 = Data';

figure ; hold on ;
t = 1:1:50000;

c = [1 6000];
t = t(c(1):c(2));

offset = cumsum(SpikeCounts) ;
offset = [1 ; (1 + offset(1:end-1))];

I = 1:1:120;
for i=1:numel(I)
    %clf;hold on;
    if(fr.type == 0)
      D = Data2(I(i),c(1):c(2));
      I(i)    
      D = D + 2*i*75     ;
      plot(t,D);
    end
    
    times = SpikeTimes(offset(I(i)):(offset(I(i))+SpikeCounts(I(i))-1));
    times = times((times > c(1))&(times < c(2) ));
    scatter(times,(ones(size(times))*2*i*75 + 0.5),100,'filled','r');
    
    %waitforbuttonpress ; 
end


