
function BLDATA = MAIN_INITIALISATION_build_data_bony_landmark()
% Function to initialise the bony landmark dataset
%--------------------------------------------------------------------------
% Syntax :
% BLDATA = MAIN_INITIALISATION_build_data_bony_landmark()
%--------------------------------------------------------------------------
%{
File Description:

This function includes the bony landmarks received from
AMIRA and transforms them into BLDATA.Original_Points.
It also:

        1- defines the rotation matrix from AMIRA to MATLAB:
        BLDATA.Amira_to_MATLAB.Rt = R_am

        2- sets the initial and current points to the original points to
        initialize the code.
        BLDATA.Original_Points    ---->  BLDATA.Initial_Points
        BLDATA.Original_Points    ---->  BLDATA.Current_Points

        3- defines the original rotation matrices of the bones fixed frames
        and also sets the initial and current ones to original:
        BLDATA.Original_Matrices_L2A,
        BLDATA.Initial_Matrices_L2A,
        BLDATA.Current_Matrices_L2A

        4- saves the points needed to plot the wireframes of the bones:
        BLDATA.Original_WFBones,
        BLDATA.Initial_WFBones,
        BLDATA.Current_WFBones

        Garner & Pandy Scapular reference frame to compare moment arms and
        validate
        BLDATA.Original_GnP.Rs
        BLDATA.Initial_GnP.Rs
        BLDATA.Current_GnP.Rs
%}
%--------------------------------------------------------------------------

% Initialiase the Output
BLDATA = [];


%--------------------------------------------------------------------------
% BONY LANDMARKS IN AMIRA REFERENCE FRAME
%--------------------------------------------------------------------------
IJ = [   74.1129;  -74.8060;   68.9446]; % Incisura Jugularis
PX = [   82.5171; -133.1130;  -76.9724]; % Processus Xiphoideus
T8 = [   78.9481;  -24.5985;  -40.6273]; % Vertebra T8
C7 = [   70.5729;  -35.7244;  150.7640]; % Vertebra C7
SC = [   56.6771;  -69.2782;   72.7629]; % Sternoclaviuclar joint
%SC= [   52.0511;  -79.0859;   75.0302]; % Sternoclaviuclar joint
AC = [   -82.2127; -25.2576;   148.444]; % Sternoclaviuclar joint
%AC = [  -82.1051;  -30.7575;  145.4510]; % Acromioclavicular joint
GH = [  -86.1456;  -31.7209;  107.6860]; % Glenohumeral joint
HU = [ -103.7780;  -33.3235; -205.8640]; % Humeroulnar joint= 0.5(EM+EL)
TS = [   -0.9241;   52.0670;  121.3280]; % Trigonum Spinae
AI = [   -6.7869;   50.3866;   -4.7008]; % Angulus Inferior
AA = [ -104.3290;   -1.0350;  133.7840]; % Angulus Acromialis
EL = [ -127.2850;  -54.8861; -208.4960]; % Lateral epicondyle
EM = [  -80.2709;  -11.7610; -203.2320]; % Medial epicondyle
%CP = [ -117.9780;   20.2045; -201.1550]; %Capitulum center
CP = [ -119.7196;     -47.9465; -207.6489]; %Capitulum center
%US = [ -119.1449;  -32.0329; -459.3816]; %Ulna Styloid
%%%%US = [-8.112e+001; -1.278e+001; -4.720e+002]; %Ulna Styloid
US = [-95.6657; -160.7194; -450.9589];
%RS = [  -80.0832;  -17.1580; -471.3330]; %Radius Styloid
%%%%RS = [-1.217e+002; -1.615e+001; -4.655e+002 ];%Radius Styloid
RS = [-62.2966; -134.5104; -464.3826];
%--------------------------------------------------------------------------
% BUILD AMIRA TO MATLAB HOMOGENEOUS TRANFORMATION & TRANSFORM ALL POINTS
%--------------------------------------------------------------------------

% AMIRA -> MATLAB Rotation Matrix
Zt = (C7 + IJ)/2 - (T8 + PX)/2;
Xt = cross(C7 - IJ, (T8 + PX)/2-IJ); 
Yt = cross(Zt, Xt); 
R_am = [Xt/norm(Xt), Yt/norm(Yt), Zt/norm(Zt)]'; %R_am=R_matlab', which means
%R_matlab map the points in matlab to AMIRA. For instance if you think
%about R_matlab*[1 0 0]' it returns the associated vector (point) related
%to the x axis of matlab in amira. Obviously it will be the first column of
%the R_matlab.

% Homogeneous transformation Matrix which maps a point in AMIRA to matlab
% coordinate system
H_am = [[R_am, -R_am*IJ]; [0, 0, 0, 1]];

%--------------------------------------------------------------------------
% SAVE THE AMIRA TO MATLAB HOMEGENEOUS TRANSFORMATON
%--------------------------------------------------------------------------
BLDATA.Amira_to_MATLAB.Rt = R_am;
BLDATA.Amira_to_MATLAB.IJ = IJ;

