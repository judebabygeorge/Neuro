function [estM,fval,lg] = estimate_model_3(D)

for i=1:10
    x  = zeros(D.nInputs,2);
    lb = zeros(size(x));
    ub = zeros(size(x));
    
    %Initialize model 
    x(:,1)=randn([D.nInputs 1]);%x(:,3)=0;    
    
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
    
    x(x<lb) =lb(x<lb);
    x(x>ub) =ub(x>ub);
    x
    
    %options = optimset('Algorithm','active-set','TolFun',1e-9,'Display','iter-detailed','MaxFunEvals',10000);
    %[x , fval] = fmincon(@model_calc,x,[],[],[],[],lb,ub,[],options);
    
    options.Verbosity = 0;
    options.Generator = @InputGenerator;    
    [x,fval] = anneal(@model_calc, x, options);
    
    xf = x
    estM = reshape(x,[numel(x)/2 2]);    
    [P,t] = CalculateModelOutput(estM,D.I,D.d);
    Eval   = [P t]
end
    function y = model_calc(x)
        %Calculate predicted output
        M = reshape(x,[numel(x)/2 2]);
        
        [P,t] = CalculateModelOutput(M,D.I,D.d) ; 
        lg = [lg;x(:)' P(:)' t(:)'];
        %Calculate Cost function to minimize              
        y = CalculateModelError(D,P,t);
    end
    function x = InputGenerator(x)
       x =  (x + ((randperm(length(x))==length(x))*randn/100)');
       x(x<lb) =lb(x<lb);
       x(x>ub) =ub(x>ub);
    end
end
function y = CalculateModelError(D,P,t)
        
        Pe = abs(P-D.P);    
        
        Pe = Pe + (P>1)*100;        
        te = (abs(t-D.t).^2).*D.P;
        %[sum(Pe(:))  sum(te(te(:)>0))]
        y  = sum(Pe(:)) + 0*sum(te(te(:)>0)) ;
        %y  = 1*y
end