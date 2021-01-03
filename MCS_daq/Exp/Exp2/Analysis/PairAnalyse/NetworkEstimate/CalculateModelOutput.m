function [P,t] = CalculateModelOutput(M,I,d)
%function [P,t,fO] = CalculateModelOutput(M,I,d)
% M = Model  : nInputLinesx4 (wex,dex,winh,dinh)

% I = Inputs : nxInputsInOrder
% d = DelaysOnInputs : (InputsInOrder-1)XnDiffDelays

% P = probability of Output nInputsxnDelays
% t = time of Output        nInputsxnDelays

nInputs = size(I,1);
nDelays = size(d,2);
P  = zeros(nInputs,nDelays);
t  = zeros(size(P));

d  = [zeros(1,size(d,2));d];
tauSyn = 0.5;
to = (0:0.1:20);

%fO  = zeros(nInputs*nDelays,numel(to));

nConn = size(M,2)/2;

for i=1:nInputs
    for j=1:nDelays
        O = zeros(size(to));
        for k=1:size(I,2) %All Input Lines
            A = zeros(size(to));
            for l=1:nConn     %All Connections 
               %% Fun1
               f = exp(-(to-(M(I(i,k),2*l)+d(k,j)))/tauSyn);  
               f(to<(M(I(i,k),2*l)+d(k,j))) = 0;   
               %% Fun2
               %f = exp(-abs(to-(M(I(i,k),2*l)+d(k,j)))/tauSyn);  
               
               %% Fun3
               %f = exp(-(to-(M(I(i,k),2*l)+d(k,j))).^2/tauSyn^2);
               %%
               A = A + M(I(i,k),2*l-1)*f;                              
            end     
            O = O+A;
        end
        
        %fO((i-1)*nDelays+j,:) = O;
        
        [p,ip] = max(O);
        if(p>0)
            P(i,j) = p.^3;
            t(i,j) = to(ip);
        end
    end
end

end
