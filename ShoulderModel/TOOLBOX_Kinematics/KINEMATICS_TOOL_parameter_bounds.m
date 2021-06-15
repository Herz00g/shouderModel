function [Ubounds, RSDATA] = KINEMATICS_TOOL_parameter_bounds(RSDATAin)
% Function for computing the bounds on the ruled-surface parameterisation.
%--------------------------------------------------------------------------
% Syntax
% [Ubounds, RSDATA] = KINEMATICS_TOOL_parameter_bounds(RSDATAin)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function computes the bounds for the u parameter of the ruled
% surface resulting from the sphere-ellipsoid intersection.
%--------------------------------------------------------------------------

% Initialise the output
Ubounds.Umin = 0;
Ubounds.Umax = 0;
RSDATA = RSDATAin;

%--------------------------------------------------------------------------
% The Quadric is a Hyperbolic-Cylinder 
%-------------------------------------------------------------------------- 
if isequal(RSDATA.Type, 'Hyperbolic-Cylinder')
    % Get the normalised quadric data
    a = RSDATA.NPa;
    b = RSDATA.NPb;
    x0 = RSDATA.Centre(1);
    y0 = RSDATA.Centre(2);
    S11 = RSDATA.S(1,1);
    S22 = RSDATA.S(2,2);
    S33 = RSDATA.S(3,3);
    S44 = RSDATA.S(4,4);
    
    % Identify the correct parameterisation. This can only be done
    % numerically.
    u = linspace(-10, 10, 1000);
    signchange = zeros(1,4);
    for i = 2:size(u,2)
        % The hyperbolic cylinder parameterisation changes depending on the
        % orientation. The bounds on u are the zeros of one of the
        % following functions. There are four possible parameterisations.
        g1 = (cosh(u(i-1))*a + x0)^2*S11 + (sinh(u(i-1))*b + y0)^2*S22 + S44;
        g2 = (-cosh(u(i-1))*a + x0)^2*S11 + (sinh(u(i-1))*b + y0)^2*S22 + S44;
        g3 = (sinh(u(i-1))*a + x0)^2*S11 + (cosh(u(i-1))*b + y0)^2*S22 + S44;
        g4 = (sinh(u(i-1))*a + x0)^2*S11 + (-cosh(u(i-1))*b + y0)^2*S22 + S44;
        
        f1 = (cosh(u(i))*a + x0)^2*S11 + (sinh(u(i))*b + y0)^2*S22 + S44;
        f2 = (-cosh(u(i))*a + x0)^2*S11 + (sinh(u(i))*b + y0)^2*S22 + S44;
        f3 = (sinh(u(i))*a + x0)^2*S11 + (cosh(u(i))*b + y0)^2*S22 + S44;
        f4 = (sinh(u(i))*a + x0)^2*S11 + (-cosh(u(i))*b + y0)^2*S22 + S44;
        
        % If the sign changes, its the correct parameterisation
        if g1*f1 < 0
            signchange(1) = 1;
        end
        
        if g2*f2 < 0
            signchange(2) = 1;
        end
        
        if g3*f3 < 0
            signchange(3) = 1;
        end
        
        if g4*f4 < 0
            signchange(4) = 1;
        end
    end
    
    % Find the roots using MATLAB's solve function. This will depend on the
    % type of parameterisation identified previously
    Uroots = [];
    if signchange(1) > 0
        Uroots = solve('(cosh(u)*a + x0)^2*S11 + (sinh(u)*b + y0)^2*S22 + S44 = 0', 'u');
        RSDATA.ParamType = 1;
    elseif signchange(1,2) > 0
        Uroots = solve('(-cosh(u)*a + x0)^2*S11 + (sinh(u)*b + y0)^2*S22 + S44 = 0', 'u');
        RSDATA.ParamType = 2;
    elseif signchange(1,3) > 0
        Uroots = solve('(sinh(u)*a + x0)^2*S11 + (cosh(u)*b + y0)^2*S22 + S44 = 0', 'u');
        RSDATA.ParamType = 3;
    elseif signchange(1,4) > 0
        Uroots = solve('(sinh(u)*a + x0)^2*S11 + (-cosh(u)*b + y0)^2*S22 + S44 = 0', 'u');
        RSDATA.ParamType = 4;
    end
    
    % Evaluate the symbolic expression
    Uroots = eval(Uroots);
    
    % Find the Real Roots
    Idx = find(abs(imag(Uroots)) < 1.e-8);

    % Identify the maximum and minimum
    UminMax = Uroots(Idx,1);
    Ubounds.Umin = min(UminMax);
    Ubounds.Umax = max(UminMax);
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
    S11 = RSDATA.S(1,1);
    S22 = RSDATA.S(2,2);
    S33 = RSDATA.S(3,3);
    S44 = RSDATA.S(4,4);
    
    % The Hyperbolic Paraboloid parameterisation is such that the bounds
    % are the zeros of a polynomial. The coefficients were computed
    % previoulsy using MATLAB's symbolic toolbox.
    p0 = -4*b^2*ss^2/c^2*S22*S44-4*a^2*ss^2/c^2*S11*z0^2*S33-4*b^2*ss^2/c^2*S22*S11*x0^2-4*b^2*ss^2/c^2*S22*z0^2*S33-4*a^2*ss^2/c^2*S11*S22*y0^2-8*a*ss^2/c^2*S11*x0*b*S22*y0-4*a^2*ss^2/c^2*S11*S44;
    p1 = 32*b*ss/c*S22*y0*z0*S33-16*a^2*ss^2/c^3*S11*b*S22*y0-16*a*ss^2/c^3*S11*x0*b^2*S22-32*a*ss/c*S11*x0*z0*S33;
    p2 = -32*a^2*ss/c^2*S11*z0*S33+32*b^2*ss/c^2*S22*z0*S33-16*a^2*ss^2/c^4*S11*b^2*S22-64*S33*S11*x0^2-64*S33*S44-64*S33*S22*y0^2;
    p3 = -128*S33*S11*a/c*x0-128*S33*S22*b/c*y0;
    p4 = -64*S33*S11*a^2/c^2-64*S33*S22*b^2/c^2;
    
    % Get the Roots
    Uroots = roots([p4, p3, p2, p1, p0]);

    % Find the Real Roots
    Idx = find(abs(imag(Uroots)) < 1.e-8);
    
    % Identify the maximum and minimum
    UminMax = Uroots(Idx,1);
    Ubounds.Umin = min(UminMax);
    Ubounds.Umax = max(UminMax);
else
end
return;