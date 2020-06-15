function tstf( Stat )
%TF Summary of this function goes here
%   Detailed explanation goes here
 nAverage = 3;
    X = (1:1:ceil(Stat.TotalFrames/nAverage))*nAverage ;
    X = double(X) + 0.01;
    if(numel(X)> 0)
        Xm = X/60;
        for i=1:numel(Stat.StimTrainStats)
            f = Stat.StimTrainStats{i}.Dout(:,1:Stat.StimTrainStats{i}.nStim);
            Y = ones(size(X))*nan;
            for j=1:numel(X)
                d = f(2,(f(1,:)> (X(j)- nAverage))&(f(1,:)<X(j)));                
                if(numel(d)>5)
                    Y(j) = sum(d==i)/numel(d);
                end                
            end
            Y           
        end
    end

end

