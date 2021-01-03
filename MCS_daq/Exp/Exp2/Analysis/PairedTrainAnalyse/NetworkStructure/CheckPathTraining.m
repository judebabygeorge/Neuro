function CheckPathTraining(path,DIV)
close all
n = 24;

opengl('software');

%patterns = [13 16  1 4 10 7];
patterns = [13 16 25 19 1 4 10 7 22 28];

names = {'A' 'B' '\{A, B, 4\}' '\{A, B, 3\}' '\{A, B, 2\}' '\{A, B, 0.5\}' '\{B, A, 0.5\}' '\{B, A, 2\}' '\{B, A, 3\}' '\{B, A, 4\}'};
%id = [1 2 3 4 5 6];
id = 1:numel(patterns);
I = 1:1:120;
%I = [13 16 31 76 92];


patterns = patterns(id);

X = ones(120,numel(patterns),(n+1)*numel(DIV))*nan;
T = ones(120,numel(patterns),(n+1)*numel(DIV))*nan;
for j=1:numel(DIV)
for i=1:n
    a = load(sprintf('%s\\DIV%d\\data_PatternCheck_2_250_probe_scan_%d.mat',path,DIV(j),i));
    [Patterns,StimConfig] = EditPatterns(a.PatternData);
    P= ones(size(Patterns));
    P(isnan(Patterns))=0;    
    P = mean(P,3);
    X(:,:,(j-1)*(n+1) + i) = P(:,patterns);
    T(:,:,(j-1)*(n+1) + i) = GetMeanFiringTime(Patterns(:,patterns,:));
end
end
T = T/50;

% Y = X(:,1,1:n);
% Y = reshape(Y,[120 n])';
% [~,I]=sort(max(Y),'descend');


s = [800 800];

co1 =        [0    0.4470    0.7410;
    0.8500    0.3250    0.0980;
    0.9290    0.6940    0.1250;
    0.4940    0.1840    0.5560;
    0.4660    0.6740    0.1880;
    0.3010    0.7450    0.9330;
    0.6350    0.0780    0.1840];

co2 = co1([4 3 2 1 5 6 7],:);

f1=figure('Position',[100 100 s],'color','w');f2=figure('Position',[100+s(1)+100 100 s],'color','w');
for i=1:numel(I)
    I(i)
    y = X(I(i),:,:);
    y = reshape(y,[numel(patterns) numel(DIV)*(n+1)])';       
    x = repmat((1:1:(n+1)*numel(DIV))',[1 numel(patterns)]);
    
    figure(f1)
    plot(x(:,1:2),y(:,1:2),'LineWidth',4, 'LineSmoothing','on');hold on;
    %plot(x(:,3),y(:,3),'LineWidth',4,'LineStyle','--');hold on;
    set(gca,'ColorOrder',co1);
    plot(x(:,3:6),y(:,3:6),'LineWidth',2, 'LineSmoothing','on');hold on;
    set(gca,'ColorOrder',co2);
    plot(x(:,7:end),y(:,7:end),'LineWidth',2,'LineStyle','-.', 'LineSmoothing','on');hold off;
    ylim([-0.1 1.1])
    xlim([0 33]);
    legend(names(id));
    
    
    set(gca,'FontName','Calibiri','FontSize',16, 'FontWeight', 'demi');
    
    xt = (1:1:24);
    xt = xt(3:3:end);
    xtl =xt(1:1:8)/3;
    set(gca,'XTick',xt,'XTickLabel',xtl);
         
    xlabel('Time(hr)');ylabel('Probability of Spike');
    
    P = get(gca,'tightinset');
    set(gca,'position',[P(1) P(2) 1-P(1)-P(3) 1-P(2)-P(4)]);
    
    legend('boxoff');
    
    y = T(I(i),:,:);
    y = reshape(y,[numel(patterns) numel(DIV)*(n+1)])'; 
    x = repmat((1:1:(n+1)*numel(DIV))',[1 numel(patterns)]); 
   
    figure(f2)
%     plot(x,y,'LineWidth',2);  
%     ylim([0 40])
%     legend(names(id));
    
    
    plot(x(:,1:2),y(:,1:2),'LineWidth',4, 'LineSmoothing','on');hold on;
    %plot(x(:,3),y(:,3),'LineWidth',4,'LineStyle','--');hold on;
    set(gca,'ColorOrder',co1);
    plot(x(:,3:6),y(:,3:6),'LineWidth',2, 'LineSmoothing','on');hold on;
    set(gca,'ColorOrder',co2);
    plot(x(:,7:end),y(:,7:end),'LineWidth',2,'LineStyle','-.', 'LineSmoothing','on');hold off;   
    ylim([5 15])
    xlim([0 33]);
    legend(names(id));
    
    set(gca,'FontName','Calibiri','FontSize',16, 'FontWeight', 'demi')
    xlabel('Time(hr)');ylabel('Mean time to Spike');
    
    xt = (1:1:24);
    xt = xt(3:3:end);
    xtl =xt(1:1:8)/3;
    set(gca,'XTick',xt,'XTickLabel',xtl);
    
    P = get(gca,'tightinset');
    set(gca,'position',[P(1) P(2) 1-P(1)-P(3) 1-P(2)-P(4)]);
    
    legend('boxoff');
    
    
    
    s=getkey;
    if(s==char('s'))
        A = getframe(f1);
        imwrite(A.cdata,sprintf('elt_%s_DIV%d_E%d.png',path(end-10:end-1),DIV,I(i)));
        A = getframe(f2);
        imwrite(A.cdata,sprintf('eltT_%s_DIV%d_E%d.png',path(end-10:end-1),DIV,I(i)));
    end
end


end


function T = GetMeanFiringTime(Patterns) 
    T = nan*ones(size(Patterns,1),size(Patterns,2));
    for i=1:size(T,1)
        for j=1:size(T,2)
            t = Patterns(i,j,:);
            t = t(:);
            t = mean(t(~isnan(t)));
            T(i,j)=t;
        end
    end
end