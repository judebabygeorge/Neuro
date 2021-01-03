
function O = SelectBestDifferentiablePair(W)

   C =  gen_perm(size(W,2),2) ;
   X = zeros(size(C,1),1) ;
   
   for i=1:size(C,1)
     X(i) = sum(W(:,C(i,1)).*W(:,C(i,2))) ;
   end
   [~,I] = max(X) ;
   O = C(I,:);
end