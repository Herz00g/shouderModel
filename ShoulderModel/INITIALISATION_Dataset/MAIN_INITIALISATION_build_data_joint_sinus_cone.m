function JCDATA = MAIN_INITIALISATION_build_data_joint_sinus_cone()
% Function to initialise the joint sinus cone data set
%--------------------------------------------------------------------------
% Syntax :
% JCDATA = MAIN_INITIALISATION_build_data_joint_sinus_cone()
%--------------------------------------------------------------------------
%{
Note: the application of this function is different from how it's been used
in Garner's thesis. The user have an option to show these joint sinus cones
on the visualization without any effect on the motion.

File Description :
This function generates the initial joint sinus cone data structure.

Data Structure Format :
          JCDATA.SCcone.ConeAngle  X - Y - Z sequence
          JCDATA.ACcone.ConeAngle  X - Y - Z sequence
          JCDATA.GHcone.ConeAngle  X - Y - Z sequence
          JCDATA.SCcone.Dimensions [Cone Base Axis 1, Cone Base Axis 2, Cone Length]
          JCDATA.ACcone.Dimensions
          JCDATA.GHcone.Dimensions
          JCDATA.SCcone.RefSys
          JCDATA.ACcone.RefSys
          JCDATA.GHcone.RefSys
%}
%--------------------------------------------------------------------------

% Initialiase the Output
JCDATA = [];

% The SC Cone is defined in the clavicula reference system.
% Cone's axis is the X axis
JCDATA.SCCone.ConeAngle     = [-1.399; -0.059; -0.011];
JCDATA.SCCone.Dimensions    = [42; 25; 100];
JCDATA.SCCone.RefSys        = 0;

% The AC cone is defined in the scapula reference system
% Cone's axis is the Z axis
JCDATA.ACCone.ConeAngle     = [0.019; 0.09; 2.693];
JCDATA.ACCone.Dimensions    = [10.5; 8.1; 30];
JCDATA.ACCone.RefSys        = 1;

% The GH cone is defined in the humerus reference system
% Cone's axis is the Z axis
JCDATA.GHCone.ConeAngle     = [-0.201; -1.260; 3];
JCDATA.GHCone.Dimensions    = [96; 44; 40];
JCDATA.GHCone.RefSys        = 2;

return;