function [best_params, best_avg_fitness, results_table] = calibrate_GA()
    % 1. Define the discrete search space (the "grid")
    popSize_grid = [50, 100, 200];
    max_gen_grid = [100, 250];
    cross_p_grid = [1];
    muta_p_grid  = [0.1, 0.2, 0.3];
    bt_p_grid    = [0.6, 0.8]; 

    % 2. Generate all possible combinations
    [p, m, c, mu, b] = ndgrid(popSize_grid, max_gen_grid, cross_p_grid, muta_p_grid, bt_p_grid);
    combinations = [p(:), m(:), c(:), mu(:), b(:)];
    num_combinations = size(combinations, 1);

    % 3. Set the number of independent runs per combination
    num_runs = 5; 
    
    % Preallocate results array
    results = zeros(num_combinations, 7);
    
    % CHANGED: Initialize to +Inf for MINIMIZATION
    best_avg_fitness = Inf; 
    best_params = [];

    fprintf('Starting Grid Search (Minimization): Evaluating %d combinations...\n', num_combinations);

    % 4. Iterate through the grid
    for i = 1:num_combinations
        % Extract current parameters
        curr_popSize = combinations(i, 1);
        curr_max_gen = combinations(i, 2);
        curr_cross_p = combinations(i, 3);
        curr_muta_p  = combinations(i, 4);
        curr_bt_p    = combinations(i, 5);

        fitness_runs = zeros(num_runs, 1);

        % Execute multiple runs for statistical significance
        for r = 1:num_runs
            [~, best_fitness] = GA_real(curr_popSize, curr_max_gen, curr_cross_p, curr_muta_p, curr_bt_p);
            fitness_runs(r) = best_fitness;
        end

        % Calculate performance metrics
        avg_fit = mean(fitness_runs);
        std_fit = std(fitness_runs);

        % Store results
        results(i, :) = [curr_popSize, curr_max_gen, curr_cross_p, curr_muta_p, curr_bt_p, avg_fit, std_fit];

        % CHANGED: Update best parameters if current is lower (MINIMIZATION)
        if avg_fit < best_avg_fitness
            best_avg_fitness = avg_fit;
            best_params = combinations(i, :);
        end

        % Display progress every 10 iterations
        if mod(i, 10) == 0 || i == num_combinations
            fprintf('Progress: %d/%d | Best Avg Fitness (Min) so far: %.4f\n', i, num_combinations, best_avg_fitness);
        end
    end

    % 5. Format results into a readable table
    varNames = {'PopSize', 'MaxGen', 'Cross_P', 'Muta_P', 'BT_P', 'AvgFitness', 'StdFitness'};
    results_table = array2table(results, 'VariableNames', varNames);
    
    % CHANGED: Sort table by AvgFitness ASCENDING (lowest fitness at the top)
    results_table = sortrows(results_table, 'AvgFitness', 'ascend');

    fprintf('\nGrid Search Complete.\n');
    fprintf('Optimal Parameters for Minimization:\n');
    fprintf('Population Size: %d\n', best_params(1));
    fprintf('Max Generations: %d\n', best_params(2));
    fprintf('Crossover Prob: %.2f\n', best_params(3));
    fprintf('Mutation Prob: %.2f\n', best_params(4));
    fprintf('BT Prob: %.2f\n', best_params(5));
end