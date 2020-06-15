

figure;
hold on;
c = ['bgrcymk'];
Q = Q2';
SCORE = SCORE1;
R = zeros(size(Q,1),1);

for id=2:3
%id = 3;
PL = SCORE(:,id)*SCORE(:,id)';
for t=1:size(Q,1)
    Qt    = Q(t,:);
    R(t)  = Qt*PL*Qt';
end
plot(R,c(id))
end
