function LoadDecoderWeights( DS,W,DecoderCheckWindow)
%LOADDECODERWEIGHTS Summary of this function goes here
%   Detailed explanation goes here

assert((size(W,1) == 121),'Wrong Size of weight vector for DSP')
assert((size(W,2) <= 64),'Exceeds maximum decoders in DSP')

W = int32(W) ;
s = size(W)  ;
W = reshape(W,[1 numel(W)]);
W = typecast(W,'uint32');
W = reshape(W,s);

A = zeros((1 + 1 + 1 + 1 + 121),1);
A(1) = size(W,2);
A(2) = uint32(50*DecoderCheckWindow);
A(3) = 0        ;
A(4) = 1        ;

for i=1:size(W,2)
 display(['Loading Decoder weight....  ' num2str(i)])
 A(3) = (i-1);
 A(5:end) = W(:,i);
 SendCommand(DS,13,A)    ;
end

end

