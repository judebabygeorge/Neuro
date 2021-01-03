
W        = [-0.3 0.5];
D        = [0 0];
Stim     = [1 1];

StimSweep = [-2 -1 -0.5  0 0.5 1 2];

O = zeros(size(StimSweep));

for i=1:numel(StimSweep)
    StimTime = [0 StimSweep(i)];
    O(i) = NeuronOPCalc(W,D,Stim,StimTime);
end

O
