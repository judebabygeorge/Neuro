function Y = KalmanEstimateStates(x,w,depth)

%Create matrices
X = zeros(depth + 1,1);
F = zeros(depth + 1,depth+1);
P = zeros(depth + 1,depth+1);
Q = zeros(depth + 1,depth+1);
H = zeros(depth,depth+1);
R = zeros(depth,depth );

Y = nan*zeros(size(x,1),2);

X(1:depth) = x(1:depth);

if depth > 1
% Calculate initial velocity
    p = polyfit((1:1:depth)',x(1:depth),1);
    X(depth+1) = p(1);
else
    X(depth+1) = 0;
end


F                  = eye(depth+1);
F(1:depth,depth+1) = 1;
Q(1:depth,1:depth) = w*eye(depth);
Q(depth+1,depth+1) = 0.1*X(depth+1);
H(1:depth,1:depth) = eye(depth);
P = Q;

%Kalman Iterations
for i=depth+1:size(x,1)-depth+1
%for i=depth+1:depth+1
    %predict
    X = F*X;
    P = F*P*F' + Q;    
    
    %Update
    Z = x(i:i+depth-1);
    y = Z - H*X;
    S = H*P*H' + R ;
    
    K = P*H'/S;
    X = X + K*y;
    P = (eye(depth+1)-K*H)*P;
    Y(i,:) = X([1 depth+1])';
end

end