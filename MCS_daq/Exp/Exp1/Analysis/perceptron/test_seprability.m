
function test_seprability(PatternData)

X = ones(size(PatternData.Pattern));
X(isnan(PatternData.Pattern))=0;
X = X - 0.5 ;

SelectedPatterns = (1:1:56)*2;
X = X(:,SelectedPatterns,:);
P = mean(X,3);


InterAngles = zeros(size(X,3),size(X,2));

for i=1:size(X,2)
    InterAngles(:,i) =find_all_angles_2(X(:,i,:),P(:,i));
end

InterAngles = reshape(InterAngles , [numel(InterAngles),1]);
IntraAngles = find_all_angles(P);

figure;hist(InterAngles);
figure;hist(IntraAngles);

end

function O =  find_all_angles_2(X,y)

  X = reshape(X,[size(X,1) size(X,2)*size(X,3)]);
  O = zeros(size(X,2),1);
  for i=1:size(X,2) 
      x = X(:,i);
      O(i) = abs(dot(x,y)/(norm(x)*norm(y)));
  end
end
function O =  find_all_angles(X)

X = reshape(X,[size(X,1) size(X,2)*size(X,3)]);
n = size(X,2);
n = n*(n-1)/2;

O = zeros(n,1);
n = 0;
for i=1:(size(X,2)-1)
    for j = (i+1):size(X,2)
         x = X(:,i);
         y = X(:,j);           
         
         n = n + 1 ;
         O(n) = abs(dot(x,y)/(norm(x)*norm(y)));
    end
end

end

