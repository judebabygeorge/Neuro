function B = Animation_CreateBackGround(Animation)

%Load original background
B = Animation.BackGround ;

%Add Flowers

fSize = size(Animation.Flowers.States{1}.image);
bSize = size(B);
Mask = Animation.Flowers.Mask ;
for i=1:size(Animation.Flowers.locs,1)    
%for i=1:1  
    if(Animation.Flowers.visited(i)==1)
        im = Animation.Flowers.States{2}.image ; 
    else
        im = Animation.Flowers.States{1}.image ;
    end    
    
    
    loc = Animation.Flowers.locs(i,:);
    %Convert to actual directions of row col
    %Row is y cordinate
    loc = [-loc(2) loc(1)];    
    loc = (loc + 1)/2 ;     
    loc = round(0.8*loc.*bSize(1:2) + 0.1*bSize(1:2) );
    
    start = round(loc - (fSize(1:2)/2)) ;
    start = max(start,[1 1]);
    
    iB   = B(start(1):(start(1) + fSize(1)-1),start(2):(start(2) + fSize(2)-1),:);
    iB   = bsxfun(@times,im,1 - Mask) + bsxfun(@times,iB,Mask);
    B(start(1):(start(1) + fSize(1)-1),start(2):(start(2) + fSize(2)-1),:)=iB;
end

%Add Spiders
fSize = size(Animation.Spiders.States{1}.image);
Mask  = Animation.Spiders.Mask ;
for i=1:size(Animation.Spiders.locs,1)    
%for i=1:1  
  
    im = Animation.Spiders.States{1}.image ;
     
    
    
    loc = Animation.Spiders.locs(i,:);
    %Convert to actual directions of row col
    %Row is y cordinate
    loc = [-loc(2) loc(1)];    
    loc = (loc + 1)/2 ;     
    loc = round(0.8*loc.*bSize(1:2)+ 0.1*bSize(1:2));
    
    start = round(loc - (fSize(1:2)/2)) ;
    start = max(start,[1 1]);
    
    iB   = B(start(1):(start(1) + fSize(1)-1),start(2):(start(2) + fSize(2)-1),:);
    iB   = bsxfun(@times,im,1- Mask) + bsxfun(@times,iB,Mask);
    B(start(1):(start(1) + fSize(1)-1),start(2):(start(2) + fSize(2)-1),:)=iB;
end


end