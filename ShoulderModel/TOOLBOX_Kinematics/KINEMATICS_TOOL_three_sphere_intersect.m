function PP = KINEMATICS_TOOL_three_sphere_intersect(O1, O2, O3, r1, r2, r3)
% Function for computing the intersection between three spheres.
%--------------------------------------------------------------------------
% Syntax :
% PP = KINEMATICS_TOOL_three_sphere_intersect(O1, O2, O3, r1, r2, r3)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function computes the intersection between three spheres given their
% centres and their radii. Three cases are used to avoid divide by zero.
%
%--------------------------------------------------------------------------

% Initialize the Output
P1 = [];
P2 = [];

% Get the Center Coordinates
a = O1(1,1); b = O1(2,1); c = O1(3,1);
d = O2(1,1); e = O2(2,1); f = O2(3,1);
g = O3(1,1); h = O3(2,1); j = O3(3,1);

% Constants
a1 = 2*(d-a); b1 = 2*(e-b); c1 = 2*(f-c); d1 = r2^2 - r1^2 + norm(O1)^2 - norm(O2)^2;
a2 = 2*(g-a); b2 = 2*(h-b); c2 = 2*(j-c); d2 = r3^2 - r1^2 + norm(O1)^2 - norm(O3)^2;

Am = [a1, b1; a2, b2];
Bm = [a1, c1; a2, c2];
Cm = [b1, c1; b2, c2];

[v, idx] = max([abs(det(Am)), abs(det(Bm)), abs(det(Cm))]);

if idx == 1
    K1 = (b1*d2 - b2*d1)/det(Am);
    K2 = (b1*c2 - b2*c1)/det(Am);
    K3 = (a2*d1 - a1*d2)/det(Am);
    K4 = (a2*c1 - a1*c2)/det(Am);
    
    p1 = K2^2 + K4^2 + 1;
    p2 = 2*(K1*K2 - a*K2 + K3*K4 - b*K4 - c);
    p3 = (K1^2 + K3^2 + a^2 + b^2 + c^2 - r1^2 - 2*a*K1 - 2*b*K3);
    
    % Test the existence of the intersection
    if (p2^2 - 4*p1*p3) < 0
        disp('H');
    else
        
        z1 = (-p2 + sqrt(p2^2 - 4*p1*p3))/(2*p1);
        z2 = (-p2 - sqrt(p2^2 - 4*p1*p3))/(2*p1);
        
        x1 = K1 + K2*z1;
        x2 = K1 + K2*z2;
        
        y1 = K3 + K4*z1;
        y2 = K3 + K4*z2;
        
        % Define the Output
        if z1 > z2
            P1 = [x1; y1; z1];
            P2 = [x2; y2; z2];
        else
            P2 = [x1; y1; z1];
            P1 = [x2; y2; z2];
        end
    end 
elseif idx == 2
    K1 = (c1*d2 - c2*d1)/det(Bm);
    K2 = (c1*b2 - c2*b1)/det(Bm);
    K3 = (a2*d1 - a1*d2)/det(Bm);
    K4 = (a2*b1 - a1*b2)/det(Bm);
    
    p1 = K2^2 + K4^2 + 1;
    p2 = 2*(K1*K2 - a*K2 + K3*K4 - c*K4 - b);
    p3 = (K1^2 + K3^2 + a^2 + b^2 + c^2 - r1^2 - 2*a*K1 - 2*c*K3);
    
    % Test the existence of the intersection
    if (p2^2 - 4*p1*p3) < 0
        disp('H');
    else
        
        y1 = (-p2 + sqrt(p2^2 - 4*p1*p3))/(2*p1);
        y2 = (-p2 - sqrt(p2^2 - 4*p1*p3))/(2*p1);
        
        x1 = K1 + K2*y1;
        x2 = K1 + K2*y2;
        
        z1 = K3 + K4*y1;
        z2 = K3 + K4*y2;
        
        % Define the Output
        if y1 > y2
            P1 = [x1; y1; z1];
            P2 = [x2; y2; z2];
        else
            P2 = [x1; y1; z1];
            P1 = [x2; y2; z2];
        end
    end
elseif idx == 3
    K1 = (c1*d2 - c2*d1)/det(Cm);
    K2 = (c1*a2 - c2*a1)/det(Cm);
    K3 = (b2*d1 - b1*d2)/det(Cm);
    K4 = (b2*a1 - b1*a2)/det(Cm);
    
    p1 = K2^2 + K4^2 + 1;
    p2 = 2*(K1*K2 - b*K2 + K3*K4 - c*K4 - a);
    p3 = (K1^2 + K3^2 + a^2 + b^2 + c^2 - r1^2 - 2*b*K1 - 2*c*K3);
    
    % Test the existence of the intersection
    if (p2^2 - 4*p1*p3) < 0
        disp('H');
    else
        
        x1 = (-p2 + sqrt(p2^2 - 4*p1*p3))/(2*p1);
        x2 = (-p2 - sqrt(p2^2 - 4*p1*p3))/(2*p1);
        
        y1 = K1 + K2*x1;
        y2 = K1 + K2*x2;
        
        z1 = K3 + K4*x1;
        z2 = K3 + K4*x2;
        
        % Define the Output
        if x1 > x2
            P1 = [x1; y1; z1];
            P2 = [x2; y2; z2];
        else
            P2 = [x1; y1; z1];
            P1 = [x2; y2; z2];
        end
    end
end
% Set the output
PP = [P1, P2];

return;