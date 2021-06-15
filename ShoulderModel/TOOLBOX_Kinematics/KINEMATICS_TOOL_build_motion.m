function KEDATA = KINEMATICS_TOOL_build_motion(KEDATAin, BLDATA, REDATA)
% Function for building the kinematic motion of the shoulder.
%--------------------------------------------------------------------------
% Syntax
% KEDATA = KINEMATICS_TOOL_build_motion(KEDATAin, BLDATA, REDATA)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function computes the evolution of the minimal coordinates, 
% bony landmarks, and joint angles, given a desired initial and final
% values of the minimal coordinates.
%--------------------------------------------------------------------------

% Initialise the output
KEDATA = KEDATAin;

%--------------------------------------------------------------------------
% Build the Evolution of the minimal coordinates
%--------------------------------------------------------------------------
X_0   = zeros(9,1); X_T   = zeros(9,1); % initialize the initial and final vectors of minimal coordinates

for i = 1:9
    X_0(i,1) = KEDATA.Initial_Minimal_Coordinate(i,1); % initial minimal coordinates vector
    X_T(i,1) = KEDATA.Final_Minimal_Coordinate(i,1);   % final minimal coordinates vector
end

% Construct the Time
t = linspace(0, 1, KEDATA.NbPoints); % initial and final times are always considered 0 and 1, respectively.

% Time Matrix
Tmat = [t; t.^2; t.^3; t.^4; t.^5; t.^6; t.^7; t.^8; t.^9]; % this is different from what it's considered in the page 167 of the thesis.

% Polynomial Coefficients Matrix. This marix is based on the hypothesis
% that Tf = 1 (always) and that T0 = 0.
% Here the coefficients of a polynomila of order KEDATA.Order(1,i) are
% defined for the ith minimal coordinate evulotion. The maximum order can
% be 9. First based on the defined order a smooth curve is defined for each
% of the coordinates individually and then this curve is exapnded in the y
% direction by DX to account for the final position. Because the
% coefficients are first derived considering 1 as the final position. Then
% the X0 is also added to account for the initial position (Pmat*Pcoef=Bmat).

Pmat = [1, 1, 1,  1,   1,   1,   1,    1,    1;  % Final Condition
        1, 0, 0,  0,   0,   0,   0,    0,    0;  % 1st derivative initial condition
        1, 2, 3,  4,   5,   6,   7,    8,    9;  % 1st derivative final condition
        0, 2, 0,  0,   0,   0,   0,    0,    0;  % 2nd derivative initial condition
        0, 2, 6, 12,  20,  30,  42,   56,   72;  % 2nd derivative final condition
        0, 0, 6,  0,   0,   0,   0,    0,    0;  % 3rd derivative initial condition
        0, 0, 6, 24,  60, 120, 210,  336,  504;  % 3rd derivative final condition
        0, 0, 0, 24,   0,   0,   0,    0,    0;  % 4th derivative initial condition
        0, 0, 0, 24  120, 360, 840, 1680, 3024]; % 4th derivative final condition

