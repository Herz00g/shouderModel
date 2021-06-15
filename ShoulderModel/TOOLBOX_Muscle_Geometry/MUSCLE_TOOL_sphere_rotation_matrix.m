function Mobj = MUSCLE_TOOL_sphere_rotation_matrix(Pv, Sv, Ov)
% UICONTROL Callback constructs the sphere rotation matrix (sphere wrap)
%--------------------------------------------------------------------------
% Syntax :
% Mobj = MUSCLE_TOOL_sphere_rotation_matrix(Pv, Sv, Ov)
%--------------------------------------------------------------------------
%
% File Description :
% This function constructs the sphere rotation matrix used on the sphere
% wrapping algorithm.
%--------------------------------------------------------------------------

% Initialise the output
Mobj = [];

% Define the X-axis
Ex = Sv - Ov;                   
Ex = Ex/norm(Ex);

% Colinearity of PvOv & SvOv?
e1 = Pv - Ov; e2 = Sv - Ov; 
Ez = [];
if isequal(acos(e1'*e2/(norm(e1)*norm(e2))), pi) == 1
    if e2(1) == 0
        if e2(2) == 0
            Ez_z = (-e2(1)-e2(2))/e2(3);
            Ez = [1; 1; Ez_z];
        else
            Ez_y = (-e2(1)-e2(3))/e2(2);
            Ez = [1; Ez_y; 1];
        end
    else
        Ez_x = (-e2(2)-e2(3))/e2(1);
        Ez = [Ez_x; 1; 1];
    end
else
    Ez = cross(Pv - Ov, Sv - Ov);   Ez = Ez/norm(Ez);
end

% Define the y-axis
Ey = cross(Ez, Ex);             
Ey = Ey/norm(Ey);

% Matrix : Plane frame -> Object Frame
Mobj = [Ex, Ey, Ez];


return;