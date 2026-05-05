% calibration

tic
% Your code here
[best_params, best_avg_fitness, results_table] = calibrate_GA(); %process
elapsed_time = toc;

disp(elapsed_time)