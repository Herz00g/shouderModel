function TS = KINEMATICS_TOOL_build_TS(AI, M4, REDATA, BLDATA)
% Function for obtaining the location of the point TS
%--------------------------------------------------------------------------
% Syntax
% TS = KINEMATICS_TOOL_build_TS(AI, M4, REDATA, BLDATA)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function computes the location of the point TS on the scapula's
% medial border given the location of the point AI and the value of the
% fourth minimal coordinate.
%--------------------------------------------------------------------------

% Initialise the output
TS = [];

%--------------------------------------------------------------------------
% Build Sphere Quadric around AI
%--------------------------------------------------------------------------
AIx = AI(1) - REDATA.Centre(1);
AIy = AI(2) - REDATA.Centre(2);
AIz = AI(3) - REDATA.Centre(3);

% Sphere Radii
R = norm(BLDATA.Initial_Points.TS - BLDATA.Initial_Points.AI);

% Quadric Matrix
T = [1,    0,    0, -AIx;
     0,    1,    0, -AIy;
     0,    0,    1, -AIz;
  -AIx, -AIy, -AIz, AIx^2+AIy^2+AIz^2-R^2];

%--------------------------------------------------------------------------
% Build Ellipsoid Quadric
%--------------------------------------------------------------------------
% Get the Ellipsoid Axes
Ax = REDATA.TSaxes(1,1); Ay = REDATA.TSaxes(2,1); Az = REDATA.TSaxes(3,1);

% Quadric Matrix
S = [1/Ax^2,    0,    0,  0;
        0, 1/Ay^2,    0,  0;
        0,    0, 1/Az^2,  0;
        0,    0,      0, -1];

%--------------------------------------------------------------------------
% Identify the type of intersection quadric
%--------------------------------------------------------------------------    
IQuad = KINEMATICS_TOOL_intersection_identification(S, T);

% Construct the ruled surface
RSDATA = KINEMATICS_TOOL_ruled_surface_parameters(IQuad);

% Get the lower and upper bounds on the ruled surface u parameter
[Ubounds, RSDATA] = KINEMATICS_TOOL_parameter_bounds(RSDATA);

% Compute the Value of u
u = 0;
if M4 < 0.5
    u = Ubounds.Umin + 2*M4*(Ubounds.Umax - Ubounds.Umin);
elseif M4 >= 0.5
    u = Ubounds.Umax - 2*(M4 - 0.5)*(Ubounds.Umax - Ubounds.Umin);
end

% Compute the value of v
Vval = KINEMATICS_TOOL_v_of_u(RSDATA, u);
v = 0;
if M4 < 0.5
    v = Vval.vp;
elseif M4 >= 0.5
    v = Vval.vn;
end

% Build the Position of the Point
if isequal(RSDATA.Type, 'Hyperbolic-Cylinder')
    % Get the Normalised Quadric Parameters
    a = RSDATA.NPa;
    b = RSDATA.NPb;
    x0 = RSDATA.Centre(1);
    y0 = RSDATA.Centre(2);
    
    pu = [];
    qu = [0; 0; 1; 0];
    % Compute parameters depending on the type of parameterisation
    if RSDATA.ParamType == 1
        pu = [a*cosh(u)+x0; b*sinh(u)+y0; 0; 1];
    elseif RSDATA.ParamType == 1
        pu = [-a*cosh(u)+x0; b*sinh(u)+y0; 0; 1];
    elseif RSDATA.ParamType == 3
        pu = [a*sinh(u)+x0; b*cosh(u)+y0; 0; 1];
    elseif RSDATA.ParamType == 4
        pu = [a*sinh(u)+x0; -b*cosh(u)+y0; 0; 1];
    end
    
    % Compute the position of the point
    TS = pu + v*qu;
    
    % Make the Index Switch
    TS = TS(RSDATA.IdS,1);
    
elseif isequal(RSDATA.Type, 'Hyperbolic Paraboloid')
    % Get the Normalised Quadric Parameters
    a = RSDATA.NPa;
    b = RSDATA.NPb;
    c = RSDATA.NPc;
    ss = sign(RSDATA.Coef(3));
    x0 = RSDATA.Centre(1);
    y0 = RSDATA.Centre(2);
    z0 = RSDATA.Centre(3);
    
    % Build the parameterisation
    pu = [a*u/c+x0; b*u/c+y0; z0; 1];
    qu = [-ss*a/c; ss*b/c; 4*u; 0];
    
    TS = pu + v*qu;
    
    % Make the Index Switch
    TS = TS(RSDATA.IdS,1);
end

% Take only the first three values
TS = TS(1:3,1);

return;