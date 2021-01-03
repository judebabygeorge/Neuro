function [y,b,bb,ee] = ExtractBurstInfo(PatternData)
%T1 Summary of this function goes here
%   Detailed explanation goes here

window = 5;
Pattern = PatternData.Pattern;
y  = zeros((numel(Pattern))*1000/window,1);
e  = zeros((numel(Pattern))*1000/window,120);
for i=12:numel(Pattern)
    for j=1:1000/window
        t = [(j-1)*window j*window]*50;
        y((i-1)*(1000/window) + j )=sum(Pattern{i}.SpikeTimes >= t(1) & Pattern{i}.SpikeTimes < t(2));
        
        Offset = [0;cumsum(Pattern{i}.SpikeCounts)];
        for k=1:120
           S = Pattern{i}.SpikeTimes(Offset(k)+1:Offset(k+1));
           e((i-1)*(1000/window) + j,k ) = sum(S >= t(1) & S < t(2));
        end
    end
end

% sigma = 5;
% fsize = 10;
% x = linspace(-fsize / 2, fsize / 2, fsize);
% gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
% gaussFilter = gaussFilter / sum (gaussFilter); % normalize

%y = conv (y, gaussFilter, 'same');

bw = (500*50)/(window*50);
b = detect_bursts(y,20,bw);

bb = zeros(bw,numel(b));
ee = zeros(bw,120,numel(b));
for i=1:numel(b)
    bb(:,i)= y(b(i)-bw/2+1:b(i)+bw/2);
    for j=1:120
        ee(:,j,i) = e(b(i)-bw/2+1:b(i)+bw/2,j);
    end
end
end

function b = detect_bursts(y,count,bw)
  th_lim = [max(y)  min(y)];
  th = round(mean(th_lim));
  lim = [(count-10) (count+10)];
  
  
  done = 0 ; 
  dir  = 0 ;
  
  while(done==0)
      b = find_bursts(y,th,bw,lim);
      nDetected =  numel(b) ;

      if(nDetected < lim(1))
          if(dir==1)
              done = 1;
          else
              th = th - 1;          
              dir = -1;
          end
      else
          if(nDetected > lim(2))
              if (dir == -1)
                  done = 1;
              else
                th = th + 1;
                dir =1;
              end
          else
              done = 1;
          end
      end
      if((th > th_lim(1)) || (th < th_lim(2)))
          done = 1;
      end
  end
  
  for i=1:numel(b)
      [~,ii] = max(y(b(i)-bw/2:b(i)+bw/2));
      b(i)=b(i)-bw/2+ii-1;
  end
end

function b = find_bursts(y,th,bw,lim)
    I = find(y>=th);
    
    nBursts = 0;
    maxBursts = lim(2)+1;
    maxDetects = numel(I);
    b = zeros(maxBursts,1);
    id = 1;
    LastDetect = bw;
    while((nBursts < maxBursts)&&(id < maxDetects))
       id = find(I>LastDetect ,1);
       if ~isempty(id)
          nBursts = nBursts + 1;
          b(nBursts) = I(id);
          LastDetect = b(nBursts) + bw;
       else
           break;
       end
    end
    
    b = b(1:nBursts);
end
