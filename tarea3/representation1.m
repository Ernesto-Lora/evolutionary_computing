% We have 
% Lower bound -> -10
% Upper bound ->  10
% Precision -> 3
% Applying formula
% bits = log2( (10-(-10)) * 10^3)+0.9 
% 15 bits

classdef representation1
    methods (Static)
        function grayBool = gray_binaryRep1(x)
            k = int16((x-(-10))*10^3);
            % Convert to binary string
            binStr = dec2bin(k, 15);

            %convert to array of booleans
            binBool = (binStr == '1'); 
            
            % Return the gray code 
            grayBool = bin2gray_bool(binBool);
        end
        
        function realVal = realRep(grayBool)
            % Convert from gray boolean array to binary boolean array
            binBool = gray2bin_bool(grayBool);
            
            % Convert boolean array back to character array ('0' and '1')
            binStr = char(binBool + '0');
            k = bin2dec(binStr);
            realVal = -10 + k/(10^3);
        end 
    end
end

% helper Functions. This where given by Gemini

function g = bin2gray_bool(b)
    % b is a logical array like [true, false, true, true, false]
    n = length(b);
    g = false(1, n); % initialize logical array of same length
    
    g(1) = b(1); % The Most Significant Bit remains the same
    for i = 2:n
        g(i) = xor(b(i), b(i-1));
    end
end

function b = gray2bin_bool(g)
    % g is a logical array like [true, true, true, false, true]
    n = length(g);
    b = false(1, n); % initialize logical array of same length
    
    b(1) = g(1); % The Most Significant Bit remains the same
    for i = 2:n
        b(i) = xor(b(i-1), g(i));
    end
end
