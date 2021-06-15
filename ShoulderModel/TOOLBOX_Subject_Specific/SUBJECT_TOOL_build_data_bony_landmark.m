
function BLDATA = SUBJECT_TOOL_build_data_bony_landmark(BLDATAin, DYDATA)
% Function to scale the bony landmarks
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
BLDATA = BLDATAin;

% scaling factor to scale the landmarks according to the body height
Height_Scaling_Factor = DYDATA.Height_Scaling_Factor;

%--------------------------------------------------------------------------
% BONY LANDMARKS IN AMIRA REFERENCE FRAME
%--------------------------------------------------------------------------
IJ = Height_Scaling_Factor*[   74.1129;  -74.8060;   68.9446]; % Incisura Jugularis
PX = Height_Scaling_Factor*[   82.5171; -133.1130;  -76.9724]; % Processus Xiphoideus
T8 = Height_Scaling_Factor*[   78.9481;  -24.5985;  -40.6273]; % Vertebra T8
C7 = Height_Scaling_Factor*[   70.5729;  -35.7244;  150.7640]; % Vertebra C7
SC = Height_Scaling_Factor*[   56.6771;  -69.2782;   72.7629]; % Sternoclaviuclar joint
%SC= [   52.0511;  -79.0859;   75.0302]; % Sternoclaviuclar joint
AC = Height_Scaling_Factor*[   -82.2127; -25.2576;   148.444]; % Sternoclaviuclar joint
%AC = [  -82.1051;  -30.7575;  145.4510]; % Acromioclavicular joint
%TS = Height_Scaling_Factor*[   -0.9241;   52.0670;  121.3280]; % Trigonum Spinae
%AI = Height_Scaling_Factor*[   -6.7869;   50.3866;   -4.7008]; % Angulus Inferior
TS = Height_Scaling_Factor*[-1.585891723632813e+000; 5.131806945800781e+001; 1.226403579711914e+002]; % new values from Yasmine 1Aug2018
AI = Height_Scaling_Factor*[-4.471809387207031e+000; 4.468699645996094e+001; -8.649490356445313e+000]; % new values from Yasmine 1Aug2018
AA = Height_Scaling_Factor*[ -104.3290;   -1.0350;  133.7840]; % Angulus Acromialis
SN = Height_Scaling_Factor*[-5.834277343750000e+001; 1.268512725830078e+000; 1.163459472656250e+002]; % Spino-glenoid Notch
S1 = Height_Scaling_Factor*[-4.437187576293945e+001; 1.044776678085327e+000; 1.171667938232422e+002]; % the most lateral point on the supraspinatus fossa
S2 = Height_Scaling_Factor*[-2.524987030029297e+001; 3.014913558959961e+001; 1.212621765136719e+002]; % one of the other 4 points on the supraspinatus fossa
S3 = Height_Scaling_Factor*[-4.073601150512695e+001; 9.907344818115234e+000; 1.174581298828125e+002]; % one of the other 4 points on the supraspinatus fossa
S4 = Height_Scaling_Factor*[-3.028522109985352e+001; 2.512048149108887e+001; 1.201423034667969e+002]; % one of the other 4 points on the supraspinatus fossa
S5 = Height_Scaling_Factor*[-3.626570129394531e+001; 1.977687454223633e+001; 1.190045471191406e+002]; % one of the other 4 points on the supraspinatus fossa

%GH = Height_Scaling_Factor*[  -86.1456;  -31.7209;  107.6860]; % Glenohumeral joint
GH = Height_Scaling_Factor*[-84.5443; -33.5688; 106.6692]; % Glenohumeral joint constructed with no subluxation

