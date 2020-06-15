function [Y,Z,Yp,Vp] = CalculateEvolveScores(path,DIV)

path0 = [path '\' DIV '\'];
paired_probes = dir([path0 '\data_PatternCheck_2_250_paired_train_probe_*.mat']);
numel(paired_probes)
Y = zeros(120,20,numel(paired_probes));
size(Y)
for i = 1:numel(paired_probes)
    f = sprintf('\\data_PatternCheck_2_250_paired_train_probe_%d.mat',i);
    f = [path0  f];
    a = load(f); 
    P = CreateFiringProbabilityMatrix( a.PatternData );
    Y(:,:,i) = P;
end

Z = zeros(size(Y,1),size(Y,2));

l  = 2;
h  = (1/(2*l+1))*ones(2*l+1,1);
Yp = zeros(size(Y));
Vp = zeros(size(Y));
for i=1:size(Z,1)
    for j=1:size(Z,2)
        o  = Y(i,j,:);
        o  = o(:);
        o2 = filtfilt(h,1,o);
        w  = std(o-o2);
        for k=4
         y = KalmanEstimateStates(o,w,k);
         v = y(:,2);
         v(isnan(v)) = 0;
         y = ProjectFromVel(v);
         Z(i,j)=Z(i,j) + sum(y.^2)*k;
         Vp(i,j,:)  = reshape(v,1,1,numel(v));
         Yp(i,j,:)  = reshape(y,1,1,numel(y));
        end
    end
    i
end
    

end