% Compute the Evolutions
X_t = zeros(9,size(Tmat,2));
for i = 1:9
    % Compute the total variation
    DX = X_T(i,1) - X_0(i,1);
    
    % Avoid divide by zero
    if abs(DX) > 1.e-6
        Bmat = [DX; KEDATA.DerCond(i,1:KEDATA.Order(1,i)-1)']/DX;
        Pcoef = Pmat(1:KEDATA.Order(1,i), 1:KEDATA.Order(1,i))\Bmat;
        X_t(i,:) = X_0(i,1) + DX*Pcoef'*Tmat(1:KEDATA.Order(1,i),:);
    else
        X_t(i,:) = X_0(i,1)*ones(1,size(Tmat,2));
    end
end
 
% Store the Evolution (Path) of Minimal Coordinates
KEDATA.Coordinate_Evolution.M1 = X_t(1,:);
KEDATA.Coordinate_Evolution.M2 = X_t(2,:);
KEDATA.Coordinate_Evolution.M3 = X_t(3,:);
KEDATA.Coordinate_Evolution.M4 = X_t(4,:);
KEDATA.Coordinate_Evolution.M5 = X_t(5,:);
KEDATA.Coordinate_Evolution.M6 = X_t(6,:);
KEDATA.Coordinate_Evolution.M7 = X_t(7,:);
KEDATA.Coordinate_Evolution.M8 = X_t(8,:);
KEDATA.Coordinate_Evolution.M9 = X_t(9,:);

% Stage_I referes to the first phase among the different stages of the
% scapula motion regarding the scapulohumeral rhythm, (page 18-19 of the thesis).
% note that here only the first phase is considered in contrast with the
% text.

% defining till what time id (Iddx) the arm elevation is less than pi/6.
Stage_I_end = abs(X_t(6,:))-pi/6*ones(1,KEDATA.NbPoints);
[val, Iddx] = min(abs(Stage_I_end));
% until when the arm elevation is less than pi/6 the whole shoulder girdle
% (corresponding to the first 4 minimal coordinates) would not move. For
% thenafter, the position reached till that time is substracted and the x0
% is added --> [0 ... 0, Mi-Mi(rightafter when arm elevation is equal to pi/6)+x0i]
KEDATA.Coordinate_Evolution.M1 = [X_0(1,1)*ones(1,Iddx), KEDATA.Coordinate_Evolution.M1(1,Iddx+1:end)-KEDATA.Coordinate_Evolution.M1(1,Iddx+1)*ones(1,KEDATA.NbPoints-Iddx)+X_0(1,1)*ones(1,KEDATA.NbPoints-Iddx)];
KEDATA.Coordinate_Evolution.M2 = [X_0(2,1)*ones(1,Iddx), KEDATA.Coordinate_Evolution.M2(1,Iddx+1:end)-KEDATA.Coordinate_Evolution.M2(1,Iddx+1)*ones(1,KEDATA.NbPoints-Iddx)+X_0(2,1)*ones(1,KEDATA.NbPoints-Iddx)];
KEDATA.Coordinate_Evolution.M3 = [X_0(3,1)*ones(1,Iddx), KEDATA.Coordinate_Evolution.M3(1,Iddx+1:end)-KEDATA.Coordinate_Evolution.M3(1,Iddx+1)*ones(1,KEDATA.NbPoints-Iddx)+X_0(3,1)*ones(1,KEDATA.NbPoints-Iddx)];
KEDATA.Coordinate_Evolution.M4 = [X_0(4,1)*ones(1,Iddx), KEDATA.Coordinate_Evolution.M4(1,Iddx+1:end)-KEDATA.Coordinate_Evolution.M4(1,Iddx+1)*ones(1,KEDATA.NbPoints-Iddx)+X_0(4,1)*ones(1,KEDATA.NbPoints-Iddx)];

%--------------------------------------------------------------------------
% Build the Bonylandmark Evolutions
%--------------------------------------------------------------------------
% The thorax points are always the same
KEDATA.Point_Evolution.IJ = diag(BLDATA.Initial_Points.IJ)*ones(3,size(t,2));
KEDATA.Point_Evolution.PX = diag(BLDATA.Initial_Points.PX)*ones(3,size(t,2));
KEDATA.Point_Evolution.T8 = diag(BLDATA.Initial_Points.T8)*ones(3,size(t,2));
KEDATA.Point_Evolution.C7 = diag(BLDATA.Initial_Points.C7)*ones(3,size(t,2));

% The SC joint is also always static
KEDATA.Point_Evolution.SC = diag(BLDATA.Initial_Points.SC)*ones(3,size(t,2));

% The Motion of the point AI is already known with the coordinates
AIx = REDATA.Centre(1)*ones(1,size(t,2)) + REDATA.AIaxes(1)*sin(KEDATA.Coordinate_Evolution.M3).*cos(KEDATA.Coordinate_Evolution.M2);
AIy = REDATA.Centre(2)*ones(1,size(t,2)) + REDATA.AIaxes(2)*sin(KEDATA.Coordinate_Evolution.M3).*sin(KEDATA.Coordinate_Evolution.M2);
AIz = REDATA.Centre(3)*ones(1,size(t,2)) + REDATA.AIaxes(3)*cos(KEDATA.Coordinate_Evolution.M3);
KEDATA.Point_Evolution.AI = [AIx; AIy; AIz];

% Build the humerus rotation matrix
Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles',...
    [zeros(1,6), KEDATA.Coordinate_Evolution.M5(1,1), KEDATA.Coordinate_Evolution.M6(1,1),...
    KEDATA.Coordinate_Evolution.M7(1,1), KEDATA.Coordinate_Evolution.M8(1,1),...
    KEDATA.Coordinate_Evolution.M9(1,1)], BLDATA);
