
function off = uniform_mutation(grayBool_array, mp)
    off = false(10, 15);
    for i = 1:10
        off(i, :) = uniform_mutation_element(grayBool_array(i,:),mp );
    end
end


function mutated = uniform_mutation_element(individual, mp)
    l = length(individual);
    mutated = individual;
    
    for i = 1:l
        if rand < mp
            mutated(i) = not(mutated(i));
        end
    end
end