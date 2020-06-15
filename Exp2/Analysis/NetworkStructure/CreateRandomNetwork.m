
close all

nInputs  = 8 ;

nEx      = 0.8;
nTotal   = 120;
%sig    = 1; 

if(0)
    %Randomize Locations in a circle of radius 1
    r  = rand(nTotal,1);
    th = 2*pi*rand(nTotal,1);

    x  = r.*cos(th);
    y  = r.*sin(th);

    dx = bsxfun(@minus,repmat(x,[1,nTotal]),x');
    dy = bsxfun(@minus,repmat(y,[1,nTotal]),y');

    d  = (dx.^2 + dy.^2).^0.5;
    d  = d./max(d(:));
    
    Exciatory = rand(nTotal,1) < 0.8;
    Inhibitory = logical(1-Exciatory);
end
%P  = (1/(sig*(2*pi)^0.5))*exp(-d.^2/(2*sig^2));
P  = exp(-d.^2/(2*sig^2));
I = eye(nTotal);
P = P.*(1-I);





A = rand(nTotal,nTotal);
A = A < P;

if(0)
yy=sum(A(1:8,:));
hist(yy,-0.5:1:9)
    

figure;

hold on
for i=1:nTotal
    if (Exciatory(i) == 1)
        c = [0 0 1];
    else
        c = [1 0 0];
    end 
    for j=1:nTotal
        if(A(i,j)==1)
            hl = line([x(i) x(j)],[y(i) y(j)],'Color',c, 'LineSmoothing','off');            
        end
    end
end
scatter(x(Exciatory),y(Exciatory),100,'filled','o','g');
scatter(x(Inhibitory),y(Inhibitory),100,'filled','s','r');
end

Av = zeros(nTotal);
Av (1:nInputs,nInputs+1:nTotal) = 1;
A = A.*Av;

xT = zeros(120,1);
yT = zeros(120,1);


xT(1:nInputs) = 0 + 0.1*(Inhibitory(1:nInputs))*0; 
xT(nInputs+1:nTotal)=1 - 0.25*(Inhibitory(nInputs+1:nTotal))*0;
yT(1:nInputs) = (1:nInputs)/nInputs;
yT(nInputs+1:nTotal)=(1:(nTotal-nInputs))/(nTotal-nInputs);

if(0)
figure;


    
clf;
hold on
for i=1:nTotal
    if (Exciatory(i) == 1)
        c = 'b';
    else
        c = 'r';
    end    
    for j=1:nTotal
        if(A(i,j)==1)            
            line([xT(i) xT(j)],[yT(i) yT(j)],'Color',c)
        end
    end
end

scatter(xT(Exciatory),yT(Exciatory),150,'filled','o','g');
scatter(xT(Inhibitory),yT(Inhibitory),150,'filled','s','r');
hold off
end

if(0)
figure;

for id=1:nTotal-nInputs
    id
    clf;
    hold on
    NeuronsToShow = nInputs + id;
    for i=1:nTotal
        if (Exciatory(i) == 1)
            c = [0 0 1];
        else
            c = [1 0 0];
        end
        for j=1:nTotal
            if(A(i,j)==1)
                if j==NeuronsToShow                      
                    line([xT(i) xT(j)],[yT(i) yT(j)],'LineWidth',2,'Color',c)
                else
                    c1 = [1 1 1]*0.8;
                    line([xT(i) xT(j)],[yT(i) yT(j)],'LineWidth',1,'Color',c1)
                end
            end
        end
    end

    scatter(xT(Exciatory),yT(Exciatory),100,'filled','o','g');
    scatter(xT(Inhibitory),yT(Inhibitory),100,'filled','s','r');
    hold off
    a = getkey;
    if( a=='q')
        break;
    end
end
end