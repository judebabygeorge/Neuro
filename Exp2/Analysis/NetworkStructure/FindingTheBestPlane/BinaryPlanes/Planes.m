
close all

figure;


p1 = [0 0 0];
p2 = [1 0 0];
p3 = [0 1 0];
p4 = [1 1 0];
p5 = [0 0 1];
p6 = [1 0 1];
p7 = [0 1 1];
p8 = [1 1 1];

Points = [p1;p2;p3;p4;p5;p6;p7;p8];

%scatter3(Points(:,1),Points(:,2),Points(:,3),100,[0.7 0.7 0.7],'filled');
%hold on;

Points1 = [p1;p2;];
Points3 = [p3;p4] ;
Points2 = [p5;p6;p7;p8];
scatter3(Points1(:,1),Points1(:,2),Points1(:,3),100,[1 0 0],'filled');hold on;
scatter3(Points3(:,1),Points3(:,2),Points3(:,3),100,[0 0 1],'filled');hold on;
scatter3(Points2(:,1),Points2(:,2),Points2(:,3),100,[0.7 0.7 0.7],'filled');hold on;

if(0)
verts = [0 -.5 -.5; 0 -.5 .5; 0 .5 .5; 0 .5 -.5]*1.5;
trans = [1 1 1]*.25;
verts = bsxfun(@plus, verts,trans);

faces = [1 2 3 4];
p = patch('Faces',faces,'Vertices',verts,'FaceColor',[0.5 0.5 0.5], 'FaceAlpha',0.5);
dir = [0 0 1];
rotate(p,dir,45,trans);

dir = [1 -1 0];
rotate(p,dir,atan(1/2^0.5)*180/pi,trans);
end

axis square
grid off
l = 2;
c = [0.5 0.5 0.5];


line([0 1]',[0 0]',[0 0]','Color',c,'LineWidth',l);
line([0 1]',[1 1]',[0 0]','Color',c,'LineWidth',l);
line([1 1]',[0 1]',[0 0]','Color',c,'LineWidth',l);
line([0 0]',[0 1]',[0 0]','Color',c,'LineWidth',l);

line([0 1]',[0 0]',[1 1]','Color',c,'LineWidth',l);
line([0 1]',[1 1]',[1 1]','Color',c,'LineWidth',l);
line([1 1]',[0 1]',[1 1]','Color',c,'LineWidth',l);
line([0 0]',[0 1]',[1 1]','Color',c,'LineWidth',l);

line([0 0]',[0 0]',[0 1]','Color',c,'LineWidth',l);
line([0 0]',[1 1]',[0 1]','Color',c,'LineWidth',l);
line([1 1]',[0 0]',[0 1]','Color',c,'LineWidth',l);
line([1 1]',[1 1]',[0 1]','Color',c,'LineWidth',l);
% xlabel(['E' num2str(Electrodes(k,1))]);
% ylabel(['E' num2str(Electrodes(k,2))]);
% zlabel(['E' num2str(Electrodes(k,3))]);

xlim([-2 2])
ylim([-2 2])
zlim([-2 2])