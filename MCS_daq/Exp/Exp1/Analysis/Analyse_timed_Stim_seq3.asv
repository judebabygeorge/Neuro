
StimConfig = PatternData.StimConfig;

X = PatternData.Pattern;

% for i=1:size(X,2)
%     X(:,i,:) = X(:,i,:) + (StimConfig.PatternDelay(1,i) - 50)*50;
% end
X(X>25*50) = nan;
%X(X<50*50) =nan;
%X(X>100*50) =nan;
E = StimConfig.Electrodes ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
X(E,:,:)=nan;

PFiring = ones(size(X));
PFiring(isnan(X))=0 ;

Pf = mean(PFiring,3);

I = 1:1:size(X,2);

% if(numel(I)>32)
%     I = I(1:48);
% end

%I=I2;
%a(I) 


h = PatternView ;
hO  = guidata(h);  

C = ones(size(X)) ;
C(isnan(X)) = 0 ;
C = sum(C,3);
B = X ;
B(isnan(X)) = 0 ;
B = sum(B,3) ;
B(C~=0) = B(C~=0)./C(C~=0) ;

B = (B - 50*50)/(25*50);

start = 0 ;
for i = 1:8  % Pair
   for j=1:2 % Order 
      for k=1:2 %10. 0.5
        if(1)
            id = start + (i-1)*4 + (j-1)*2 + k;
            Vis  = Pf(:,(id));
            Act  = ones(size(Vis))*0;     
        else        
            Vis  = Pf(:,(i*2 + j));
            Act = B(:,i*2 + j) ;
            Act(Act>1) = 1 ;
            Act(Act<0) = 0 ;
            Act  = 1- Act  ;
        end
        Mark = zeros(size(Act));
        
        id = (k-1)*8 + j + ((rem(i-1,4)+1 )-1)*2 + (ceil(i/4)-1)*16;
        hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);
      end
   end
    
end

% h = PatternView ;
% hO  = guidata(h);
% 
% start = 88 ;
% for i = 1:8  % Pair
%    for j=1:2 % Order 
%       for k=1:2 %10. 0.5
%         if(1)
%             id = start + (i-1)*4 + (j-1)*2 + k;
%             Vis  = Pf(:,(id));
%             Act  = ones(size(Vis))*0;     
%         else        
%             Vis  = Pf(:,(i*2 + j));
%             Act = B(:,i*2 + j) ;
%             Act(Act>1) = 1 ;
%             Act(Act<0) = 0 ;
%             Act  = 1- Act  ;
%         end
%         Mark = zeros(size(Act));
%         
%         id = (k-1)*8 + j + ((rem(i-1,4)+1 )-1)*2 + (ceil(i/4)-1)*16;
%         hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);
%       end
%    end
%     
% end


