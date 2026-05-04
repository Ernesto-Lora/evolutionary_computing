% Loop the crossover to get the complete matrix
function [off1, off2] = two_point_crossover(father1, father2)
    off1 = false(10, 15);
    off2 = false(10, 15);
    for i = 1:10
        [elem_off1, elem_off2] =  two_point_crossover_element(father1(i, :), father2(i, :));
        off1(i, :) = elem_off1;
        off2(i, :) = elem_off2;
    end
end


% Compute the crossover of A DIMENTION of the variables
function [off1, off2] = two_point_crossover_element(father1, father2)
    l = length(father1);
    
    points = sort(randperm(l, 2));
    
    % First part
    off1_1 = father1(1:points(1)) ;
    off2_1 = father2(1:points(1)) ;
    
    % Second part
    off1_2 = father1(points(1)+1:points(2)) ;
    off2_2 = father2(points(1)+1:points(2)) ;
    
    % Third part
    off1_3 = father1(points(2)+1:end) ;
    off2_3 = father2(points(2)+1:end) ;
    
    off1 = [off1_1 off1_2 off1_3];
    off2 = [off2_1 off2_2 off2_3];

end

