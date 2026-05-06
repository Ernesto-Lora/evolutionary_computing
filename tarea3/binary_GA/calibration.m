% calibration

function f1 = fun1(x_array)
f1 = sum( x_array.^2 );
end


tic
% Your code here
[best_params, best_avg_fitness, results_table] = calibrate_GA(@fun1, ...
    -10,10,representation1()); %process
elapsed_time = toc;

disp(elapsed_time)