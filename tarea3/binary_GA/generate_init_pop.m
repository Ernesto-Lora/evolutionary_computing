% Generate initial population

function population = generate_init_pop(popSize, lb, ub)
dim = 10;
population = {};
for i = 1:popSize
    population{i} = lb + (ub - lb) * rand(1, dim);
end
end