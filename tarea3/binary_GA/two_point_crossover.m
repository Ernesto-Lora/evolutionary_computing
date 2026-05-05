% Loop the crossover to get the complete matrix
function [off1, off2] = two_point_crossover(father1, father2)
    [nrows, ncols] = size(father1);

    % Flatten: 10×nbits → 1×(10*nbits)
    flat_f1 = reshape(father1', 1, []);
    flat_f2 = reshape(father2', 1, []);

    % Crossover on the full flat chromosome
    [flat_off1, flat_off2] = two_point_crossover_element(flat_f1, flat_f2);

    % Reshape back: 1×(10*nbits) → 10×nbits
    off1 = reshape(flat_off1, ncols, nrows)';
    off2 = reshape(flat_off2, ncols, nrows)';
end


% Compute the crossover of A DIMENTION of the variables
function [off1, off2] = two_point_crossover_element(father1, father2)
    l = length(father1);
    
    points = sort(randperm(l, 2));
    
    % First part
    off1_1 = father1(1:points(1)) ;
    off2_1 = father2(1:points(1)) ;
    
    % Second part
    off1_2 = father2(points(1)+1:points(2)) ;
    off2_2 = father1(points(1)+1:points(2)) ;
    
    % Third part
    off1_3 = father1(points(2)+1:end) ;
    off2_3 = father2(points(2)+1:end) ;
    
    off1 = [off1_1 off1_2 off1_3];
    off2 = [off2_1 off2_2 off2_3];

end

