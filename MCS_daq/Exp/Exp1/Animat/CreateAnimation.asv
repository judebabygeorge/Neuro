function Animation = CreateAnimation()



Animation.ImageSize = [50 50 800 800];
Animation.h = figure('Position' ,Animation.ImageSize  );

Animation.BackGround = zeros(Animation.ImageSize(3),Animation.ImageSize(4),3);

%Create Butterfly related structures
Animation.ButterFly.States{2}=[];

Butterfly = double(imread('butterfly.jpg'))/255;
Butterfly = imresize(Butterfly, 0.5);
Animation.ButterFly.States{1}.image =  Butterfly ;
Butterfly = double(imread('butterfly2.jpg'))/255;
Butterfly = imresize(Butterfly, 0.5);
Animation.ButterFly.States{2}.image =  Butterfly ;

Animation.ButterFly.f                  = fspecial('disk', 5);
Animation.ButterFly.CurrentWingState   = 1                  ;
Animation.ButterFly.CurrentPosition    = [0 0]              ;
Animation.ButterFly.CurrentOrientation = 0                  ;




Animation.Flowers.States{2} = [] ;

flower = double(imread('flower_a.png'))/255;
flower = imresize(flower, 0.2);
Animation.Flowers.States{1}.image = flower;

flower = double(imread('flower_b.png'))/255;
flower = imresize(flower, 0.2);
Animation.Flowers.States{2}.image = flower;

Animation.Flowers.f      = fspecial('disk', 5);

Mask = double((flower(:,:,1) > 0.9) & (flower(:,:,2) > 0.9) & (flower(:,:,3) > 0.9)) ;
Mask = imfilter(Mask,Animation.Flowers.f ,'replicate');
Animation.Flowers.Mask = Mask ;


Animation.Spiders.States{1} = [] ;

spider = double(imread('spider.png'))/255;
spider = imresize(spider, 0.2);
Animation.Spiders.States{1}.image = spider;

Animation.Spiders.f                  = fspecial('disk', 2);
Mask = double((spider(:,:,1) > 0.9) & (spider(:,:,2) > 0.9) & (spider(:,:,3) > 0.9)) ;
Mask = imfilter(Mask,Animation.Spiders.f ,'replicate');
Animation.Spiders.Mask = Mask ;

%Create Some Flowers
nFlowers   = 50 ;
major_locs = [0.2 0.3 ; -0.8 0.7 ; 0.5 -0.6 ; -0.4 -0.8 ; 0.7 0.75];

nLocs = size(major_locs,1);
Animation.Flowers.locs =  major_locs(randi(nLocs,[nFlowers,1]),:);
Animation.Flowers.visited = zeros(nFlowers,1);

Animation.Flowers.locs = Animation.Flowers.locs + (rand(size( Animation.Flowers.locs))*2 - 1)*0.2 ;

%Create Some Spiders

Animation.Spiders.locs = [-0.6  0.5 ; 0.3 -0.4 ; 0.8 0];


end