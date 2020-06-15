
path = 'E:\Data\Data\';
Culture = 'G09102014A';
DIV = 'DIV29' ;
X= GetElectrodeEvolve( [path Culture] ,DIV);
Y=zeros(size(X,1),size(X,2));
Z=zeros(size(X,1),size(X,2));

close all;
h=figure;

l=2;
h  = (1/(2*l+1))*ones(2*l+1,1);

for i=1:120
    for j=1:20
        Z(i,j) = max(X(i,j,:));
%         if(Z(i,j)>0.4)
%             y = X(i,j,:);
%             y = y(:);
%             
%             o2 = filtfilt(h,1,y);
%             w  = std(y-o2);
% 
%             yy = KalmanEstimateStates(y,w,4);
%             v = yy(:,2);
%             yy = ProjectFromVel(v);
%             v = v./max(abs(v));
%             yy = yy./max(abs(yy));
%             plot([y v yy],'LineWidth',2);
%             
%             ylim([-1.1 1.1]);
%             %hold on;
%             ch = getkey;
%             Y(i,j)=ch;
%         end
    end
    i
end

Y(Y==115)= 1;
Y(Y==97)=2;

save(['./temp/' Culture '_' DIV '.mat'],'Y')