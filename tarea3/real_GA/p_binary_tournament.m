function indexes = p_binary_tournament(fitness, num_fa, p)
    pop_size = length(fitness);
    indexes = zeros(1, num_fa);

    for i = 1:num_fa
        max_attempts = 100;
        attempt = 0;
        candidate = -1;

        while attempt < max_attempts
            tour_idx = randperm(pop_size, 2);
            cand1 = tour_idx(1);
            cand2 = tour_idx(2);

            % Determine winner
            if fitness(cand1) < fitness(cand2)
                winner = cand1;
                loser  = cand2;
            else
                winner = cand2;
                loser  = cand1;
            end

            % Apply probabilistic selection
            if rand < p
                candidate = winner;
            else
                candidate = loser;
            end

            % Enforce uniqueness within each consecutive triple (i-2, i-1, i)
            is_duplicate = false;
            if i >= 2 && indexes(i-1) == candidate
                is_duplicate = true;
            end
            if i >= 3 && indexes(i-2) == candidate
                is_duplicate = true;
            end

            if ~is_duplicate
                break;
            end

            attempt = attempt + 1;
        end

        % Fallback: if no unique candidate found, pick any index not in the recent triple
        if attempt == max_attempts
            forbidden = indexes(max(1, i-2) : i-1);
            available = setdiff(1:pop_size, forbidden);
            candidate = available(randi(length(available)));
        end

        indexes(i) = candidate;
    end
end