function Y = ProjectFromVel(X)
 Y = zeros(size(X));
 for i=2:size(Y,1)
     if(~isnan(X(i-1,1)))         
         Y(i,:) = Y(i-1,:) + X(i-1,:);
     else
         Y(i-1,:) = nan;
     end
 end
end