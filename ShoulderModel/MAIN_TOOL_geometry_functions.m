function Output = MAIN_TOOL_geometry_functions(task, varargin)
% Function containing all geometry related tasks.
%{
--------------------------------------------------------------------------
Syntax :
Output = MAIN_TOOL_geometry_functions(task, varargin)
--------------------------------------------------------------------------

File Description :
This file contains all the routines related to geometry. These routines
affect the intial and current geometric configuration of the model.

This function can have multiple intputs depending on the task. However,
the first input is always the desired to task to be performed. The list
of tasks are as follows:

  Task 1 : Build Rotation Matrices From Euler Angles
  Task 2 : Get Euler Angles From Original Rotation Matrices
  Task 3 : Get Euler Angles From Initial Rotation Matrices
  Task 4 : Get Euler Angles From Current Rotation Matrices
  Task 5 : Rotate Points From Local To Global Frame (Initial)
  Task 6 : Rotate Points From Global To Local Frame (Initial)
  Task 7 : Rotate Points From Local To Global Frame (Current)
  Task 8 : Rotate Points From Global To Local Frame (Current)
  Task 9 : Update Initial Bony Landmark Data from Joint Rotation Matrices
  Task 10: Update Current Bony Landmark Data from Joint Rotation Matrices

--------------------------------------------------------------------------
%}
% Initialise the Output
Output = [];

%--------------------------------------------------------------------------
% TASK 1 : BUILD ROTATION MATRICES
% Inputs :
%   1) Task
%   2) Joint Euler angles
% Outputs :
%   A single array containing three joint rotation matrices [Rc, Rs, Rh] 
%--------------------------------------------------------------------------
if isequal(task, 'Build Rotation Matrices From Euler Angles')
    
    % Get the Joint Angles
    JEA = varargin{1,1};% varargin is a 1-by-N cell array, where N is the number of inputs that the function receives after the explicitly declared inputs
    
    BLDATA = varargin{1,2}; % lately added to feed in the BLDATA for the rotation matrices of the ulna and radius regarding their proximal segments
    
    % Clavicula Rotation Matrix
    Rcx = [1.00,      0.0000,       0.0000;
           0.00, cos(JEA(1)), -sin(JEA(1));
           0.00, sin(JEA(1)),  cos(JEA(1))];
       
    Rcy = [cos(JEA(2)), 0.00, -sin(JEA(2));
                0.0000, 1.00,       0.0000;
           sin(JEA(2)), 0.00,  cos(JEA(2))];
       
    Rcz = [cos(JEA(3)), -sin(JEA(3)), 0.00;
           sin(JEA(3)),  cos(JEA(3)), 0.00;
                0.0000,       0.0000, 1.00];
       
    Rc = Rcz*Rcy'*Rcx;
    
    % Scapula Rotation Matrix
    Rsx = [1.00,      0.0000,       0.0000;
           0.00, cos(JEA(4)), -sin(JEA(4));
           0.00, sin(JEA(4)),  cos(JEA(4))];
       
    Rsy = [cos(JEA(5)), 0.00, -sin(JEA(5));
                0.0000, 1.00,       0.0000;
           sin(JEA(5)), 0.00,  cos(JEA(5))];
       
    Rsz = [cos(JEA(6)), -sin(JEA(6)), 0.00;
           sin(JEA(6)),  cos(JEA(6)), 0.00;
                0.0000,       0.0000, 1.00];
       
    Rs = Rsz*Rsy'*Rsx;
    
    % Humerus Rotation Matrix
    Rhz = [cos(JEA(7)), -sin(JEA(7)), 0.00;
           sin(JEA(7)),  cos(JEA(7)), 0.00;
                0.0000,       0.0000, 1.00];
       
    Rhy = [cos(JEA(8)), 0.00, -sin(JEA(8));
                0.0000, 1.00,       0.0000;
           sin(JEA(8)), 0.00,  cos(JEA(8))];
       
    Rhzz = [cos(JEA(9)), -sin(JEA(9)), 0.00;
            sin(JEA(9)),  cos(JEA(9)), 0.00;
                 0.0000,       0.0000, 1.00];
     
    Rh = Rhzz*Rhy'*Rhz;
    
    %Ulna Rotation Matrix
    Rux = [1.00,          0.00,          0.00; 
           0.00,  cos(JEA(10)), -sin(JEA(10)); 
           0.00,  sin(JEA(10)),  cos(JEA(10))];% ulna to the proximal segment part 1
       
    Ru_h = BLDATA.Original_Matrices_L2A.Rh'*BLDATA.Original_Matrices_L2A.Ru; % ulna to the proximal segment part 1
    
    Ru = Rh*Ru_h*Rux;         % ulna to the inertial frame (thorax)
    
    %Radius Rotation Matrix
    Rrz = [cos(JEA(11)), -sin(JEA(11)), 0.00; 
           sin(JEA(11)),  cos(JEA(11)), 0.00; 
                   0.00,          0.00, 1.00]; % radius to the proximal segment part 1
    
    Rr_u = BLDATA.Original_Matrices_L2A.Ru'*BLDATA.Original_Matrices_L2A.Rr; % radius to the proximal segment part 2
    
    Rr = Ru*Rr_u*Rrz;                               % radius to the inertial frame (thorax)

    Output = [Rc, Rs, Rh, Ru, Rr];

