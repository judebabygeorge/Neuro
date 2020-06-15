function show_spike_train( P , Eid )
%SHOW_SPIKE_TRAIN Summary of this function goes here
%   Detailed explanation goes here

x = reshape(P(:,Eid,:),[1000 62]);
figure;
for i=1:62
x(:,i) = x(:,i)+i;
end
plot(x)
end

