function REDATA = ELLIPSOID_TOOL_run_optimisation(EOPTDATA, BLDATA)
% Ribcage Ellipsoid Optimisation Overhead function.
%--------------------------------------------------------------------------
% Syntax :
% REDATA = ELLIPSOID_TOOL_run_optimisation(EOPTDATA, BLDATA)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function runs the optimisation procedure for the ribcage ellipsoid.
% Once a solution is found, the ellipsoid is adapted to the points TS and
% AI.
%
%--------------------------------------------------------------------------

% Create a wait bar to help the user be patient
ewait = waitbar(0,'Running Ellipsoid Optimisation (Status can be observed in command window)');

% Define the Optimization Options
options = optimset(...
    'Algorithm', EOPTDATA.Algorithm,...
    'Display', 'Iter',...
    'HessUpdate', 'bfgs',...
    'Diagnostics', 'on',...
    'Gradobj', 'off',...
    'TolX', EOPTDATA.TolX,...
    'TolFun', EOPTDATA.TolFun,...
    'TolCon', EOPTDATA.TolCon,...
    'MaxFunEval', EOPTDATA.MaxFunEval,...
    'MaxIter', EOPTDATA.MaxIter);

% Update the wait bar
waitbar(0.25,ewait);

% Run the Optimization with every two points
[xopt, fopt, exitflag] = fmincon(@ELLIPSOID_TOOL_optimisation_function,...
    EOPTDATA.Initial_Guess,...
    [],[],...
    [],[],...
    EOPTDATA.Lower_Bounds, EOPTDATA.Upper_Bounds,...
    [],...
    options,...
    EOPTDATA.points(1:2:end,:));

% Update the wait bar
waitbar(0.85,ewait);

% Optimisation has been run, the ribcage datastructure is to be updated

% Create the initial data
REDATA.Centre = xopt(1,1:3);
REDATA.Axes   = xopt(1,4:6);

% Position of TS & AI in thorax reference system
TS = BLDATA.Initial_Points.TS;
AI = BLDATA.Initial_Points.AI;

%--------------------------------------------------------------------------
% The Scaling Factor is one of the roots of a sixth order polyomial. The
% polynomial is obtained from the equation and must be a positive real
% root.
% (TSx - Ex)^2   (TSy - Ey)^2   (TSz - Ez)^2
% ------------ + ------------ + ------------ - 1 = 0
%  (A + sf)^2     (B + sf)^2     (C + sf)^2
%
% Required Data
TSx = TS(1); TSy = TS(2); TSz = TS(3);
A = REDATA.Axes(1); B = REDATA.Axes(2); C = REDATA.Axes(3);
Xo = REDATA.Centre(1); Yo = REDATA.Centre(2); Zo = REDATA.Centre(3);

% The Polynomial Coefficients are given by
P6 = - 1;
P5 = - 2*(A + B + C);
P4 = ((TSx - Xo)^2 + (TSy - Yo)^2 + (TSz - Zo)^2 - (C^2 + 4*C*B + B^2) - 4*(C + B)*A - A^2);
P3 = (2*(TSx - Xo)^2*(C + B) + 2*(TSy - Yo)^2*(A+C) + 2*(TSz - Zo)^2*(A + B) - 2*(C^2*B + B^2*C) - 2*(C^2 + 4*C*B + B^2)*A - 2*(C + B)*A^2);
P2 = ((TSx - Xo)^2*(B^2 + C^2 + 4*C*B) + (TSy - Yo)^2*(C^2 + 4*A*C + A^2) + (TSz - Zo)^2*(A^2 + 4*A*B + B^2) - C^2*B^2 - 4*(C^2*B + C*B^2)*A - (C^2 + 4*C*B + B^2)*A^2);
P1 = (2*(TSx - Xo)^2*(B^2*C + C^2*B) + 2*(TSy - Yo)^2*(A^2*C + C^2*A) + 2*(TSz - Zo)^2*(A^2*B + B^2*A) -2*C^2*B^2*A - 2*(C^2*B + C*B^2)*A^2);
P0 = (TSx - Xo)^2*C^2*B^2 + (TSy - Yo)^2*A^2*C^2 + (TSz - Zo)^2*A^2*B^2 - A^2*B^2*C^2;

% Get the Roots
TS_Scale_Roots = roots([P6, P5, P4, P3, P2, P1, P0]);

% Extract the Positive Root only
idx = find(abs(imag(TS_Scale_Roots)) < 1.e-6);
idxx = find(real(TS_Scale_Roots(idx)) > 0);
TSsf = TS_Scale_Roots(idx(idxx),1);

% Save The Data
REDATA.TSscale = TSsf;
REDATA.TSaxes = [A + TSsf; B + TSsf; C + TSsf];

%--------------------------------------------------------------------------
% The Scaling Factor is one of the roots of a sixth order polyomial. The
% polynomial is obtained from the equation and must be a positive real
% root.
% (AIx - Ex)^2   (AIy - Ey)^2   (AIz - Ez)^2
% ------------ + ------------ + ------------ - 1 = 0
%  (A + sf)^2     (B + sf)^2     (C + sf)^2
%
% Required Data
AIx = AI(1); AIy = AI(2); AIz = AI(3);

% The Polynomial Coefficients are given by
P6 = - 1;
P5 = - 2*(A + B + C);
P4 = ((AIx - Xo)^2 + (AIy - Yo)^2 + (AIz - Zo)^2 - (C^2 + 4*C*B + B^2) - 4*(C + B)*A - A^2);
P3 = (2*(AIx - Xo)^2*(C + B) + 2*(AIy - Yo)^2*(A+C) + 2*(AIz - Zo)^2*(A + B) - 2*(C^2*B + B^2*C) - 2*(C^2 + 4*C*B + B^2)*A - 2*(C + B)*A^2);
P2 = ((AIx - Xo)^2*(B^2 + C^2 + 4*C*B) + (AIy - Yo)^2*(C^2 + 4*A*C + A^2) + (AIz - Zo)^2*(A^2 + 4*A*B + B^2) - C^2*B^2 - 4*(C^2*B + C*B^2)*A - (C^2 + 4*C*B + B^2)*A^2);
P1 = (2*(AIx - Xo)^2*(B^2*C + C^2*B) + 2*(AIy - Yo)^2*(A^2*C + C^2*A) + 2*(AIz - Zo)^2*(A^2*B + B^2*A) -2*C^2*B^2*A - 2*(C^2*B + C*B^2)*A^2);
P0 = (AIx - Xo)^2*C^2*B^2 + (AIy - Yo)^2*A^2*C^2 + (AIz - Zo)^2*A^2*B^2 - A^2*B^2*C^2;

% Get the Roots
AI_Scale_Roots = roots([P6, P5, P4, P3, P2, P1, P0]);

% Extract the Positive Root only
idx = find(abs(imag(AI_Scale_Roots)) < 1.e-6);
idxx = find(real(AI_Scale_Roots(idx)) > 0);
AIsf = AI_Scale_Roots(idx(idxx),1);

% Save The Data
REDATA.AIscale = AIsf;
REDATA.AIaxes = [A + AIsf; B + AIsf; C + AIsf];

% Update the wait bar and close it
waitbar(1, ewait);
delete(ewait);

% Display a warning if the optimisation procedure was not successful!
if exitflag < 1
    warndlg('The Optimisation was Unsuccessful. See MATLAB command line for details');
end
return;