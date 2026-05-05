% rng(42); 
% xs = generate_init_pop(2,-10,10)
% bin1 = representation1.gray_array(xs{1});
% bin2 = representation1.gray_array(xs{2});
% [off1, off2] = two_point_crossover(bin1,bin2);
% 
% r1 = representation1.x_array_real(off1)
% r2 = representation1.x_array_real(off2)

function f1 = fun1(x_array)
f1 = sum( x_array.^2 );
end

function f2 = fun2(x_array)
f2 =  100+ sum( x_array.^2 -10*cos(2*pi*x_array) );
end

rng(42);   % Set seed to 42
[best_individual, best_fitness] = GA_binary(100,70,0.8,0.3,@fun1,-10,10,representation1())