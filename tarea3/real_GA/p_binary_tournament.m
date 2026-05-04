function indexes = p_binary_tournament(fitness, num_fa, p)
    pop_size = length(fitness);
    indexes = zeros(1, num_fa);
    
    for i = 1:num_fa
        tour_idx = randperm(pop_size,2);
        cand1 = tour_idx(1);
        cand2 = tour_idx(2);
        
        % Compare the two candidates (Minimization: lower fitness wins)

        if fitness(cand1) < fitness(cand2)
            % candidate 1 wins
            if rand < p
                indexes(i) = cand1;
            else
                indexes(i) = cand2;
            end
        else
            % candidate 2 wins
            if rand < p 
                indexes(i) = cand2;
            else
                indexes(i) = cand1;
            end
        end
    end
end