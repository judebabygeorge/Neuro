
StimConfig = PatternData.StimConfig;

pp = unique(StimConfig.Patterns(1,:));
%pp = unique(StimConfig.Patterns(1,13:24));

a = zeros(8,3);
for i=1:8
    a(i,:)  = find(StimConfig.Patterns(2,:) == pp(i));
end

a = a';
I = reshape(a,[1 numel(a)]);

X = PatternData.Pattern;

X(X<50*50) =nan;
X(StimConfig.Electrodes,:,:)=nan;

PFiring = ones(size(X));
PFiring(isnan(X))=0 ;

Pf = mean(PFiring,3);

% a  = sum(Pf) ;
% [~,I] = sort(a,'descend');
% T = mean(PatternData.Pattern,3) ;

if(numel(I)>24)
    I = I(1:24);
end

%I=I2;
%a(I) 


h = PatternView ;

hO  = guidata(h);  
for i=1:numel(I)
    
    Mark = zeros(120,1);
    
    %Vis  = ones(size(Pf,1),1);
    %Act  = ones(size(Vis));
    
%    E = PatternData.Config{1}.Patterns(:,I(i));
    
%     for j=1:numel(E)
%       Eid = find(PatternData.Config{1}.Config.EConfig(:,E(j))==1) ;
%       Mark(Eid) = 1 ;
%     end
    
    if(1)
        Vis  = Pf(:,I(i));
        Act  = ones(size(Vis));
    else
        Act = B(:,i) ;
        Vis(Act>1) = 0 ;
        Act(Act>1) = 0 ;
        Act  = 1- Act  ;
    end
    
    hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
end

X = PatternData.Pattern;
X(X>50*50) =nan;
X(StimConfig.Electrodes,:,:)=nan;
PFiring = ones(size(X));
PFiring(isnan(X))=0 ;

for i = 1:8
    id=find(StimConfig.Patterns(1,:) == pp(i));
    Y = PFiring(:,id,:);
    Y = mean(Y,3);
    Y = mean(Y,2);
    Mark = zeros(120,1);
    Vis  = Y;
    Act  = ones(size(Vis));
    hO.ShowElectrodeActivity(hO,24+i,[Act Vis], Mark);
end
