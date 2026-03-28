% First implementation of 8 queen problem.
% LLMs where used to debug and mainly to save the data from a run
% and perform the experiment of 30 runs. 
function cb = rand_cb()
    cb = zeros([1,64]);
    positions = randperm(8*8,8);
    cb(positions) = 1;
end

function attacks = countAttacks(chessboard)
    attacks=0;
    rchess = reshape(chessboard, 8, 8);
    [rows,cols] = find(rchess == 1);
    
    for i = 1:8
        rest_rows = rows([1:i-1, i+1:end]); % all rows except i
        rest_cols = cols([1:i-1, i+1:end]); % all cols except i
        
        % Horizontal and Vertical attacks
        attacks = attacks + sum(rest_rows == rows(i));
        attacks = attacks + sum(rest_cols == cols(i));
        
        r = rows(i);
        c = cols(i);
        
        % top-left starting point
        offset_main = min(r, c) - 1;
        curr_r = r - offset_main;
        curr_c = c - offset_main;
        
        while curr_r <= 8 && curr_c <= 8
            % Check if there's a piece here, but skip the piece's own square
            if curr_r ~= r || curr_c ~= c
                attacks = attacks + rchess(curr_r, curr_c);
            end
            % Sweep down and to the right
            curr_r = curr_r + 1;
            curr_c = curr_c + 1;
        end
       
        % top-right starting point
        offset_anti = min(r - 1, 8 - c);
        curr_r = r - offset_anti;
        curr_c = c + offset_anti;
        
        while curr_r <= 8 && curr_c >= 1
            if curr_r ~= r || curr_c ~= c
                attacks = attacks + rchess(curr_r, curr_c);
            end
            % Sweep down and to the left
            curr_r = curr_r + 1;
            curr_c = curr_c - 1;
        end
    end
    attacks = attacks/2;
end

function [son1,son2] = recombine(chessboard1,chessboard2)
    son1 = zeros([8,8]);
    son2 = zeros([8,8]);

    % reshape parents
    rcb1 = reshape(chessboard1, 8, 8);
    rcb2 = reshape(chessboard2, 8, 8); 

    % generate random mask of 1s and 2s
    mask = randi([1,2],1,8);

    for i = 1:8
        if mask(i) == 1
            son1(:,i) = rcb1(:,i);
            son2(:,i) = rcb2(:,i);
        else
            son1(:,i) = rcb2(:,i);
            son2(:,i) = rcb1(:,i);
        end
    end

    % reshape back to vectors
    son1 = reshape(son1,1,64);
    son2 = reshape(son2,1,64);
end

function valid_cb = add_queens(chessboard,s)
    Num_required = 8-s;
    % Get the positions eg. [1,2]
    current_positions = find(chessboard);
    % perform the random permutation excluding the original positions eg.1,2
    
    posible_new_positions = setdiff(1:64, current_positions);
    chose_idx = randperm(length(posible_new_positions), Num_required);
    new_positions = posible_new_positions(chose_idx);

    valid_positions = [current_positions, new_positions];

    % then you have the new vector
    valid_cb = zeros([1,8*8]);
    valid_cb(valid_positions) = 1;
end

function valid_cb = delete_queens(chessboard)
    % Get the positions eg. [1,2]
    current_positions = find(chessboard);
    chose_idx = randperm(length(current_positions), 8);
    valid_positions = current_positions(chose_idx);

    % then you have the new vector
    valid_cb = zeros([1,8*8]);
    valid_cb(valid_positions) = 1;
end

function valid_cb = repair(chessboard)
    s = sum(chessboard, "all");
    if s == 8
        valid_cb = chessboard;
    elseif s < 8
        valid_cb = add_queens(chessboard,s);
    else 
        valid_cb = delete_queens(chessboard);
    end
end

function new_cb = mutate(chessboard)
    % Get the positions eg. [1,2]
    current_positions = find(chessboard);

    % Get a random position to mutate
    posible_new_positions = setdiff(1:64, current_positions);
    chose_idx = randi(length(posible_new_positions));

    % chose random position in the original to mutate
    chose_original_idx = randi(length(current_positions));

    %mutate
    current_positions(chose_original_idx) = posible_new_positions(chose_idx);
    new_cb = zeros([1,8*8]);
    new_cb(current_positions) = 1;
end 

function [best_board, best_val, run_data] = evolutionary_alg_queens(pop_size_max, ...
    max_eval, recombination_rate, mutation_rate)
    
    % (Note: I renamed the first parameter to 'pop_size' internally to avoid 
    % confusing it with the actual array of subjects, but it functions the same)
    pop_size = randi([10, pop_size_max]);
    subjects = cell(1, pop_size+2);
    quality = zeros(1, pop_size+2);
    
    
    for i = 1:pop_size
        subjects{i} = rand_cb();
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
        % Best of random 3
        tournament_idx = randperm(pop_size, 3);
        t_individuals = quality(tournament_idx);
        [~, best_idx1] = min(t_individuals);
        best_individual_idx1 = tournament_idx(best_idx1);
        
        % The other best of 3
        tournament_idx = randperm(pop_size, 3);
        t_individuals = quality(tournament_idx);
        [~, best_idx2] = min(t_individuals);
        best_individual_idx2 = tournament_idx(best_idx2);
        
        % Recombine
        if rand() <= recombination_rate
            [son1, son2] = recombine(subjects{best_individual_idx1}, subjects{best_individual_idx2});
        else
            son1 = subjects{best_individual_idx1};
            son2 = subjects{best_individual_idx2};
        end
        
        % Mutation
        if rand() <= mutation_rate
            son1 = mutate(son1);
            son2 = mutate(son2);
        end
        
        % Repair & Evaluate
        son1 = repair(son1);
        son2 = repair(son2);
        quality(pop_size + 1) = countAttacks(son1);
        subjects{pop_size + 1} = son1;
        quality(pop_size + 2) = countAttacks(son2);
        subjects{pop_size + 2} = son2;
        
        % Replacement
        [~, worst_idx] = maxk(quality, 2);
        best_idx = setdiff(1:pop_size+2, worst_idx);
        quality(1:pop_size) = quality(best_idx);
        subjects(1:pop_size) = subjects(best_idx);
        
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
    run_data.success = (best_val == 0);                   
    run_data.final_board = best_board;
    run_data.final_attacks = best_val;
end


% Experiment Parameters
num_runs = 30;
pop_size_max = 100; 
max_eval = 10000;
recomb_rate = 0.8;
mut_rate = 0.5;

% Create a folder to keep things clean (optional but recommended)
if ~exist('experiment_results', 'dir')
    mkdir('experiment_results');
end

fprintf('Starting %d runs of the evolutionary algorithm...\n', num_runs);

for run = 1:num_runs
    fprintf('Running execution %d of %d...\n', run, num_runs);
    
    % Call the algorithm
    [~, ~, run_data] = evolutionary_alg_queens(pop_size_max, max_eval, recomb_rate, mut_rate);
    
    % Generate a unique filename: e.g., run_01.mat, run_02.mat
    filename = sprintf('experiment_results/run_%02d.mat', run);
    
    % Save only the run_data struct into the file
    save(filename, 'run_data');
end

fprintf('Experiment complete! Data saved to the "experiment_results" folder.\n');


% [best_board, best_val] = evolutionary_alg_queens(150,10000,1.0,0.5);
% best_val
% reshape(best_board,8,8)

