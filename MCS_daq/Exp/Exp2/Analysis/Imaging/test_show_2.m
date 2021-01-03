
dt=0.020;
n = 1;
ROI = MIJ.getRoi(0);

z = zeros(size(X,3),n);

for i=1:n
    %Z = Y{i};
    y = X((ROI(2,1):ROI(2,3)),(ROI(1,1):ROI(1,2)),:);
    y = mean(mean(y));
    y = y(:);
%     p = polyfit((0:1:37)',y(1:38),1);
%     p(2)=0;
%     y = y-polyval(p,(1:1:size(y,1))');
    z(:,i)=y;
end

%b = mean(z(1:100,:),1);
%z = bsxfun(@rdivide,bsxfun(@minus,z,b),b);
%z = bsxfun(@minus,z,b);

%plot(mean(z,2));hold on

if(1)
x = (1:1:size(z,1))*dt;
plot(x,z*100);
plot(x,mean(z,2)*100);
end

if(0)
k = mean(z*100,2);

z = mean(z,2);
id = id + 1;
zz(:,id)=z;
ROI_list{id} = ROI;
end

if(0)
x = (1:1:size(zz,1))*dt;
plot(x,zz*100);
end
xlabel('time(s)');
ylabel('\Delta F / F')
