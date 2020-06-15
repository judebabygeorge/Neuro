
%function P = PredictProbability(X,Y)

y = zeros(24,120);
for i=1:24
    for j=1:120
        y(i,j) = numel(Y{i}.T{j});
    end
end
s = 1./max(y);
y = bsxfun(@times,y,s);

P      = zeros(size(X));
for el = 3
    xx = reshape(X(el,:,:),[20 24])';
    yy = y(:,el);

    plot(xx,'b');hold on;plot(yy,'k','LineWidth',2);

    pp = zeros(size(xx));

    s_p = yy(1);
    a   = ones(1,20);
    %a   = 1;
    idx = 3:24;

    for i=idx
          %pp(i,:) = xx(i-1,:) + mean([(yy(i-2) - s_p) ; (yy(i-1) - yy(i-2))])*a;               
          pp(i,:) = xx(i-1,:) + (yy(i-1) - s_p)*a; 
          e  = ((pp(i,:) - xx(i,:)).^2);
          %e  = mean(e);
          a  = a.*(1-e*0.7);
          %s_p = yy(i-2);
          s_p = yy(i-1);
          
    end
    P(el,:,:) = reshape(pp',[1 20 24]);
end
P(P<0) = 0;
P(P>1)=1;
plot(idx,pp(idx,:),'g');
%end

if(1)
    figure;hold on;
    id = 1; plot([xx(:,id) yy(:,id) pp(:,id)])
end