
%TEST_NEURON Summary of this function goes here
%   Detailed explanation goes here

% I = P(:,SelectedPatterns(1:15),:) ;
% %I(I>1000) = nan;
% W = Wmin(:,1:15);

%W(1:120,:) = normc(W(1:120,:));

X = ones(size(I)) ;
X(isnan(I)) = 0 ;
X = reshape(X,[size(X,1) size(X,2)*size(X,3)]);
X = [X;ones(1,size(X,2))];

h = GraphArray;
hO = guidata(h);

%for k=1:size(I,2)
k = 4;
SelectedNeuron = k;
% a = 1:1:size(I,2) ;
% a(k) = [];
% a    = [a k];


for i=1:size(I,2)     
    %i = k;
    for j= 1:size(I,3)        
        [V SpikeTimes] = sim_neuron(I(:,i,j),W(:,SelectedNeuron),20,100);        
        %Z(:,i,j)=V;
        x = (1:1:numel(V))*20e-3;
        if(i==SelectedNeuron)
           hO.AddPlot(hO,x,V,'r',i,j>1);  
           hO.add_scatter(hO,SpikeTimes,ones(size(SpikeTimes))*j,'r',i+16,j>1);
        else
           hO.AddPlot(hO,x,V,'b',i,j>1);
           hO.add_scatter(hO,SpikeTimes,ones(size(SpikeTimes))*j,'b',i+16,j>1);
        end    
        %j
        %waitforbuttonpress
    end
    hO.AddPlot(hO,[x(1) x(end)],[0 0],'k',i,1);
end
%Calculate the perceptron Classification
O = W(:,SelectedNeuron)'*X ;
O = (O>0);
O = reshape(O,[size(I,2) size(I,3)])';
E = sum(O);
E(SelectedNeuron) = size(O,1) - E(SelectedNeuron);
%E = E/size(O,1) ;
display(['Neuron ' num2str(k)]);
%waitforbuttonpress
%end

%hO.set_ylim(hO,[-1 1]*100000);
% figure;
% X = ones(size(I));
% X(isnan(I)) = 0 ;
% O = bsxfun(@times,X,W(1:120,SelectedNeuron));
% O = sum(O);
% O = mean(O,3);
% bar(O)


%Look at how the inputs occur in different cases
%Sorted according to weight