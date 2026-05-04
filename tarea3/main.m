% x1 = -9.998;
% x2 = 5.000;

% g1 = representation1.gray_binaryRep1(x1)
% g2 = representation1.gray_binaryRep1(x2)
% 
% % mg1 = uniform_mutation(g1,1)
% 
% [off1, off2] = two_point_crossover(g1,g2);
% 
% off1
% off2
%x_rec = representation1.realRep(g1)


% xs = generate_init_pop(2,-10,10)
% bin1 = representation1.gray_array(xs{1})
% bin2 = representation1.gray_array(xs{2})
% 
% % b = representation1.x_array_real(bin1)
% 
% [off1, off2] = two_point_crossover(bin1,bin2);
rng(42);   % Set seed to 42
GA_binary(100,70,0.8,0.2)