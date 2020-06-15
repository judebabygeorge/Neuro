
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z23042015A\DIV21';
a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_1.mat',path));
PatternData = a.PatternData;


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





for j=1:numel(tg1);
    tg = tg1(j);
    nClasses = 8;
    SelectedPatterns = 1:2:112;
    E1 = E(:,SelectedPatterns);
    pg = 0;
    for k=1:numel(SelectedPatterns)
      if ((E1(1,k)==i)&&(E1(2,k)== tg))
          pg=k;
      end
    end
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
    err = 0;
    for k=1:size(O,2)
        [~,I]=max(O(:,k));
        if(I ~= i)
            err = err + 1;
        end
    end
    err
    erra(i,j)=err;
end
end
