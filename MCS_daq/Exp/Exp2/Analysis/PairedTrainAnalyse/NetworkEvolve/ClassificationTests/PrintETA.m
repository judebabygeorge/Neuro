function PrintETA (tim,i,T)
        z = toc(tim);
        eta = (z/i)*(T -i);
        if(i<T)
            s = sprintf('(%d/%d) Elasped  %d s. ETA : %d min %d s',i,T,z, floor(eta/60) ,round(eta - floor(eta/60)*60));
            display(s);
        else
            display('Landing...')
        end
end