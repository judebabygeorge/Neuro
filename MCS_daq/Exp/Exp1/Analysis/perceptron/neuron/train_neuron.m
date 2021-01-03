function [Vth E] = train_neuron(V, target)

V = reshape(V,[size(V,1) size(V,2)*size(V,3)]);
V = max(V);
V = reshape(V,[numel(V) 1]);
target = reshape(target,size(V));

Th = 0 ;

Vmax    = max(abs(V));
dVthmin = 0.01*Vmax ;
dVth    = 0.10*Vmax  ;  

Vth = 0 ;

s = sum(target==1)/sum(target==0) ;

count = 100 ;
lE = 0 ;
El = zeros(count,1);
while(count > 0)
    
   %Find Error
   O  = (V>(Vth + dVth)) ;
   
   E1 = sum((O==0)&(target==1));
   E2 = s*sum((O==1)&(target==0));
   
   E = E1 + E2 ; 
   
   if(E>lE)
       dVth = -dVth*0.9 ;
   else
       Vth  = Vth + dVth;
       dVth = dVth*1.02;
   end
   El(count)  = E ; 
   lE = E ;    
   count = count - 1 ;
end
E = min(El);
%figure;plot(El(end:-1:1))
end


