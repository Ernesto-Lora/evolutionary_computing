% For problem 1
function [best_individual, best_fitness] = GA_real(popSize, max_gen, cross_p, muta_p, bt_p, ...
    fit_fun,lb,up)
    % Initial population
    real_Xs =  generate_init_pop(popSize, lb, up);
    real_Xs = cellfun(@(x) round(x, 3), real_Xs, 'UniformOutput', false); % Precision fix
    
    % Evaluate initial population
    
    fitness = [];
    for i = 1:popSize
        fitness(i) = fit_fun(real_Xs{i});
    end
    % disp(min(fitness))
    offsprings = {};
    for gen = 1:max_gen
        % Selection
        num_fathers = int16( 3*popSize/2);
        father_indexes = p_binary_tournament(fitness, num_fathers, bt_p);

        for j = 1:int16(popSize/2)
            
            x1 = real_Xs{ father_indexes(3*j-2) };
            x2 = real_Xs{ father_indexes(3*j-1) };
            x3 = real_Xs{ father_indexes(3*j) };
            

            if rand < cross_p
                % disp('iteration')
                % father_indexes(3*j-2:3*j)
                [off1,off2] = undx(x1,x2,x3);
                off1 = round(off1, 3); 
                off2 = round(off2, 3);
                
            else
                % Clon
                off1 = x1+0;
                off2 = x2+0;
            end
    
            if rand < muta_p
                % get mutants of the same size 10x15
                off1 = uniform_mutation_real(off1,lb,up);
                off2 = uniform_mutation_real(off2, lb, up);
                off1 = round(off1, 3); 
                off2 = round(off2, 3);
                
            end
            % Back to 1x10 real numbers
            offsprings{2*j-1} = off1;
            offsprings{2*j} = off2;

        end

        fitness_offspring = [];
        for i = 1:popSize
            fitness_offspring(i) = fit_fun(offsprings{i});
        end


        % Apply elitism
        [best_parent_fitness, best_parent_idx] = min(fitness);
        best_parent = real_Xs{best_parent_idx}+0;

        % Find the worst individual in the offspring population
        [worst_offspring_fitness, worst_offspring_idx] = max(fitness_offspring);

        % Replace worst offspring with best parent if parent is better
        if best_parent_fitness < worst_offspring_fitness
            offsprings{worst_offspring_idx} = best_parent+0;
            fitness_offspring(worst_offspring_idx) = best_parent_fitness;
        end

        % Generational replacement
        real_Xs = offsprings;
        fitness = fitness_offspring;

        %disp(min(fitness))
    end
    best_individual = best_parent;
    best_fitness = best_parent_fitness;

    %disp(min(fitness))
end

function f1 = fun1(x_array)
f1 = sum( x_array.^2 );
end

function f2 = fun2(x_array)
f2 =  100+ sum( x_array.^2 -10*cos(2*pi*x_array) );
end
