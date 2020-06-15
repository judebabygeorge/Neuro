function [estM,fval,lg] = estimate_model(D)

    x  = zeros(D.nInputs,2);
    lb = zeros(size(x));
    ub = zeros(size(x));
    
    %Initialize model 
    %x(:,1)=0.5;%x(:,3)=0;    
    %x = [1 8; -.95 5];   %14
    x = [0.5 5; 0.5 4.5]; %2
    %Initialize Limits
    wmax = 2;
    dmax = 20;
%     lb(:,1) = 0;lb(:,2) = 0;lb(:,3) = -wmax;lb(:,4) = 0;
%     ub(:,1) = wmax;ub(:,2) = dmax;ub(:,3) = 0;ub(:,4) = dmax;    
    lb(:,1) = -wmax;lb(:,2) = 0;
    ub(:,1) = wmax;ub(:,2) = dmax;  
    
    lg = [];
    x = x(:);
    lb = lb(:);
    ub = ub(:);
    options = optimset('Algorithm','active-set','TolFun',1e-9,'MaxFunEvals',1000);
    [x , fval] = fmincon(@model_calc,x,[],[],[],[],lb,ub,[],options);
    estM = reshape(x,[numel(x)/2 2]);
    function y = model_calc(x)
        %Calculate predicted output
        M = reshape(x,[numel(x)/2 2]);
        
        [P,t] = CalculateModelOutput(M,D.I,D.d) ; 
        lg = [lg;x(:)' P(:)' t(:)'];
        %Calculate Cost function to minimize              
        y = CalculateModelError(D,P,t);
    end
    
end
function y = CalculateModelError(D,P,t)
        
        Pe = abs(P-D.P).^2;    
        
        Pe = Pe + (P>1)*100;        
        te = (abs(t-D.t).^2).*D.P;
        %[sum(Pe(:))  sum(te(te(:)>0))]
        y  = sum(Pe(:)) + 0*sum(te(te(:)>0)) ;
        %y  = 1*y
end