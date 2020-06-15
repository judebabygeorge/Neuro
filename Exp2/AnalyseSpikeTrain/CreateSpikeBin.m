function P = CreateSpikeBin( PatternSpike )
%CREATESPIKEBIN Summary of this function goes here
%   Detailed explanation goes here
a = size(PatternSpike);
P = zeros(250*a(2),120,a(3));

for i=1:a(3)
    Pi = PatternSpike(:,:,i);    
    for j=1:120
        Pj = Pi(1+(j-1)*20:j*20,:);
        Pj = round(Pj/50);
        Pk = zeros(250,a(2));
        for k=1:a(2)
            b = Pj(:,k);
            Pk(b(~isnan(b)),k) = 1;
        end
        Pk = reshape(Pk, [numel(Pk) 1]);
        P(:,j,i)=Pk;
    end
end

end

