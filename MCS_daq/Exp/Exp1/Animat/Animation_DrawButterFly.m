function B = Animation_DrawButterFly(Animation,loc,angle,state,B)


 im = Animation.ButterFly.States{state}.image ;
 im = imrotate(im,angle);
 fSize = size(im);
 
 bSize = size(B);

 loc = [-loc(2) loc(1)];    
 loc = (loc + 1)/2 ;     
 loc = round(0.8*loc.*bSize(1:2)+ 0.1*bSize(1:2));
 
 start = round(loc - (fSize(1:2)/2)) ;
 start = max(start,[1 1]);
    
 Mask = double(((im(:,:,1)>0.9)&(im(:,:,2)>0.9))|((im(:,:,1)<0.1)&(im(:,:,2)<0.1)&(im(:,:,3)<0.1)));
 Mask = imfilter(Mask,Animation.ButterFly.f,'replicate');
 
 iB   = B(start(1):(start(1) + fSize(1)-1),start(2):(start(2) + fSize(2)-1),:);
 iB   = bsxfun(@times,im,1- Mask) + bsxfun(@times,iB,Mask);
 B(start(1):(start(1) + fSize(1)-1),start(2):(start(2) + fSize(2)-1),:)=iB;
end