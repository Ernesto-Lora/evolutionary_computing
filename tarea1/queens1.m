chessboard1 = zeros([1,8*8]);
chessboard2 = zeros([1,8*8]);
%numbers = randperm(8*8,8);
numbers = ([49,17,32,43,54,57,62,8]);
numbers2 = ([49,47,25,40,11,42,2,16]);
chessboard1(numbers) = 1;
chessboard2(numbers2) = 1;

%reshape(chessboard1, 8, 8)
%reshape(chessboard2, 8, 8)
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

% attacks = countAttacks(chessboard1)
% [son1, son2] = recombine(chessboard1,chessboard2);


% valid_cb1 = repair(son1);
% valid_cb2 = repair(son2);
% mutated_cb1 = mutate(chessboard1);
% 
% reshape(rand_cb(), 8, 8)
% reshape(mutated_cb1, 8, 8);

function [best_board, best_val] = evolutionary_alg_queens(initial_population, ...
    max_eval, recombination_rate, mutation_rate)
    subjects = cell(1, initial_population+2);
    quality = zeros(1,initial_population+2);
    for i = 1:initial_population
        subjects{i} = rand_cb();
        quality(i) = countAttacks(subjects{i}); 
    end
    num_evals = initial_population;
    currentBest_val=10;
    while(num_evals<max_eval && not(currentBest_val == 0))
        % Parents selection.
        % Best of random 3
        tournament_idx = randperm(initial_population,3);
        t_individuals = quality(tournament_idx);
        [~, best_idx1] = min(t_individuals);
        best_individual_idx1 = tournament_idx(best_idx1);

        % The other best of 3
        tournament_idx = randperm(initial_population,3);
        t_individuals = quality(tournament_idx);
        [~, best_idx2] = min(t_individuals);
        best_individual_idx2 = tournament_idx(best_idx2);

        % Recombine
        % Generate a random number between 0 and 1
        if rand() <= recombination_rate
            % Recombine
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
        
        
        % Repair

        son1 = repair(son1);
        son2 = repair(son2);
        quality(initial_population + 1) = countAttacks(son1);
        subjects{initial_population + 1} = son1;

        quality(initial_population + 2) = countAttacks(son2);
        subjects{initial_population + 2} = son2;

        [~, worst_idx] = maxk(quality,2);
        best_idx = setdiff(1:initial_population+2, worst_idx);
        quality(1:initial_population) = quality(best_idx);
        subjects(1:initial_population) = subjects(best_idx);
        [currentBest_val, currentBest_idx] = min(quality);
        num_evals = num_evals +2;
    end
    best_board = subjects{currentBest_idx};
    best_val = quality(currentBest_idx);
end

[best_board, best_val] = evolutionary_alg_queens(150,10000,1.0,0.5);
best_val
reshape(best_board,8,8)

