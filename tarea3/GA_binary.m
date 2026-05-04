% For problem 1
function GA_binary(popSize, max_gen)
% Initial population
real_Xs =  generate_init_pop(popSize, -10, 10)

% Evaluate initial population

fitness = [];
for i = 1:popSize
    fitness(i) = fun1(real_Xs{i})
end

for gen = 1:max_gen
    % Selection
    father_indexes = deterministic_sampling(fitness)
    
end

end

function f1 = fun1(x_array)
f1 = sum( pow2( x_array ));
end