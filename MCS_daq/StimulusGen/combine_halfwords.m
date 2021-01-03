function a = combine_halfwords(a1,a2)
if a1<0
 a1 = typecast(int16(a1),'uint8');
else
 a1 = typecast(uint16(a1),'uint8');
end

if a2<0
 a2 = typecast(int16(a2),'uint8');
else
 a2 = typecast(uint16(a2),'uint8');
end

 a  = typecast([a1 a2],'uint32');
end