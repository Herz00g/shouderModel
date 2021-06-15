function KEDATA = KINEMATICS_TOOL_get_initial_values(REDATA, BLDATA)
% Function for getting the initial values of the coordinates
%--------------------------------------------------------------------------
% Syntax :
% MC0 = KINEMATICS_TOOL_get_initial_values(REDATA, BLDATA)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function computes the initial values of all the minimal coordinates
% based on the initial bony landmark structure.
%--------------------------------------------------------------------------

% Initialiase the Output
KEDATA = [];

% Get the Initial Joint Angles
JEA0 = MAIN_TOOL_geometry_functions('Get Euler Angles From Initial Rotation Matrices', BLDATA);

% Initial Joint Angles
KEDATA.Initial_Joint_Angles = JEA0;

%--------------------------------------------------------------------------
% The First Initial Minimal Coordinate: Clavicual Axial Rotation
%--------------------------------------------------------------------------
KEDATA.Initial_Minimal_Coordinate(1,1) = JEA0(1);

%--------------------------------------------------------------------------
% Second & Third Initial Minimal Coordinates: AI spherical coordinates
%--------------------------------------------------------------------------
% Get the AI coordinates
AIx = BLDATA.Initial_Points.AI(1) - REDATA.Centre(1);
AIy = BLDATA.Initial_Points.AI(2) - REDATA.Centre(2);
AIz = BLDATA.Initial_Points.AI(3) - REDATA.Centre(3);

Ax = REDATA.AIaxes(1);
Ay = REDATA.AIaxes(2);
Az = REDATA.AIaxes(3);

% The position of AI, with respect to the ellipsoid centre is :
% AIx = Ax sin(M3) cos(M2)
% AIy = Ay sin(M3) sin(M2)
% AIz = Az cos(M3)
KEDATA.Initial_Minimal_Coordinate(3,1) = acos(AIz/Az);
KEDATA.Initial_Minimal_Coordinate(2,1) = atan2(AIy*Ax,AIx*Ay);

%--------------------------------------------------------------------------
% The Fourth Initial Minimal Coordinates: TS intersection Coordinate
%--------------------------------------------------------------------------
mu0 = KINEMATICS_TOOL_get_TS_intersect_coordinate(REDATA, BLDATA);
KEDATA.Initial_Minimal_Coordinate(4,1) = mu0;

%--------------------------------------------------------------------------
% The Fifth to Seventh Initial Minimal Coordinates: Glenohumeral Joint Angles
%--------------------------------------------------------------------------
% These values are inintialised a bit differently
KEDATA.Initial_Minimal_Coordinate(5,1) = 0;%JEA0(7);%
KEDATA.Initial_Minimal_Coordinate(6,1) = -1*pi/180;%JEA0(8);%
KEDATA.Initial_Minimal_Coordinate(7,1) = 30*pi/180;%JEA0(9);%

%--------------------------------------------------------------------------
% The Eighth and Nineth Initial Minimal Coordinates: Humeroulnar and Radiulnar Joint Angles
%--------------------------------------------------------------------------
% These values might be inintialized a bit differently
KEDATA.Initial_Minimal_Coordinate(8,1) = JEA0(10);%0*pi/180;  %JEA0(8); 
KEDATA.Initial_Minimal_Coordinate(9,1) = JEA0(11);%0*pi/180;  %JEA0(9);

%--------------------------------------------------------------------------
% Set the final values and build an initial motion
%--------------------------------------------------------------------------
% Set the Final Values (these values were obtained from initial testing,
% they are not necessarily the best)
KEDATA.Final_Minimal_Coordinate(1,1) = 30*pi/180;
KEDATA.Final_Minimal_Coordinate(2,1) = -40*pi/180;
KEDATA.Final_Minimal_Coordinate(3,1) = 90*pi/180;
KEDATA.Final_Minimal_Coordinate(4,1) = KEDATA.Initial_Minimal_Coordinate(4,1)+0.07;
KEDATA.Final_Minimal_Coordinate(5,1) = 0*pi/180;
KEDATA.Final_Minimal_Coordinate(6,1) = -140*pi/180;
KEDATA.Final_Minimal_Coordinate(7,1) = 30*pi/180;
KEDATA.Final_Minimal_Coordinate(8,1) = JEA0(10);%0*pi/180;
KEDATA.Final_Minimal_Coordinate(9,1) = JEA0(11);%0*pi/180;

% Set the polynomial orders
KEDATA.Order = 5*ones(1,9);

% Set the Derivative Conditions
KEDATA.DerCond = zeros(9,8);

% Number of way points
KEDATA.NbPoints = 100;

%--------------------------------------------------------------------------
% Build an initial motion
%--------------------------------------------------------------------------
% This function will set the following elements of KEDATA
% KEDATA.Joint_Angle_Evolution
% KEDATA.Coordinate_Evolution.M1
% KEDATA.Coordinate_Evolution.M2
% KEDATA.Coordinate_Evolution.M3
% KEDATA.Coordinate_Evolution.M4
% KEDATA.Coordinate_Evolution.M5
% KEDATA.Coordinate_Evolution.M6
% KEDATA.Coordinate_Evolution.M7
% KEDATA.Coordinate_Evolution.M8
% KEDATA.Coordinate_Evolution.M9
% KEDATA.Point_Evolution.IJ
% KEDATA.Point_Evolution.PX
% KEDATA.Point_Evolution.T8
% KEDATA.Point_Evolution.C7
% KEDATA.Point_Evolution.SC
% KEDATA.Point_Evolution.AC
% KEDATA.Point_Evolution.AA
% KEDATA.Point_Evolution.TS
% KEDATA.Point_Evolution.AI
% KEDATA.Point_Evolution.GH
% KEDATA.Point_Evolution.HU
% KEDATA.Point_Evolution.EL
% KEDATA.Point_Evolution.EM
% KEDATA.Point_Evolution.CP
% KEDATA.Point_Evolution.US
% KEDATA.Point_Evolution.RS
KEDATA = KINEMATICS_TOOL_build_motion(KEDATA, BLDATA, REDATA);
return;