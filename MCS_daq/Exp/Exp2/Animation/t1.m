
O = npermutek(1:0.1:3,3)-2;
gun_pos = [3 3 3];

V= bsxfun(@minus,O,gun_pos);
theta = atan2(V(:,2),V(:,1))*180/pi;
phi   = atan2(V(:,3),(V(:,1).^2+V(:,2).^2).^0.5)*180/pi;

figure;
hold on;

for i=-1:0.1:1
   % for j=-1.5:0.1:0.5
      j = -1;
      id = (O(:,3)==j)&(O(:,1)==i) ;
      plot(O(id,2),theta(id),'LineWidth',2)
   % end
end

xlabel('X coordinate')
ylabel('\theta');
set(gcf,'Color',[1 1 1])

axis tight
axis square