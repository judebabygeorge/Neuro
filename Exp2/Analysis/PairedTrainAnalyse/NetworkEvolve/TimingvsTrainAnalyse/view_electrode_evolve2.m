
function view_electrode_evolve2(Q)

close all;
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
%path = 'E:\Data\Data\'

Culture = 'G03022015B';
DIV = 'DIV39' ;
PatternTrain = 1;

[X1,Y] = GetElectrodeEvolve( [path Culture] ,DIV);

% 
% X = zeros(size(X1,1),size(X1,2),24)*nan;
% X(:,:,1:6)   = X1(:,:,1:6);
% X(:,:,19:24) = X1(:,:,7:12);
X=X1;

D = create_evolve_display();
%Normalize to total culture activity
ym = sum(Y,1);
Y = bsxfun(@times,Y,1./ym);
%Normalize for plot
ym = max(Y,[],2);
Y = bsxfun(@times,Y,1./ym);

ElectrodeId = 91;
for ElectrodeId = 1:120
    
     ElectrodeId
     y=X(ElectrodeId,:,:);
     y = reshape(y,[size(y,2) size(y,3)])'; 
     
     %y = [y(1:6,:) ; nan*zeros(12,size(y,2)); y(7:end,:)];
     
     axes(D.ax);
     R = find(Q(ElectrodeId,:)>0);
     
     x = repmat([1:12]',[1 size(y,2)]);
     y1 = y(1:12,:);
     plot(x,y1,'k','LineWidth',2); hold on;
     
     plot(x(:,R),y1(:,R),'g','LineWidth',2); hold on;
     
     plot(x,Y(ElectrodeId,1:12)','b','LineWidth',4);
    
     x = repmat([13:size(y,1)]',[1 size(y,2)]) ;
     y1= y(13:end,:);
     plot(x,y1,'k','LineWidth',2);
     plot(x(:,R),y1(:,R),'g','LineWidth',2); hold on;
     
     plot(x,Y(ElectrodeId,13:end)','b','LineWidth',4);
     
     hold off;
     
     
     set(D.ax,'XTick',1:1:24,'YTick',[],'YLim',[-50 50],'YLim',[-0.1 1.1],'XLim',[0.5 24.5]);
     ch = getkey;
  
    if(ch==49)
        for PatternId=1:20
         y=X(ElectrodeId,PatternId,:);
         y = y(:); 
         axes(D.ax);
         c = 'k';
         if(Q(ElectrodeId,PatternId)>0)
             c='g';
         end
         plot(1:1:12,y(1:12),c,'LineWidth',2); hold on;
         plot(13:size(y,1), y(13:end),c,'LineWidth',2); hold off;
         set(D.ax,'XTick',1:1:24,'YTick',[],'YLim',[-50 50],'YLim',[-0.1 1.1],'XLim',[0.5 24.5]);
         ch = getkey;
         if ch==49
          ShowSpikes(D,[path '\' Culture '\' DIV],PatternId,ElectrodeId);
          ShowSpikeTimes(D,[path '\' Culture '\' DIV],PatternId,ElectrodeId);
          ch = getkey;
         end
         if(ch==(48+9))
           save_path = 'C:\Users\45c\Desktop\Eval\f1\';
           print([save_path   sprintf('elpd_%s_%03d_%02d',Culture,ElectrodeId,PatternId)],'-dpng' )
         end
        end
    end
    if(ch==(48+9))
         save_path = 'C:\Users\45c\Desktop\Eval\f1\';
         print([save_path   sprintf('el_%s_%03d',Culture,ElectrodeId)],'-dpng' )
    end
end

end

function ShowSpikeTimes(D,path,PatternId,ElectrodeId)
    xl = [4 80];
    x = xl(1):round((xl(2)-xl(1))/20):xl(2);

    paired_probes = dir([path '\data_spiketrain_PatternCheck_2_250_paired_train_probe_*.mat']);
    nSamples = numel(paired_probes);
   for i=1:nSamples
       a = load(sprintf('%s/data_spiketrain_PatternCheck_2_250_paired_train_probe_%d.mat',path,i));
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


function ShowSpikes(D,path,PatternId,ElectrodeId)
    paired_probes = dir([path '\data_spiketrain_PatternCheck_2_250_paired_train_probe_*.mat']);
    nSamples = numel(paired_probes);
  for i=1:nSamples
    a = load(sprintf('%s/spiketrain_wf_PatternCheck_2_250_paired_train_probe_%d.mat',path,i));
    SpikeWF = a.SpikeWF ;
    S = SpikeWF.SpikeIndex(ElectrodeId,:,PatternId,:);
    S = reshape(S,[size(S,2) size(S,4)]);
 
    S1 = S(1:end,:);
    S1 = S1(:);
    id = S1(S1>0);
    y = SpikeWF.SpikeData(:,id);
    plot(D.Spikes{i}.ax,y,'k');
    set(D.Spikes{i}.ax,'XTick',[],'YTick',[],'YLim',[-50 50],'XLim',[0 100]);
  end
end