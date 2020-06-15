
StimConfig = PatternData.StimConfig;

X = PatternData.Pattern;

for i=1:size(X,2)
    X(:,i,:) = X(:,i,:) + (StimConfig.PatternDelay(1,i) - 50)*50;
end
%X(X<50*50) =nan;
%X(X>100*50) =nan;
X(StimConfig.Electrodes,:,:)=nan;

PFiring = ones(size(X));
PFiring(isnan(X))=0 ;

Pf = mean(PFiring,3);

I = 1:1:size(X,2);

if(numel(I)>24)
    I = I(1:24);
end

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

for i = 0:11
    for j = 1:2
        
        if(1)
            Vis  = Pf(:,(i*2 + j));
            Act  = ones(size(Vis));     
        else        
            Vis  = Pf(:,(i*2 + j));
            Act = B(:,i*2 + j) ;
            Act(Act>1) = 1 ;
            Act(Act<0) = 0 ;
            Act  = 1- Act  ;
        end
        Mark = zeros(size(Act));
        id = floor(i/8)*16 + rem(i,8) + (j-1)*8 + 1;
        hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);
    end
end


% x = [1 2 4 8] + 1;
% for i=1:numel(x)
%     %Vis  = F(:,i);
%     Vis  = W(:,x(i));
%     Act  = ones(size(Vis));
%     hO.ShowElectrodeActivity(hO,i+24,[Act Vis], Mark);
% end