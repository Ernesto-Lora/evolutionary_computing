% load('experiment_results_2/run_01.mat')
% plot(run_data.time_series(:,1), run_data.time_series(:,2));

% Define the total number of runs
num_runs = 30;

% Optional but recommended: Preallocate the struct array for performance
experiment(num_runs) = struct(); 
success = zeros([1, num_runs]);
total_evals = zeros([1, num_runs]);
best_att = zeros([1, num_runs]);
for i = 1:num_runs
    % 1. Dynamically construct the filename
    % '%02d' formats the integer 'i' to have a leading zero for single digits (01, 02... 30)
    filename = sprintf('experiment_results/run_%02d.mat', i);
    
    % 2. Load the file into a temporary structure
    temp_data = load(filename);
    
    % 3. Store the data into your 'experiment' array
    % This assumes the variable saved in the .mat file was called 'run_data'
    success(i) = temp_data.run_data.success;
    total_evals(i) = temp_data.run_data.total_evals;
    best_att(i) = temp_data.run_data.final_attacks;
    experiment(i).time_series = temp_data.run_data.time_series;
end

sum(success)
idx_suc = find(success);
min(total_evals(idx_suc))
mean(total_evals(idx_suc))

x_sorted = sort(total_evals(idx_suc) );
n = length(total_evals(idx_suc) );
median_value_suc = x_sorted(ceil(n/2))

%median(total_evals(idx_suc))
std(total_evals(idx_suc))
max(total_evals(idx_suc))


median_idx = find(total_evals == median_value_suc);

% Create the figure
fig = figure;

hPlot = plot(experiment(median_idx).time_series(:,1), ...
             experiment(median_idx).time_series(:,2));

% 1. Style the line
set(hPlot, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]); % Standard blue, thicker line

% 2. Add Labels and Title
title('Convergence Plot of Median Experiment in Algorithm 1', 'FontSize', 14);
xlabel('Number of Evaluations', 'FontSize', 12);
ylabel('Best Attack', 'FontSize', 12);

% 3. Improve the axes styling
grid on;
set(gca, 'FontSize', 10, 'Box', 'on');

% 4. Save as plot1.pdf
% 'ContentType', 'vector' ensures the PDF stays sharp regardless of zoom
exportgraphics(gcf, 'plot1.pdf', 'ContentType', 'vector');

%%%%%%%%%%%%%%%%
30 - sum(success)
idx_fail = find(~success);
min(best_att(idx_fail))
mean(best_att(idx_fail))

x_sorted = sort(best_att(idx_fail) );
n = length(best_att(idx_fail) );
median_value = x_sorted(ceil(n/2))

%median(total_evals(idx_suc))
std(best_att(idx_fail))
max(best_att(idx_fail))