%--------------------------------------------------------------------------
% TASK 2 : EXTRACT EULER ANGLES FROM ORIGINAL MATRICES
% Inputs :
%   1) Task
%   2) BLDATA : Bonylandmark data structure
% Outputs :
%   A single array containing nine joint rotation angles
%--------------------------------------------------------------------------
elseif isequal(task, 'Get Euler Angles From Original Rotation Matrices')
    
    % Get the Rotation Matrices
    BLDATA = varargin{1,1};
    
    Rc = BLDATA.Original_Matrices_L2A.Rc;
    Rs = BLDATA.Original_Matrices_L2A.Rs;
    Rh = BLDATA.Original_Matrices_L2A.Rh;
    Ru = BLDATA.Original_Matrices_L2A.Ru;
    Rr = BLDATA.Original_Matrices_L2A.Rr;
    
    % Get Clavicula Euler Angles
    THETAc = asin(-Rc(3,1));         % Elevation/Depression
    PSIc   = atan(Rc(3,2)/Rc(3,3));  % Axial Rotation
    PHIc   = atan(Rc(2,1)/Rc(1,1));  % Protraction/Retraction
    
    % Get Scapula Euler Angles
    THETAs = asin(-Rs(3,1));         % Elevation/Depression
    PSIs   = atan(Rs(3,2)/Rs(3,3));  % Spinal Tilt
    PHIs   = atan(Rs(2,1)/Rs(1,1));  % Protraction/Retraction
    
    % Get Humerus Euler Angles
    THETAh = acos(Rh(3,3));           % Abduction/Adduction
    PSIh   = atan2(Rh(3,2),-Rh(3,1)); % Axial Rotation
    PHIh   = atan2(Rh(2,3),Rh(1,3));  % Elevation Plane
    
    % Get Ulna Euler Angles
    Ru_h = BLDATA.Original_Matrices_L2A.Rh'*BLDATA.Original_Matrices_L2A.Ru; 
        
    Rux=Ru_h'*Rh'*Ru;
    
    THETAu = atan2(Rux(3,2),Rux(2,2)); % Flexion/Extension

    % Get Ulna Euler Angles
    Rr_u = BLDATA.Original_Matrices_L2A.Ru'*BLDATA.Original_Matrices_L2A.Rr; 
    
    Rrz = Rr_u'*Ru'*Rr;
    
    THETAr = atan2(Rrz(2,1),Rrz(1,1)); % Pronation/Supination
    
    % Save The Euler Angles
    Output = [PSIc, THETAc, PHIc, PSIs, THETAs, PHIs, PSIh, THETAh, PHIh, THETAu, THETAr];
    
