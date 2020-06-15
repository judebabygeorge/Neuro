
function erra=CheckSEQ(path)
%path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z23042015A\DIV21';
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

Q = 1:2:56;

[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;


erra = zeros(numel(Q),1);
st=1;
for i=1:numel(Q)
i
SelectedPatterns = st:2:112;
SelectedPatterns = SelectedPatterns([Q(i) (Q(i)+1)]);
nClasses  = 2;
t = zeros(nClasses,numel(SelectedPatterns),size(PatternData.Pattern,3));
for k=1:nClasses
      t(k,k,:)=1;
end 
t = reshape(t,[size(t,1) size(t,2)*size(t,3)]);
C = ones(121,nClasses);

[emin, W] = CheckClassifiability_2(PatternData,SelectedPatterns,t,C);

SelectedPatterns = st:2:112;
ee=E(:,SelectedPatterns);
pcheck = SelectedPatterns(((ee(1,:)==ee(1,Q(i)))&(ee(2,:)~=ee(2,Q(i))))|((ee(1,:)==ee(2,Q(i)))&(ee(2,:)~=ee(1,Q(i)))));
Y = P(:,pcheck,:) ;
x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
O = W'*x ;
err = zeros(size(O,2),1);

for k=1:size(O,2)
    [~,I]=max(O(:,k));
    err(k)=I;
end
err = reshape(err,[size(Y,2) size(Y,3)]);
err = sum(sum(err(1:6,:)~=1,2))+sum(sum(err(7:end,:)~=2,2));
erra(i)=err;
end

erra=erra/(12*45);
sum(erra<0.2)
end