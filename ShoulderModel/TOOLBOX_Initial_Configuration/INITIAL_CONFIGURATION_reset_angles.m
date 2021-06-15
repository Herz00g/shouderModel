function [BLDATA, ICGUIHandle] = INITIAL_CONFIGURATION_reset_angles(BLDATA_in, ICGUIHandle_in)
% Function for reseting the joint angles to the original configuration
%--------------------------------------------------------------------------
% Syntax :
% [BLDATA, ICGUIHandle] = INITIAL_CONFIGURATION_reset_angles(BLDATA_in, ICGUIHandle_in)
%--------------------------------------------------------------------------

%
% File Description :
% This function resets all the joint angles to the original values of the
% data set. It also resets the uicontrol values. 
%--------------------------------------------------------------------------

% Create the outputs
BLDATA = BLDATA_in;
ICGUIHandle = ICGUIHandle_in;

% Get the Euler Angles of the Original Matrices
JEA0 = MAIN_TOOL_geometry_functions('Get Euler Angles From Original Rotation Matrices', BLDATA);

%---------------------------------------------------------
% CLAVICULA AXIAL ROTATION
set(ICGUIHandle.Clavicula_Axial_Rotation.Slider, 'value', JEA0(1)*180/pi);
set(ICGUIHandle.Clavicula_Axial_Rotation.Edit, 'string', num2str(JEA0(1)*180/pi));
%---------------------------------------------------------
% CLAVICULA ELEVATION
set(ICGUIHandle.Clavicula_Elevation_Rotation.Slider, 'value', JEA0(2)*180/pi);
set(ICGUIHandle.Clavicula_Elevation_Rotation.Edit, 'string', num2str(JEA0(2)*180/pi));
%---------------------------------------------------------
% CLAVICULA PROTRACTION
set(ICGUIHandle.Clavicula_Protraction_Rotation.Slider, 'value', JEA0(3)*180/pi);
set(ICGUIHandle.Clavicula_Protraction_Rotation.Edit, 'string', num2str(JEA0(3)*180/pi));
%---------------------------------------------------------
% SCAPULA AXIAL TILT
set(ICGUIHandle.Scapula_Tilt_Rotation.Slider, 'value', JEA0(4)*180/pi);
set(ICGUIHandle.Scapula_Tilt_Rotation.Edit, 'string', num2str(JEA0(4)*180/pi));
%---------------------------------------------------------
% SCAPULA ELEVATION
set(ICGUIHandle.Scapula_Elevation_Rotation.Slider, 'value', JEA0(5)*180/pi);
set(ICGUIHandle.Scapula_Elevation_Rotation.Edit, 'string', num2str(JEA0(5)*180/pi));
%---------------------------------------------------------
% SCAPULA PROTRACTION
set(ICGUIHandle.Scapula_Protraction_Rotation.Slider, 'value', JEA0(6)*180/pi);
set(ICGUIHandle.Scapula_Protraction_Rotation.Edit, 'string', num2str(JEA0(6)*180/pi));
%---------------------------------------------------------
% HUMERUS AXIAL ROTATION
set(ICGUIHandle.Humerus_Axial_Rotation.Slider, 'value', JEA0(7)*180/pi);
set(ICGUIHandle.Humerus_Axial_Rotation.Edit, 'string', num2str(JEA0(7)*180/pi));
%---------------------------------------------------------
% HUMERUS ELEVATION
set(ICGUIHandle.Humerus_Abduction_Rotation.Slider, 'value', JEA0(8)*180/pi);
set(ICGUIHandle.Humerus_Abduction_Rotation.Edit, 'string', num2str(JEA0(8)*180/pi));
%---------------------------------------------------------
% HUMERUS ELEVATION PLANE
set(ICGUIHandle.Humerus_Elevation_Plane.Slider, 'value', JEA0(9)*180/pi);
set(ICGUIHandle.Humerus_Elevation_Plane.Edit, 'string', num2str(JEA0(9)*180/pi));
%---------------------------------------------------------
% ULNA Flexion
set(ICGUIHandle.Ulna_Flexion_Rotation.Slider, 'value', round(JEA0(10)*180/pi));
set(ICGUIHandle.Ulna_Flexion_Rotation.Edit, 'string', num2str(round(JEA0(10)*180/pi)));
%---------------------------------------------------------
% RADIUS Pronation
set(ICGUIHandle.Radius_Pronation_Rotation.Slider, 'value', round(JEA0(11)*180/pi));
set(ICGUIHandle.Radius_Pronation_Rotation.Edit, 'string', num2str(round(JEA0(11)*180/pi)));

%--------------------------------------------------------------------------
% RESET ALL THE BONY LANDMARK DATA
%--------------------------------------------------------------------------
% Reset the initial configuration
BLDATA = MAIN_TOOL_geometry_functions(...
    'Update Initial Bony Landmark Data from Joint Rotation Matrices',...
    BLDATA.Original_Matrices_L2A.Rc, BLDATA.Original_Matrices_L2A.Rs, BLDATA.Original_Matrices_L2A.Rh, BLDATA.Original_Matrices_L2A.Ru, BLDATA.Original_Matrices_L2A.Rr, BLDATA);

% Update the current configuration
BLDATA = MAIN_TOOL_geometry_functions(...
    'Update Current Bony Landmark Data from Joint Rotation Matrices',...
    BLDATA.Original_Matrices_L2A.Rc, BLDATA.Original_Matrices_L2A.Rs, BLDATA.Original_Matrices_L2A.Rh, BLDATA.Original_Matrices_L2A.Ru, BLDATA.Original_Matrices_L2A.Rr, BLDATA);

return;