%--------------------------------------------------------------------------
% TASK 3 : EXTRACT EULER ANGLES FROM INITIAL MATRICES
% Inputs :
%   1) Task
%   2) BLDATA : Bonylandmark data structure
% Outputs :
%   A single array containing nine joint rotation angles
%--------------------------------------------------------------------------
elseif isequal(task, 'Get Euler Angles From Initial Rotation Matrices')
    
    % Get the Rotation Matrices
    BLDATA = varargin{1,1};
    
    Rc = BLDATA.Initial_Matrices_L2A.Rc;
    Rs = BLDATA.Initial_Matrices_L2A.Rs;
    Rh = BLDATA.Initial_Matrices_L2A.Rh;
    Ru = BLDATA.Initial_Matrices_L2A.Ru;
    Rr = BLDATA.Initial_Matrices_L2A.Rr;
    
    % Get Clavicula Euler Angles
    THETAc = asin(-Rc(3,1));         % Elevation/Depression
    PSIc   = atan(Rc(3,2)/Rc(3,3));  % Axial Rotation
    PHIc   = atan(Rc(2,1)/Rc(1,1));  % Protraction/Retraction
    
    % Get Scapula Euler Angles
    THETAs = asin(-Rs(3,1));         % Elevation/Depression
    PSIs   = atan(Rs(3,2)/Rs(3,3));  % Spinal Tilt
    PHIs   = atan(Rs(2,1)/Rs(1,1));  % Protraction/Retraction
    
    % Get Humerus Euler Angles
    THETAh = acos(Rh(3,3));           % Abduction/Adduction
    PSIh   = atan2(Rh(3,2),-Rh(3,1)); % Axial Rotation
    PHIh   = atan2(Rh(2,3),Rh(1,3));  % Elevation Plane
    
    % Get Ulna Euler Angles
    Ru_h = BLDATA.Original_Matrices_L2A.Rh'*BLDATA.Original_Matrices_L2A.Ru;
    
    Rux=Ru_h'*Rh'*Ru;
    %Rux=Rh'*Ru;
    THETAu = atan2(Rux(3,2),Rux(2,2)); % Flexion/Extension
    
    % Get Radius Euler Angles
    Rr_u = BLDATA.Original_Matrices_L2A.Ru'*BLDATA.Original_Matrices_L2A.Rr;
        
    Rrz = Rr_u'*Ru'*Rr;
    %Rrz=Ru'*Rr;
    THETAr = atan2(Rrz(2,1),Rrz(1,1)); % Pronation/Supination
    
    % Save The Euler Angles
    Output = [PSIc, THETAc, PHIc, PSIs, THETAs, PHIs, PSIh, THETAh, PHIh, THETAu, THETAr];
    
%--------------------------------------------------------------------------
% TASK 4: EXTRACT EULER ANGLES FROM CURRENT MATRICES
% Inputs :
%   1) Task
%   2) BLDATA : Bonylandmark data structure
% Outputs :
%   A single array containing nine joint rotation angles
%--------------------------------------------------------------------------
elseif isequal(task, 'Get Euler Angles From Current Rotation Matrices')
    
    % Get the Rotation Matrices
    BLDATA = varargin{1,1};
    
    Rc = BLDATA.Current_Matrices_L2A.Rc;
    Rs = BLDATA.Current_Matrices_L2A.Rs;
    Rh = BLDATA.Current_Matrices_L2A.Rh;
    Ru = BLDATA.Current_Matrices_L2A.Ru;
    Rr = BLDATA.Current_Matrices_L2A.Rr;
    
    % Get Clavicula Euler Angles
    THETAc = asin(-Rc(3,1));         % Elevation/Depression
    PSIc   = atan(Rc(3,2)/Rc(3,3));  % Axial Rotation
    PHIc   = atan(Rc(2,1)/Rc(1,1));  % Protraction/Retraction
    
    % Get Scapula Euler Angles
    THETAs = asin(-Rs(3,1));         % Elevation/Depression
    PSIs   = atan(Rs(3,2)/Rs(3,3));  % Spinal Tilt
    PHIs   = atan(Rs(2,1)/Rs(1,1));  % Protraction/Retraction
    
    % Get Humerus Euler Angles
    THETAh = acos(Rh(3,3));           % Abduction/Adduction
    PSIh   = atan2(Rh(3,2),-Rh(3,1)); % Axial Rotation
    PHIh   = atan2(Rh(2,3),Rh(1,3));  % Elevation Plane
    
    % Get Ulna Euler Angles
    Ru_h = BLDATA.Original_Matrices_L2A.Rh'*BLDATA.Original_Matrices_L2A.Ru;
        
    Rux=Ru_h'*Rh'*Ru;
    %Rux=Rh'*Ru;
    THETAu = atan2(Rux(3,2),Rux(2,2)); % Flexion/Extension
    
    % Get Ulna Euler Angles
    Rr_u = BLDATA.Original_Matrices_L2A.Ru'*BLDATA.Original_Matrices_L2A.Rr;
        
    Rrz = Rr_u'*Ru'*Rr;
    %Rrz=Ru'*Rr;
    THETAr = atan2d(Rrz(2,1),Rrz(1,1)); % Pronation/Supination
    
    % Save The Euler Angles
    Output = [PSIc, THETAc, PHIc, PSIs, THETAs, PHIs, PSIh, THETAh, PHIh, THETAu, THETAr];
    
