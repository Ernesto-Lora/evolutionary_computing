clc; clear; close all;

% Adjustable limits
limit = 5;
n = 200;

x = linspace(-limit, limit, n);
y = linspace(-limit, limit, n);
[X, Y] = meshgrid(x, y);


%% Function 2: Strong nonlinear epistasis
Z2 = sin(X .* Y) + 0.1*(X.^2 + Y.^2);

figure;
surf(X, Y, Z2);
title('Nonlinear Epistasis: sin(xy) + 0.1(x^2 + y^2)');
xlabel('x'); ylabel('y'); zlabel('f(x,y)');
shading interp; colorbar;
% Save
filename = "3dplot.png";
exportgraphics(gcf, filename, 'Resolution', 300);