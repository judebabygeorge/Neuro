function P = ExtractFirstSpikeVector( Pin )
%EXTRACTFIRSTSPIKEVECTOR Summary of this function goes here
%   Detailed explanation goes here

a = size(Pin);
P = ones(4,a(2),a(3))*Inf;

for i=1:a(2)
    for j=1:a(3)
        X = Pin(:,i,j);
        for k=1:4
             b = find(X(1+(k-1)*250:k*250)==1);
             if(~isempty(b))
              P(k,i,j)=b(1);
             end
        end
    end
end

end

