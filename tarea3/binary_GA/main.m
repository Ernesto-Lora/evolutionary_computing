%%%%%%%%%%%%%%%%%%%%%%%%%
% BINARY
%%%%%%%%%%%%%%%%%%%%%%%%%
function f1 = fun1(x_array)
f1 = sum( x_array.^2 );
end

function f2 = fun2(x_array)
f2 =  100+ sum( x_array.^2 -10*cos(2*pi*x_array) );
end

%rng(48);   % Set seed to 42
[best_individual, best_fitness] = GA_binary(50,700,0.6,0.1,@fun1,-10,10,representation1())