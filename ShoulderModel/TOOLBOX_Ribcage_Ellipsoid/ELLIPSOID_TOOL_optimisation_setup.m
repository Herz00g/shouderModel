function [EOPTDATA] =  ELLIPSOID_TOOL_optimisation_setup(EGUIHandle, EOPTDATA_In)
% Uicontrol callback function which updates the optimisation data structure.
%--------------------------------------------------------------------------
% Syntax :
% [EOPTDATA] =  ELLIPSOID_TOOL_optimisation_setup(EGUIHandle, EOPTDATA_In)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function gets all the current optimisation settings from the
% uicontrols of the ELLIPSOID_TOOL GUI.
%
%--------------------------------------------------------------------------

% Initialise the output
EOPTDATA = EOPTDATA_In;

% Get the Lower Bounds
EOPTDATA.Lower_Bounds(1,1) = str2double(get(EGUIHandle.Optimisation_Parameters.CentreXLbv, 'string'));
EOPTDATA.Lower_Bounds(1,2) = str2double(get(EGUIHandle.Optimisation_Parameters.CentreYLbv, 'string'));
EOPTDATA.Lower_Bounds(1,3) = str2double(get(EGUIHandle.Optimisation_Parameters.CentreZLbv, 'string'));
EOPTDATA.Lower_Bounds(1,4) = str2double(get(EGUIHandle.Optimisation_Parameters.AxisXLbv, 'string'));
EOPTDATA.Lower_Bounds(1,5) = str2double(get(EGUIHandle.Optimisation_Parameters.AxisYLbv, 'string'));
EOPTDATA.Lower_Bounds(1,6) = str2double(get(EGUIHandle.Optimisation_Parameters.AxisZLbv, 'string'));

% Get the Upper Bounds
EOPTDATA.Upper_Bounds(1,1) = str2double(get(EGUIHandle.Optimisation_Parameters.CentreXUbv, 'string'));
EOPTDATA.Upper_Bounds(1,2) = str2double(get(EGUIHandle.Optimisation_Parameters.CentreYUbv, 'string'));
EOPTDATA.Upper_Bounds(1,3) = str2double(get(EGUIHandle.Optimisation_Parameters.CentreZUbv, 'string'));
EOPTDATA.Upper_Bounds(1,4) = str2double(get(EGUIHandle.Optimisation_Parameters.AxisXUbv, 'string'));
EOPTDATA.Upper_Bounds(1,5) = str2double(get(EGUIHandle.Optimisation_Parameters.AxisYUbv, 'string'));
EOPTDATA.Upper_Bounds(1,6) = str2double(get(EGUIHandle.Optimisation_Parameters.AxisZUbv, 'string'));

% Get the Initial Values
EOPTDATA.Initial_Guess(1,1) = str2double(get(EGUIHandle.Optimisation_Parameters.CentreXov, 'string'));
EOPTDATA.Initial_Guess(1,2) = str2double(get(EGUIHandle.Optimisation_Parameters.CentreYov, 'string'));
EOPTDATA.Initial_Guess(1,3) = str2double(get(EGUIHandle.Optimisation_Parameters.CentreZov, 'string'));
EOPTDATA.Initial_Guess(1,4) = str2double(get(EGUIHandle.Optimisation_Parameters.AxisXov, 'string'));
EOPTDATA.Initial_Guess(1,5) = str2double(get(EGUIHandle.Optimisation_Parameters.AxisYov, 'string'));
EOPTDATA.Initial_Guess(1,6) = str2double(get(EGUIHandle.Optimisation_Parameters.AxisZov, 'string'));

% List of Algorithms, Tolenrances & Maximum function evaluations
Algorithm_List = {'sqp', 'trust-region-reflective', 'interior-point', 'active-set'};
Tolerance_list = [1.e-3, 1.e-4, 1.e-5, 1.e-6, 1.e-7, 1.e-8];
Iterations_List = [1.e2, 1.e3, 1.e4];

% Get All the Data Into the Structure
EOPTDATA.Algorithm      = Algorithm_List{1,get(EGUIHandle.Optimisation_Setup.AlgorithmSelect, 'value')};
EOPTDATA.TolX           = Tolerance_list(1,get(EGUIHandle.Optimisation_Setup.TolXSelect, 'value'));
EOPTDATA.TolFun         = Tolerance_list(1,get(EGUIHandle.Optimisation_Setup.TolFunSelect, 'value'));
EOPTDATA.TolCon         = Tolerance_list(1,get(EGUIHandle.Optimisation_Setup.TolConSelect, 'value'));
EOPTDATA.MaxFunEval     = Iterations_List(1,get(EGUIHandle.Optimisation_Setup.MaxFunEvalSelect, 'value'));
EOPTDATA.MaxIter        = Iterations_List(1,get(EGUIHandle.Optimisation_Setup.MaxIterSelect, 'value'));
return;