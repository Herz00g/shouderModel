function mu0 = KINEMATICS_TOOL_get_TS_intersect_coordinate(REDATA, BLDATA)
% Function for computing the intial value of the TS intersection coordinate
%--------------------------------------------------------------------------
% Syntax
% mu0 = KINEMATICS_TOOL_get_TS_intersect_coordinate(REDATA, BLDATA)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function computes the intial coordinate of the sphere ellipsoid
% intersection coordinate for the TS point. This is done by computing the
% intersection quadric and extracting the parameterisation coordinates.
%--------------------------------------------------------------------------

% Initialise the output
mu0 = 0;

%--------------------------------------------------------------------------
% Build Sphere Quadric around AI
%--------------------------------------------------------------------------
% Get the AI coordinates
AIx = BLDATA.Initial_Points.AI(1) - REDATA.Centre(1);
AIy = BLDATA.Initial_Points.AI(2) - REDATA.Centre(2);
AIz = BLDATA.Initial_Points.AI(3) - REDATA.Centre(3);

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

%--------------------------------------------------------------------------
% Extract the Parameterisation Coordinates 
%-------------------------------------------------------------------------- 
% Get the point in the ellipsoid reference system
TS = [BLDATA.Initial_Points.TS - REDATA.Centre; 1];

% Perform the Index Switch
TS = TS(IQuad.IndexSwitch,1);

%--------------------------------------------------------------------------
% The Quadric is a Hyperbolic-Cylinder 
%-------------------------------------------------------------------------- 
if isequal(RSDATA.Type, 'Hyperbolic-Cylinder')
    % Get the Normalised Quadric Parameters
    a = RSDATA.NPa;
    b = RSDATA.NPb;
    x0 = RSDATA.Centre(1);
    y0 = RSDATA.Centre(2);
    
    u = 0;
    v = 0;
    Vval = 0;
    Idx = 0;
    
    % Compute parameters depending on the type of parameterisation
    if RSDATA.ParamType == 1
        u = acosh((TS(1) - x0)/a);
        u = asinh((TS(2) - y0)/b);
    elseif RSDATA.ParamType == 2
        u = acosh((TS(1) - x0)/-a);
        u = asinh((TS(2) - y0)/b);
    elseif RSDATA.ParamType == 3
        u = asinh((TS(1) - x0)/a);
        u = acosh((TS(2) - y0)/b);
    elseif RSDATA.ParamType == 4
        u = asinh((TS(1) - x0)/a);
        u = acosh((TS(2) - y0)/-b);
    end
    
    % Compute the v's based on u
    Vval = KINEMATICS_TOOL_v_of_u(RSDATA, u);
    v = TS(3);
    
    % Evaluate the errors
    Err = [abs(Vval.vp-v), abs(Vval.vn-v)];
    [Val, Idx] = min(Err);
    
    % Extract the Normalised coordinate
    if Idx == 1
        mu0 = (u - Ubounds.Umin)/(2*(Ubounds.Umax - Ubounds.Umin));
    elseif Idx == 2
        mu0 = (Ubounds.Umax - u)/(2*(Ubounds.Umax - Ubounds.Umin)) + 0.5;
    end
    
%--------------------------------------------------------------------------
% The Quadric is a Hyperbolic Paraboloid
%-------------------------------------------------------------------------- 
elseif isequal(RSDATA.Type, 'Hyperbolic Paraboloid')
    % Get the Normalised Quadric Parameters
    a = RSDATA.NPa;
    b = RSDATA.NPb;
    c = RSDATA.NPc;
    ss = sign(RSDATA.Coef(3));
    x0 = RSDATA.Centre(1);
    y0 = RSDATA.Centre(2);
    z0 = RSDATA.Centre(3);
    
    % Compute parameters
    v = (TS(2) - b/a*TS(1) + b/a*x0 - y0)/(2*ss*b/c);
    u = c/a*(TS(1) - x0 + ss*a/c*v);
    
    % Compute both v's based on u.
    Vval = KINEMATICS_TOOL_v_of_u(RSDATA, u);
    
    % Evaluate the errors
    Err = [abs(Vval.vp-v), abs(Vval.vn-v)];
    [Val, Idx] = min(Err);
    
    % Extract the Normalised coordinate
    if Idx == 1
        mu0 = (u - Ubounds.Umin)/(2*(Ubounds.Umax - Ubounds.Umin));
    elseif Idx == 2
        mu0 = (Ubounds.Umax - u)/(2*(Ubounds.Umax - Ubounds.Umin)) + 0.5;
    end
end

 
return;