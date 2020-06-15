function O = ConnectionOpCalc(x,Pair)
%[W1 W2 td]

 Wv = x(1:8);
 D = x(9:16);
 
 td = 0.5;
 tau_ex = 3;
 tau_ex = 1/tau_ex;
 
 O = zeros(1,64);
 
 inh=0.5;
 for i=1:56
        tdn = (D(Pair(1,i))) - (D(Pair(2,i))+td);
        if(tdn<0)
             m1 =  Wv(Pair(1,i));             
             m2 =  Wv(Pair(2,i))*inh + Wv(Pair(1,i))*exp(tdn*tau_ex);
        else
             m1 =  Wv(Pair(2,i));
             m2 =  Wv(Pair(1,i))*inh + Wv(Pair(2,i))*exp(-tdn*tau_ex);
        end        
        
        if(m1==0)
            m2=m2*inh;
        end       
        O(i)=max(m1,m2);

end
for i=57:64
    O(i) = Wv(i-56);
end

 %O
 th=0.5;
 %O(O<th)=0;

 O = (tansig(8*(O - th))+1)*0.5;

end


