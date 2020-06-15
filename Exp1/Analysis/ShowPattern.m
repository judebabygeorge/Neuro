function  ShowPattern(P)

%Assuming that P[nElectrodes,1:nSamples]
P = reshape(P,[size(P,1) numel(P)/size(P,1)]);

Pp = zeros(size(P));
Pp(~isnan(P)) = 1 ; % window > 1
Pp(isnan(P))  = 0 ;
Pp = mean(Pp,2);

I = (Pp > 0.1) ;

P = P(I,:) ;
w = Pp(I)  ;

m = mean(P,2);
[~,I] = sort(m);
P = P(I,:);
w = w(I);

window = 150e-3*50e3;

figure ; hold on ;
for i=1:size(P,1)
    x = P(i,:)';
    
    C = ones(numel(x),3);
    C(:,1) = C(:,1)*0;
    %C(:,3) = C(:,3)*0;
    C(:,2) = C(:,2).*w(i);
    
    C(x>window,:)=[];
    x(x>window)=[];
    
    x = x*20e-3 ;
    
    C = hsv2rgb(C);
    scatter(x,ones(size(x))*i,ones(size(x))*20,C,'filled');
end

xlabel('Time(ms)')
set(gca,'YTick',[])
set(gcf, 'color', [1 1 1])

end