%--------------------------------------------------------------------------
% TASK 5: ROTATE A SET OF POINTS INTO THE GLOBAL FRAME (INITIAL CONFIG)
% Inputs :
%   1) Task
%   2) Q : The list of points (3 x n) 
%   3) BLDATA : Bonylandmark data structure
%   4) frameId : local frame in which the points are defined
% Outputs :
%   A single (3 x n) array containing the transformed points
%--------------------------------------------------------------------------
elseif isequal(task, 'Rotate Points From Local To Global Frame (Initial)')
    % Get the List of points
    Q = varargin{1,1};
    
    % Get the BLDATA structure
    BLDATA = varargin{1,2};
    
    % Get the Frame Identification
    frameId = varargin{1,3};
    
    % Initialise the output
    Output = Q;
    
    % Get the Current Rotation Matrices (Local -> Absolute)
    Rc = BLDATA.Initial_Matrices_L2A.Rc;
    Rs = BLDATA.Initial_Matrices_L2A.Rs;
    Rh = BLDATA.Initial_Matrices_L2A.Rh;
    Ru = BLDATA.Initial_Matrices_L2A.Ru;
    Rr = BLDATA.Initial_Matrices_L2A.Rr;
    
    % Get the necessary bony landmarks
    SC = BLDATA.Initial_Points.SC;
    AA = BLDATA.Initial_Points.AA;
    GH = BLDATA.Initial_Points.GH;
    HU = BLDATA.Initial_Points.HU;
    CP = BLDATA.Initial_Points.CP;
    
    % Rotate the set of points
    for i = 1:size(Q,2)
        % Transform point
        if frameId == 0
            Output(:,i) = P(:,i);
        elseif frameId == 1
            Output(:,i) = Rc*Q(:,i) + SC;
        elseif frameId == 2
            Output(:,i) = Rs*Q(:,i) + AA;
        elseif frameId == 3
            Output(:,i) = Rh*Q(:,i) + GH;
        elseif frameId == 4
            Output(:,i) = Ru*Q(:,i) + HU;
        elseif frameId == 5
            Output(:,i) = Rr*Q(:,i) + CP;
        else
            % The wrong frame was provided
        end
    end
%--------------------------------------------------------------------------
% TASK 6: ROTATE A SET OF POINTS INTO A LOCAL FRAME (INITIAL CONFIG)
% Inputs :
%   1) Task
%   2) Q : The list of points (3 x n) 
%   3) BLDATA : Bonylandmark data structure
%   4) frameId : local frame in which the points are to be transformed
% Outputs :
%   A single (3 x n) array containing the transformed points
%--------------------------------------------------------------------------
elseif isequal(task, 'Rotate Points From Global To Local Frame (Initial)')
    % Get the List of points
    Q = varargin{1,1};
    
    % Get the BLDATA structure
    BLDATA = varargin{1,2};
    
    % Get the Frame Identification
    frameId = varargin{1,3};
    
    % Initialise the output
    Output = Q;

    % Get the Current Rotation Matrices (Local -> Absolute)
    Rc = BLDATA.Initial_Matrices_L2A.Rc;
    Rs = BLDATA.Initial_Matrices_L2A.Rs;
    Rh = BLDATA.Initial_Matrices_L2A.Rh;
    Ru = BLDATA.Initial_Matrices_L2A.Ru;
    Rr = BLDATA.Initial_Matrices_L2A.Rr;
    
    % Get the necessary bony landmarks
    SC = BLDATA.Initial_Points.SC;
    AA = BLDATA.Initial_Points.AA;
    GH = BLDATA.Initial_Points.GH;
    HU = BLDATA.Initial_Points.HU;
    CP = BLDATA.Initial_Points.CP;
    
    % Rotate the set of points
    for i = 1:size(Q,2)
        % Transform point
        if frameId == 0
            Output(:,i) = Q(:,i);
        elseif frameId == 1
            Output(:,i) = Rc'*(Q(:,i) - SC);
        elseif frameId == 2
            Output(:,i) = Rs'*(Q(:,i) - AA);
        elseif frameId == 3
            Output(:,i) = Rh'*(Q(:,i) - GH);
        elseif frameId == 4
            Output(:,i) = Ru'*(Q(:,i) - HU);
        elseif frameId == 5
            Output(:,i) = Rr'*(Q(:,i) - CP);
        else
            % The wrong frame was provided
        end
    end
