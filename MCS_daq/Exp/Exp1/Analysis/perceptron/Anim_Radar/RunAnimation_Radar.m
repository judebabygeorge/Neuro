function RunAnimation_Radar(Animation,Inputs)

h = figure('Position' ,Animation.ImageSize  );

B = Animation.BackGround ;

angle = -45:1:45;
angle = [angle(1:end) angle(end:-1:1)];
th = 1 ;
id = 1 ;
%Can fire identify planes at 8 locations
enemy_loc = (15:10:90) - 45;

counter = 0 ;

gun_loc   = [-0.95 -0.8];
gun_angle = 0 ;
for i=1:1000    
    
    if(counter == 0)
    I = DrawObject(B,Animation.radar.image,[-0.95 0],angle(th));    
    
    j = Inputs(:,id)==8 ;

    if (angle(th) == enemy_loc(j))           
          counter = 20 ;
          d = Inputs(:,id);
          d = d(d~=8);
          thh = ((d(1) - 4)/3)*30*pi/180;
          loc = [-0.95 0] + 1*[cos(thh) sin(thh)];
          I = DrawObject(I,Animation.plane.image,loc,0); 
          id = id + 1 ;
          if(id > size(Inputs,2))
              id = 1;
          end 
          
          gun_angle = atan2(loc(2) - gun_loc(2), loc(1) - gun_loc(1));
          gun_angle = gun_angle*180/pi;
    end
    
    I = DrawObject(I,Animation.gun.image,gun_loc,gun_angle);
    
    imshow(I);
    th = th + 1 ; 
    if(th > numel(angle))
        th = 1 ;
    end
    else
        counter = counter - 1 ;
    end
    
    pause(0.03)
end

end



function B = DrawObject(B,im,loc,angle)

 im = imrotate(im,angle);
 fSize = size(im);
 
 bSize = size(B);

 loc = [-loc(2) loc(1)];    
 loc = (loc + 1)/2 ;     
 loc = round(0.8*loc.*bSize(1:2)+ 0.1*bSize(1:2));
 
 start = round(loc - (fSize(1:2)/2)) ;
 start = max(start,[1 1]);
    
 Mask = double(((im(:,:,1)>0.9)&(im(:,:,2)>0.9)&(im(:,:,3)>0.9)));
 %Mask = imfilter(Mask,Animation.radar.f,'replicate');
 
 iB   = B(start(1):(start(1) + fSize(1)-1),start(2):(start(2) + fSize(2)-1),:);
 iB   = bsxfun(@times,im,1- Mask) + bsxfun(@times,iB,Mask);
 B(start(1):(start(1) + fSize(1)-1),start(2):(start(2) + fSize(2)-1),:)=iB;
end

