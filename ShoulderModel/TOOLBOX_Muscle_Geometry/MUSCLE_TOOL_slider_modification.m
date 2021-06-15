function [BLDATA, ICGUIHandle] = MUSCLE_TOOL_slider_modification(task, BLDATA_in, ICGUIHandle_in)
% Function for modifying the Initial Configuration GUI uicontrols.
%--------------------------------------------------------------------------
% Syntax :
% [BLDATA, ICGUIHandle] = MUSCLE_TOOL_slider_modification(task, BLDATA_in, ICGUIHandle_in)
%--------------------------------------------------------------------------
%
% File Description :
% This function updates the initial configuration every time a slider or
% edit box is modified in the muscle wrapping tool toolbox.
%--------------------------------------------------------------------------

% Initialise the output
BLDATA = BLDATA_in;
ICGUIHandle = ICGUIHandle_in;

%--------------------------------------------------------------------------
% Update the Settings of the uicontrols from the initial configuration GUI
%--------------------------------------------------------------------------
if isequal(task, 'Slider Modified')
    %---------------------------------------------------------
    % CLAVICULA AXIAL ROTATION
    set(ICGUIHandle.Clavicula_Axial_Rotation.Edit,...
        'string', num2str(get(ICGUIHandle.Clavicula_Axial_Rotation.Slider, 'value')));
    %---------------------------------------------------------
    % CLAVICULA ELEVATION
    set(ICGUIHandle.Clavicula_Elevation_Rotation.Edit,...
        'string', num2str(get(ICGUIHandle.Clavicula_Elevation_Rotation.Slider, 'value')));
    %---------------------------------------------------------
    % CLAVICULA PROTRACTION
    set(ICGUIHandle.Clavicula_Protraction_Rotation.Edit,...
        'string', num2str(get(ICGUIHandle.Clavicula_Protraction_Rotation.Slider, 'value')));
    %---------------------------------------------------------
    % SCAPULA AXIAL TILT
    set(ICGUIHandle.Scapula_Tilt_Rotation.Edit,...
        'string', num2str(get(ICGUIHandle.Scapula_Tilt_Rotation.Slider, 'value')));
    %---------------------------------------------------------
    % SCAPULA ELEVATION
    set(ICGUIHandle.Scapula_Elevation_Rotation.Edit,...
        'string', num2str(get(ICGUIHandle.Scapula_Elevation_Rotation.Slider, 'value')));
    %---------------------------------------------------------
    % SCAPULA PROTRACTION
    set(ICGUIHandle.Scapula_Protraction_Rotation.Edit,...
        'string', num2str(get(ICGUIHandle.Scapula_Protraction_Rotation.Slider, 'value')));
    %---------------------------------------------------------
    % HUMERUS AXIAL ROTATION
    set(ICGUIHandle.Humerus_Axial_Rotation.Edit,...
        'string', num2str(get(ICGUIHandle.Humerus_Axial_Rotation.Slider, 'value')));
    %---------------------------------------------------------
    % HUMERUS ELEVATION
    set(ICGUIHandle.Humerus_Abduction_Rotation.Edit,...
        'string', num2str(get(ICGUIHandle.Humerus_Abduction_Rotation.Slider, 'value')));
    %---------------------------------------------------------
    % HUMERUS ELEVATION PLANE
    set(ICGUIHandle.Humerus_Elevation_Plane.Edit,...
        'string', num2str(get(ICGUIHandle.Humerus_Elevation_Plane.Slider, 'value')));
    %--------------------------------------------------------------------------
    % ULNA Flexion
    set(ICGUIHandle.Ulna_Flexion_Rotation.Edit,...
        'string', num2str(get(ICGUIHandle.Ulna_Flexion_Rotation.Slider, 'value')));
    %--------------------------------------------------------------------------
    % RADIUS Pronation
    set(ICGUIHandle.Radius_Pronation_Rotation.Edit,...
        'string', num2str(get(ICGUIHandle.Radius_Pronation_Rotation.Slider, 'value')));
    %--------------------------------------------------------------------------