%--------------------------------------------------------------------------
% TASK 7: ROTATE A SET OF POINTS INTO THE GLOBAL FRAME (CURRENT CONFIG)
% Inputs :
%   1) Task
%   2) Q : The list of points (3 x n) 
%   3) BLDATA : Bonylandmark data structure
%   4) frameId : local frame in which the points are defined
% Outputs :
%   A single (3 x n) array containing the transformed points
%--------------------------------------------------------------------------
elseif isequal(task, 'Rotate Points From Local To Global Frame (Current)')
    % Get the List of points
    Q = varargin{1,1};
    
    % Get the BLDATA structure
    BLDATA = varargin{1,2};
    
    % Get the Frame Identification
    frameId = varargin{1,3};
    
    % Initialise the output
    Output = Q;
    
    % Get the Current Rotation Matrices (Local -> Absolute)
    Rc = BLDATA.Current_Matrices_L2A.Rc;
    Rs = BLDATA.Current_Matrices_L2A.Rs;
    Rh = BLDATA.Current_Matrices_L2A.Rh;
    Ru = BLDATA.Current_Matrices_L2A.Ru;
    Rr = BLDATA.Current_Matrices_L2A.Rr;
    % Get the necessary bony landmarks
    SC = BLDATA.Current_Points.SC;
    AA = BLDATA.Current_Points.AA;
    GH = BLDATA.Current_Points.GH;
    HU = BLDATA.Current_Points.HU;
    CP = BLDATA.Current_Points.CP;
    
    % Rotate the set of points
    for i = 1:size(Q,2)
        % Transform point
        if frameId == 0
            Output(:,i) = Q(:,i);
        elseif frameId == 1
            Output(:,i) = Rc*Q(:,i) + SC;
        elseif frameId == 2
            Output(:,i) = Rs*Q(:,i) + AA;
        elseif frameId == 3
            Output(:,i) = Rh*Q(:,i) + GH;
        elseif frameId == 4
            Output(:,i) = Ru*Q(:,i) + HU;
        elseif frameId == 5
            Output(:,i) = Rr*Q(:,i) + CP;
        else
            % The wrong frame was provided
        end
    end
%--------------------------------------------------------------------------
% TASK 8: ROTATE A SET OF POINTS INTO A LOCAL FRAME (Current CONFIG)
% Inputs :
%   1) Task
%   2) Q : The list of points (3 x n) 
%   3) BLDATA : Bonylandmark data structure
%   4) frameId : local frame in which the points are to be transformed
% Outputs :
%   A single (3 x n) array containing the transformed points
%--------------------------------------------------------------------------
elseif isequal(task, 'Rotate Points From Global To Local Frame (Current)')
    % Get the List of points
    Q = varargin{1,1};
    
    % Get the BLDATA structure
    BLDATA = varargin{1,2};
    
    % Get the Frame Identification
    frameId = varargin{1,3};
    
    % Initialise the output
    Output = Q;

    % Get the Current Rotation Matrices (Local -> Absolute)
    Rc = BLDATA.Current_Matrices_L2A.Rc;
    Rs = BLDATA.Current_Matrices_L2A.Rs;
    Rh = BLDATA.Current_Matrices_L2A.Rh;
    Ru = BLDATA.Current_Matrices_L2A.Ru;
    Rr = BLDATA.Current_Matrices_L2A.Rr;
    
    % Get the necessary bony landmarks
    SC = BLDATA.Current_Points.SC;
    AA = BLDATA.Current_Points.AA;
    GH = BLDATA.Current_Points.GH;
    HU = BLDATA.Current_Points.HU;
    CP = BLDATA.Current_Points.CP;
    
    % Rotate the set of points
    for i = 1:size(Q,2)
        % Transform point
        if frameId == 0
            Output(:,i) = Q(:,i);
        elseif frameId == 1
            Output(:,i) = Rc'*(Q(:,i) - SC);
        elseif frameId == 2
            Output(:,i) = Rs'*(Q(:,i) - AA);% why this point is AA?
        elseif frameId == 3
            Output(:,i) = Rh'*(Q(:,i) - GH);
        elseif frameId == 4
            Output(:,i) = Ru'*(Q(:,i) - HU);
        elseif frameId == 5
            Output(:,i) = Rr'*(Q(:,i) - CP);
        else
            % The wrong frame was provided
        end
    end
