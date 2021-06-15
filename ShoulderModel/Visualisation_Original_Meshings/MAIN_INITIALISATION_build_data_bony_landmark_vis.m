function BLDATA = MAIN_INITIALISATION_build_data_bony_landmark()
% Function to initialise the bony landmark dataset
%--------------------------------------------------------------------------
% Syntax :
% BLDATA = MAIN_INITIALISATION_build_data_bony_landmark()
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram
%
% File Description :
% This function generates the initial bony landmark data structure. There
% are three important sub parts of the data structure.
%   1) Original Data from the AMIRA data set. Raw from collection.
%   2) Initial Data, this can be changed by the initial configuration
%   3) Current Data, this is used when working with motion. 
%
% Data Structure Format :
% Original Data from the CHUV dataset
%       BLDATA.Original_Points.IJ
%       BLDATA.Original_Points.PX
%       BLDATA.Original_Points.T8
%       BLDATA.Original_Points.C7
%       BLDATA.Original_Points.SC
%       BLDATA.Original_Points.AC
%       BLDATA.Original_Points.AA
%       BLDATA.Original_Points.TS
%       BLDATA.Original_Points.AI
%       BLDATA.Original_Points.GH
%       BLDATA.Original_Points.HU
%       BLDATA.Original_Points.EL
%       BLDATA.Original_Points.EM
%       BLDATA.Original_WFBones.Thorax
%       BLDATA.Original_WFBones.Clavicula
%       BLDATA.Original_WFBones.Scapula
%       BLDATA.Original_WFBones.Humerus
%       BLDATA.Original_Matrices_L2A.Rc
%       BLDATA.Original_Matrices_L2A.Rs
%       BLDATA.Original_Matrices_L2A.Rh
%
% The user can define a new initial configuration
%       BLDATA.Initial_Points.IJ
%       BLDATA.Initial_Points.PX
%       BLDATA.Initial_Points.T8
%       BLDATA.Initial_Points.C7
%       BLDATA.Initial_Points.SC
%       BLDATA.Initial_Points.AC
%       BLDATA.Initial_Points.AA
%       BLDATA.Initial_Points.TS
%       BLDATA.Initial_Points.AI
%       BLDATA.Initial_Points.GH
%       BLDATA.Initial_Points.HU
%       BLDATA.Initial_Points.EL
%       BLDATA.Initial_Points.EM
%       BLDATA.Initial_WFBones.Thorax
%       BLDATA.Initial_WFBones.Clavicula
%       BLDATA.Initial_WFBones.Scapula
%       BLDATA.Initial_WFBones.Humerus
%       BLDATA.Initial_Matrices_L2A.Rc
%       BLDATA.Initial_Matrices_L2A.Rs
%       BLDATA.Initial_Matrices_L2A.Rh
%
% AMIRA -> MATLAB transformation required to initialise the muscle data
%       BLDATA.Amira_to_MATLAB.Rt
%       BLDATA.Amira_to_MATLAB.IJ
%
% Current location of landmarks used visualise the motion
%       BLDATA.Current_Points.IJ
%       BLDATA.Current_Points.PX
%       BLDATA.Current_Points.T8
%       BLDATA.Current_Points.C7
%       BLDATA.Current_Points.SC
%       BLDATA.Current_Points.AC
%       BLDATA.Current_Points.AA
%       BLDATA.Current_Points.TS
%       BLDATA.Current_Points.AI
%       BLDATA.Current_Points.GH
%       BLDATA.Current_Points.HU
%       BLDATA.Current_Points.EL
%       BLDATA.Current_Points.EM
%       BLDATA.Current_WFBones.Thorax
%       BLDATA.Current_WFBones.Clavicula
%       BLDATA.Current_WFBones.Scapula
%       BLDATA.Current_WFBones.Humerus
%       BLDATA.Current_Matrices_L2A.Rc
%       BLDATA.Current_Matrices_L2A.Rs
%       BLDATA.Current_Matrices_L2A.Rh
%
% Garner & Pandy Scapular reference frame to compare moment arms and
% validate
%       BLDATA.Original_GnP.Rs
%       BLDATA.Initial_GnP.Rs
%       BLDATA.Current_GnP.Rs
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
HU = [ -103.7780;  -33.3235; -205.8640]; % Humeroulnar joint
TS = [   -0.9241;   52.0670;  121.3280]; % Trigonum Spinae
AI = [   -6.7869;   50.3866;   -4.7008]; % Angulus Inferior
AA = [ -104.3290;   -1.0350;  133.7840]; % Angulus Acromialis
EL = [ -127.2850;  -54.8861; -208.4960]; % Lateral epicondyle
EM = [  -80.2709;  -11.7610; -203.2320]; % Medial epicondyle