elseif isequal(task, 'Value Modified')
    %---------------------------------------------------------
    % CLAVICULA AXIAL ROTATION
    set(ICGUIHandle.Clavicula_Axial_Rotation.Slider,...
        'value', str2double(get(ICGUIHandle.Clavicula_Axial_Rotation.Edit, 'string')));
    %---------------------------------------------------------
    % CLAVICULA ELEVATION
    set(ICGUIHandle.Clavicula_Elevation_Rotation.Slider,...
        'value', str2double(get(ICGUIHandle.Clavicula_Elevation_Rotation.Edit, 'string')));
    %---------------------------------------------------------
    % CLAVICULA PROTRACTION
    set(ICGUIHandle.Clavicula_Protraction_Rotation.Slider,...
        'value', str2double(get(ICGUIHandle.Clavicula_Protraction_Rotation.Edit, 'string')));
    %---------------------------------------------------------
    % SCAPULA AXIAL TILT
    set(ICGUIHandle.Scapula_Tilt_Rotation.Slider,...
        'value', str2double(get(ICGUIHandle.Scapula_Tilt_Rotation.Edit, 'string')));
    %---------------------------------------------------------
    % SCAPULA ELEVATION
    set(ICGUIHandle.Scapula_Elevation_Rotation.Slider,...
        'value', str2double(get(ICGUIHandle.Scapula_Elevation_Rotation.Edit, 'string')));
    %---------------------------------------------------------
    % SCAPULA PROTRACTION
    set(ICGUIHandle.Scapula_Protraction_Rotation.Slider,...
        'value', str2double(get(ICGUIHandle.Scapula_Protraction_Rotation.Edit, 'string')));
    %---------------------------------------------------------
    % HUMERUS AXIAL ROTATION
    set(ICGUIHandle.Humerus_Axial_Rotation.Slider,...
        'value', str2double(get(ICGUIHandle.Humerus_Axial_Rotation.Edit, 'string')));
    %---------------------------------------------------------
    % HUMERUS ELEVATION
    set(ICGUIHandle.Humerus_Abduction_Rotation.Slider,...
        'value', str2double(get(ICGUIHandle.Humerus_Abduction_Rotation.Edit, 'string')));
    %---------------------------------------------------------
    % HUMERUS ELEVATION PLANE
    set(ICGUIHandle.Humerus_Elevation_Plane.Slider,...
        'value', str2double(get(ICGUIHandle.Humerus_Elevation_Plane.Edit, 'string')));
    %--------------------------------------------------------------------------
    % ULNA Flexion
    set(ICGUIHandle.Ulna_Flexion_Rotation.Slider,...
        'value', str2double(get(ICGUIHandle.Ulna_Flexion_Rotation.Edit, 'string')));
    %--------------------------------------------------------------------------
    % RADIUS Pronation
    set(ICGUIHandle.Radius_Pronation_Rotation.Slider,...
        'value', str2double(get(ICGUIHandle.Radius_Pronation_Rotation.Edit, 'string')));
    % The desired task is not valid
else
    error('myApp:TaskCheck', 'Not A Valid Task!');
end

%--------------------------------------------------------------------------
% UPDATE THE CURRENT ROTATION MATRICES
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Get All Current Euler Angles
EAList(1,1) = get(ICGUIHandle.Clavicula_Axial_Rotation.Slider, 'value');
EAList(2,1) = get(ICGUIHandle.Clavicula_Elevation_Rotation.Slider, 'value');
EAList(3,1) = get(ICGUIHandle.Clavicula_Protraction_Rotation.Slider, 'value');
EAList(4,1) = get(ICGUIHandle.Scapula_Tilt_Rotation.Slider, 'value');
EAList(5,1) = get(ICGUIHandle.Scapula_Elevation_Rotation.Slider, 'value');
EAList(6,1) = get(ICGUIHandle.Scapula_Protraction_Rotation.Slider, 'value');
EAList(7,1) = get(ICGUIHandle.Humerus_Axial_Rotation.Slider, 'value');
EAList(8,1) = get(ICGUIHandle.Humerus_Abduction_Rotation.Slider, 'value');
EAList(9,1) = get(ICGUIHandle.Humerus_Elevation_Plane.Slider, 'value');
EAList(10,1) = get(ICGUIHandle.Ulna_Flexion_Rotation.Slider, 'value');
EAList(11,1) = get(ICGUIHandle.Radius_Pronation_Rotation.Slider, 'value');


% Build the New Initial Rotation Matrices
Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles', EAList*pi/180, BLDATA);

% Update the initial configuration
BLDATA = MAIN_TOOL_geometry_functions(...
    'Update Initial Bony Landmark Data from Joint Rotation Matrices', Rmat(:,1:3), Rmat(:,4:6), Rmat(:,7:9), Rmat(:,10:12), Rmat(:,13:15), BLDATA);

% Update the current configuration
BLDATA = MAIN_TOOL_geometry_functions(...
    'Update Current Bony Landmark Data from Joint Rotation Matrices', Rmat(:,1:3), Rmat(:,4:6), Rmat(:,7:9), Rmat(:,10:12), Rmat(:,13:15), BLDATA);
return;