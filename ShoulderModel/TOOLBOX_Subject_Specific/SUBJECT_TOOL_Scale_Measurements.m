function SSDATA = SUBJECT_TOOL_Scale_Measurements(SGUIHandle, SSDATAin)
%{
Function to scale measured kinematics.
--------------------------------------------------------------------------
Syntax :
SSDATA = SUBJECT_TOOL_Scale_Measurements(SGUIHandle, SSDATAin)
--------------------------------------------------------------------------
File Description :
Given that we did not manage/plan to measure the kinematics on each
patient, we decided to use the measurements of the generic subject for each
one of the patients from our cohort. Therefore, the measurements must be
scaled accoridng to the under study patient.
--------------------------------------------------------------------------
%}

% initialize the SSDATA
SSDATA = SSDATAin;

% import the subject's height [m]?from the GUI
Subject_Height = str2double(get(SGUIHandle.Height_Selection.Height,'String')); 

% define the scaling factor
Height_Scaling_Factor = [Subject_Height/1.86 0 0; 0 Subject_Height/1.86 0; 0 0 Subject_Height/1.86];

% scale the measured landmarks                           
for TimeId = 1:length(SSDATA.Measured_Kinematics.IJ)
    
    IJ(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.IJ(:,TimeId);
    PX(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.PX(:,TimeId);
    T8(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.T8(:,TimeId);
    C7(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.C7(:,TimeId);
    SC(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.SC(:,TimeId);
    Ac(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.Ac(:,TimeId);
    AA(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.AA(:,TimeId);
    EL(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.EL(:,TimeId);
    EM(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.EM(:,TimeId);
    US(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.US(:,TimeId);
    RS(:,TimeId) = Height_Scaling_Factor*SSDATA.Measured_Kinematics.RS(:,TimeId);
end

% replace the measured landmarks with the scaled landmarks
    SSDATA.Measured_Kinematics.IJ = IJ;
    SSDATA.Measured_Kinematics.PX = PX;
    SSDATA.Measured_Kinematics.T8 = T8;
    SSDATA.Measured_Kinematics.C7 = C7;
    SSDATA.Measured_Kinematics.SC = SC;
    SSDATA.Measured_Kinematics.Ac = Ac;
    SSDATA.Measured_Kinematics.AA = AA;
    SSDATA.Measured_Kinematics.EL = EL;
    SSDATA.Measured_Kinematics.EM = EM;
    SSDATA.Measured_Kinematics.US = US;
    SSDATA.Measured_Kinematics.RS = RS;
    
    return;
    



