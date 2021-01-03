function O =  NeuronOPCalc(W,D,Stim,StimTime)

inh = 0.5;
tau_ex = 3;
th=0.5;

tau_ex = 1/tau_ex;

StimTime = StimTime + D;
[~,I]   = sort(StimTime,'ascend');

O = zeros(numel(I),1);

p = 0;
td = StimTime(I(1));
in_0 = 1;
for i=1:numel(I)
   if(Stim(I(i) ~=0))
       tdn  = StimTime(I(i))-td;
       O(i) = p*exp(-tdn*tau_ex) + W(I(i))*in_0;
       p = O(i);
       td = StimTime(I(i));
   end
   in_0 = in_0*inh;
end
O = max(O);


O = (tansig(8*(O - th))+1)*0.5;

end