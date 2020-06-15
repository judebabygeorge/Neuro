function  test1
%TEST1 Summary of this function goes here
%   Detailed explanation goes here
close all
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
Culture = 'G05012015A';
DIV = 'DIV38' ;
[X,Y] = GetElectrodeEvolve( [path Culture] ,DIV);
ym = max(Y,[],2);
Y = bsxfun(@times,Y,1./ym);

ElectrodeId =12;
y=X(ElectrodeId,:,:);
o = reshape(y,[size(y,2) size(y,3)]); 
m = max(o,[],2);
o1 = bsxfun(@times,o,1./m);
o1 = o;
m = ones(size(m));
%I = rand(20,1);
%b = rand(24,1);

%display([I;b])
%o = model_output(I,b);
%o = o + randn(size(o))*0.1;

figure;
plot(o','k');hold on;

% I1 = 2*mean(o1,2);
% b1 = 2*mean(o1,1)';
% x0 = [I1;b1];
% 
% options = optimset('Display','iter','TolFun',1e-15,'TolX',1e-4);
% x = fminunc(@(x)target_fn(x(1:20),x(21:44),o1),x0,options);

I1 = 2*mean(o1,2);
b1 = 2*Y(ElectrodeId,:)';
x0 = I1;

options = optimset('Display','iter','TolFun',1e-15,'TolX',1e-4);
x = fminunc(@(x)target_fn(x(1:20),b1,o1),x0,options);


% x1 = x;
% for i=1:20    
%     x1(i) = fminunc(@(x)target_fn(x,x1(21:44),o(i,:)),x1(i),options);
% end
% for i=21:44    
%     x1(i) = fminunc(@(x)target_fn(x1(1:20),x,o(:,i-20)),x1(i),options);
% end
% x = x1;
%x =  mh_mcmc(o,x0);
%x = x0;
o1 = model_output(x(1:20),b1);
o1 = bsxfun(@times,o1,m);
plot(o1','g');





figure;
plot(b1)
figure;
plot(sort(x(1:20)))

%e = target_fn(x0(1:20),x0(1:24),o)
%e = target_fn(x(1:20),x(1:24),o)
end

function e = target_fn(I,b,o)
%   I = x(1:20);
%   b = x(21:44);
  oest = model_output(I,b);

  e  = sum(sum((oest - o).^2));
  %e = -prod(prod(exp(-0.5*(oest - o).^2/0.1)))*1e40;
end
function o = model_output(I,b)
  o = I*b';
  o = min(o,ones(size(o)));
end

function x =  mh_mcmc(o,x0)


nSamples = 1000000;
samples  = zeros(nSamples,numel(x0));
fval     = zeros(nSamples,1);

samples(1,:) = x0';
fval(1) = target_fn(samples(1,:)',o);

% Samples of proposal function 
sigma = 0.5;
r = sigma*randn(nSamples,numel(x0));
% Samples for acceptance function
u = rand(nSamples,1);

not_valid = zeros(nSamples,1);

for i = 2:nSamples
    samples(i,:) = samples(i-1,:) + r(i,:); %propose a sample
    fval(i) = 1/target_fn(samples(i,:)',o); %evaluavte the function
    
    not_valid(i) = isnan(fval(i));
    
    if(not_valid(i))
        alpha = -1; %definitly reject
    else
        %alpha = min(1,fval(i)/fval(i-1));   
        alpha = fval(i)/fval(i-1);   
    end
    
    %Reject the sample if does not meet criteria
    if (alpha  < u(i)) 
       samples(i,:) = samples(i-1,:); 
       fval(i)=fval(i-1);
    end
   
end
samples = samples(not_valid==0,:);
fval    = fval(not_valid==0);
samples = samples(500:end,:);%reject some initial samples
fval = fval(500:end,:);

[~,I]=max(fval);
x = samples(I,:)';
end