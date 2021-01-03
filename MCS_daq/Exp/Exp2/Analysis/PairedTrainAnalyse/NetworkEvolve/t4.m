
close all;
path = 'E:\Data\Data\';
Culture = 'G09102014A';
DIV = 'DIV29' ;
PatternTrain = 2;
X = GetElectrodeEvolve( [path Culture] ,DIV);
Y = GetElectrodeTimeEvolve( [path Culture] ,DIV );

path = './temp/';
a = load([path Culture '_' DIV '_Z.mat']);
Z = a.Z;

e = zeros(120,20);
for i=1:24
  e(:,i)=sum(BurstData{i}.e,1)';
end

Z = sum(Z,3);

h1 =  figure('Position',[100 100 600 600]);
%h2 =  figure('Position',[800 100 600 600]);
p  = [];
for i=1:120
    if((tr(i)==1)&&(sum(Z(i,:))>0))
        e1 = e(i,:);
        mean(e1(1:12))
        e1 = e1(:)./max(e1);
        
        figure(h1)
        plot(e1,'b','LineWidth',2);
        hold on;
        for j=1:20
            y=X(i,j,:);
            y = y(:);
            if(Z(i,j) > 0)                
              plot(y,'g','LineWidth',2);
            else
              plot(y,'m','LineWidth',2);
            end            
        end
        y=X(i,2*PatternTrain,:);
        y = y(:);
        plot(y,'r','LineWidth',4);
        hold off;
        
%         figure(h2);
%         z= [];
%         for j=1:20
%             y = Y(i,j,1:12);
%             y = y(~isnan(y));
%             if(j ~= 2*PatternTrain)    
%                 y = Y(i,j,1:12)-Y(i,2*PatternTrain,1:12);
%                 y = y(~isnan(y));y=y(:);
%                 z = [z ; y];
% %                scatter(ones(size(y)),y,5,'r','fill','r');hold on;
% %             else
% %                 scatter(2*ones(size(y)),y,5,'b','fill','b');
%             end
%         end
%         hist(z);
%         p = [p ; mean(z)];
%         %hold off;
        %getkey;
    end    
end