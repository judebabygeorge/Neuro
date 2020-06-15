
path = 'C:\Users\45c\Documents\MATLAB\FLIM\Data\890nm_paper data\';
a = dir([path 'thy1*']);

I = zeros(numel(a),1);
for i=1:numel(a)
    s = a(i).name;
    p = sscanf(s,'thy1_intensity scan_890nm_%fmw%f.tiff');
    I(i)=p(1);
end
X = (I*0.001*0.22).^2;
[~,id] = sort(I);
X(id)

ThI  = imread([path 'thy1_intensity scan_890nm_245.8mw139.tif']);
ThI(ThI<400)=0;



    w = 1:size(ThI,2);
    h = 1:size(ThI,1);

    [w(1) w(end) h(1) h(end)]
    
    %n = numel(w)*numel(h)
    

    F = zeros(numel(h),numel(w),numel(a))  ;

    for fid = 1:numel(a)
        I = imread([path a(fid).name]);
        F(:,:,fid) = I(h,w);
    end
    
    ThII = ThI(h,w);
    P = zeros(numel(h),numel(w),4);
    
    ind = find(ThII);
    
    siz = size(P);
    for k=1:numel(ind)
        [i,j] = ind2sub(siz,ind(k));
        FF = F(i,j,:);
        f = @(x)param_function(x,X,FF(:));
        x0 = [0.5,0.5,0.5];
        opts = optimoptions('fmincon','Display','none');   
        [x,ressquared,eflag,outputunc] = fmincon(f,x0,[],[],[],[],[0 0 -Inf],[],[],opts);
        P(i,j,:) = reshape([x ressquared],[1 1 4]);  
    end

%         n_c = 0;
%         for i=1:numel(h)
%              for j=1:numel(w)
%                 [i j]
% 
%                 if(ThII(i,j)>0)
%                     FF = F(i,j,:);
%                     f = @(x)param_function_new(x,X,FF(:));
%                     x0 = [0.5,0.5,0.5];
%     %                opts = optimoptions('fminunc','Display','none','Algorithm','quasi-newton');
%     %   options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
%     %                 x = fminunc(f,x0,opts);   
% 
%     %                x = fminunc(f,x0);     
%                      [x,ressquared,eflag,outputunc] = fmincon(f,x0,[],[],[],[],[0 0 0],[]);
%                     P(i,j,:) = reshape(x,[1 1 3]);            
%                 end
% 
%              end                  
%         end

    save(sprintf('out_th'),'P');

