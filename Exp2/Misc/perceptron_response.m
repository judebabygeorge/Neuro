




X =Y;

Y = ones(size(X) + [1 0 0]) ;
Y(1:120,:,:) = X ;

a = size(Y);
b = size(Wmin);
Y = reshape(Y,[a(1) a(2)*a(3)]);

O = Wmin'*Y ;
O = reshape(O , [b(2) a(2) a(3)]);

O = mean(O,3);

x = 1:1:b(2) ;

h2 = GraphArray ;
hO2  = guidata(h2);  

x1 = 1:1:min(32,size(O,2));
for i=1:numel(x1)
    hO2.PlotBar(hO2,x1,O(1:numel(x1),i),i);
end

