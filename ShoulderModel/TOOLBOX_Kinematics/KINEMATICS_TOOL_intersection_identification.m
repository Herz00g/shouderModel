function IQuad = KINEMATICS_TOOL_intersection_identification(S, T)
% Function for indentifying the type of quadric intersection
%--------------------------------------------------------------------------
% Syntax
% IQuad = KINEMATICS_TOOL_intersection_identification(S, T)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function identifies the type of quadric resulting from the sphere
% ellipsoid intersection.
%--------------------------------------------------------------------------

% Initialise the output
IQuad.Type = '';
IQuad.Axis = '';
IQuad.IndexSwitch = [1,2,3,4];
IQuad.S = S;
IQuad.T = T;
IQuad.Q = S+T;

%--------------------------------------------------------------------------
% Initial Possibilities
%--------------------------------------------------------------------------
% List of Possible Eigenvalues for the intersection quadric
lam(1) = -S(1,1);
lam(2) = -S(2,2);
lam(3) = -S(3,3);

% Selection Index
Idx = 0;

%--------------------------------------------------------------------------
% Selection Process
%--------------------------------------------------------------------------
for i = 1:3
    % Compute the Quadric matrix
    Qi = S + lam(i)*T;
    
    % Get the 3 x 3 sub-matrix
    Qi3 = Qi(1:3,1:3);

    % Get the Eigenvalues
    Eg = eig(Qi3);
    
    % Initialise number of possitive and negative eigen values
    p = 0;
    n = 0;
    for j = 1:3
        if Eg(j,1) > 1.e-8
            p = p+1;
        elseif Eg(j,1) < -1.e-8
            n = n+1;
        end   
    end
    
    % Eigenvalue sign balance
    Ebalance = p - n;
    
    % Test condition
    if Ebalance == 0
        Idx = i;
        break;
    end
end

% Define the intersection Quadric
Q = S + lam(Idx)*T;
Q3 = Q(1:3,1:3);

%--------------------------------------------------------------------------
% STEP 2 : Identify the type of quadric & Principle Direction
%--------------------------------------------------------------------------
TypeList = {'Hyperbolic-Cylinder', 'Hyperbolic Paraboloid'};
AxisList = {'X-axis', 'Y-axis', 'Z-axis'};

% Find the Value on the diagonal which is zero
Idz = find(abs(diag(Q3)) < 1.e-8);

% Set the Quadrics Principle Axis
IQuad.Axis = AxisList{1,Idz};

% Set the Type of quadric for the intersection
if abs(Q(Idz, 4)) < 1.e-8
    IQuad.Type = TypeList{1,1};
else
    IQuad.Type = TypeList{1,2};
end

% Make Sure that the X has positive value
Idx = find(diag(Q3) > 1.e-8);
Idy = find(diag(Q3) < -1.e-8);

% Set the index switch to normalise the quadric
IQuad.IndexSwitch = [Idx, Idy, Idz, 4];

% Set the Quadrics
IQuad.S = S(IQuad.IndexSwitch, IQuad.IndexSwitch);
IQuad.T = T(IQuad.IndexSwitch, IQuad.IndexSwitch);
IQuad.Q = Q(IQuad.IndexSwitch, IQuad.IndexSwitch);

return;