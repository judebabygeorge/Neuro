for i=1:size(y,2)
    plot(t,y(:,i)+i);hold on;
end
hold on ; plot(78+(1:numel(D))*(1/50e3),D,'r');
hold on ; plot(358+78+(1:numel(D2))*(1/50e3),D2,'r');


if(0)
    D = D-min(D);
    D = D/max(D);
    D = D + 23;
    D2 = D2-min(D2);
    D2 = D2/max(D2);
    D2 = D2 + 23;
end