%--------------------------------------------------------------------------
% BUILD AMIRA TO MATLAB HOMOGENEOUS TRANFORMATION & TRANSFORM ALL POINTS
%--------------------------------------------------------------------------

% AMIRA -> MATLAB Rotation Matrix
Zt = (C7 + IJ)/2 - (T8 + PX)/2;
Xt = cross(C7 - IJ, (T8 + PX)/2-IJ); 
Yt = cross(Zt, Xt); 
R_am = [Xt/norm(Xt), Yt/norm(Yt), Zt/norm(Zt)]';

% Homogeneous transformation Matrix
H_am = [[R_am, -R_am*IJ]; [0, 0, 0, 1]];

%--------------------------------------------------------------------------
% SAVE THE AMIRA TO MATLAB HOMEGENEOUS TRANSFORMATON
%--------------------------------------------------------------------------
BLDATA.Amira_to_MATLAB.Rt = R_am;
BLDATA.Amira_to_MATLAB.IJ = IJ;


% Transform all points to MATLAB reference frame
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

%--------------------------------------------------------------------------
% BUILD ORIGINAL BONE REFERENCE FRAME ROTATION MATRICES
%--------------------------------------------------------------------------

% Clavicula Rotation Matrix
Xc = AC - SC; Xc = Xc/norm(Xc);
Yc = cross([0; 0; 1], Xc); Yc = Yc/norm(Yc);
Zc = cross(Xc, Yc); Zc = Zc/norm(Zc);
Rc = [Xc, Yc, Zc];                              % Local -> absolute

% Scapula Rotation Matrix
Xs = AA - TS; Xs = Xs/norm(Xs);
Ys = cross(Xs, AI - TS); Ys = Ys/norm(Ys);
Zs = cross(Xs, Ys); Zs = Zs/norm(Zs);
Rs = [Xs, Ys, Zs];                              % Local -> absolute

% Humerus Rotation Matrix
Zh = GH - (EM + EL)/2; Zh = Zh/norm(Zh);
Yh = cross(GH - EL, EL - EM); Yh = Yh/norm(Yh);
Xh = cross(Yh, Zh); Xh = Xh/norm(Xh);
Rh = [Xh, Yh, Zh];                              % Local -> absolute

%--------------------------------------------------------------------------
% BUILD ORIGINAL BONY LANDMARK DATA STRUCTURE
%--------------------------------------------------------------------------
% List of points in the original configuration
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

% Build the original bone wire frames for plotting purposes
BLDATA.Original_WFBones.Thorax      = [IJ, PX, T8, C7, IJ]; 
BLDATA.Original_WFBones.Clavicula   = [SC, AC];
BLDATA.Original_WFBones.Scapula     = [AC, AA, TS, AI, GH, AC];
BLDATA.Original_WFBones.Humerus     = [GH, HU, EL, EM];

% Original Rotation Matrices
BLDATA.Original_Matrices_L2A.Rc = Rc;
BLDATA.Original_Matrices_L2A.Rs = Rs;
BLDATA.Original_Matrices_L2A.Rh = Rh;

%--------------------------------------------------------------------------
% BUILD INITIAL BONY LANDMARK DATA STRUCTURE
%--------------------------------------------------------------------------
% To start, both initial and current data is set to original.
% List of Points in the current configuration
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

% Build the bone wire frames for plotting purposes
BLDATA.Initial_WFBones.Thorax       = [IJ, PX, T8, C7, IJ]; 
BLDATA.Initial_WFBones.Clavicula    = [SC, AC];
BLDATA.Initial_WFBones.Scapula      = [AC, AA, TS, AI, GH, AC];
BLDATA.Initial_WFBones.Humerus      = [GH, HU, EL, EM];

% Initial Rotation Matrices
BLDATA.Initial_Matrices_L2A.Rc = Rc;
BLDATA.Initial_Matrices_L2A.Rs = Rs;
BLDATA.Initial_Matrices_L2A.Rh = Rh;

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

% Build the bone wire frames for plotting purposes
BLDATA.Current_WFBones.Thorax       = [IJ, PX, T8, C7, IJ]; 
BLDATA.Current_WFBones.Clavicula    = [SC, AC];
BLDATA.Current_WFBones.Scapula      = [AC, AA, TS, AI, GH, AC];
BLDATA.Current_WFBones.Humerus      = [GH, HU, EL, EM];

% Current Rotation Matrices
BLDATA.Current_Matrices_L2A.Rc = Rc;
BLDATA.Current_Matrices_L2A.Rs = Rs;
BLDATA.Current_Matrices_L2A.Rh = Rh;

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

return;