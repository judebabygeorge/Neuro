P = ones(size(PatternData.Pattern));
P(isnan(PatternData.Pattern))=0;
P = mean(P,3);
P=P(:,1:112,:);
Q = reshape(P,[120 4 28]);

Q(Q>=0.5) = 1;
Q(Q<0.5) = 0;
% Translate >0.8 to 1, <0.8 to zero inbetween to nan
% Q(Q>0.8) = 3;
% Q(Q<0.2) = 2;
% Q(Q<1)   = nan;
% Q = Q - 2;

Q = Q(:,1,:) + 2*(Q(:,2,:)) + 4*(Q(:,3,:)) + 8*(Q(:,4,:));
Q= reshape(Q,[120,28]);
QQ = Q;
Q=Q(Q>0);
x=0:1:16;
y = hist(Q,x); [~,i] = sort(y,'descend');i(1:8)-1;
figure;bar(x,y)

RR = zeros(size(QQ));
%merit = [0 1 1 0 1 0 1 0 1 0 1 0 0 0 1 0];
merit = [0 2 2 0 1 0 1 0 2 0 1 0 0 0 2 0];
for i=1:16
    RR(QQ==i-1)=merit(i);
end