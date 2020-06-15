
function [K1 K2] = DelayModelTest(p) % [W td tau_ex]

% 0.3392    1.3163    0.3597

global N W1 W2 Winh WW D


W  = (W1 + p(1))+WW.*(W2 + 0.5) + Winh;
td = 0.5;
tau_ex = p(3);

D0 = D*p(2);
D1  = D0(:,1)-(D0(:,2)+td) ;
D2  = (D0(:,1)+td)-D0(:,2) ;



DD = zeros(N,4);
DD(D1<0,1) = abs(D1(D1<0));
DD(D1>0,2) = abs(D1(D1>0));

DD(D2<0,3) = abs(D2(D2<0));
DD(D2>0,4) = abs(D2(D2>0));


tau_ex = 1/tau_ex;
DD = -tau_ex*DD;

O = zeros(N,2);

for i=1:N
    
  if(D1(i)<0)
      m1 = W(i,1);
      m2 = W(i,2) + W(i,1)*exp(tau_ex*D1(i));      
  else
      m1 = W(i,2);
      m2 = W(i,1) + W(i,2)*exp(-tau_ex*D1(i));        
  end
  O(i,1)=max(m1,m2);
  
  if(D2(i)<0)
      m1 = W(i,1);
      m2 = W(i,2) + W(i,1)*exp(tau_ex*D2(i));      
  else
      m1 = W(i,2);
      m2 = W(i,1) + W(i,2)*exp(-tau_ex*D2(i));        
  end
  O(i,2)=max(m1,m2);
    
end




%O(:,1) = W(:,1).*exp(DD(:,1)) + W(:,2).*exp(DD(:,2)) ; 
%O(:,2) = W(:,1).*exp(DD(:,3)) + W(:,2).*exp(DD(:,4)) ; 


th = 0.4;
O(O<th)=0;
O = O + randn(size(O))*0.0 ;
O(O<0.02)=0;
O(O>1)=1;

%Without Pairing
OO =W;
OO(OO<th)=0;
OO = OO + randn(size(OO))*0.0 ;
OO(OO<0.02)=0;
OO(OO>1)=1;

a = 1 - (1- OO(:,1)).*(1-OO(:,2)) ;
Ch = [O(:,1) - a O(:,2) - a ] ;
%Ch = [O(:,1) -  max(OO,[],2) O(:,2) - max(OO,[],2)] ;
K1 = Ch(:);

Ch = [O(:,1) - O(:,2)] ;
K2 = Ch(:);

K1(abs(K1)<0.1)=[];
K2(abs(K2)<0.1)=[];


end
