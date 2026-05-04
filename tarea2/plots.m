% Configurable limits
limit = 3;
n = 100; % resolution

[x, y] = meshgrid(linspace(-limit, limit, n), linspace(-limit, limit, n));

% -------- Function 1 --------
f1 = x.^2 + y.^2;

figure;
contourf(x, y, f1, 10); % 30 contour levels (modifiable)
colorbar;
axis equal;
title('f(x,y) = x^2 + y^2');

exportgraphics(gcf, 'fun1.png', 'Resolution', 300);

% -------- Function 2 (Rosenbrock) --------

[x, y] = meshgrid(linspace(0.8, 1.2, n), linspace(0.8, 1.2, n));
f2 = 100*(y - x.^2).^2 + (1 - x).^2;

figure;
contourf(x, y, f2, 10);
colorbar;
axis equal;
title('f(x,y) = 100(y - x^2)^2 + (1 - x)^2');

exportgraphics(gcf, 'fun2.png', 'Resolution', 300);