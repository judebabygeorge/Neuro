function estM = estimate_model_stdp(D)

    x  = zeros(D.nInputs,2);
    lb = zeros(size(x));
    ub = zeros(size(x));
    
    %Initialize model 
    %x(:,1)=0.5;x(:,2)=2;    
   % x = [1 8; -.95 5];   %14
    x = [0.5 5; 0.5 4.5]; %2
    %x = [0.7768    0.0415 ;   -2.0000    0.4828];
   
    %Initialize Limits
    wmax = 2;
    dmax = 20; 
    lb(:,1) = -wmax;lb(:,2) = 0;
    ub(:,1) = wmax;ub(:,2) = dmax;  
    
       
    x = EstimateModelSTDP(x,D,lb,ub);
    
    estM =x;
end
function M = EstimateModelSTDP(M,D,lb,ub)
    nIter = 500;
    
    Mstart = M
    [P,t] = CalculateModelOutput(M,D.I,D.d);
    Eval   = [P t]
    
    debug = 0;
    for i=1:nIter
        if(debug > 0)
            display('-------')
        end
        [P,t] = CalculateModelOutput(M,D.I,D.d) ;
        
        %Calculate Correction
        dM    = zeros(size(M));
        for j=1:size(P,2)
            d = [0 ; D.d(:,j)];
            for k=1:size(P,1)                        
                dM = dM +  CalculateCorrection(d(D.I(k,:))+M(:,2),P(k,j),t(k,j),D.P(k,j),D.t(k,j));
            end
        end
        
        %Apply Correction
        M = M + dM;
        M(M>ub) = ub(M>ub);
        M(M<lb) = lb(M<lb);
        
        if(debug>0)
        M
        [P,t] = CalculateModelOutput(M,D.I,D.d);
        Eval   = [P t]
        end
    end    
    Mend = M
end
function dM=CalculateCorrection(InputDelay,Po,to,Pe,te)
    %Po-Acutal Output firing probability
    %to-Actual time of max probability
    %Pe-Expected Probability
    %te-Expected time
    %Input delay : Time of firing of each input
    %dM =nInputsx2 (dW ,dt)
    
    debug = 0;
    dM=zeros(numel(InputDelay),2);
    eP=Pe-Po ; %Error in probability
    Aw = 0.1;
    At = 0.1;
    
    if(debug>1)
     eP
     InputDelay
     to
    end
    
    for i=1:size(dM,1)
        dW =0 ;
        dt =0 ;
        
        dd = (to+0.1)-InputDelay(i);
        if(eP>0) %have to increase probability of firing
            if(dd>=0)%Is Causal
                dW= abs(eP)*Aw*exp(-dd/3);
            end
            %Make causal
            dt= abs(eP)*(dd/(abs(dd)+1e-9)).*At.*dexp(dd,0.5,3);
        else %have to reduce probability
            if(dd>=0)%Is Causal
                dW= -abs(eP)*Aw*exp(-dd/3);
            end
            %Make causal
            dt= abs(eP)*(dd/(abs(dd)+1e-9)).*At.*dexp(dd,0.5,3);
        end
        if(debug>1)
            [dW dt]
        end        
        dM(i,:)=[dW dt];
    end
    %Adjust for time of firing of output
    et = te-to;
    %dM(:,2)= dM(:,2) + 0.0*At*(et/(abs(et)+1e-9));
    function y = dexp(t,tau1,tau2)
        t = abs(t);
        y=(1-exp(-t/tau1)).*(exp(-t/tau2));
    end
end
