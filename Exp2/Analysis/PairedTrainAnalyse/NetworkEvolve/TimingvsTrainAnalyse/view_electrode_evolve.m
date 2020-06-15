
function view_electrode_evolve
opengl('software');
close all;
%path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
path = 'E:\Data\Data\'

Culture = 'G05012015A';
DIV = 'DIV37' ;
PatternTrain = 4;

tag  = 'paired_train_probe';
[X1,Y] = GetElectrodeEvolve( [path Culture] ,DIV,sprintf('data_PatternCheck_2_250_%s',tag));

a = load(sprintf('%s\\%s\\%s\\%s',path,Culture,DIV,'data_PatternCheck_2_250_PairedTrain_Theta_1'));

 [Patterns , ~ ]= EditPatterns(a.PatternData);
 P = ones(size(Patterns));
 P(isnan(Patterns)) = 0;
 
 TrainData = mean(P,3);
 TrainData = TrainData(:,1);
 
 %TrainData = mean(mean(P,3),2);
 
% 
% X = zeros(size(X1,1),size(X1,2),24)*nan;
% X(:,:,1:6)   = X1(:,:,1:6);
% X(:,:,19:24) = X1(:,:,7:12);
X=X1;

D = create_evolve_display();
ym = max(Y,[],2);
Y = bsxfun(@times,Y,1./ym);

%ElId = [25 82 91 110];
ElId = 1:120;
for ElectrodeId = ElId
    
     ElectrodeId
     y=X(ElectrodeId,:,:);
     y = reshape(y,[size(y,2) size(y,3)])'; 
     
     %y = [y(1:6,:) ; nan*zeros(12,size(y,2)); y(7:end,:)];
     
     axes(D.ax);
     
     x = repmat([1:12]',[1 size(y,2)]);
     y1 = y(1:12,:);
     plot(x(:,1:2:end),y1(:,1:2:end),'k','LineWidth',2, 'LineSmoothing','on'); hold on;
     plot(x(:,2:2:end),y1(:,2:2:end),'k','LineWidth',2, 'LineSmoothing','on'); 
     
     plot(x(:,PatternTrain),y1(:,PatternTrain),'g','LineWidth',2, 'LineSmoothing','on'); 
     plot(x(:,PatternTrain),TrainData(ElectrodeId)*ones(size(x(:,PatternTrain))),'y','LineWidth',4,'LineSmoothing','on');
     
     plot(x,Y(ElectrodeId,1:12)','b','LineWidth',4,'LineSmoothing','on');
     
     
     
     x = repmat([13:size(y,1)]',[1 size(y,2)]) ;
     y1= y(13:end,:);
     plot(x(:,1:2:end),y1(:,1:2:end),'k','LineWidth',2, 'LineSmoothing','on'); hold on;
     plot(x(:,2:2:end),y1(:,2:2:end),'k','LineWidth',2, 'LineSmoothing','on');
    
     plot(x(:,PatternTrain),y1(:,PatternTrain),'g','LineWidth',2, 'LineSmoothing','on'); 
     plot(x(:,PatternTrain),TrainData(ElectrodeId)*ones(size(x(:,PatternTrain))),'y','LineWidth',4,'LineSmoothing','on');
     
     plot(x,Y(ElectrodeId,13:end)','b','LineWidth',4,'LineSmoothing','on');
     
     hold off;
     
     
     set(D.ax,'XTick',1:1:24,'YTick',[],'YLim',[-50 50],'YLim',[-0.1 1.1],'XLim',[0.5 24.5]);
     title(sprintf('Electrode %d',ElectrodeId));
     
     ch = getkey;
  
    if(ch==49)
        for PatternId=1:20
         y=X(ElectrodeId,PatternId,:);
         y = y(:); 
         axes(D.ax);
         x = ((1:1:size(y,1)));
         plot(x(1:1:12),y(1:12),'k','LineWidth',2, 'LineSmoothing','on'); hold on;
         plot(x(13:size(y,1)), y(13:end),'k','LineWidth',2, 'LineSmoothing','on'); hold off;
         set(D.ax,'XTick',x,'YTick',0:0.1:1,'YLim',[-0.1 1.1],'XLim',[0 25]);
         
         xt = (1:1:24);
         xt = xt(3:3:end);
         xtl =xt(1:1:8)/3;
         set(D.ax,'XTick',xt,'XTickLabel',xtl);
         set(D.ax,'FontName','Calibiri','FontSize',16, 'FontWeight', 'demi');
         xlabel('Time(hr)');ylabel('Probability of Spike');
         
         ch = getkey;
         if ch==49
          ShowSpikes(D,[path '\' Culture '\' DIV],PatternId,ElectrodeId,tag);
          ShowSpikeTimes(D,[path '\' Culture '\' DIV],PatternId,ElectrodeId,tag);
          ch = getkey;
         end
         if(ch==(48+9))
           %save_path = 'C:\Users\45c\Desktop\Eval\f1\';
           %print([save_path   sprintf('elpd_%s_%s_%03d_%02d',Culture,DIV,ElectrodeId,PatternId)],'-dpng' )
           
           A = getframe(D.h);
           imwrite(A.cdata,sprintf('elpd_%s_%s_%03d_%02d.png',Culture,DIV,ElectrodeId,PatternId));
                
         end
        end
    end
    if(ch==(48+9))
         save_path = 'C:\Users\45c\Desktop\Eval\f1\';
         print([save_path   sprintf('el_%s_%s_%03d',Culture,DIV,ElectrodeId)],'-dpng' )
         
         
    end
end

end

function ShowSpikeTimes(D,path,PatternId,ElectrodeId,tag)
    xl = [4 80];
    x = xl(1):round((xl(2)-xl(1))/20):xl(2);

    paired_probes = dir([path sprintf('\\data_spiketrain_PatternCheck_2_250_%s_*.mat',tag)]);
    nSamples = numel(paired_probes);
   for i=1:nSamples
       a = load(sprintf('%s\\data_spiketrain_PatternCheck_2_250_%s_%d.mat',path,tag,i));
       PatternData = a.PatternData;
       S = PatternData.Pattern(ElectrodeId,:,PatternId,:);
       S = reshape(S,[size(S,2) size(S,4)]);
      
       t = reshape(S,[numel(S) 1])/50;
       t = t(~isnan(t));
       hist(D.Hist{i}.ax,t,x, 'LineSmoothing','on');
       set(D.Hist{i}.ax,'XLim',[0 xl(end)+1],'YLim',[0 50],'YLimMode','manual','XLimMode','manual','XTick',[],'YTick',[]); 
       set(D.Hist{i}.ax,'XTick',[],'YTick',[]);
   end
end


function ShowSpikes(D,path,PatternId,ElectrodeId,tag)
    paired_probes = dir([path sprintf('\\data_spiketrain_PatternCheck_2_250_%s_*.mat',tag)]);
    nSamples = numel(paired_probes);
  for i=1:nSamples
    a = load(sprintf('%s\\spiketrain_wf_PatternCheck_2_250_%s_%d.mat',path,tag,i));
    SpikeWF = a.SpikeWF ;
    S = SpikeWF.SpikeIndex(ElectrodeId,:,PatternId,:);
    S = reshape(S,[size(S,2) size(S,4)]);
 
    S1 = S(1:end,:);
    S1 = S1(:);
    id = S1(S1>0);
    y = SpikeWF.SpikeData(:,id);
    plot(D.Spikes{i}.ax,y,'k', 'LineSmoothing','on');
    set(D.Spikes{i}.ax,'XTick',[],'YTick',[],'YLim',[-50 50],'XLim',[0 100]);
  end
end