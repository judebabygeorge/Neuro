function O = binSpikes(T,binsize,maxtime)
% T sample_number (20uS interval between samples
% binsize in min ;
% maxtime in min ;

nBins = maxtime/binsize;
O = zeros(nBins,numel(T));

for i=1:numel(T)
    t = T{i}/(50*1000*60);
    t_start = 0 ; 
    for j=1:nBins
        O(j,i) = sum((t >= t_start) & t < (t_start + binsize));
        t_start = t_start + binsize;
    end
end

end