% HU = Height_Scaling_Factor*[ -103.7780;  -33.3235; -205.8640]; % Humeroulnar joint= 0.5(EM+EL)
% EL = Height_Scaling_Factor*[ -127.2850;  -54.8861; -208.4960]; % Lateral epicondyle
% EM = Height_Scaling_Factor*[  -80.2709;  -11.7610; -203.2320]; % Medial epicondyle
% %CP = [ -117.9780;   20.2045; -201.1550]; %Capitulum center
% CP = Height_Scaling_Factor*[ -119.7196;     -47.9465; -207.6489]; %Capitulum center
% %US = [ -119.1449;  -32.0329; -459.3816]; %Ulna Styloid
% US = Height_Scaling_Factor*[-95.6657; -160.7194; -450.9589]; %Ulna Styloid %-8.112e+001; -1.278e+001; -4.720e+002
% %RS = [  -80.0832;  -17.1580; -471.3330]; %Radius Styloid
% RS = Height_Scaling_Factor*[-62.2966; -134.5104; -464.3826];%Radius Styloid % -1.217e+002; -1.615e+001; -4.655e+002 

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
TS = H_am*[TS; 1]; TS = TS(1:3,1);
AI = H_am*[AI; 1]; AI = AI(1:3,1);
AA = H_am*[AA; 1]; AA = AA(1:3,1);
GH_scaled = H_am*[GH; 1]; GH_scaled = GH_scaled(1:3,1);
SN = H_am*[SN; 1]; SN = SN(1:3,1);
S1 = H_am*[S1; 1]; S1 = S1(1:3,1);
S2 = H_am*[S2; 1]; S2 = S2(1:3,1);
S3 = H_am*[S3; 1]; S3 = S3(1:3,1);
S4 = H_am*[S4; 1]; S4 = S4(1:3,1);
S5 = H_am*[S5; 1]; S5 = S5(1:3,1);

% define the subject specific GH point based on glenoid orientation, note
% that if the glenoid orientation is not defined by the user, the GH point
% will be constructed such that the glenoid orientation stays the same as
% the generic model
    % 1) scale the humeral head
    if isequal(BLDATA.Glenoid_Orientations_Generic(1, 3), BLDATA.Glenoid_Orientations(1, 3))
        HH_radius_ss = Height_Scaling_Factor(1, 1)*BLDATA.Glenoid_Orientations(1, 3); % scale the diamter
    else
        HH_radius_ss = BLDATA.Glenoid_Orientations(1, 3); % take subject specific diameter
    end

    % 2) calculate the glenoid center line from glenoid verison and
    % inlcination from the subject
GV = BLDATA.Glenoid_Orientations_Generic(1, 1);
GI = BLDATA.Glenoid_Orientations_Generic(1, 2);    
GV = BLDATA.Glenoid_Orientations(1, 1);
GI = BLDATA.Glenoid_Orientations(1, 2);

GC_axis = [sind(GV)*cosd(GI) cosd(GV)*sind(GI) cosd(GV)*cosd(GI)]';
GC_axis = GC_axis/norm(GC_axis);
    % 3) calculate the subject specific GH in glenoid frame
GH_new_g = HH_radius_ss*GC_axis;
    % 4) transform the new GH to thorax coordinate system (Matlab). To this
    % end we need to have the Rsa rotation matrix for the scaled model.
    % It's the secondary scapula coordinate system according to A. Terrier, et
    % al, Bone Joint J 2014;96-B:513?18.
        % 4-a) define the scapula plane
        % define the plane normal vector (posterior-anterior positive)
        X_SA = cross((S1 - AI), (S1 - TS)); X_SA = X_SA/norm(X_SA);

        % 4-b) project the five points of the supraspinatus fossa on the scapula plane
        landmark_list = {'SN' 'S2' 'S3' 'S4' 'S5'}; % list of landmarks to be projected

            for land_id = 1:length(landmark_list)
                t = X_SA'*(S1 - eval(landmark_list{land_id})); % line parameter in projection
                projected.(landmark_list{land_id}) = eval(landmark_list{land_id}) + t*X_SA; % projected points
            end

        % 4-c) fit a line through the 4 projected points of the supraspinatus fossa
        % and S1. The projected SN will be used as the origin of the scapula
        % coordnate system
        Z_SA = fitLine([S1, projected.S2, projected.S3, projected.S4, projected.S5]');
        %coeffs = princomp([S1, projected.S2, projected.S3, projected.S4, projected.S5]');
        %Z_SA = coeffs(:,1);

        Z_SA = Z_SA/norm(Z_SA);

        % 4-d) construct the scapula coordinate system and its rotation matrix
        X_SA = X_SA; % x axis of the scapula coordinate system
        Z_SA = Z_SA; % z axis of the scapula coordinate system
        Y_SA = cross(Z_SA, X_SA); Y_SA = Y_SA/norm(Y_SA); % y axis of the scapula coordinate system

        Rsa = [X_SA, Y_SA, Z_SA]; % local ---> global
        
        % 4-e) transform the point
        if isequal(BLDATA.Glenoid_Orientations_Generic(1, 4:6)', BLDATA.Glenoid_Orientations(1, 4:6)')
            GC_sa = Height_Scaling_Factor*BLDATA.Glenoid_Orientations(1, 4:6)'; % scale the glenoid fossa center point
        else
            GC_sa = BLDATA.Glenoid_Orientations(1, 4:6)'; % take subject specific glenoid fossa center point
        end
        
        GH = projected.SN + Rsa*(GC_sa + eye(3)*GH_new_g);

        BLDATA.Original_Points.GC = projected.SN + Rsa*GC_sa; % for the glenoid cone we'll need glenoid center in thorax

    % 5) define the offset vector
    offset_T = GH - GH_scaled; % offset vector in thorax is the vector from the scaled GH in thorax to the new subject specific GH
    offset_Amira = R_am'*offset_T;
    BLDATA.offset_Amira = R_am'*offset_T;
    