% Transform all points to MATLAB reference frame and then get rid of the
% homegeneous part
IJ = H_am*[IJ; 1]; IJ = IJ(1:3,1);
PX = H_am*[PX; 1]; PX = PX(1:3,1); 
T8 = H_am*[T8; 1]; T8 = T8(1:3,1);
C7 = H_am*[C7; 1]; C7 = C7(1:3,1);
SC = H_am*[SC; 1]; SC = SC(1:3,1);
AC = H_am*[AC; 1]; AC = AC(1:3,1);
GH = H_am*[GH; 1]; GH = GH(1:3,1);
HU = H_am*[HU; 1]; HU = HU(1:3,1);
TS = H_am*[TS; 1]; TS = TS(1:3,1);
AI = H_am*[AI; 1]; AI = AI(1:3,1);
AA = H_am*[AA; 1]; AA = AA(1:3,1);
EL = H_am*[EL; 1]; EL = EL(1:3,1);
EM = H_am*[EM; 1]; EM = EM(1:3,1);
CP = H_am*[CP; 1]; CP = CP(1:3,1);
US = H_am*[US; 1]; US = US(1:3,1);
RS = H_am*[RS; 1]; RS = RS(1:3,1);
%--------------------------------------------------------------------------
% BUILD ORIGINAL BONE REFERENCE FRAME ROTATION MATRICES
%--------------------------------------------------------------------------

% Clavicula to Thorax Rotation Matrix
Xc = AC - SC; Xc = Xc/norm(Xc);
Yc = cross([0; 0; 1], Xc); Yc = Yc/norm(Yc);
Zc = cross(Xc, Yc); Zc = Zc/norm(Zc);
Rc = [Xc, Yc, Zc];                              % Local -> absolute

% Scapula to Thorax Rotation Matrix
Xs = AA - TS; Xs = Xs/norm(Xs);
Ys = cross(Xs, AI - TS); Ys = Ys/norm(Ys);
Zs = cross(Xs, Ys); Zs = Zs/norm(Zs);
Rs = [Xs, Ys, Zs];                              % Local -> absolute

% Humerus to Thorax Rotation Matrix
Zh = GH - HU; Zh = Zh/norm(Zh);
Yh = cross(GH - EL, EL - EM); Yh = Yh/norm(Yh);
Xh = cross(Yh, Zh); Xh = Xh/norm(Xh);
Rh = [Xh, Yh, Zh];                              % Local -> absolute

% Ulna to Thorax Rotation Matrix
% first choice of segment coordinate for the Ulna
% Zu = (EM + EL)/2 - US; Zu = Zu/norm(Zu);
% Yu = cross(US - EL, EL - EM); Yu = Yu/norm(Yu);
% Xu = cross(Yu, Zu); Xu = Xu/norm(Xu);
% Ru = [Xu, Yu, Zu];                              % Local -> absolute
% second choice
Xu = EL - HU; Xu = Xu/norm(Xu);
Yu = cross(US - EL, EM - EL); Yu = Yu/norm(Yu);
Zu = cross(Xu, Yu); Zu = Zu/norm(Zu);
Ru = [Xu, Yu, Zu];                              % Local -> absolute

% Radius to Thorax Rotation Matrix
Zr = CP - US; Zr = Zr/norm(Zr);
Yr = cross(CP - RS, RS - US); Yr = Yr/norm(Yr);
Xr = cross(Yr, Zr); Xr = Xr/norm(Xr);
Rr = [Xr, Yr, Zr];                              % Local -> absolute

%--------------------------------------------------------------------------
% BUILD ORIGINAL BONY LANDMARK DATA STRUCTURE
%--------------------------------------------------------------------------
% List of points in the original configuration and in MATLAB frame

BLDATA.Original_Points.IJ = IJ;
BLDATA.Original_Points.PX = PX;
BLDATA.Original_Points.T8 = T8;
BLDATA.Original_Points.C7 = C7;
BLDATA.Original_Points.SC = SC;
BLDATA.Original_Points.AC = AC;
BLDATA.Original_Points.GH = GH;
BLDATA.Original_Points.HU = HU;
BLDATA.Original_Points.TS = TS;
BLDATA.Original_Points.AI = AI;
BLDATA.Original_Points.AA = AA;
BLDATA.Original_Points.EL = EL;
BLDATA.Original_Points.EM = EM;
BLDATA.Original_Points.CP = CP;
BLDATA.Original_Points.US = US;
BLDATA.Original_Points.RS = RS;

% Build the original bone wire frames for plotting purposes
BLDATA.Original_WFBones.Thorax      = [IJ, PX, T8, C7, IJ]; 
BLDATA.Original_WFBones.Clavicula   = [SC, AC];
BLDATA.Original_WFBones.Scapula     = [AC, AA, TS, AI, GH, AC];
BLDATA.Original_WFBones.Humerus     = [GH, HU, EL, EM];
BLDATA.Original_WFBones.Ulna        = [CP, HU, EM, US];
BLDATA.Original_WFBones.Radius      = [CP, RS];


