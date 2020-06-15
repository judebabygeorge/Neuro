function plist = test2
%TEST2 Summary of this function goes here
%   Detailed explanation goes here

close all
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
Culture = 'G05012015A';
DIV = 'DIV38' ;
X = GetElectrodeEvolve( [path Culture] ,DIV);

for ElectrodeId=1:120
    ElectrodeId
%ElectrodeId =12;
y=X(ElectrodeId,:,:);
o = reshape(y,[size(y,2) size(y,3)]);
o1 = find_intersting_traces(o) ;
z = mean(o,2);
z(o1==0)
 %sum(o1)
 plist = zeros(20,2);
 for i=1:20
    if(o1(i)==1)
        plot(o(i,:)','g','LineWidth',2);hold on;
    else
        plot(o(i,:)','k','LineWidth',2);hold on;
    end
 end
 hold off;
 set(gca,'YLim',[-0.1 1.1]);
 getkey;
end
end

function o = find_intersting_traces(y)
    o = zeros(size(y,1),1);
 for i=1:size(y,1)
    o(i) = isaninterestingline(y(i,:)') ;
 end
 
end
function o = isaninterestingline(y)
  p = get_line_params(y);
  if(p(1)>0.1 || abs(p(2))>0.005)
      o=1;
  else
      o=0;
  end
end

function p = get_line_params(y)
  p = zeros(2,1);
  p(1) = mean(y);
  p1=cooks_d(y);
  p(2) = p1(1);
end
function p=line_fit(y)
  y = reshape(y,[numel(y) 1]);
  x = (1:1:numel(y))';
  p = polyfit(x,y,1);
end

function p = cooks_d(y)

  y = reshape(y,[numel(y) 1]);
  x = (1:1:numel(y))';
  d  = zeros(numel(y),1);
  
  p = polyfit(x,y,1);
  y1 = polyval(p,x);
  
  for i=1:20
      xx = x;yy=y;
      xx(i) = [];yy(i)=[];
      p = polyfit(xx,yy,1);
      yy = polyval(p,x);
      d(i) = sum((y1-yy).^2)/sum((y-yy).^2);
  end
  [d,I] = max(d);
  if(d>0.05)
      xx = x;yy=y;
      xx(I) = [];yy(I)=[];
      p = polyfit(xx,yy,1);
  else
      p = polyfit(x,y,1);
  end
end