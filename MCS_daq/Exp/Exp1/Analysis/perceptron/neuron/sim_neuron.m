function [O SpikeTimes] = sim_neuron(I , W ,Vth ,t_stop)
%SIM_NEURON Summary of this function goes here
%   Detailed explanation goes here

tau_m   = 30 ;
tau_ex  = 5  ;
tau_inh = 5 ;
t_refrac= 3  ;
Vr      = 0  ;

Vth     = Vth + Vr;

%I = [I ; 500];
I = (I*20e-6)*1e3;

t_step  = 20e-6*1e3 ;

a = zeros(size(W)) ;
a(W>100) = 1;
a(W<-100) = -1;
W = a;
scale =  (1/norm(W(1:numel(I))))*0.6 ;
W(1:numel(I)) = W(1:numel(I))*scale;
Ib = W(end)*scale*0.1;



ex  = W(1:numel(I))>0 ;
inh = W(1:numel(I))<=0;


I_ex  = I(ex);
W_ex =  W(ex);
i = ~isnan(I_ex);
I_ex = I_ex(i);
W_ex = W_ex(i);
[I_ex,id] = sort(I_ex);
W_ex = W_ex(id);

I_inh = I(inh);
W_inh = W(inh);
i = ~isnan(I_inh);
I_inh = I_inh(i);
W_inh = W_inh(i);
[I_inh,id] = sort(I_inh);
W_inh = W_inh(id);

%[sum(W_ex) sum(W_inh)]

I_ex  = [I_ex ; (t_stop + 1)];
I_inh = [I_inh ; (t_stop + 1)];

Id_ex  = 1;
Id_inh = 1;

t_sim = t_step:t_step:t_stop;
V = zeros(size(t_sim))';
I = zeros(size(t_sim))';

I1 = 0;
I2 = 0;

d_ex = exp(-t_step/tau_ex);
d_inh= exp(-t_step/tau_inh);
d_m  = exp(-t_step/tau_m);


spiked = 0 ;
last_spike_time = 0 ;
SpikeTimes = zeros(100,1);
nSpikes    = 0 ;
V(1) = Vr ;

for i = 2:numel(t_sim)
  if(I_ex(Id_ex) < t_sim(i))
      I1 = I1 + W_ex(Id_ex);
      Id_ex = Id_ex +1;
  end
  if(I_inh(Id_inh) < t_sim(i))
      I2 = I2 + W_inh(Id_inh);
      Id_inh = Id_inh + 1;
  end
  
  if((spiked ==1)&&((i-last_spike_time)>t_refrac))
      spiked = 0 ;
  end
  if(spiked ==0)
      %a1 = 1/(1+exp(-(V(i-1)-(-20))*(4/80)));
      %a1 = 1;
      %V(i) = V(i-1) - (V(i-1) - Vr)*0.0005 + 1*(I1*a1+I2);
      V(i) = V(i-1)*d_m + (I1+I2);
  else
      V(i) = Vr ;
  end
  I(i) = I1  + I2  ;
%   if(V(i) > Vth)
%       spiked = 1;
%       last_spike_time = i;
%       nSpikes = nSpikes + 1 ;
%       SpikeTimes(nSpikes) = i;
%   end
  %Decay currents
  I1 = I1*d_ex ;
  I2 = I2*d_inh ;
  %O(i) = I1; 
end

O =V ;
%O = I;
SpikeTimes = SpikeTimes(1:nSpikes);
% K = ones(size(I));
% K(isnan(I)) = 0  ;
% O = sum(K.*W(1:120));
%O = cumsum(O);
end