%--------------------------------------------------------------------------
% TASK 9: UPDATE BONY LANDMARK DATA FROM JOINT ROTATION MATRICES
% Inputs :
%   1) Task
%   2) Rc : SC rotation matrix 
%   3) Rs : AC rotation matrix 
%   4) Rh : GH rotation matrix
%   5) Ru : HU rotation matrix 
%   6) Rr : RU rotation matrix 
%   7) BLDATA : bonylandmark data
% Outputs :
%   BLDATA : the bony landmark data with updated initial configuration
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Initial Bony Landmark Data from Joint Rotation Matrices')
    % Get the SC joint rotation matrix
    Rc = varargin{1,1};
    
    % Get the AC joint rotation matrix
    Rs = varargin{1,2};
    
    % Get the GH joint rotation matrix
    Rh = varargin{1,3};

    % Get the HU joint rotation matrix
    Ru = varargin{1,4};
    
    % Get the RU joint rotation matrix
    Rr = varargin{1,5};
    
    % Get the BLDATA input
    BLDATA = varargin{1,6};
    
    % Get Initial Rotation Matrices
    Rci = BLDATA.Original_Matrices_L2A.Rc;
    Rsi = BLDATA.Original_Matrices_L2A.Rs;
    Rhi = BLDATA.Original_Matrices_L2A.Rh;
    Rui = BLDATA.Original_Matrices_L2A.Ru;
    Rri = BLDATA.Original_Matrices_L2A.Rr;
    
    % Ge all the points (these points are in the thorax frame i.e. matlab frame)
    IJ = BLDATA.Original_Points.IJ;
    PX = BLDATA.Original_Points.PX;
    T8 = BLDATA.Original_Points.T8;
    C7 = BLDATA.Original_Points.C7;
    SC = BLDATA.Original_Points.SC;
    AC = BLDATA.Original_Points.AC;
    AA = BLDATA.Original_Points.AA;
    TS = BLDATA.Original_Points.TS;
    AI = BLDATA.Original_Points.AI;
    GH = BLDATA.Original_Points.GH;
    HU = BLDATA.Original_Points.HU;
    EL = BLDATA.Original_Points.EL;
    EM = BLDATA.Original_Points.EM;
    CP = BLDATA.Original_Points.CP;
    US = BLDATA.Original_Points.US;
    RS = BLDATA.Original_Points.RS;
    
    % Set the Points
    BLDATA.Initial_Points.IJ = IJ;
    BLDATA.Initial_Points.PX = PX;
    BLDATA.Initial_Points.T8 = T8;
    BLDATA.Initial_Points.C7 = C7;
    BLDATA.Initial_Points.SC = SC;
    BLDATA.Initial_Points.AC = Rc*Rci'*(AC - SC) + BLDATA.Initial_Points.SC;% Rci'*(AC - SC) is AC in Clavicle coordinate, so with the rotation matrix Rc we can define its new position in the inertial frame as such.
    BLDATA.Initial_Points.AA = Rs*Rsi'*(AA - AC) + BLDATA.Initial_Points.AC;
    BLDATA.Initial_Points.TS = Rs*Rsi'*(TS - AC) + BLDATA.Initial_Points.AC;
    BLDATA.Initial_Points.AI = Rs*Rsi'*(AI - AC) + BLDATA.Initial_Points.AC;
    BLDATA.Initial_Points.GH = Rs*Rsi'*(GH - AC) + BLDATA.Initial_Points.AC;
    BLDATA.Initial_Points.HU = Rh*Rhi'*(HU - GH) + BLDATA.Initial_Points.GH;
    BLDATA.Initial_Points.EL = Rh*Rhi'*(EL - GH) + BLDATA.Initial_Points.GH;
    BLDATA.Initial_Points.EM = Rh*Rhi'*(EM - GH) + BLDATA.Initial_Points.GH;
    BLDATA.Initial_Points.US = Ru*Rui'*(US - HU) + BLDATA.Initial_Points.HU;
    BLDATA.Initial_Points.CP = Rh*Rhi'*(CP - GH) + BLDATA.Initial_Points.GH;
    BLDATA.Initial_Points.RS = Rr*Rri'*(RS - CP) + BLDATA.Initial_Points.CP;
    
    % Set the Rotation Matrices
    BLDATA.Initial_Matrices_L2A.Rc = Rc;
    BLDATA.Initial_Matrices_L2A.Rs = Rs;
    BLDATA.Initial_Matrices_L2A.Rh = Rh;
    BLDATA.Initial_Matrices_L2A.Ru = Ru;
    BLDATA.Initial_Matrices_L2A.Rr = Rr;
    
    % Set the wire frame bones
    BLDATA.Initial_WFBones.Thorax = [IJ, PX, T8, C7, IJ];
    BLDATA.Initial_WFBones.Clavicula = ...
       [BLDATA.Initial_Points.SC,...
        BLDATA.Initial_Points.AC];
    BLDATA.Initial_WFBones.Scapula = ...
       [BLDATA.Initial_Points.AC,...
        BLDATA.Initial_Points.AA,...
        BLDATA.Initial_Points.TS,...
        BLDATA.Initial_Points.AI,...
        BLDATA.Initial_Points.GH,...
        BLDATA.Initial_Points.AC];
    BLDATA.Initial_WFBones.Humerus =...
       [BLDATA.Initial_Points.GH,...
        BLDATA.Initial_Points.HU,...
        BLDATA.Initial_Points.EL,...
        BLDATA.Initial_Points.EM];
    BLDATA.Initial_WFBones.Ulna =...
       [BLDATA.Initial_Points.CP,...
        BLDATA.Initial_Points.HU,...
        BLDATA.Initial_Points.EM,...
        BLDATA.Initial_Points.US];
    BLDATA.Initial_WFBones.Radius =...
       [BLDATA.Initial_Points.CP,...
        BLDATA.Initial_Points.RS];

    % Set the Garner and Pandy Scapular Rotation Matrix
    Zaxis = BLDATA.Initial_Points.AC - BLDATA.Initial_Points.GH; Zaxis = Zaxis/norm(Zaxis);
    Yaxis = cross(Zaxis, BLDATA.Initial_Points.AC - BLDATA.Initial_Points.TS); Yaxis = Yaxis/norm(Yaxis);
    Xaxis = cross(Yaxis, Zaxis); Xaxis = Xaxis/norm(Xaxis);
    
    % Set the rotation matrix
    BLDATA.Initial_GnP.Rs = [Xaxis, Yaxis, Zaxis];

    % Set the output
    Output = BLDATA;
