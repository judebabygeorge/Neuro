
function O  = TrainTwoInput (InputResponse)

% InputResponse 120x4xnSamples 

% Output = Success for Training for 16 possible output function
% 4 possile inputs => 16 possile outputs


X = ones(size(InputResponse));
X(isnan(InputResponse)) = -1;
Pf = mean(X,3);

F = FindInputWeights(Pf);
O = zeros(4,1);
for i=1:4
    a = sum(bsxfun(@times,X(:,i,:),Pf))    ;
    a = reshape(a,[size(a,2) size(a,3)]);
    [~,I]=max(a);
    O(i) = sum((I ==i))./size(X,3) ;
end

end

function F = FindInputWeights(InputResponse)
 %Input response : 120X4 = probaility of firing of each output
   %Bayes rule for each electrode
   F = bsxfun(@rdivide , InputResponse.*(1/size(InputResponse,2)) , mean(InputResponse,2));
   F(isnan(F))=0;
   F = 1./(1+exp(-30*(F - 0.4))) ;
end

% function F = TrainToInput(InputWeights , DesiredOutput)
% 
% %Find Out from proability of spiking
% %DesiredOutput(DesiredOutput==0) = -1 ;
% F = bsxfun(@times , InputWeights ,DesiredOutput); 
% F = sum(F,2);
% end