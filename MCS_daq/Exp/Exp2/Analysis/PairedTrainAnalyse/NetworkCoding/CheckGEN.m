
%Genereralization
function erra = CheckGen(path)
%path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z23042015A\DIV21';
a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_1.mat',path));
PatternData = a.PatternData;

%RandomShuffle;

E = PatternData.StimConfig.Patterns;
Ex= PatternData.StimConfig.Electrodes(1,1:8);
Eid =zeros(120,1);
for i=1:numel(Ex)
    Eid(Ex(i))=i;
end
for i=2:2:112
    p = E(1,i);
    E(1,i)=Eid(PatternData.StimConfig.Electrodes(1,p));
    E(2,i)=Eid(PatternData.StimConfig.Electrodes(2,p));
end


[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;

erra=zeros(8,7)*nan;

for i=1:8

%i = 1;
tg1 = 1:1:8;
tg1(i)=[];




st=1;
for j=1:numel(tg1)
%for j=1:1
    tg = tg1(j);
    nClasses = 8;
    SelectedPatterns = st:2:112;
    E1 = E(:,SelectedPatterns);
     
    pg = zeros(7,1);
    ll =1:8;
    ll(tg)=[];
    for l=1:numel(ll)
    for k=1:numel(SelectedPatterns)
      if ((E1(1,k)==ll(l))&&(E1(2,k)== tg))
          pg(l)=k;
      end
    end
    end
    pg(pg==0)=[];
    pcheck = SelectedPatterns(pg);
    SelectedPatterns(pg)=[];
    E1(:,pg)=[];
    
    t = zeros(nClasses,numel(SelectedPatterns),size(PatternData.Pattern,3));
    
    for k=1:nClasses
      t(k,E1(1,:)==k,:)=1;
    end
    t = reshape(t,[size(t,1) size(t,2)*size(t,3)]);

    C = ones(121,nClasses);
    % n=60;
    % for i=1:size(C,2)
    %   el = randperm(120);
    %   C(el(1:n),i)=0; 
    % end
    [emin, W] = CheckClassifiability_2(PatternData,SelectedPatterns,t,C);
    Y = P(:,pcheck,:) ;
    x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
    x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
    O = W'*x ;
    err = zeros(7,1);
    O = reshape(O,[size(O,1) size(Y,2) size(Y,3)]);
    for l=1:size(O,2)
        for k=1:size(O,3)
            [~,I]=max(O(:,l,k));
            if(I ~= ll(l))
                err(l) = err(l) + 1;
            end
        end
    end
    err
    erra(i,j)=sum((err/45)>0.2)
end
end
end