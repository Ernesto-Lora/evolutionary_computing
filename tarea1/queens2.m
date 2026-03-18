% Permutations implementation

% cb = randperm(8,8)
% cb = ([5,2,3,8,1,6,7,4]);
% cb2 = ([8,3,1,5,7,6,4,2]);
% table_reo = zeros([8,8]);
% for i = 1:8
%     table_reo(cb(i),i)=1;
% end
% table_reo
% 

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


function [best_board, best_val] = evolutionary_alg_queens(initial_population, ...
    max_eval, recombination_rate,mutation_rate)
    subjects = cell(1, initial_population+2);
    quality = zeros(1,initial_population+2);
    for i = 1:initial_population
        subjects{i} = randperm(8);
        quality(i) = countAttacks(subjects{i}); 
    end
    num_evals = initial_population;
    currentBest_val=10;
    gen = 1;
    while(num_evals<max_eval && not(currentBest_val == 0))
        % Parents selection.
        % 2 Best of random 5
        tournament_idx = randperm(initial_population,5);
        t_individuals = quality(tournament_idx); %Tornament quality
        [~, best_idx] = mink(t_individuals,2);
        
        %Get the index in the original population
        best_individual_idx1 = tournament_idx(best_idx(1));
        best_individual_idx2 = tournament_idx(best_idx(2));

        % Recombine
        
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

        quality(initial_population + 1) = countAttacks(son1);
        subjects{initial_population + 1} = son1;

        quality(initial_population + 2) = countAttacks(son2);
        subjects{initial_population + 2} = son2;

        % Replace
        [~, worst_idx] = maxk(quality,2);
        best_idx = setdiff(1:initial_population+2, worst_idx);

        quality(1:initial_population) = quality(best_idx);
        subjects(1:initial_population) = subjects(best_idx);

        [currentBest_val, currentBest_idx] = min(quality);
        num_evals = num_evals +2;
        register(gen) = currentBest_val;
    end
    best_board = subjects{currentBest_idx};
    best_val = quality(currentBest_idx);
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

[best_board, best_val] = evolutionary_alg_queens(150,1000,1.0,0.5);
best_val
vectorToChessboard(best_board)
% a = countAttacks(cb);
% [son1, son2] = recombine(cb,cb2);
% mutate(cb);