function  run_animation

h = figure('Position' , [50 50 800 800]) ;
ha = axes;%ha = axes('Position' ,[50 50 700 700]);
set(ha,'XLimMode' , 'Manual' , 'YLimMode' , 'Manual' , 'ZLimMode' , 'Manual' );
set(ha,'XLim',[-5 5],'YLim',[-5 5],'ZLim',[-5 5]);
set(ha,'XTick', [],'YTick',[], 'ZTick',[]);
set(ha,'XTickMode', 'Manual', 'YTickMode', 'Manual', 'ZTickMode', 'Manual');
%set(ha,'XColor',[1 1 1], 'YColor',[1 1 1], 'ZColor',[1 1 1])
set(ha,'CameraTargetMode','manual','CameraTarget',[0 0 0],'CameraPositionMode','manual');

set(ha,'DataAspectRatioMode','manual','DataAspectRatio',[1 1 1],'PlotBoxAspectRatioMode','manual','PlotBoxAspectRatio',[1 1 1]);
view(ha,45,30);

gun_pos = [5 3 -2];
%set(ha,'CameraPosition',[])

coordinates = npermutek(1:3,3)-2.5;


coordinates(1,:) = [];
coordinates(13,:) = [];
coordinates(25,:) = [];
coordinates = coordinates([1 4 5 7 8  10 11 12 14 15 18 19 20 21 23],:);

a = randperm(size(coordinates,1));

hold(ha,'on');
draw_grid(ha);
for i=1:size(coordinates,1)
    draw_sphere(ha,100,coordinates(i,:),'r');
end
draw_sphere(ha,400,gun_pos,'b');
% dl = 4/size(coordinates,1);
% for i=1:size(coordinates,1)
%     draw_animation(ha,coordinates(a(i),:),coordinates(a(i),:)+[0.5 0.5 0.5],gun_pos)
%     pause(0.5);
% end


end

function draw_animation(ha,target,bullet_target,gun_pos)
  n_steps = 50 ;
  dl = (bullet_target - gun_pos)./n_steps ;

  
  for i =1:n_steps
      draw_scene(ha,target,gun_pos+dl*i);
      pause(0.1);
  end
end
function draw_scene(ha,target,bullet)
    cla(ha)
    hold(ha,'on');
    draw_grid(ha)
    draw_target(ha,target,[1 1 1]*0.5,'r');
    
    draw_sphere(ha,2,bullet,'b');
    
end
function draw_sphere(ha,r,loc,c)
  axes(ha);
  scatter3(loc(1),loc(2),loc(3),r,'filled',c);
end

function draw_grid(ha)
axes(ha)
%P = [1 1 1 ; 4 1 1;1 2 1 ; 4 2 1; 1 3 1 ;4 3 1; 1 4 1 ;4 4 1];
P = [1 1 1 ; 3 1 1;1 2 1 ; 3 2 1; 1 3 1 ;3 3 1;];
P1 = P ;
%P1(:,3) = P1(:,3)+3;
P1(:,3) = P1(:,3)+2;
P = [P;P1];

P1 = P(:,[2 1 3]) ;
P = [P;P1];

P1 = P ; 
P  = [P;P1(:,[1 3 2])];
P  = [P;P1(:,[3 2 1])];


P = P-2.5;

for i=1:size(P,1)/2
 Q = P((2*i-1):(2*i),:);   
 X = Q(:,1);Y=Q(:,2);Z = Q(:,3);
 hl = line(X,Y,Z);
 set(hl,'Color',[1 1 1]*0.5);
end

end

function draw_target(ha,loc , dim,c)
  %draw_box(ha,loc , dim,c)
  draw_sphere(ha,10,loc,'c')
end
function draw_box(ha,loc , dim,c)

%Draw 6 faces
axes(ha)
X = loc(1)+ dim(1)*[0 1 1 0 0 0; 1 1 0 0 1 1; 1 1  0 0 1 1   ; 0 1 1 0 0 0] ;
Y = loc(2)+ dim(2)*[0 0 1 1 0 0 ;  0 1 1 0 0 0 ; 0 1 1 0 1 1 ; 0 0 1 1 1 1] ;
Z = loc(3)+ dim(3)*[0 0 0 0 0 1 ;  0 0 0 0 0 1 ; 1 1 1 1 0 1 ; 1 1 1 1 0 1] ;

h = patch(X,Y,Z,c);
set(h,'EdgeColor',c)
end
