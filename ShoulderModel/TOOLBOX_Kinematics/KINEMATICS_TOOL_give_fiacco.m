function [Hessian_est, Lost_factor] = KINEMATICS_TOOL_give_fiacco(JEA, SSDATA, multipliers, time_id)


q1 = JEA(1);
q2 = JEA(2);
q3 = JEA(3);
q4 = JEA(4);
q5 = JEA(5);
q6 = JEA(6);
q7 = JEA(7);
q8 = JEA(8);
q9 = JEA(9);
q10 = JEA(10);
q11 = JEA(11);

% lagrange multipliers
w1 = multipliers(1, 1);
w2 = multipliers(2, 1);

i = time_id;

IJ_m1 = SSDATA.Measured_Kinematics.IJ(1,i);
IJ_m2 = SSDATA.Measured_Kinematics.IJ(2,i);
IJ_m3 = SSDATA.Measured_Kinematics.IJ(3,i);

PX_m1 = SSDATA.Measured_Kinematics.PX(1,i);
PX_m2 = SSDATA.Measured_Kinematics.PX(2,i);
PX_m3 = SSDATA.Measured_Kinematics.PX(3,i);

T8_m1 = SSDATA.Measured_Kinematics.T8(1,i);
T8_m2 = SSDATA.Measured_Kinematics.T8(2,i);
T8_m3 = SSDATA.Measured_Kinematics.T8(3,i);

C7_m1 = SSDATA.Measured_Kinematics.C7(1,i);
C7_m2 = SSDATA.Measured_Kinematics.C7(2,i);
C7_m3 = SSDATA.Measured_Kinematics.C7(3,i);

SC_m1 = SSDATA.Measured_Kinematics.SC(1,i);
SC_m2 = SSDATA.Measured_Kinematics.SC(2,i);
SC_m3 = SSDATA.Measured_Kinematics.SC(3,i);

AC_m1 = SSDATA.Measured_Kinematics.AC(1,i);
AC_m2 = SSDATA.Measured_Kinematics.AC(2,i);
AC_m3 = SSDATA.Measured_Kinematics.AC(3,i);

AA_m1 = SSDATA.Measured_Kinematics.AA(1,i);
AA_m2 = SSDATA.Measured_Kinematics.AA(2,i);
AA_m3 = SSDATA.Measured_Kinematics.AA(3,i);

TS_m1 = SSDATA.Measured_Kinematics.TS(1,i);
TS_m2 = SSDATA.Measured_Kinematics.TS(2,i);
TS_m3 = SSDATA.Measured_Kinematics.TS(3,i);

AI_m1 = SSDATA.Measured_Kinematics.AI(1,i);
AI_m2 = SSDATA.Measured_Kinematics.AI(2,i);
AI_m3 = SSDATA.Measured_Kinematics.AI(3,i);

GH_m1 = SSDATA.Measured_Kinematics.GH(1,i);
GH_m2 = SSDATA.Measured_Kinematics.GH(2,i);
GH_m3 = SSDATA.Measured_Kinematics.GH(3,i);

HU_m1 = SSDATA.Measured_Kinematics.HU(1,i);
HU_m2 = SSDATA.Measured_Kinematics.HU(2,i);
HU_m3 = SSDATA.Measured_Kinematics.HU(3,i);

EL_m1 = SSDATA.Measured_Kinematics.EL(1,i);
EL_m2 = SSDATA.Measured_Kinematics.EL(2,i);
EL_m3 = SSDATA.Measured_Kinematics.EL(3,i);

EM_m1 = SSDATA.Measured_Kinematics.EM(1,i);
EM_m2 = SSDATA.Measured_Kinematics.EM(2,i);
EM_m3 = SSDATA.Measured_Kinematics.EM(3,i);

US_m1 = SSDATA.Measured_Kinematics.US(1,i);
US_m2 = SSDATA.Measured_Kinematics.US(2,i);
US_m3 = SSDATA.Measured_Kinematics.US(3,i);

CP_m1 = SSDATA.Measured_Kinematics.CP(1,i);
CP_m2 = SSDATA.Measured_Kinematics.CP(2,i);
CP_m3 = SSDATA.Measured_Kinematics.CP(3,i);

RS_m1 = SSDATA.Measured_Kinematics.RS(1,i);
RS_m2 = SSDATA.Measured_Kinematics.RS(2,i);
RS_m3 = SSDATA.Measured_Kinematics.RS(3,i);

KINEMATICS_TOOL_lost_factor;

Hessian_est = M_matrix(1:11,1:11);
Lost_factor = M_matrix(2:11,2:11)\N_matrix(2:11,:);

return









