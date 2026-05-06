% For problem 1
function [best_individual, best_fitness]  =GA_binary(popSize, max_gen, cross_p, muta_p, ...
    fit_fun,lb,ub,repre)
    % Initial population
    real_Xs =  generate_init_pop(popSize, lb, ub);
    
    % Evaluate initial population
    
    fitness = [];
    for i = 1:popSize
        fitness(i) = fit_fun(real_Xs{i});
    end
    % disp(min(fitness))
    offsprings = {};
    for gen = 1:max_gen
        % Selection
        father_indexes = deterministic_sampling(fitness);
        %fprintf('iteration %d is\n', i);

        for j = 1:length(father_indexes)/2
            
            x1 = real_Xs{ father_indexes(2*j-1) };
            x2 = real_Xs{ father_indexes(2*j) };
            
            % x1 and x2 have 10 dimentions
            % Each dimention has to be 
            % transform into the binary 15 
            % bin representation
            bin1 = repre.gray_array(x1);
            bin2 = repre.gray_array(x2);
            

            if rand < cross_p
                % Get off1 and off2 of the same size 10x15
                [off1,off2] = two_point_crossover(bin1,bin2);
                
            else
                % Clon
                off1 = bin1;
                off2 = bin2;
            end
    
            if rand < muta_p
                off1 = uniform_mutation(off1, muta_p);
            end
            if rand < muta_p
                off2 = uniform_mutation(off2, muta_p);
            end
            % Back to 1x10 real numbers
            offsprings{2*j-1} = repre.x_array_real(off1);
            offsprings{2*j} = repre.x_array_real(off2);

        end

        fitness_offspring = [];
        for i = 1:popSize
            fitness_offspring(i) = fit_fun (offsprings{i});
        end


        % Apply elitism
        [best_parent_fitness, best_parent_idx] = min(fitness);
        best_parent = real_Xs{best_parent_idx};

        % Find the worst individual in the offspring population
        [worst_offspring_fitness, worst_offspring_idx] = max(fitness_offspring);

        % Replace worst offspring with best parent if parent is better
        if best_parent_fitness < worst_offspring_fitness
            offsprings{worst_offspring_idx} = best_parent;
            fitness_offspring(worst_offspring_idx) = best_parent_fitness;
        end

        % Generational replacement
        real_Xs = offsprings;
        fitness = fitness_offspring;

        %disp(min(fitness))
    end
    % disp(min(fitness))
    best_individual = best_parent;
    best_fitness = best_parent_fitness;
end

