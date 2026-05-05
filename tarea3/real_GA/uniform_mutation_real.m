function x_mut = uniform_mutation_real(x,lb,up)
x_mut = x;
i = randi(length(x));
x_mut(i) = lb + (up-lb)*rand;
end 