% 
% real_Xs =  generate_init_pop(3, -10, 10);
% % undx(real_Xs{1}, real_Xs{2}, real_Xs{3})
% real_Xs{1}
% uniform_mutation_real(real_Xs{1}, -10, 10)

%fitness = [0 0 0 0 0 50 50 50 50 50 ];
%in = p_binary_tournament(fitness, 15, 0.9)
% sum(in<6)
% rng(42);   % Set seed to 42

% [best_individual, best_fitness] = GA_real(200,250,1,0.1,0.8)

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