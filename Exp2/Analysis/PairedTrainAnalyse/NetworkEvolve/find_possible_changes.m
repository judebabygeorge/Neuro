
close all;


path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
Culture = 'G05012015A';
DIV = 'DIV47' ;


X= GetElectrodeEvolve( [path Culture] ,DIV);

path = './temp/';
% a = load([path Culture '_' DIV '.mat']);
% Y = a.Y;

l=2;
h  = (1/(2*l+1))*ones(2*l+1,1);

Z = zeros(120,20,24);

for i=1:120
    i
    for j = 1:20
        y = X(i,j,:);
        y = y(:);
        %if(max(y)>0.4)
            
            
            %o2 = filtfilt(h,1,y);
%% Linear Fit Test

%             [p,idx] = fit_best_piecewise_linear(y,2);
%             N = numel(y);
%             
%             plot(y,'LineWidth',2);
%             hold on;
%             o2 = polyval(p(:,1)',(1:1:N)');
%             plot(o2,'LineWidth',2);            
%             plot((1:idx(2))' ,polyval(p(:,2)',(1:idx(2))'),'k','LineWidth',2);
%             plot((idx(2)+1:N)' ,polyval(p(:,3)',(idx(2)+1:N)'),'k','LineWidth',2);
%             hold off;
 
%% Exponential Fit test

            f = fit_exponential(y,6);
            [m,I] = max(abs(f(:,1)));            
            %if(m>0.06)
             Z(i,j,I) = f(I,1);            
            %end

%             if(m>0.06)
%               plot(y,'b','LineWidth',2);
%             else
%               plot(y,'r','LineWidth',2);  
%             end
%             ylim([-0.1 1.1]);
%             ch = getkey;
            
            
%             hold on ;
%             f = bsxfun(@rdivide,f,max(f));
%             plot(f);
%             hold off;            
%               f = fit_exponential(y,6);
%               Z(i,j) = max(f(:,1));
%             w  = std(y-o2);
% 
%             yy = KalmanEstimateStates(y,w,4);
%             v = yy(:,2);
%             yy = ProjectFromVel(v);
%             v = v./max(abs(v));
%             yy = yy./max(abs(yy));
%             
            

        %end
    end
end
sum(sum(sum(abs(Z)>0.06,3),2))
save([path Culture '_' DIV '_Z.mat'],'Z');