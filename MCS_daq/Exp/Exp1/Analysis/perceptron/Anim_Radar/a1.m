

 p = (rand(2500,2)*2 - 1)*3 ;

 
 d = p(:,2) - p(:,1) ;
 
 p1 = p(d>0.2,:);
 p2 = p(d<-0.2,:);
 
 figure ; hold on ;
 scatter(p1(:,1),p1(:,2),'filled','r');
 scatter(p2(:,1),p2(:,2),'filled','g');
 
 x = [-3 3] ; y = [-3 3] ;
 line(x,y)
%  figure ; hold on ;
%  scatter3(p1(:,1),p1(:,2),p1(:,3),'filled','r');
%  scatter3(p2(:,1),p2(:,2),p2(:,3),'filled','g');
%  
%  k = 1.5;
%  V = [-k -k 1.1; k -k 1.1 ; k k 1.1 ; -k k 1.1];
%  a = patch(V(:,1),V(:,2),V(:,3),'b');

