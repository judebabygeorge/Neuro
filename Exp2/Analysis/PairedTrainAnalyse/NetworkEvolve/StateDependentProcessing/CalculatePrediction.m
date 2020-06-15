function e = CalculatePrediction(a,y1,y2)
  o = a(1)*(y1(2:end-1)-y1(1:end-2))+  y2(2:end-1) + a(2) ;
  e = (o- y2(3:end));
  e = sum(e.^2);
end