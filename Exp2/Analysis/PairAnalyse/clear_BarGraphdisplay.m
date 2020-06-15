function clear_BarGraphdisplay(B)
    y = zeros(size(B.x));   
    s = [size(B.BarAxis,1)  size(B.BarAxis,2) size(B.BarAxis,3) ];
    for i=1:s(1)
        for j=1:s(2)
            for k=1:s(3)
                set(B.BarAxis{i,j,k}.bh,'YData',y);
                set(B.BarAxis{i,j,k}.ht,'String','');
                set(B.BarAxis{i,j,k}.hl,'String','');
            end
        end
    end
end