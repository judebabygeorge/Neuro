



load('test_r.mat')

ClassResult{numel(sig_t)} = {};
ClassR = zeros(numel(sig_t),1);
leg{numel(sig_t)} = {};
for i=1:numel(sig_t)
    S = load(sprintf('Sim%1.4f.mat',sig_t(i)));
    ClassResult{i} = S.S;
    leg{i} = sprintf('%1.4f',sig_t(i));
    
    
    for j = 1:numel(ClassResult{i})
        ClassR(i) = ClassR(i)  + (8-mean(mean(ClassResult{i}{j}.erra)));
    end
    ClassR(i) = ClassR(i)/numel(ClassResult{i});
end

test_r = mean(test_r,2);

close all

%figure;
subplot(1,2,1);
plot(test_r,'LineWidth',2,'LineSmoothing','on');
set(gca,'XTickLabel',leg);
xlabel('Connectivity')
ylabel('Correct Classes');
title('56 Pattern Classification')

%figure;
subplot(1,2,2);
plot(ClassR,'LineWidth',2,'LineSmoothing','on');
set(gca,'XTickLabel',leg);
xlabel('Connectivity')
ylabel('Correct Classes');
title('Novel Pattern Classification')
