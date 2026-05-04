clear; close all; clc;

% Points to evaluate
points = [-1, 2;
           0.2, 2;
           1, 2];

% Axis limits (adjust if needed)

%% =========================
% FUNCTION 1: f(x,y) = x^2 + y^2
% Gradient: [2x, 2y]
%% =========================
figure;

set(gcf, 'Color', 'w');   % figure background
axes;
set(gca, 'Color', 'w');   % axes background

for i = 1:size(points,1)
    px = points(i,1);
    py = points(i,2);

    dfdx = 2*px;
    dfdy = 2*py;

    figure;

    % set(gcf, 'Color', 'w');   % figure background
    axes;
    set(gca, 'Color', 'w');   % axes background
    hold on; grid on;
    axis equal;
    xlim([-3 3]);
    ylim([1 5]);

    % Axes
    xline(0,'k');
    yline(0,'k');

    % Arrows
    quiver(px, py, dfdx, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 2);
    quiver(px, py, 0, dfdy, 'b', 'LineWidth', 2, 'MaxHeadSize', 2);

    % Point
    plot(px, py, 'ko', 'MarkerFaceColor', 'k');

    title(sprintf('f(x,y)=x^2+y^2 at (%.2f, %.2f)', px, py));

    % Save
    filename = sprintf('f1_axes_grad_%d.png', i);
    exportgraphics(gcf, filename, 'Resolution', 300);
end

%% =========================
% FUNCTION 2: Rosenbrock
% f(x,y)=100(y−x^2)^2+(1−x)^2
%% =========================
for i = 1:size(points,1)
    px = points(i,1);
    py = points(i,2);

    dfdx = -(400*px*(py - px^2) - 2*(1 - px))/100;
    dfdy = (200*(py - px^2))/100;

    figure;
    axes;
    set(gca, 'Color', 'w');   % axes background
    hold on; grid on;
    axis equal;
    xlim([-3 3]);
    ylim([1 5]);

    % Axes
    xline(0,'k');
    yline(0,'k');

    % Arrows
    quiver(px, py, dfdx, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 2);
    quiver(px, py, 0, dfdy, 'b', 'LineWidth', 2, 'MaxHeadSize', 2);

    % Point
    plot(px, py, 'ko', 'MarkerFaceColor', 'k');

    title(sprintf('Rosenbrock at (%.2f, %.2f)', px, py));
    

    % Save
    filename = sprintf('f2_axes_grad_%d.png', i);
    exportgraphics(gcf, filename, 'Resolution', 300);
end