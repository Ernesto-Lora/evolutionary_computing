% We have 
% Lower bound -> -10
% Upper bound ->  10
% Precision -> 3
% Applying formula
% bits = log2( (10-(-10)) * 10^3)+0.9 
% 15 bits

function binStr = gray_binaryRep1(x)
k = int16((x-(-10))*10^3);
binStr = dec2bin(k,15);
% Return the gray code representation
binStr = bin2gray_str(binStr);
end