Rh = Rmat(:,7:9);

% Initialise the remaining points
KEDATA.Point_Evolution.TS = zeros(3,size(t,2));
KEDATA.Point_Evolution.AA = zeros(3,size(t,2));
KEDATA.Point_Evolution.GH = zeros(3,size(t,2));
KEDATA.Point_Evolution.HU = zeros(3,size(t,2));
KEDATA.Point_Evolution.EL = zeros(3,size(t,2));
KEDATA.Point_Evolution.EM = zeros(3,size(t,2));
KEDATA.Point_Evolution.US = zeros(3,size(t,2));
KEDATA.Point_Evolution.CP = zeros(3,size(t,2));
KEDATA.Point_Evolution.RS = zeros(3,size(t,2));

% Run through the entire motion and build the remaining points and joint
% angles
for TimeId = 1:size(t,2)
    % TS lies on the sphere ellipsoid intersection. This function returns
    % TS in the ellipsoid reference system.
    TSe = KINEMATICS_TOOL_build_TS(KEDATA.Point_Evolution.AI(:,TimeId), KEDATA.Coordinate_Evolution.M4(1,TimeId), REDATA, BLDATA);
    KEDATA.Point_Evolution.TS(:,TimeId) = TSe + REDATA.Centre;
    
    %----------------------------------------------------------------------
    % The Point AC lies on the intersection between three spheres centred
    % at AI, TS and SC. The sphere centres are defined
    O1 = KEDATA.Point_Evolution.SC(:,TimeId);
    O2 = KEDATA.Point_Evolution.TS(:,TimeId);
    O3 = KEDATA.Point_Evolution.AI(:,TimeId);
    
    % The sphere radii are defined
    r1 = norm(BLDATA.Initial_Points.AC - BLDATA.Initial_Points.SC);
    r2 = norm(BLDATA.Initial_Points.AC - BLDATA.Initial_Points.TS);
    r3 = norm(BLDATA.Initial_Points.AC - BLDATA.Initial_Points.AI);
       
    % There are two possible solutions to the three sphere intersection
    PP = KINEMATICS_TOOL_three_sphere_intersect(O1, O2, O3, r1, r2, r3);
    
    % Use the previous point to ensure the right solution is selected
    if TimeId == 1
        % There is no previous solution. Choose the one closest to the
        % initial location of AC
        [Val, Idx] = min([norm(BLDATA.Initial_Points.AC - PP(:,1)), norm(BLDATA.Initial_Points.AC - PP(:,2))]);
        KEDATA.Point_Evolution.AC(:,TimeId) = PP(:,Idx);
    else
        % Use the previous solution
        [Val, Idx] = min([norm(KEDATA.Point_Evolution.AC(:,TimeId-1) - PP(:,1)), norm(KEDATA.Point_Evolution.AC(:,TimeId-1) - PP(:,2))]);
        KEDATA.Point_Evolution.AC(:,TimeId) = PP(:,Idx);
    end
    
    %----------------------------------------------------------------------
    % The point AA lies on the intersection between three spheres centred
    % at AC, TS and AI. The sphere centres are defined
    O1 = KEDATA.Point_Evolution.AC(:,TimeId);
    O2 = KEDATA.Point_Evolution.TS(:,TimeId);
    O3 = KEDATA.Point_Evolution.AI(:,TimeId);
    
    % The sphere radii are defined
    r1 = norm(BLDATA.Initial_Points.AA - BLDATA.Initial_Points.AC);
    r2 = norm(BLDATA.Initial_Points.AA - BLDATA.Initial_Points.TS);
    r3 = norm(BLDATA.Initial_Points.AA - BLDATA.Initial_Points.AI);
        
    % There are two possible solutions to the three sphere intersection
    PP = KINEMATICS_TOOL_three_sphere_intersect(O1, O2, O3, r1, r2, r3);
    
    % Use the previous point to ensure the right solution is selected
    if TimeId == 1
        % There is no previous solution. Choose the one closest to the
        % initial location of AA
        [Val, Idx] = min([norm(BLDATA.Initial_Points.AA - PP(:,1)), norm(BLDATA.Initial_Points.AA - PP(:,2))]);
        KEDATA.Point_Evolution.AA(:,TimeId) = PP(:,Idx);
    else
        % Use the previous solution
        [Val, Idx] = min([norm(KEDATA.Point_Evolution.AA(:,TimeId-1) - PP(:,1)), norm(KEDATA.Point_Evolution.AA(:,TimeId-1) - PP(:,2))]);
        KEDATA.Point_Evolution.AA(:,TimeId) = PP(:,Idx);
    end
    
    %----------------------------------------------------------------------
    % The point GH lies on the intersection between three spheres centred
    % at AC, TS and AI. The sphere centres are defined
    O1 = KEDATA.Point_Evolution.AC(:,TimeId);
    O2 = KEDATA.Point_Evolution.TS(:,TimeId);
    O3 = KEDATA.Point_Evolution.AI(:,TimeId);
    
    % The sphere radii are defined
    r1 = norm(BLDATA.Initial_Points.GH - BLDATA.Initial_Points.AC);
    r2 = norm(BLDATA.Initial_Points.GH - BLDATA.Initial_Points.TS);
    r3 = norm(BLDATA.Initial_Points.GH - BLDATA.Initial_Points.AI);
        
    % There are two possible solutions to the three sphere intersection
    PP = KINEMATICS_TOOL_three_sphere_intersect(O1, O2, O3, r1, r2, r3);
   
    % Use the previous point to ensure the right solution is selected
    if TimeId == 1
        % There is no previous solution. Choose the one closest to the
        % initial location of GH
        [Val, Idx] = min([norm(BLDATA.Initial_Points.GH - PP(:,1)), norm(BLDATA.Initial_Points.GH - PP(:,2))]);
        KEDATA.Point_Evolution.GH(:,TimeId) = PP(:,Idx);
    else
        % Use the previous solution
        [Val, Idx] = min([norm(KEDATA.Point_Evolution.GH(:,TimeId-1) - PP(:,1)), norm(KEDATA.Point_Evolution.GH(:,TimeId-1) - PP(:,2))]);
        KEDATA.Point_Evolution.GH(:,TimeId) = PP(:,Idx);
    end
    
    % Build the humerus, ulna, and radius rotation matrix
    Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles',...
        [zeros(1,6), KEDATA.Coordinate_Evolution.M5(1,TimeId), KEDATA.Coordinate_Evolution.M6(1,TimeId),...
         KEDATA.Coordinate_Evolution.M7(1,TimeId), KEDATA.Coordinate_Evolution.M8(1,TimeId),...
         KEDATA.Coordinate_Evolution.M9(1,TimeId)], BLDATA);
    
    Rh = Rmat(:,7:9);
    Ru = Rmat(:,10:12);
    Rr = Rmat(:,13:15);
    
    % Build the Location of the remaining points   
    KEDATA.Point_Evolution.HU(:,TimeId) =...
        Rh*BLDATA.Initial_Matrices_L2A.Rh'*(BLDATA.Initial_Points.HU - BLDATA.Initial_Points.GH) + KEDATA.Point_Evolution.GH(:,TimeId);
    KEDATA.Point_Evolution.EL(:,TimeId) =...
        Rh*BLDATA.Initial_Matrices_L2A.Rh'*(BLDATA.Initial_Points.EL - BLDATA.Initial_Points.GH) + KEDATA.Point_Evolution.GH(:,TimeId);
    KEDATA.Point_Evolution.EM(:,TimeId) =...
        Rh*BLDATA.Initial_Matrices_L2A.Rh'*(BLDATA.Initial_Points.EM - BLDATA.Initial_Points.GH) + KEDATA.Point_Evolution.GH(:,TimeId);
    KEDATA.Point_Evolution.US(:,TimeId) =...
        Ru*BLDATA.Initial_Matrices_L2A.Ru'*(BLDATA.Initial_Points.US - BLDATA.Initial_Points.HU) + KEDATA.Point_Evolution.HU(:,TimeId);
    KEDATA.Point_Evolution.CP(:,TimeId) =...
        Rh*BLDATA.Initial_Matrices_L2A.Rh'*(BLDATA.Initial_Points.CP - BLDATA.Initial_Points.GH) + KEDATA.Point_Evolution.GH(:,TimeId);
    KEDATA.Point_Evolution.RS(:,TimeId) =...
        Rr*BLDATA.Initial_Matrices_L2A.Rr'*(BLDATA.Initial_Points.RS - BLDATA.Initial_Points.CP) + KEDATA.Point_Evolution.CP(:,TimeId);

    %----------------------------------------------------------------------
    % Only the Clavicula and Scapula rotation matrices need be constructed,
    % because we want to define the JEAs from the rotation matrices. However,
    % for humerus, ulna, and radius the minimal coordinates and the associated
    % joint angles coincide. We could have used the
    % MAIN_TOOL_geometry_functions, but I don't see why we didn't.
    
    % Clavicula Rotation Matrix
    Xc = KEDATA.Point_Evolution.AC(:,TimeId) - KEDATA.Point_Evolution.SC(:,TimeId); Xc = Xc/norm(Xc);
    Yc = cross([0; 0; 1], Xc); Yc = Yc/norm(Yc);
    Zc = cross(Xc, Yc); Zc = Zc/norm(Zc);
    Rc = [Xc, Yc, Zc];                              % Local -> absolute
    
    % Scapula Rotation Matrix
    Xs = KEDATA.Point_Evolution.AA(:,TimeId) - KEDATA.Point_Evolution.TS(:,TimeId); Xs = Xs/norm(Xs);
    Ys = cross(Xs, KEDATA.Point_Evolution.AI(:,TimeId) - KEDATA.Point_Evolution.TS(:,TimeId)); Ys = Ys/norm(Ys);
    Zs = cross(Xs, Ys); Zs = Zs/norm(Zs);
    Rs = [Xs, Ys, Zs];                              % Local -> absolute
    
    % Get the Joint Angles
    % Get Clavicula Euler Angles
    THETAc = asin(-Rc(3,1));         % Elevation/Depression
    PSIc   = atan(Rc(3,2)/Rc(3,3));  % Axial Rotation
    PHIc   = atan(Rc(2,1)/Rc(1,1));  % Protraction/Retraction
    
    % Get Scapula Euler Angles
    THETAs = asin(-Rs(3,1));         % Elevation/Depression
    PSIs   = atan(Rs(3,2)/Rs(3,3));  % Spinal Tilt
    PHIs   = atan(Rs(2,1)/Rs(1,1));  % Protraction/Retraction
    
    % Store the data
    KEDATA.Joint_Angle_Evolution(:,TimeId) = ...
        [KEDATA.Coordinate_Evolution.M1(1,TimeId); THETAc; PHIc; PSIs; THETAs; PHIs; KEDATA.Coordinate_Evolution.M5(1,TimeId); KEDATA.Coordinate_Evolution.M6(1,TimeId); KEDATA.Coordinate_Evolution.M7(1,TimeId); KEDATA.Coordinate_Evolution.M8(1,TimeId); KEDATA.Coordinate_Evolution.M9(1,TimeId)];
end
return;

