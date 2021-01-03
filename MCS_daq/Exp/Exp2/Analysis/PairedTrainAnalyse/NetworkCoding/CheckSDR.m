
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z01062015A\DIV7';
a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_2.mat',path));
PatternData = a.PatternData;

SelectedPatterns = 1:1:112;
C = ones(121,numel(SelectedPatterns));
[emin, ~] = CheckClassifiability(PatternData,SelectedPatterns,C);

% [~,I] = sort(emin,'ascend');
% SelectedPatterns= I(1:20);
% C = ones(121,numel(SelectedPatterns));
% [emin, ~] = CheckClassifiability(PatternData,SelectedPatterns,C);

if(0)

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

SelectedPatterns = 2:2:112;

nClasses = 8;
t = zeros(nClasses,numel(SelectedPatterns),size(PatternData.Pattern,3));
E = E(:,SelectedPatterns);

for i=1:nClasses
  t(i,E(1,:)==i,:)=1;
end
t = reshape(t,[size(t,1) size(t,2)*size(t,3)]);

C = ones(121,nClasses);
% n=60;
% for i=1:size(C,2)
%   el = randperm(120);
%   C(el(1:n),i)=0; 
% end

[emin, ~] = CheckClassifiability_2(PatternData,SelectedPatterns,t,C);
end

