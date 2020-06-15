
function RunAnimation(Animation,Inputs)

figure(Animation.h);
B = Animation_CreateBackGround(Animation);


%Starting Location
pos   = [0 0] ;
theta = 0 ;

%Move randomly

nFlowers = size(Animation.Flowers.visited,1);

%while(sum(Animation.Flowers.visited)<nFlowers)
i = 0;
df = [0 0] ;
while(i<1000)
    i = i+1;
    Forward  = [1 0] ;
    
    
    
    FlowerSense = CalculateSenorSignal(Animation,pos,theta) ;
%     FlowerSense = [FlowerSense ; FlowerSense];    
%     
%     d = [cos(pi/3) cos(pi) cos(5*pi/3) ; sin(pi/3) sin(pi) sin(5*pi/3)];
%     d = d.*FlowerSense;
%     d = sum(d,2);
%     df(1) = d(2);
    
    df= df.*0.5 ;
    df(1) = df(1) +  FlowerSenseDeocde(FlowerSense);
    
    
    SpiderSense = CalculateSpiderSignal(Animation,pos,theta);
%     SpiderSense = [SpiderSense ; SpiderSense];    
%     
%     d = [cos(pi/3) cos(5*pi/3) ; sin(pi/3) sin(5*pi/3)];
%     d = d.*SpiderSense;
%     d = sum(d,2);
%     
%     df(2) = -100*d(2) + exp(-abs(sum(df)))*50*d(2) ;
   
    
    if(sum(abs(SpiderSense))>0.5)
       x = SpiderSense(1) - SpiderSense(2) ;
       x = x/abs(x) ;
       df(2) = 200*x;
    else
       df(2) = 0;
    end
    df(2)= 0 ;
    
    df
    Wings    = [df(1) -df(1);df(2) -df(2)] ;
    
    Force    = [Forward(1)  sum(Wings*[1 -1]')] ; 
    
    %Force(2)    = Force(2) ;
    
    Force = Force.*[0.01 0.0005];
    

       
    %Rotate the butterfly
%    if(sum(pos.^2)^0.5>0.2)    
       %Translate the butterfly 
       
      
       pos = pos + [cos(theta) sin(theta)]*Force(1) ; 
      
       
       pos = min(pos,[1 1]*0.9);
       pos = max(pos,[-1 -1]*0.9);
       theta = theta + Force(2);    
%     else
%        Force(1)  
%        pos = pos + [1 0].*Force(1)         
%     end
    
    %Calculate new orientation
    I = Animation_DrawButterFly(Animation,pos,theta*180/pi,1,B);
    
    fid = CheckFlowers(Animation,pos);
    Animation.Flowers.visited(fid) = 1 ;
    if(numel(fid>0))
       B = Animation_CreateBackGround(Animation); 
    end
    
    imshow(I)
    pause(0.03);
    %waitforbuttonpress()
end

    
    
end

function o = FlowerSenseDeocde(FlowerSense)

  Map = [1 2 ; 2 3 ; 3 1; 1 3 ; 3 2 ; 2 1] ;
  
  
  [~,I] = sort(FlowerSense) ;
  o = sum(bsxfun(@eq,Map,I(1:2)),2)==2;
  
  wing_map = [1 1 1 -1 -1 -1];
  
  o = 40*wing_map(o);
end
function SpiderSense = CalculateSpiderSignal(Animation,pos,theta)

  l = Animation.Spiders.locs;
  t1 = theta + pi*(1/3) ;
  
  s = [0 0] ;
  d = sum((bsxfun(@minus,l,pos)).^2,2) ;
  l =  bsxfun(@minus,l,pos);
  ta = atan2(l(:,2),(l(:,1) + 1e-9));
  for i = 1:2      
    t =  cos((t1 - ta))      ;
    s(i) = sum(exp(-d*4).*t) ;
    t1 = t1 + pi*2/3;    
  end
  SpiderSense=s;
  
end
function FlowerSense = CalculateSenorSignal(Animation,pos,theta)

  id = Animation.Flowers.visited==0;
  l = Animation.Flowers.locs(id,:);
  
 
  t1 = theta + pi*(1/3) ;
  
  s = [0 0 0] ;
  d = sum((bsxfun(@minus,l,pos)).^2,2).^0.5 ;
  l =  bsxfun(@minus,l,pos);
  ta = atan2(l(:,2),(l(:,1) + 1e-9));
  for i = 1:3       
    t =  cos((t1 - ta))      ;
    s(i) = sum(exp(-d*0.2).*t) ;
    t1 = t1 + pi*2/3;    
  end
  FlowerSense=s;
end

function fid = CheckFlowers(Animation,loc)
  
  id = find(Animation.Flowers.visited==0);
  l = Animation.Flowers.locs(id,:);
  
  l = bsxfun(@minus,l,loc);
  l = l.^2 ;
  l = sum(l,2);
  
  fid = id(l<0.04);
  
end