function Vval = KINEMATICS_TOOL_v_of_u(RSDATA, u)
% Function for computing the v's associated to the u for the ruled surface
%--------------------------------------------------------------------------
% Syntax
% Vval = KINEMATICS_TOOL_v_of_u(RSDATA, u)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function computes the two values of v for a given value of u for the
% ruled surface resulting from the sphere-ellipsoid intersection.
%--------------------------------------------------------------------------

% Initialise the output
Vval.vp = 0;
Vval.vn = 0;

%--------------------------------------------------------------------------
% The Quadric is a Hyperbolic-Cylinder 
%--------------------------------------------------------------------------
if isequal(RSDATA.Type, 'Hyperbolic-Cylinder')
    % Get the normalised quadric data
    a = RSDATA.NPa;
    b = RSDATA.NPb;
    x0 = RSDATA.Centre(1);
    y0 = RSDATA.Centre(2);
    
    S = RSDATA.S;
    pu = [];
    
    % Use the correct parameterisation
    if RSDATA.ParamType == 1
        pu = [a*cosh(u)+x0; b*sinh(u)+y0; 0; 1];
    elseif RSDATA.ParamType == 1
        pu = [-a*cosh(u)+x0; b*sinh(u)+y0; 0; 1];
    elseif RSDATA.ParamType == 3
        pu = [a*sinh(u)+x0; b*cosh(u)+y0; 0; 1];
    elseif RSDATA.ParamType == 4
        pu = [a*sinh(u)+x0; -b*cosh(u)+y0; 0; 1];
    end
    qu = [0; 0; 1; 0];
    
    % Construct the polynomial coefficients
    p0 = pu'*S*pu;
    p1 = 2*pu'*S*qu;
    p2 = qu'*S*qu;
    
    % Compute the values of v
    Vval.vp = -p1/(2*p2) + sqrt(abs(p1^2 - 4*p0*p2))/(2*p2);
    Vval.vn = -p1/(2*p2) - sqrt(abs(p1^2 - 4*p0*p2))/(2*p2);
    
    % Allways set the smaller value of v as vp
    if Vval.vp < Vval.vn;
        vn = Vval.vp;
        vp = Vval.vn;
        Vval.vp = vp;
        Vval.vn = vn;
    end
    
%--------------------------------------------------------------------------
% The Quadric is a Hyperbolic Paraboloid
%--------------------------------------------------------------------------  
elseif isequal(RSDATA.Type, 'Hyperbolic Paraboloid')
    % Get the normalised quadric data
    a = RSDATA.NPa;
    b = RSDATA.NPb;
    c = RSDATA.NPc;
    ss = sign(RSDATA.Coef(3));
    x0 = RSDATA.Centre(1);
    y0 = RSDATA.Centre(2);
    z0 = RSDATA.Centre(3);
    S = RSDATA.S;
    
    % Build the parameterisation
    pu = [a*u/c+x0; b*u/c+y0; z0; 1];
    qu = [-ss*a/c; ss*b/c; 4*u; 0];
    
    % Construct the polynomial coefficients
    p0 = pu'*S*pu;
    p1 = 2*pu'*S*qu;
    p2 = qu'*S*qu;
    
    % Compute the values of v
    Vval.vp = -p1/(2*p2) + sqrt(abs(p1^2 - 4*p0*p2))/(2*p2);
    Vval.vn = -p1/(2*p2) - sqrt(abs(p1^2 - 4*p0*p2))/(2*p2);
    
    % Allways set the smaller value of v as vp
    if Vval.vp < Vval.vn;
        vn = Vval.vp;
        vp = Vval.vn;
        Vval.vp = vp;
        Vval.vn = vn;
    end
else
end

return;