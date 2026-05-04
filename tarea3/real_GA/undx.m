function [off1,off2] = undx(x1,x2,x3)
% xp the midpoint 
xp = 0.5*(x1+x2);
% d difference vector
d = x2-x1;

D2 =  norm(x3-x1)^2;
term1 = (x3-x1)*(x2-1)';
term2 = norm(x3-x1)*norm(x2-x1);

D2 = D2*(1- (term1/term2)^2 );

D = sqrt(D2);

% Above way to find ortonormal vectors where given by Gemini.
% Find the orthonormal basis for the subspace perpendicular to d
% By passing 'd' to null(), MATLAB solves d * E = 0.
% E will be an N x (N-1) matrix where each column is a basis vector.
E = null(d);

% e1 = E(:, 1)'; % Transposed back to row vectors to match input style
% e2 = E(:, 2)';

sigma_epsilon2 = 0.25;
% sigma_eta = 0.35^2/n
% sigma_eta = 0.35^2/10 = 0.0122
sigma_eta2 = 0.0122;

%randnormal(0,1,1,10)
off1 = xp + randnormal(0,sigma_epsilon2);
for i = 1:9
    off1 = off1 + D*randnormal(0,sigma_eta2)*E(:, i)';
end

off2 = xp - randnormal(0,sigma_epsilon2);
for i = 1:9
    off1 = off1 - D*randnormal(0,sigma_eta2)*E(:, i)';
end


end 


% Normal distributed random numbers generator
% Given by gemini
function r = randnormal(mu, sigma, varargin)
% RANDNORMAL Generate random numbers from a normal distribution
%   r = randnormal(mu, sigma)         → scalar
%   r = randnormal(mu, sigma, n)      → n×n matrix
%   r = randnormal(mu, sigma, m, n)   → m×n matrix
%
%   Uses the Box-Muller transform. Requires only core MATLAB (no toolboxes).
%
%   Parameters:
%     mu    - Mean of the distribution
%     sigma - Standard deviation (must be > 0)

    % --- Input validation ---
    if sigma <= 0
        error('randnormal: sigma must be positive.');
    end

    % --- Parse output size ---
    if nargin == 2
        sz = [1, 1];
    elseif nargin == 3
        sz = [varargin{1}, varargin{1}];
    elseif nargin == 4
        sz = [varargin{1}, varargin{2}];
    else
        error('randnormal: too many input arguments.');
    end

    % --- Box-Muller Transform ---
    % Need an even number of elements; generate pairs
    N = prod(sz);
    N_pairs = ceil(N / 2);

    U1 = rand(1, N_pairs);   % Uniform samples in (0,1)
    U2 = rand(1, N_pairs);

    % Transform to standard normal (mean=0, std=1)
    Z1 = sqrt(-2 * log(U1)) .* cos(2 * pi * U2);
    Z2 = sqrt(-2 * log(U1)) .* sin(2 * pi * U2);

    Z = [Z1, Z2];     % Concatenate both outputs
    Z = Z(1:N);       % Trim to exact requested size

    % --- Scale to desired mu and sigma ---
    r = mu + sigma * reshape(Z, sz);

end