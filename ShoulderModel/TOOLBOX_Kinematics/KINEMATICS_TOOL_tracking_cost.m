function [tracking_cost, thorax_error, clavicle_error, scapula_error, humerus_error, ulna_error, radius_error] = KINEMATICS_TOOL_tracking_cost(i, q, SSDATA, BLDATA)
%{
Function for building the IK cost function (tracking cost).
--------------------------------------------------------------------------
Syntax
outpus = KINEMATICS_TOOL_tracking_cost(i, q, SSDATA, BLDATA)
--------------------------------------------------------------------------
File Description :
This file builds the inverse kinematics cost function. This function can be
called as the tracking cost as it defines the eculidean difference between
the positions of the measured markers and the model defined markers. It's a
function of generalized coordinates that are going to be defined using IK
such that this cost function is minimized.
First we define the forward kinematics map, and then we build the error and
then the tracking cost.
--------------------------------------------------------------------------
%}

%--------------------------------------------------------------------------
% define the landmarks using the forward kinematics map
%--------------------------------------------------------------------------
% 1) define the rotation matrices from the generalized coordinates vector (Euler angles)
Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles', q, BLDATA);
    Rc = Rmat(:,1:3);
    Rs = Rmat(:,4:6);
    Rh = Rmat(:,7:9);
    Ru = Rmat(:,10:12);
    Rr = Rmat(:,13:15);

% 2) Get Initial Rotation Matrices
Rc_initial = BLDATA.Initial_Matrices_L2A.Rc;
Rs_initial = BLDATA.Initial_Matrices_L2A.Rs;
Rh_initial = BLDATA.Initial_Matrices_L2A.Rh;
Ru_initial = BLDATA.Initial_Matrices_L2A.Ru;
Rr_initial = BLDATA.Initial_Matrices_L2A.Rr;
    
% 3) Get all initial configurations of the landmarks
IJ_initial = BLDATA.Initial_Points.IJ;
PX_initial = BLDATA.Initial_Points.PX;
T8_initial = BLDATA.Initial_Points.T8;
C7_initial = BLDATA.Initial_Points.C7;
SC_initial = BLDATA.Initial_Points.SC;
AC_initial = BLDATA.Initial_Points.AC;
AA_initial = BLDATA.Initial_Points.AA;
TS_initial = BLDATA.Initial_Points.TS;
AI_initial = BLDATA.Initial_Points.AI;
GH_initial = BLDATA.Initial_Points.GH;
HU_initial = BLDATA.Initial_Points.HU;
EL_initial = BLDATA.Initial_Points.EL;
EM_initial = BLDATA.Initial_Points.EM;
CP_initial = BLDATA.Initial_Points.CP;
US_initial = BLDATA.Initial_Points.US;
RS_initial = BLDATA.Initial_Points.RS;
    
% 4) define the configurations of the landmarks
IJ = IJ_initial;
PX = PX_initial;
T8 = T8_initial;
C7 = C7_initial;
SC = SC_initial;
AC = Rc*Rc_initial'*(AC_initial - SC_initial) + SC_initial;
AA = Rs*Rs_initial'*(AA_initial - AC_initial) + AC;
TS = Rs*Rs_initial'*(TS_initial - AC_initial) + AC;
AI = Rs*Rs_initial'*(AI_initial - AC_initial) + AC;
GH = Rs*Rs_initial'*(GH_initial - AC_initial) + AC;
HU = Rh*Rh_initial'*(HU_initial - GH_initial) + GH;
EL = Rh*Rh_initial'*(EL_initial - GH_initial) + GH;
EM = Rh*Rh_initial'*(EM_initial - GH_initial) + GH;
US = Ru*Ru_initial'*(US_initial - HU_initial) + HU;
CP = Rh*Rh_initial'*(CP_initial - GH_initial) + GH;
RS = Rr*Rr_initial'*(RS_initial - CP_initial) + CP;

%--------------------------------------------------------------------------
% provide the measured landmarks including those were estimated using the
% Estimate Missing Landmarks
%--------------------------------------------------------------------------
IJ_m = SSDATA.Measured_Kinematics.IJ(:,i);
PX_m = SSDATA.Measured_Kinematics.PX(:,i);
T8_m = SSDATA.Measured_Kinematics.T8(:,i);
C7_m = SSDATA.Measured_Kinematics.C7(:,i);
SC_m = SSDATA.Measured_Kinematics.SC(:,i);
AC_m = SSDATA.Measured_Kinematics.AC(:,i);
AA_m = SSDATA.Measured_Kinematics.AA(:,i);
TS_m = SSDATA.Measured_Kinematics.TS(:,i);
AI_m = SSDATA.Measured_Kinematics.AI(:,i);
GH_m = SSDATA.Measured_Kinematics.GH(:,i);
HU_m = SSDATA.Measured_Kinematics.HU(:,i);
EL_m = SSDATA.Measured_Kinematics.EL(:,i);
EM_m = SSDATA.Measured_Kinematics.EM(:,i);
US_m = SSDATA.Measured_Kinematics.US(:,i);
CP_m = SSDATA.Measured_Kinematics.CP(:,i);
RS_m = SSDATA.Measured_Kinematics.RS(:,i);

%--------------------------------------------------------------------------
% define the error
%--------------------------------------------------------------------------
% global tracking error over the whole upper arm extremity
tracking_error = [IJ-IJ_m; PX-PX_m; T8-T8_m; C7-C7_m; SC-SC_m; AC-AC_m;...
                  AA-AA_m; TS-TS_m; AI-AI_m; GH-GH_m; EM-EM_m; EL-EL_m;...
                  HU-HU_m; CP-CP_m; US-US_m; RS-RS_m];              
%--------------------------------------------------------------------------
% define the tracking cost (IK cost function)
%--------------------------------------------------------------------------              
% global tracking cost
tracking_cost = tracking_error'*tracking_error;

% tracking costs associated with each of the segments
thorax_error = tracking_error(1:12,1)'*tracking_error(1:12,1);
clavicle_error = tracking_error(13:18,1)'*tracking_error(13:18,1);
scapula_error = tracking_error(19:27,1)'*tracking_error(19:27,1);
humerus_error = tracking_error(28:42,1)'*tracking_error(28:42,1);
ulna_error = tracking_error([31:33,43:45],1)'*tracking_error([31:33,43:45],1);
radius_error = tracking_error([34:36,46:48],1)'*tracking_error([34:36,46:48],1);

return


