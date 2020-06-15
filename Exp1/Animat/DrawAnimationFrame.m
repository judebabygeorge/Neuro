function  DrawAnimationFrame( Animation )
%DRAWANIMATIONFRAME Summary of this function goes here
%   Detailed explanation goes here

figure(Animation.h);
B = Animation_CreateBackGround(Animation);

for i=1:100
    loc = [i i]*0.005 ;
    angle = i*4;
    state = 1;
    I = Animation_DrawButterFly(Animation,loc,angle,state,B);
    imshow(I);
    pause(0.03);
end


end



