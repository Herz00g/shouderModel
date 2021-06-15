function [f, df] = ELLIPSOID_TOOL_optimisation_function(x, Points)
% Function used by fmincon to compute the cost function for the ellipsoid.
%--------------------------------------------------------------------------
% Syntax :
% [f, df] = ELLIPSOID_TOOL_optimisation_function(x, Points)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function computes the cost function for the ribcage ellipsoid
% optimisaiton. The cost function is the sum of the norms between points on
% the ribcage meshing and their projection onto the surface of the
% ellipsoid.
%
%--------------------------------------------------------------------------

% Get Ellipsoid Variables
xo = x(1); a = x(4);
yo = x(2); b = x(5);
zo = x(3); c = x(6);

% Ellipsoid Matrix
E = diag([1/a^2; 1/b^2; 1/c^2]);

% Ellipsoid Centre
O = [xo; yo; zo];

% Initialise the output
f = 0; 

% The gradient is computed using MATLAB (finite differencing)
df = zeros(6,1);

% Compute the cost function
for i = 1:size(Points,1)
    % Get the coordinates of point to be projected
    u = Points(i,1);
    v = Points(i,2);
    w = Points(i,3);
    Q = [u; v; w];
    
    % Compute the projection scalar
    Lam = Lambda_Compute(xo, yo, zo, a, b, c, u, v, w);
    
    % Compute the projected point
    P = inv(eye(3) + 2*Lam*E)*(Q + 2*Lam*E*O);
    
    % Augment the cost function
    f = f + 0.5*(P-Q)'*(P-Q);
end
return;

% Small Sub-function for computing Lambda the projection scalar
function Lam = Lambda_Compute(xo, yo, zo, a, b, c, u, v, w)
% The Projected Point Coordinates satisfy the equations
% u = x + 2 * lam * (x - xo)/a^2 -> x = (u * a^2 + 2 * lam * xo)/(a^2 + 2 * lam)
% v = y + 2 * lam * (y - yo)/b^2 -> y = (v * b^2 + 2 * lam * yo)/(b^2 + 2 * lam)
% w = z + 2 * lam * (z - zo)/c^2 -> z = (w * c^2 + 2 * lam * zo)/(c^2 + 2 * lam)
%
% Injecting the relations into the ellipsoid equation
%
% a^2*(u - xo)^2/(a^2 + 2 * lam) + b^2*(v - yo)^2/(b^2 + 2 * lam) + c^2*(w - zo)^2/(c^2 + 2 * lam) - 1 = 0
%
% List of Polynomial Coefficients for Computing lambda, the projection
% parameter. These coefficients where computed using MATLAB's symbolic
% toolbox.
K6 = - 64;

K5 = - 64*(a^2 + b^2 + c^2);

K4 = - 16*(a^4 + b^4 + c^4)...
    - 64*(a^2*c^2 + b^2*c^2 + a^2*b^2)...
    + 16*(a^2*u^2 + b^2*v^2 + c^2*w^2)...
    - 32*(a^2*u*xo + b^2*v*yo + c^2*w*zo)...
    + 16*(a^2*xo^2 + b^2*yo^2 + c^2*zo^2);

K3 = - 64*(a^2*b^2*c^2)...
    - 16*(a^4*b^2 + a^4*c^2 + b^4*a^2 + b^4*c^2 + c^4*a^2 + c^4*b^2)...
    + 16*(a^2*u^2*b^2 + a^2*u^2*c^2 + b^2*v^2*a^2 + b^2*v^2*c^2 + c^2*w^2*a^2 + c^2*w^2*b^2)...
    + 16*(c^2*zo^2*b^2 + c^2*zo^2*a^2 + a^2*xo^2*c^2 + a^2*xo^2*b^2 + b^2*yo^2*c^2 + b^2*a^2*yo^2)...
    - 32*(a^2*u*xo*c^2 + a^2*u*xo*b^2 + b^2*v*yo*c^2 + b^2*v*yo*a^2 + c^2*w*zo*b^2 + c^2*w*zo*a^2);

K2 = + 16*(a^2*b^2*c^2*u^2 + a^2*b^2*c^2*v^2 + a^2*b^2*c^2*w^2)...
    + 16*(a^2*b^2*c^2*xo^2 + a^2*b^2*c^2*yo^2 + a^2*b^2*c^2*zo^2)...
    - 32*(a^2*b^2*c^2*u*xo + a^2*b^2*c^2*v*yo + a^2*b^2*c^2*w*zo)...
    -  4*(a^4*b^4 + a^4*c^4 + b^4*c^4) - 16*(a^4*b^2*c^2 + a^2*b^4*c^2 + a^2*b^2*c^4)...
    +  4*(a^2*b^4*u^2 + a^2*c^4*u^2 + b^2*a^4*v^2 + b^2*c^4*v^2 + c^2*a^4*w^2 + c^2*b^4*w^2)...
    -  8*(a^2*c^4*u*xo + a^2*b^4*u*xo + b^2*c^4*v*yo + b^2*a^4*v*yo + c^2*a^4*w*zo + c^2*b^4*w*zo)...
    +  4*(a^2*b^4*xo^2 + a^2*c^4*xo^2 + b^2*a^4*yo^2 + b^2*c^4*yo^2 + c^2*a^4*zo^2 + c^2*b^4*zo^2);

K1 = - 4*(a^2*b^4*c^4 + b^2*a^4*c^4 + c^2*b^4*a^4)...
    + 4*(a^2*b^2*c^4*u^2 + a^2*b^4*c^2*u^2 + a^4*b^2*c^2*v^2 + a^2*b^2*c^4*v^2 + a^4*b^2*c^2*w^2 + a^2*b^4*c^2*w^2)...
    - 8*(a^2*b^2*c^4*u*xo + a^2*b^4*c^2*u*xo + a^2*b^2*c^4*v*yo + a^4*b^2*c^2*v*yo + a^4*b^2*c^2*w*zo + a^2*b^4*c^2*w*zo)...
    + 4*(a^2*b^2*c^4*xo^2 + a^2*b^4*c^2*xo^2 + a^4*b^2*c^2*yo^2 + a^2*b^2*c^4*yo^2 + a^4*b^2*c^2*zo^2 + a^2*b^4*c^2*zo^2);

K0 = - (a^4*b^4*c^4)...
    + (a^2*b^4*c^4*u^2 + a^4*b^2*c^4*v^2 + a^4*b^4*c^2*w^2)...
    + (a^2*b^4*c^4*xo^2 + a^4*b^2*c^4*yo^2 + a^4*b^4*c^2*zo^2)...
    - 2*(a^2*b^4*c^4*u*xo + a^4*b^2*c^4*v*yo + a^4*b^4*c^2*w*zo);

% Select the smallest real root
% K6*lam^6 + K5*lam^5 + K4*lam^4 + K3*lam^3 + K2*lam^2 + K1*lam + K0 = 0
LamRoots = roots([K6, K5, K4, K3, K2, K1, K0]);     % Compute roots
idx = find(abs(imag(LamRoots)) < 1.e-6);            % Identify real roots
[Lam, idy] = min([abs(LamRoots(idx(1),1)), abs(LamRoots(idx(2),1))]); % Select smallest value
Lam = LamRoots(idx(idy),1);
return;
