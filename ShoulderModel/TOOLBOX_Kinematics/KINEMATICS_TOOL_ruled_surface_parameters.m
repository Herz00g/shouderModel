function RSDATA = KINEMATICS_TOOL_ruled_surface_parameters(IQuad)
% Function which generates a quadric data structure
%--------------------------------------------------------------------------
% Syntax :
% RSDATA = KINEMATICS_TOOL_ruled_surface_parameters(IQuad)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function generates a datastructure RSDATA with all the parameters 
% related to the quadric-quadric intersection.
%--------------------------------------------------------------------------

% Initialise the output
RSDATA = [];

% Differentiate between the two types of intersection surfaces.
if isequal(IQuad.Type, 'Hyperbolic-Cylinder')
    % Compute the parameters of the Intersection Surface
    % alpha_1*(x - x0)^2 + alpha_2*(y - y0)^2 + alpha_4 = 0
    alpha_1 = IQuad.Q(1,1);
    alpha_2 = IQuad.Q(2,2);
    
    x0 = -IQuad.Q(4,1)/alpha_1;
    y0 = -IQuad.Q(4,2)/alpha_2;
    
    alpha_4 = IQuad.Q(4,4) - (alpha_1*x0^2 + alpha_2*y0^2);
    
    % Set the Parameters
    RSDATA.Coef     = [alpha_1; alpha_2; alpha_4];
    RSDATA.Centre   = [x0; y0];
    RSDATA.Type     = 'Hyperbolic-Cylinder';
    RSDATA.Axis     = IQuad.Axis;
    RSDATA.IdS      = IQuad.IndexSwitch;
    RSDATA.S        = IQuad.S;
    RSDATA.T        = IQuad.T;
    RSDATA.Q        = IQuad.Q;
    RSDATA.ParamType = 1;
    
    % Compute the normalised Parameters
    RSDATA.NPa = sqrt(abs(alpha_4/alpha_1));
    RSDATA.NPb = sqrt(abs(alpha_4/alpha_2));
    RSDATA.NPc = [];
    
elseif isequal(IQuad.Type, 'Hyperbolic Paraboloid')
    % Compute the parameters of the Intersection Surfac
    % alpha_1*(x - x0)^2 + alpha_2*(y - y0)^2 + alpha_3*(z - z0) = 0
    alpha_1 = IQuad.Q(1,1);
    alpha_2 = IQuad.Q(2,2);
    alpha_3 = 2*IQuad.Q(3,4);
    
    x0 = -IQuad.Q(4,1)/alpha_1;
    y0 = -IQuad.Q(4,2)/alpha_2;
    z0 = (alpha_1*x0^2 + alpha_2*y0^2-IQuad.Q(4,4))/alpha_3;
    
    % Set the Parameters
    RSDATA.Coef     = [alpha_1; alpha_2; alpha_3];
    RSDATA.Centre   = [x0; y0; z0];
    RSDATA.Type     = 'Hyperbolic Paraboloid';
    RSDATA.Axis     = IQuad.Axis;
    RSDATA.IdS      = IQuad.IndexSwitch;
    RSDATA.S        = IQuad.S;
    RSDATA.T        = IQuad.T;
    RSDATA.Q        = IQuad.Q;
    
    % Compute the normalised Parameters
    RSDATA.NPa = 1/sqrt(abs(alpha_1));
    RSDATA.NPb = 1/sqrt(abs(alpha_2));
    RSDATA.NPc = 1/sqrt(abs(alpha_3));
else
end

return;