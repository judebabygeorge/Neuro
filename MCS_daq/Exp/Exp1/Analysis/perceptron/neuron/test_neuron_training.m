

I = P(:,SelectedPatterns,:) ;
W = Wmin;

SelectedNeuron = 2 ;
target = zeros([1 size(I,2) size(I,3)]);
target(1,SelectedNeuron,:) = 1;

W2 = train_neuron(I, target , W(:,SelectedNeuron));