% Original Rotation Matrices
BLDATA.Original_Matrices_L2A.Rc = Rc;
BLDATA.Original_Matrices_L2A.Rs = Rs;
BLDATA.Original_Matrices_L2A.Rh = Rh;
BLDATA.Original_Matrices_L2A.Ru = Ru;
BLDATA.Original_Matrices_L2A.Rr = Rr;

%--------------------------------------------------------------------------
% BUILD INITIAL BONY LANDMARK DATA STRUCTURE
%--------------------------------------------------------------------------
% To start, both initial and current data are set to original.
% List of Points in the initial configuration
BLDATA.Initial_Points.IJ = IJ;
BLDATA.Initial_Points.PX = PX;
BLDATA.Initial_Points.T8 = T8;
BLDATA.Initial_Points.C7 = C7;
BLDATA.Initial_Points.SC = SC;
BLDATA.Initial_Points.AC = AC;
BLDATA.Initial_Points.GH = GH;
BLDATA.Initial_Points.HU = HU;
BLDATA.Initial_Points.TS = TS;
BLDATA.Initial_Points.AI = AI;
BLDATA.Initial_Points.AA = AA;
BLDATA.Initial_Points.EL = EL;
BLDATA.Initial_Points.EM = EM;
BLDATA.Initial_Points.CP = CP;
BLDATA.Initial_Points.US = US;
BLDATA.Initial_Points.RS = RS;

% Build the bone wire frames for plotting purposes
BLDATA.Initial_WFBones.Thorax       = [IJ, PX, T8, C7, IJ]; 
BLDATA.Initial_WFBones.Clavicula    = [SC, AC];
BLDATA.Initial_WFBones.Scapula      = [AC, AA, TS, AI, GH, AC];
BLDATA.Initial_WFBones.Humerus      = [GH, HU, EL, EM];
BLDATA.Initial_WFBones.Ulna         = [CP, HU, EM, US];
BLDATA.Initial_WFBones.Radius       = [CP, RS];

% Initial Rotation Matrices
BLDATA.Initial_Matrices_L2A.Rc = Rc;
BLDATA.Initial_Matrices_L2A.Rs = Rs;
BLDATA.Initial_Matrices_L2A.Rh = Rh;
BLDATA.Initial_Matrices_L2A.Ru = Ru;
BLDATA.Initial_Matrices_L2A.Rr = Rr;

%--------------------------------------------------------------------------
% BUILD CURRENT BONY LANDMARK DATA STRUCTURE
%--------------------------------------------------------------------------
% List of Points in the current configuration
BLDATA.Current_Points.IJ = IJ;
BLDATA.Current_Points.PX = PX;
BLDATA.Current_Points.T8 = T8;
BLDATA.Current_Points.C7 = C7;
BLDATA.Current_Points.SC = SC;
BLDATA.Current_Points.AC = AC;
BLDATA.Current_Points.GH = GH;
BLDATA.Current_Points.HU = HU;
BLDATA.Current_Points.TS = TS;
BLDATA.Current_Points.AI = AI;
BLDATA.Current_Points.AA = AA;
BLDATA.Current_Points.EL = EL;
BLDATA.Current_Points.EM = EM;
BLDATA.Current_Points.CP = CP;
BLDATA.Current_Points.US = US;
BLDATA.Current_Points.RS = RS;

% Build the bone wire frames for plotting purposes
BLDATA.Current_WFBones.Thorax       = [IJ, PX, T8, C7, IJ]; 
BLDATA.Current_WFBones.Clavicula    = [SC, AC];
BLDATA.Current_WFBones.Scapula      = [AC, AA, TS, AI, GH, AC];
BLDATA.Current_WFBones.Humerus      = [GH, HU, EL, EM];
BLDATA.Current_WFBones.Ulna         = [CP, HU, EM, US];
BLDATA.Current_WFBones.Radius       = [CP, RS];

% Current Rotation Matrices
BLDATA.Current_Matrices_L2A.Rc = Rc;
BLDATA.Current_Matrices_L2A.Rs = Rs;
BLDATA.Current_Matrices_L2A.Rh = Rh;
BLDATA.Current_Matrices_L2A.Ru = Ru;
BLDATA.Current_Matrices_L2A.Rr = Rr;

%--------------------------------------------------------------------------
% BUILD THE GARNER & PANDY SCAPULAR ROTATION MATRIX
%--------------------------------------------------------------------------
% Define the Garner & Pandy Scapular Reference frame
Zaxis = AC - GH; Zaxis = Zaxis/norm(Zaxis);
Yaxis = cross(Zaxis, AC - TS); Yaxis = Yaxis/norm(Yaxis);
Xaxis = cross(Yaxis, Zaxis); Xaxis = Xaxis/norm(Xaxis);

Rgnp = [Xaxis, Yaxis, Zaxis];
BLDATA.Original_GnP.Rs = Rgnp;
BLDATA.Initial_GnP.Rs = Rgnp;
BLDATA.Current_GnP.Rs = Rgnp;

% initialize glenoid fossa orientation for the subject specific toolbox
BLDATA.Glenoid_Orientations = [7 4];
BLDATA.Glenoid_Orientations_Unchanged = [7 4];% for the visualization we keep this to have the initial values unchanged to visualize

return