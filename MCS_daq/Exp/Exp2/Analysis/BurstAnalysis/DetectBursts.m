function Bursts = DetectBursts(y)

h = ones(10,1)/10;
z = filtfilt(h,1,y);

th1 = 2;
th2 = 0.1;
del = 20 ;

inBurst = 0;
DetectOff = 0;
BurstCount = 0;
BusrtPos = [0 0];

%maxBursts=1000;
%maxBurstWidth= 1000;
Bursts = zeros(1000,2);

for i=1:size(z,1)    
    if(inBurst == 1)
        if(z(i)<th2)
            inBurst = 0;
            DetectOff =del;
            BusrtPos(2) = i;
            BurstCount = BurstCount + 1;
            Bursts(BurstCount,:) = BusrtPos;
        end
    else
        if DetectOff > 0
             DetectOff = DetectOff - 1;
        else
             if(z(i)>th1)
                inBurst = 1;        
                j = i;
                while(j>0)
                    if(z(j)<th2)
                        BusrtPos(1) = j;
                        break;
                    end
                    j = j - 1;
                end
             end
        end
    end
end

Bursts = Bursts(1:BurstCount,:);
end