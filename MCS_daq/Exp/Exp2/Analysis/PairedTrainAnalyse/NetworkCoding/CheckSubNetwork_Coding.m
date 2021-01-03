
function emin = CheckSubNetwork_Coding(Culture,DIV,n)

path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
a = load(sprintf('%s/%s/DIV%d/data_PatternCheck_2_250_two_time_seq4_1.mat',path,Culture,DIV));
PatternData = a.PatternData;
[Patterns , PatternConfig ]= EditPatterns(PatternData);

P = ones(size(Patterns));
P(isnan(Patterns)) = 0;

%P=P(:,1:2:112,:);
s = size(P);
Q = reshape(P,[s(1) s(2)*s(3)]);

Z = zeros(120,112);
z = zeros(112,1);
sh=0;
th=0.01;
for i=1:112
    %I = find(Q(i,:)==1);
    Z(:,i) = mean(Q(:,Q(i+sh,:)==1),2);
    z(i)= mean(Q(i+sh,:),2)>th;
end

Z(isnan(Z))=0;
Y = sum(Z,2);
Y = Y./max(Y);

th=0.5;
Z(Z>=th)=1;
Z(Z<th)=0;    

SelectedPatterns = 1:1:112;
C = zeros(121,numel(SelectedPatterns));
C(121,:)=1;

[~,I]=sort(Y,'descend');
%n=15;
C(I(1:n),:)=1;
[emin, ~] = CheckClassifiability(PatternData,SelectedPatterns,C);

end

