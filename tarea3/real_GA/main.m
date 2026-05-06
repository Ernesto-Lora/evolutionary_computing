%%%%%%%%%%%%%%%%%%%%%%%%
% Real
%%%%%%%%%%%%%%%%%%%%%%%%
function f1 = fun1(x_array)
f1 = sum( x_array.^2 );
end

function f2 = fun2(x_array)
f2 =  100+ sum( x_array.^2 -10*cos(2*pi*x_array) );
end

function f = a(fun,x)
f =  fun(x);
end

%a(@fun2,[5 5])

% [best_individual, best_fitness] = GA_real(200,250,1,0.1,0.8,@fun1,-10,10)
[best_individual, best_fitness] = GA_real(200,250,1,0.1,0.8,@fun2,-5.12,5.12)