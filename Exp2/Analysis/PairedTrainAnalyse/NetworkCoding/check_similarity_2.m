function check_similarity_2
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z01062015A\';
DIV  = [16];
% DIV  = [16 17 18];
% DIV  = [27];

%base_file = 'data_PatternCheck_2_250_train_protocol';
base_file = 'data_PatternCheck_2_250_probe_scan';




a = load(sprintf('%s\\DIV%d\\StimConfigProbe.mat',path,DIV(1)));

p = a.StimConfigProbe.PatternDetails.probe_patterns;
patterns=1:1:20;
for i=1:numel(patterns)
    [~,I]=find(p==patterns(i));
    patterns(i)=I;
end

nP = 24;

XX=zeros(120,numel(p),nP*numel(DIV));

for j=1:numel(DIV)
    for i=1:nP
        p = sprintf('%s\\DIV%d\\%s_%d.mat',path,DIV(j),base_file,i);
        Z = GetProbabilityMatrix(p) ;
        XX(:,:,(j-1)*24+i)=Z(:,patterns);
    end
end

if(0)
patterns  = [5 1 9 7 3 11];
XX = XX(:,patterns,:);
Y = zeros(size(XX,3),3);
x = [1 2 3];
%x = [4 5 6];
for i=1:size(XX,3)   
    Y(i,1) = sum(CalculateDistance(XX(:,x(1),i),XX(:,x(2),i)));
    Y(i,2) = sum(CalculateDistance(XX(:,x(1),i),XX(:,x(3),i)));
    Y(i,3) = sum(CalculateDistance(XX(:,x(2),i),XX(:,x(3),i)));
end
%mean(Y)
figure;plot(Y(:,1).*Y(:,2).*Y(:,3));
end


Y = sum(XX(:,:,1),2);
[~,I]=sort(Y,'descend');

Eid = I(6);

figure;
y= XX(Eid,[9 11],:);y=reshape(y,[2 24])';plot(y,'b');hold on;
y= XX(Eid,[10 12],:);y=reshape(y,[2 24])';plot(y,'g');hold on;
%x = 1:1:20;
%x(9:12)=[];
%y= XX(Eid,x,:);y=reshape(y,[16 24])';plot(y,'k');hold on;
hold off;


end

function D=CalculateDistance(P1,P2)
 D = 1 - ((P1.*P2).^0.5 + ((1-P1).*(1-P2)).^0.5);
end
function P=GetProbabilityMatrix(path)
    a = load(path);
    PatternData = a.PatternData;
    [Patterns , ~ ]= EditPatterns(PatternData);
    P = ones(size(Patterns));
    P(isnan(Patterns)) = 0;

    P = mean(P,3);
end