%--------------------------------------------------------------------------
% TASK 10: UPDATE BONY LANDMARK DATA FROM JOINT ROTATION MATRICES
% Inputs :
%   1) Task
%   2) Rc : SC rotation matrix 
%   3) Rs : AC rotation matrix 
%   4) Rh : GH rotation matrix
%   5) Ru : HU rotation matrix 
%   6) Rr : RU rotation matrix
%   7) BLDATA : bonylandmark data
% Outputs :
%   BLDATA : the bony landmark data with updated current configuration
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Current Bony Landmark Data from Joint Rotation Matrices')
    % Get the SC joint rotation matrix
    Rc = varargin{1,1};
    
    % Get the AC joint rotation matrix
    Rs = varargin{1,2};
    
    % Get the GH joint rotation matrix
    Rh = varargin{1,3};

    % Get the HU joint rotation matrix
    Ru = varargin{1,4};
    
    % Get the RU joint rotation matrix
    Rr = varargin{1,5};
    
    % Get the BLDATA input
    BLDATA = varargin{1,6};
    
    % Get Initial Rotation Matrices
    Rci = BLDATA.Initial_Matrices_L2A.Rc;
    Rsi = BLDATA.Initial_Matrices_L2A.Rs;
    Rhi = BLDATA.Initial_Matrices_L2A.Rh;
    Rui = BLDATA.Initial_Matrices_L2A.Ru;
    Rri = BLDATA.Initial_Matrices_L2A.Rr;
    
    % Ge all the points
    IJ = BLDATA.Initial_Points.IJ;
    PX = BLDATA.Initial_Points.PX;
    T8 = BLDATA.Initial_Points.T8;
    C7 = BLDATA.Initial_Points.C7;
    SC = BLDATA.Initial_Points.SC;
    AC = BLDATA.Initial_Points.AC;
    AA = BLDATA.Initial_Points.AA;
    TS = BLDATA.Initial_Points.TS;
    AI = BLDATA.Initial_Points.AI;
    GH = BLDATA.Initial_Points.GH;
    HU = BLDATA.Initial_Points.HU;
    EL = BLDATA.Initial_Points.EL;
    EM = BLDATA.Initial_Points.EM;
    CP = BLDATA.Initial_Points.CP;
    US = BLDATA.Initial_Points.US;
    RS = BLDATA.Initial_Points.RS;
    
    % Rotate all points
    BLDATA.Current_Points.IJ = IJ;
    BLDATA.Current_Points.PX = PX;
    BLDATA.Current_Points.T8 = T8;
    BLDATA.Current_Points.C7 = C7;
    BLDATA.Current_Points.SC = SC;
    BLDATA.Current_Points.AC = Rc*Rci'*(AC - SC) + SC;
    BLDATA.Current_Points.AA = Rs*Rsi'*(AA - AC) + BLDATA.Current_Points.AC;
    BLDATA.Current_Points.TS = Rs*Rsi'*(TS - AC) + BLDATA.Current_Points.AC;
    BLDATA.Current_Points.AI = Rs*Rsi'*(AI - AC) + BLDATA.Current_Points.AC;
    BLDATA.Current_Points.GH = Rs*Rsi'*(GH - AC) + BLDATA.Current_Points.AC;
    BLDATA.Current_Points.HU = Rh*Rhi'*(HU - GH) + BLDATA.Current_Points.GH;
    BLDATA.Current_Points.EL = Rh*Rhi'*(EL - GH) + BLDATA.Current_Points.GH;
    BLDATA.Current_Points.EM = Rh*Rhi'*(EM - GH) + BLDATA.Current_Points.GH;
    BLDATA.Current_Points.US = Ru*Rui'*(US - HU) + BLDATA.Current_Points.HU;
    BLDATA.Current_Points.CP = Rh*Rhi'*(CP - GH) + BLDATA.Current_Points.GH;
    BLDATA.Current_Points.RS = Rr*Rri'*(RS - CP) + BLDATA.Current_Points.CP;
  
    % Set the Current rotation matrices
    BLDATA.Current_Matrices_L2A.Rc = Rc;
    BLDATA.Current_Matrices_L2A.Rs = Rs;
    BLDATA.Current_Matrices_L2A.Rh = Rh;
    BLDATA.Current_Matrices_L2A.Ru = Ru;
    BLDATA.Current_Matrices_L2A.Rr = Rr;
    
    % Set the current wire frames
    BLDATA.Current_WFBones.Thorax = [IJ, PX, T8, C7, IJ];
    BLDATA.Current_WFBones.Clavicula =...
        [BLDATA.Current_Points.SC,...
         BLDATA.Current_Points.AC];
    BLDATA.Current_WFBones.Scapula =...
        [BLDATA.Current_Points.AC,...
         BLDATA.Current_Points.AA,...
         BLDATA.Current_Points.TS,...
         BLDATA.Current_Points.AI,...
         BLDATA.Current_Points.GH,...
         BLDATA.Current_Points.AC];
    BLDATA.Current_WFBones.Humerus =...
        [BLDATA.Current_Points.GH,...
         BLDATA.Current_Points.HU,...
         BLDATA.Current_Points.EL,...
         BLDATA.Current_Points.EM];
    BLDATA.Current_WFBones.Ulna =...
       [BLDATA.Current_Points.CP,...
        BLDATA.Current_Points.HU,...
        BLDATA.Current_Points.EM,...
        BLDATA.Current_Points.US];
    BLDATA.Current_WFBones.Radius =...
       [BLDATA.Current_Points.CP,...
        BLDATA.Current_Points.RS];
     
    % Set the Garner and Pandy Scapular Rotation Matrix
    Zaxis = BLDATA.Current_Points.AC - BLDATA.Current_Points.GH; Zaxis = Zaxis/norm(Zaxis);
    Yaxis = cross(Zaxis, BLDATA.Current_Points.AC - BLDATA.Current_Points.TS); Yaxis = Yaxis/norm(Yaxis);
    Xaxis = cross(Yaxis, Zaxis); Xaxis = Xaxis/norm(Xaxis);
    
    % Set the rotation matrix
    BLDATA.Current_GnP.Rs = [Xaxis, Yaxis, Zaxis];
    
    % Set the Output
    Output = BLDATA;    
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% LIST OF TASKS ENDS HERE!!
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
else
    % If the wrong task is given, MATLAB throws an error
    ErrorMsg = [...
        'The user supplied task is not valid.',...
        'MAIN_TOOL_geometry_functions requires a valid task as first input.\n',...
        'Try the Followings : \n',...
        'Task 1 : Build Rotation Matrices From Euler Angles,\n',...
        'Task 2 : Get Euler Angles From Original Rotation Matrices,\n',...
        'Task 3 : Get Euler Angles From Initial Rotation Matrices,\n',...
        'Task 4 : Get Euler Angles From Current Rotation Matrices,\n',... 
        'Task 5 : Rotate Points From Local To Global Frame (Initial),\n',...
        'Task 6 : Rotate Points From Global To Local Frame (Initial),\n',...
        'Task 7 : Rotate Points From Local To Global Frame (Current),\n',...
        'Task 8 : Rotate Points From Global To Local Frame (Current),\n',...
        'Task 9 : Update Initial Bony Landmark Data from Joint Rotation Matrices,\n',...
        'Task 10: Update Current Bony Landmark Data from Joint Rotation Matrices.'];
    
    % Throw the Error
    error('MainApp:GomertricTaskCheck', ErrorMsg);
end
return;