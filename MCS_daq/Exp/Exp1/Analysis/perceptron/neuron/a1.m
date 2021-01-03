
E =zeros(15,1);
%for k=1:15
%k = 4;
test_neuron
% z = Z(k,:,:);
% z = reshape(z,[size(z,2) size(z,3)])';
t = zeros(size(Z,2),size(Z,3));
t(k,:) = 1 ;
[Vth Ei]=train_neuron(Z,t);
Ei
% E(k) = Ei;
% end