function ConeHandle = VISUALISATION_view_joint_sinus_cones(JCHandle, JCDATA, BLDATA, ConeId)
% Function for visualising the joint sinus cones.
%--------------------------------------------------------------------------
% Syntax :
% ConeHandle = VISUALISATION_view_joint_sinus_cones(JCHandle, JCDATA, BLDATA, ConeId)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function either creates a visualisation of the joint sinus cones or 
% updates an already existing one.
%
% JCHandle contains the handle
% JCDATA joint sinus cone data structure
% ConeId is the bone identification number
% BLDATA bony landmark data structure
%--------------------------------------------------------------------------


% Initialise the output
ConeHandle = JCHandle;

% Creat an angle
theta = linspace(0, 2*pi, 21);

% Initialise the list of points
Cx = []; R = [];
Cy = []; Q = [];
Cz = [];

%--------------------------------------------------------------------------
% The Plot handle is empty: Create one
%--------------------------------------------------------------------------
if isempty(JCHandle)
    % Run the Code for each cone
    switch ConeId
        case 1 % SC JOINT SINUS CONE
            % Construct the Cone (X-axis is the cone axis)
            Cx = [zeros(1,21); JCDATA.SCCone.Dimensions(3)*ones(1,21)];
            Cy = [zeros(1,21); JCDATA.SCCone.Dimensions(1)*cos(theta)];
            Cz = [zeros(1,21); JCDATA.SCCone.Dimensions(2)*sin(theta)];
            
            % Build the Rotation Matrix
            Rsc = Build_Rotation_Matrix(JCDATA.SCCone.ConeAngle(1), JCDATA.SCCone.ConeAngle(2), JCDATA.SCCone.ConeAngle(3));
            R = BLDATA.Current_Matrices_L2A.Rc*Rsc;
            Q = BLDATA.Current_Points.SC;
            
        case 2 % AC JOINT SINUS CONE
            % Construct the Cone (negative Z-axis is the cone axis)
            Cx = [zeros(1,21);  JCDATA.ACCone.Dimensions(1)*cos(theta)];
            Cy = [zeros(1,21);  JCDATA.ACCone.Dimensions(2)*sin(theta)];
            Cz = [zeros(1,21); -JCDATA.ACCone.Dimensions(3)*ones(1,21)];
            
            % Build the Rotation Matrix
            Rac = Build_Rotation_Matrix(JCDATA.ACCone.ConeAngle(1), JCDATA.ACCone.ConeAngle(2), JCDATA.ACCone.ConeAngle(3));
            R = BLDATA.Current_Matrices_L2A.Rs*Rac;
            Q = BLDATA.Current_Points.AC;
            
        case 3 % GH JOINT SINUS CONE
            % Construct the Cone (negative Z-axis is the cone axis)
            Cx = [zeros(1,21);  JCDATA.GHCone.Dimensions(1)*cos(theta)];
            Cy = [zeros(1,21);  JCDATA.GHCone.Dimensions(2)*sin(theta)];
            Cz = [zeros(1,21); -JCDATA.GHCone.Dimensions(3)*ones(1,21)];
            
            % Build the Rotation Matrix
            Rgh = Build_Rotation_Matrix(JCDATA.GHCone.ConeAngle(1), JCDATA.GHCone.ConeAngle(2), JCDATA.GHCone.ConeAngle(3));
            R = BLDATA.Current_Matrices_L2A.Rh*Rgh;
            Q = BLDATA.Current_Points.GH;
        otherwise
    end
    
    % Rotate & Place the Cone
    for i = 1:2
        for j = 1:size(Cx,2)
            P = R*[Cx(i,j); Cy(i,j); Cz(i,j)] + Q;
            Cx(i,j) = P(1); 
            Cy(i,j) = P(2); 
            Cz(i,j) = P(3);
        end
    end
            
    % Draw The Cone
    ConeHandle = surf(Cx, Cy, Cz, 'facecolor', 'green', 'facealpha', 0.5);
    
%--------------------------------------------------------------------------    
% The Plot handle is empty: Update the current one
%--------------------------------------------------------------------------
else
    
    switch ConeId
        case 1 % SC JOINT SINUS CONE
            % Construct the Cone
            Cx = [zeros(1,21); JCDATA.SCCone.Dimensions(3)*ones(1,21)];
            Cy = [zeros(1,21); JCDATA.SCCone.Dimensions(1)*cos(theta)];
            Cz = [zeros(1,21); JCDATA.SCCone.Dimensions(2)*sin(theta)];
            
            % Build the Rotation Matrix
            Rsc = Build_Rotation_Matrix(JCDATA.SCCone.ConeAngle(1), JCDATA.SCCone.ConeAngle(2), JCDATA.SCCone.ConeAngle(3));
            R = BLDATA.Current_Matrices_L2A.Rc*Rsc;
            Q = BLDATA.Current_Points.SC;
            
        case 2 % AC JOINT SINUS CONE
            % Construct the Cone
            Cx = [zeros(1,21); JCDATA.ACCone.Dimensions(1)*cos(theta)];
            Cy = [zeros(1,21); JCDATA.ACCone.Dimensions(2)*sin(theta)];
            Cz = [zeros(1,21); -JCDATA.ACCone.Dimensions(3)*ones(1,21)];
            
            % Build the Rotation Matrix
            Rac = Build_Rotation_Matrix(JCDATA.ACCone.ConeAngle(1), JCDATA.ACCone.ConeAngle(2), JCDATA.ACCone.ConeAngle(3));
            R = BLDATA.Current_Matrices_L2A.Rs*Rac;
            Q = BLDATA.Current_Points.AC;

        case 3 % GH JOINT SINUS CONE
            % Construct the Cone
            Cx = [zeros(1,21);  JCDATA.GHCone.Dimensions(1)*cos(theta)];
            Cy = [zeros(1,21);  JCDATA.GHCone.Dimensions(2)*sin(theta)];
            Cz = [zeros(1,21); -JCDATA.GHCone.Dimensions(3)*ones(1,21)];
            
            % Build the Rotation Matrix
            Rgh = Build_Rotation_Matrix(JCDATA.GHCone.ConeAngle(1), JCDATA.GHCone.ConeAngle(2), JCDATA.GHCone.ConeAngle(3));
            R = BLDATA.Current_Matrices_L2A.Rh*Rgh;
            Q = BLDATA.Current_Points.GH;
        otherwise
    end
    
    % Rotate & Place the Cone
    for i = 1:2
        for j = 1:size(Cx,2)
            P = R*[Cx(i,j); Cy(i,j); Cz(i,j)] + Q;
            Cx(i,j) = P(1); 
            Cy(i,j) = P(2); 
            Cz(i,j) = P(3);
        end
    end
    
    % Draw The Cone
    set(ConeHandle, 'xdata', Cx, 'ydata', Cy, 'zdata', Cz, 'facecolor', 'green', 'facealpha', 0.5);
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% END OF PRIMARY SCRIPT
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
return;

% Small sub-function for creating the rotation matrices
function R = Build_Rotation_Matrix(Ax, Ay, Az)
% This function simply builds a rotation matrix given three angles.

Rx = [1,       0,        0;
      0, cos(Ax), -sin(Ax);
      0, sin(Ax),  cos(Ax)];
  
Ry = [cos(Ay), 0, -sin(Ay);
            0, 1, 0;
      sin(Ay), 0,  cos(Ay)];
  
Rz = [cos(Az), -sin(Az), 0;
      sin(Az),  cos(Az), 0;
            0,        0, 1];
  
% Define the Output. The sequence is Z - Y - X
R = Rx*Ry'*Rz;

return