function [c, scapulothoracic_constraints] = KINEMATICS_TOOL_nonlinear_constraints(q, BLDATA, REDATA)
%{
Function for building the IK nonlinear constraints associated with the
scapulothoracic joint.
--------------------------------------------------------------------------
Syntax
[c, scapulothoracic_constraints] = KINEMATICS_TOOL_nonlinear_constraints(p, BLDATA, REDATA, SSDATA, KRGUIHandle)
--------------------------------------------------------------------------
File Description :
This function defines the scapulothoracic constraints as nonlinear
constraints and a function of the generalized coordinates (q). We can also
supress these constraints or even consider them as penalty functions.

      c                           = nonlinear nonequality constraints
      scapulothoracic_constraints = nonlinear equality cosntraints
--------------------------------------------------------------------------
%}
          
%--------------------------------------------------------------------------
% define the AI and TS landmarks using the forward kinematics map
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
    
% 4) define TS and AI
SC = SC_initial;
AC = Rc*Rc_initial'*(AC_initial - SC_initial) + SC_initial;
TS = Rs*Rs_initial'*(TS_initial - AC_initial) + AC;
AI = Rs*Rs_initial'*(AI_initial - AC_initial) + AC;

%--------------------------------------------------------------------------
% nonlinear equality constraint for the TS and AI landmark
%--------------------------------------------------------------------------
% TS ellipsoide
E_TS = diag([1/REDATA.TSaxes(1)^2; 1/REDATA.TSaxes(2)^2; 1/REDATA.TSaxes(3)^2]);

% AI ellipsoide
E_AI = diag([1/REDATA.AIaxes(1)^2; 1/REDATA.AIaxes(2)^2; 1/REDATA.AIaxes(3)^2]);

% TS constraint
phi_TS = (TS-REDATA.Centre)'*E_TS*(TS-REDATA.Centre)-1;

% AI constraint
phi_AI = (AI-REDATA.Centre)'*E_AI*(AI-REDATA.Centre)-1;

scapulothoracic_constraints = [phi_TS phi_AI]';

% nonequality nonlinear cosntraint
c = [];
 
return;

% -------------------------------------------------------------------------
% while parametrizing the joint space using splines Philippe believed that
% using the velocity of the landmarks in the output space and constraning
% the problem to also satisfy thoese velocities would help the optimizer
% end up at a desired solution. To that end, I added few lines in the
% MAIN_INITIALISATION_build_data_dynamics to define the jacobian and the
% first and second time derivatives of the jacobian. These three relates
% the position, velocity and acceleration of joint space to thoese of the
% output space. The code below is a part of that code to use the
% precalculated symbolic equations of the dphi_AI and ddphi_AI.

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Get the Joint Angles
% xc = q(1,1);
% yc = q(2,1);
% zc = q(3,1);
% xs = q(4,1); 
% ys = q(5,1);
% zs = q(6,1);
% zh = q(7,1); 
% yh = q(8,1); 
% zzh = q(9,1);
% xu = q(10,1);
% zr = q(11,1);
% 
% % Get the Joint Angular Velocities
% dxc = dq(1,1);
% dyc = dq(2,1);
% dzc = dq(3,1);
% dxs = dq(4,1); 
% dys = dq(5,1);
% dzs = dq(6,1);
% dzh = dq(7,1); 
% dyh = dq(8,1); 
% dzzh = dq(9,1);
% dxu = dq(10,1);
% dzr = dq(11,1);
% 
% ddxc = ddq(1,1);
% ddyc = ddq(2,1);
% ddzc = ddq(3,1);
% ddxs = ddq(4,1); 
% ddys = ddq(5,1);
% ddzs = ddq(6,1);
% ddzh = ddq(7,1); 
% ddyh = ddq(8,1); 
% ddzzh = ddq(9,1);
% ddxu = ddq(10,1);
% ddzr = ddq(11,1);
% 
% 
% SCx = SC(1); SCy = SC(2); SCz = SC(3);
% ACx = AC(1); ACy = AC(2); ACz =AC(3);
% %AAx = DYDATA.AA(1)/1000; AAy = DYDATA.AA(2)/1000; AAz = DYDATA.AA(3)/1000;
% TSx = TS(1); TSy = TS(2); TSz = TS(3);
% AIx = AI(1); AIy = AI(2); AIz = AI(3);
% % GHx = DYDATA.GH(1)/1000; GHy = DYDATA.GH(2)/1000; GHz = DYDATA.GH(3)/1000;
% % HUx = DYDATA.HU(1)/1000; HUy = DYDATA.HU(2)/1000; HUz = DYDATA.HU(3)/1000;
% % USx = DYDATA.US(1)/1000; USy = DYDATA.US(2)/1000; USz = DYDATA.US(3)/1000;
% % CPx = DYDATA.CP(1)/1000; CPy = DYDATA.CP(2)/1000; CPz = DYDATA.CP(3)/1000;
% % RSx = DYDATA.RS(1)/1000; RSy = DYDATA.RS(2)/1000; RSz = DYDATA.RS(3)/1000;
% OEx = REDATA.Centre(1); OEy = REDATA.Centre(2); OEz = REDATA.Centre(3);
% Ats = REDATA.TSaxes(1); Bts = REDATA.TSaxes(2); Cts = REDATA.TSaxes(3);
% Aai = REDATA.AIaxes(1); Bai = REDATA.AIaxes(2); Cai = REDATA.AIaxes(3);
% 
% ESTIMATION_TOOL_constraints_file;
% 
% 
% dphi_TS = dPHItsdt;
% dphi_AI = dPHIaidt;
% 
% 
% ddphi_TS = ddPHItsdt;
% ddphi_AI = ddPHIaidt;