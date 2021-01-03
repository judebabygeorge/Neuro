
function Animation = CreateAnimation_Radar()

Animation.ImageSize = [50 50 800 800];


Animation.BackGround = zeros(Animation.ImageSize(3),Animation.ImageSize(4),3);

radar = double(imread('radar.png'))/255;
%radar = imresize(radar, 0.5);
Animation.radar.image =  radar ;
Animation.radar.f     = fspecial('disk', 5);

gun = double(imread('gun.png'))/255;
%gun = imresize(gun, 0.5);
Animation.gun.image =  gun ;
Animation.gun.f     = fspecial('disk', 5);


bullet = double(imread('bullet.png'))/255;
%bullet = imresize(bullet, 0.5);
Animation.bullet.image =  bullet ;
Animation.bullet.f     = fspecial('disk', 5);

plane = double(imread('plane.png'))/255;
%bullet = imresize(bullet, 0.5);
Animation.plane.image =  plane ;
Animation.plane.f     = fspecial('disk', 5);




end