% scale and shift the rest of the bony landmarks (on the hand)    
HU = Height_Scaling_Factor*[-103.7780;  -33.3235; -205.8640] + offset_Amira; % Humeroulnar joint= 0.5(EM+EL)
EL = Height_Scaling_Factor*[-127.2850;  -54.8861; -208.4960] + offset_Amira; % Lateral epicondyle
EM = Height_Scaling_Factor*[-80.2709;   -11.7610; -203.2320] + offset_Amira; % Medial epicondyle
CP = Height_Scaling_Factor*[-119.7196;  -47.9465; -207.6489] + offset_Amira; %Capitulum center
US = Height_Scaling_Factor*[-95.6657;  -160.7194; -450.9589] + offset_Amira; %Ulna Styloid 
RS = Height_Scaling_Factor*[-62.2966;  -134.5104; -464.3826] + offset_Amira;%Radius Styloid 
    
% transform the points to thorax coordinate system    
HU = H_am*[HU; 1]; HU = HU(1:3,1);
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
Zh = GH - (EM + EL)/2; Zh = Zh/norm(Zh);
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
Xu = EL-(EM + EL)/2; Xu = Xu/norm(Xu);
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
BLDATA.Original_Points.SN = SN;
BLDATA.Original_Points.S1 = S1;
BLDATA.Original_Points.S2 = S2;
BLDATA.Original_Points.S3 = S3;
BLDATA.Original_Points.S4 = S4;
BLDATA.Original_Points.S5 = S5;


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
BLDATA.Original_Matrices_L2A.Rsa = Rsa;

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
BLDATA.Initial_Points.SN = SN;
BLDATA.Initial_Points.S1 = S1;
BLDATA.Initial_Points.S2 = S2;
BLDATA.Initial_Points.S3 = S3;
BLDATA.Initial_Points.S4 = S4;
BLDATA.Initial_Points.S5 = S5;

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
BLDATA.Initial_Matrices_L2A.Rsa = Rsa;

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
BLDATA.Current_Points.SN = SN;
BLDATA.Current_Points.S1 = S1;
BLDATA.Current_Points.S2 = S2;
BLDATA.Current_Points.S3 = S3;
BLDATA.Current_Points.S4 = S4;
BLDATA.Current_Points.S5 = S5;

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
BLDATA.Current_Matrices_L2A.Rsa = Rsa;

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

return

% function for fitting a line to a matrix of points in X (n times 3)
function [dirVect,meanX,residuals,rmse,R2] = fitLine(X)

% Fits a line to a group of points in X
% X should be X = [x1 y1 z1]
%                 [   ...  ]
%                 [xn yn zn]

%[coeff,score,~] = princomp(X);
[coeff,score,~] = pca(X);% new matlab revision
dirVect = coeff(:,1);
[Xn,Xm] = size(X);
meanX = mean(X,1);
Xfit1 = repmat(meanX,Xn,1) + score(:,1)*coeff(:,1)';
residuals = X-Xfit1;
error =  diag(pdist2(residuals,zeros(Xn,Xm)));
sse = sum(error.^2);
rmse = norm(error)/sqrt(Xn);

for i=1:Xn
    tot(i) = norm(meanX-X(i,:));
end
    
sst = sum(tot.^2); 

R2 = 1-(sse/sst); %http://en.wikipedia.org/wiki/Coefficient_of_determination
return
