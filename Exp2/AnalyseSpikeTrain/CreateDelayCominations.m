function Pout = CreateDelayCominations( Pin )
%CREATE Summary of this function goes here
%   Detailed explanation goes here

%Pn = [nxp] p patterns [n=nTrials*nElectrodes] firsr k rows = k trials electrode 1 next k rows = ktrials of electrode 2

a = size(Pin);
nTrials = a(1)/120;
P1 = zeros(nTrials,a(2),120);

for i=1:120
    P1(:,:,i) = Pin(1+(i-1)*nTrials:i*nTrials,:);
end

%P1(isinf(P1)) = 500;

b = combnk(1:1:120,2);
Pout = zeros(nTrials,a(2),size(b,1));

for i=1:size(b,1)
  Pout(:,:,i) = P1(:,:,b(i,1))-P1(:,:,b(i,2));
end

Pout = reshape(Pout, [size(Pout,1)*size(Pout,2) size(Pout,3)]);

end

