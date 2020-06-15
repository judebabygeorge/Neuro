
PatternData0 = PatternData;
n = [30 60 90 120];
Cl = zeros(numel(n),3);

if(1)
    for j=1:numel(n)   
        for k=1:3
            [j k]
            C = zeros(121,numel(SelectedPatterns));
            C(121,:)=1;
            for i=1:numel(SelectedPatterns)
              el = randperm(120);
              C(el(1:n(j)),i)=1; 
            end
            [emin, ~] = CheckClassifiability(PatternData0,SelectedPatterns,C);
            Cl(j,k)=sum((emin/size(PatternData.Pattern,3))<0.2);
        end
    end
end

if(0)
C = zeros(121,numel(SelectedPatterns));
t = 0.7;
C(D>t,:) = 1;

nLeft = n - sum(C);
elef = (1:1:120)';
elef(D>t)=[];
for i=1:numel(SelectedPatterns)
  el = randperm(numel(elef));
  C(elef(el(1:nLeft)),i)=1; 
end
C(121,:)=1;
[emin, ~] = CheckClassifiability(PatternData0,SelectedPatterns,C);
end

%save(sprintf('%s/ClassificationResults.mat',path),'Cl');