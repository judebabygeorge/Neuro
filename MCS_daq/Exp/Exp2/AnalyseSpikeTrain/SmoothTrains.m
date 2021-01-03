function SpikeOut = SmoothTrains( SpikeIn )
%SMOOTHTRAINS Summary of this function goes here
%   Detailed explanation goes here


s = 20 ;
x = 1:1:50;
g = exp(-((x-mean(x)).^2)/(2*s^2));
g = g./sum(g);

SpikeOut = zeros(size(SpikeIn));
a = size(SpikeIn);

for i = 1:a(2)
    for j=1:a(3)
        SpikeOut(:,i,j) = conv(SpikeIn(:,i,j),g,'same');
    end
end

end

