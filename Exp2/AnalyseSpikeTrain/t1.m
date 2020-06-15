
%PatternSpikes{1} = ExtractSpikeTrainData(PatternData);
P = CreateSpikeBin( PatternSpikes{3}.Pattern );

m = 0 ;

switch(m)
    case 0
        P1 = ExtractFirstSpikeVector(P);
        P2 = reshape(P1,[4 120*62]);
    case 1
        P1 = SmoothTrains( P );
        P2 = reshape(P1,[1000 120*62]);
end

K = zeros(62,120);
for k=1:120
K(:,k) = (k:120:7440);
end
K= reshape(K,[numel(K) 1]);
P2=P2(:,K)';

%Pout = CreateDelayCominations( P2 );

% Y = pdist(Pout,@dist_SpikeDelay);
% Y2 = squareform(Y);
% imagesc(Y2)