% Second implementation of 8 queen problem.
% LLMs where used to debug and mainly to save the data from a run
% and perform the experiment of 30 runs. 
function attacks = countAttacks(cb)
    attacks = 0;
    for i = 1:8
        diag = cb(i)+1; % 5 + 1
        j = i+1;
        while (diag <= 8 && j<=8)
            if cb(j) == diag
                attacks = attacks+1;
            end
            j = j+1;
            diag = diag +1;
        end
        diag = cb(i)-1; % 5 -1
        j = i+1;
        while (diag >= 1 && j<=8)
            if cb(j) == diag
                attacks = attacks+1;
            end
            j = j+1;
            diag = diag -1;
        end

    end
end


function [son1, son2] = recombine(cb1, cb2)
    son1 = zeros(1,8);
    son2 = zeros(1,8);

    k = randi(8);

    son1(1:k) = cb1(1:k);
    son2(1:k) = cb2(1:k);

    for j = k+1:8
        if ~ismember(cb2(j), son1(1:k))
            son1(j) = cb2(j);
        end

        if ~ismember(cb1(j), son2(1:k))
            son2(j) = cb1(j);
        end
    end

    missing1 = setdiff(1:8, son1);
    missing2 = setdiff(1:8, son2);

    idx1 = find(son1 == 0);
    idx2 = find(son2 == 0);

    son1(idx1) = missing1(randperm(length(missing1)));
    son2(idx2) = missing2(randperm(length(missing2)));
end

function mutated_cb = mutate(cb)
    idx = randperm(8,2);
    c = cb(idx(1));
    cb(idx(1)) = cb(idx(2));
    cb(idx(2)) = c;
    mutated_cb = cb;
end


function [best_board, best_val, run_data] = evolutionary_alg_queens(pop_size_max, ...
    max_eval, recombination_rate, mutation_rate)
    
    % (Note: Renamed 'initial_population' to 'pop_size' internally for clarity)
    pop_size = randi([10, pop_size_max]);
    subjects = cell(1, pop_size+2);
    quality = zeros(1, pop_size+2);
    initial_pop_record = cell(1, pop_size); % To save the initial random boards
    
    % Initialize population
    for i = 1:pop_size
        subjects{i} = randperm(8);
        quality(i) = countAttacks(subjects{i}); 
        
    end
    
    num_evals = pop_size;
    [currentBest_val, currentBest_idx] = min(quality(1:pop_size));
    
    % --- TRACKING SETUP ---
    % Preallocate time series arrays for maximum possible iterations for speed
    max_iters = ceil((max_eval - pop_size) / 2) + 1;
    history_evals = NaN(max_iters, 1);
    history_best = NaN(max_iters, 1);
    
    % Record generation 0 (initialization)
    iter = 1;
    history_evals(iter) = num_evals;
    history_best(iter) = currentBest_val;
   
    while(num_evals < max_eval && currentBest_val ~= 0)
        % Parents selection.
        % 2 Best of random 5
        tournament_idx = randperm(pop_size, 5);
        t_individuals = quality(tournament_idx); % Tournament quality
        [~, best_idx] = mink(t_individuals, 2);
        
        % Get the index in the original population
        best_individual_idx1 = tournament_idx(best_idx(1));
        best_individual_idx2 = tournament_idx(best_idx(2));
        
        % Recombine
        % Generate a random number between 0 and 1
        if rand() <= recombination_rate
            [son1, son2] = recombine(subjects{best_individual_idx1}, subjects{best_individual_idx2});
        else
            % Clone
            son1 = subjects{best_individual_idx1};
            son2 = subjects{best_individual_idx2};
        end
        
        % Mutation
        if rand() <= mutation_rate
            son1 = mutate(son1);
            son2 = mutate(son2);
        end
        
        % Evaluate children
        quality(pop_size + 1) = countAttacks(son1);
        subjects{pop_size + 1} = son1;
        quality(pop_size + 2) = countAttacks(son2);
        subjects{pop_size + 2} = son2;
        
        % Replace
        [~, worst_idx] = maxk(quality, 2);
        best_idx_surv = setdiff(1:pop_size+2, worst_idx);
        quality(1:pop_size) = quality(best_idx_surv);
        subjects(1:pop_size) = subjects(best_idx_surv);
        
        % Update counters and bests
        [currentBest_val, currentBest_idx] = min(quality(1:pop_size));
        num_evals = num_evals + 2;
        
        % --- TRACKING UPDATE ---
        iter = iter + 1;
        history_evals(iter) = num_evals;
        history_best(iter) = currentBest_val;
    end
    
    best_board = subjects{currentBest_idx};
    best_val = quality(currentBest_idx);
    
    % --- PACK DATA FOR EXPORT ---
    % Remove unused NaN rows from preallocation
    history_evals = history_evals(1:iter);
    history_best = history_best(1:iter);
    
    % Save all requested metrics into the struct
    run_data.initial_population = pop_size;
    run_data.total_evals = num_evals ;
    run_data.time_series = [history_evals, history_best]; % Col 1: Evals, Col 2: Best Value
    run_data.success = (best_val == 0);                   % 1 if true, 0 if false
    run_data.final_board = best_board;
    run_data.final_attacks = best_val;
end

function B = vectorToChessboard(cb)
    % Determine the size (works for 8x8 or any NxN)
    n = length(cb);
    
    % Initialize a matrix of zeros
    B = zeros(n, n);
    
    % Use linear indexing to place the 1s
    % sub2ind(size, row_indices, col_indices)
    indices = sub2ind([n, n], 1:n, cb);
    
    B(indices) = 1;
end

% Experiment Parameters
num_runs = 30;
pop_size_max = 100; 
max_eval = 10000;
recomb_rate = 1.0;
mut_rate = 0.5;

% Create a folder to keep things clean (optional but recommended)
if ~exist('experiment_results_2', 'dir')
    mkdir('experiment_results_2');
end

fprintf('Starting %d runs of the evolutionary algorithm...\n', num_runs);

for run = 1:num_runs
    fprintf('Running execution %d of %d...\n', run, num_runs);
    
    % Call the algorithm
    [~, ~, run_data] = evolutionary_alg_queens(pop_size_max, max_eval, recomb_rate, mut_rate);
    
    % Generate a unique filename: e.g., run_01.mat, run_02.mat
    filename = sprintf('experiment_results_2/run_%02d.mat', run);
    
    % Save only the run_data struct into the file
    save(filename, 'run_data');
end

fprintf('Experiment complete! Data saved to the "experiment_results" folder.\n');




% [best_board, best_val] = evolutionary_alg_queens(150,1000,1.0,0.5);
% best_val
% vectorToChessboard(best_board)
% a = countAttacks(cb);
% [son1, son2] = recombine(cb,cb2);
% mutate(cb);