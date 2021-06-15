function [JCDATA, JGUIHandle] = JOINT_CONE_TOOL_change_cone(task, SliderId, ConeId, JCDATA_in, JGUIHandle_in)
% UICONTROL Callback updates the cone date when a uicontrol is modified
%--------------------------------------------------------------------------
% Syntax :
% [JCDATA, JGUIHandle] = JOINT_CONE_TOOL_change_cone(task, SliderId, ConeId, JCDATA_in, JGUIHandle_in)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function updates the cone date when a uicontrol from the joint tool
% is modified.
%--------------------------------------------------------------------------

% Initialise the output
JCDATA = JCDATA_in;
JGUIHandle = JGUIHandle_in;

%--------------------------------------------------------------------------
% THE SLIDER WAS MODIFIED
%--------------------------------------------------------------------------
if isequal(task, 'Slider Modified')
    switch ConeId
        case 1
            switch SliderId
                %---------------------------------------------------------
                case 1      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.EditDimx, 'string', num2str(get(JGUIHandle.SCCone.SliderDimx, 'value')));
                    %---------------------------------------------------------
                case 2      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.EditDimy, 'string', num2str(get(JGUIHandle.SCCone.SliderDimy, 'value')));
                    %---------------------------------------------------------
                case 3      % CONE HEIGHT
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.EditDimz, 'string', num2str(get(JGUIHandle.SCCone.SliderDimz, 'value')));
                    %---------------------------------------------------------
                case 4      % CONE X-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.EditAnglex, 'string', num2str(get(JGUIHandle.SCCone.SliderAnglex, 'value')));
                    %---------------------------------------------------------
                case 5      % CONE Y-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.EditAngley, 'string', num2str(get(JGUIHandle.SCCone.SliderAngley, 'value')));
                    %---------------------------------------------------------
                case 6      % CONE Z-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.EditAnglez, 'string', num2str(get(JGUIHandle.SCCone.SliderAnglez, 'value')));
            end
        case 2
            switch SliderId
                %---------------------------------------------------------
                case 1      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.EditDimx, 'string', num2str(get(JGUIHandle.ACCone.SliderDimx, 'value')));
                    %---------------------------------------------------------
                case 2      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.EditDimy, 'string', num2str(get(JGUIHandle.ACCone.SliderDimy, 'value')));
                    %---------------------------------------------------------
                case 3      % CONE HEIGHT
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.EditDimz, 'string', num2str(get(JGUIHandle.ACCone.SliderDimz, 'value')));
                    %---------------------------------------------------------
                case 4      % CONE X-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.EditAnglex, 'string', num2str(get(JGUIHandle.ACCone.SliderAnglex, 'value')));
                    %---------------------------------------------------------
                case 5      % CONE Y-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.EditAngley, 'string', num2str(get(JGUIHandle.ACCone.SliderAngley, 'value')));
                    %---------------------------------------------------------
                case 6      % CONE Z-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.EditAnglez, 'string', num2str(get(JGUIHandle.ACCone.SliderAnglez, 'value')));
            end
        case 3
            switch SliderId
                %---------------------------------------------------------
                case 1      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.EditDimx, 'string', num2str(get(JGUIHandle.GHCone.SliderDimx, 'value')));
                    %---------------------------------------------------------
                case 2      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.EditDimy, 'string', num2str(get(JGUIHandle.GHCone.SliderDimy, 'value')));
                    %---------------------------------------------------------
                case 3      % CONE HEIGHT
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.EditDimz, 'string', num2str(get(JGUIHandle.GHCone.SliderDimz, 'value')));
                    %---------------------------------------------------------
                case 4      % CONE X-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.EditAnglex, 'string', num2str(get(JGUIHandle.GHCone.SliderAnglex, 'value')));
                    %---------------------------------------------------------
                case 5      % CONE Y-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.EditAngley, 'string', num2str(get(JGUIHandle.GHCone.SliderAngley, 'value')));
                    %---------------------------------------------------------
                case 6      % CONE Z-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.EditAnglez, 'string', num2str(get(JGUIHandle.GHCone.SliderAnglez, 'value')));
            end
    end
%--------------------------------------------------------------------------
% THE VALUE WAS MODIFIED
%--------------------------------------------------------------------------
elseif isequal(task, 'Value Modified')
    switch ConeId
        case 1
            switch SliderId
                %---------------------------------------------------------
                case 1      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.SliderDimx, 'value', str2double(get(JGUIHandle.SCCone.EditDimx, 'string')));
                %---------------------------------------------------------
                case 2      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.SliderDimy, 'value', str2double(get(JGUIHandle.SCCone.EditDimy, 'string')));
                %---------------------------------------------------------
                case 3      % CONE HEIGHT
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.SliderDimz, 'value', str2double(get(JGUIHandle.SCCone.EditDimz, 'string')));
                %---------------------------------------------------------
                case 4      % CONE X-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.SliderAnglex, 'value', str2double(get(JGUIHandle.SCCone.EditAnglex, 'string')));
                %---------------------------------------------------------
                case 5      % CONE Y-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.SliderAngley, 'value', str2double(get(JGUIHandle.SCCone.EditAngley, 'string')));
                %---------------------------------------------------------
                case 6      % CONE Z-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.SliderAnglez, 'value', str2double(get(JGUIHandle.SCCone.EditAnglez, 'string')));
            end
        case 2
            switch SliderId
                %---------------------------------------------------------
                case 1      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.SliderDimx, 'value', str2double(get(JGUIHandle.ACCone.EditDimx, 'string')));
                %---------------------------------------------------------
                case 2      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.SliderDimy, 'value', str2double(get(JGUIHandle.ACCone.EditDimy, 'string')));
                %---------------------------------------------------------
                case 3      % CONE HEIGHT
                    % Set the value of the text edit
                    set(JGUIHandle.SCCone.SliderDimz, 'value', str2double(get(JGUIHandle.ACCone.EditDimz, 'string')));
                %---------------------------------------------------------
                case 4      % CONE X-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.SliderAnglex, 'value', str2double(get(JGUIHandle.ACCone.EditAnglex, 'string')));
                %---------------------------------------------------------
                case 5      % CONE Y-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.SliderAngley, 'value', str2double(get(JGUIHandle.ACCone.EditAngley, 'string')));
                %---------------------------------------------------------
                case 6      % CONE Z-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.ACCone.SliderAnglez, 'value', str2double(get(JGUIHandle.ACCone.EditAnglez, 'string')));
            end
        case 3
            switch SliderId
                %---------------------------------------------------------
                case 1      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.SliderDimx, 'value', str2double(get(JGUIHandle.GHCone.EditDimx, 'string')));
                    %---------------------------------------------------------
                case 2      % CONE BASE DIMENSION 1
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.SliderDimy, 'value', str2double(get(JGUIHandle.GHCone.EditDimy, 'string')));
                    %---------------------------------------------------------
                case 3      % CONE HEIGHT
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.SliderDimz, 'value', str2double(get(JGUIHandle.GHCone.EditDimz, 'string')));
                    %---------------------------------------------------------
                case 4      % CONE X-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.SliderAnglex, 'value', str2double(get(JGUIHandle.GHCone.EditAnglex, 'string')));
                    %---------------------------------------------------------
                case 5      % CONE Y-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.SliderAngley, 'value', str2double(get(JGUIHandle.GHCone.EditAngley, 'string')));
                    %---------------------------------------------------------
                case 6      % CONE Z-AXIS ANGLE
                    % Set the value of the text edit
                    set(JGUIHandle.GHCone.SliderAnglez, 'value', str2double(get(JGUIHandle.GHCone.EditAnglez, 'string')));
            end
    end
else
    error('myApp:TaskCheck', 'Not A Valid Task!');
end

%--------------------------------------------------------------------------
% Set the JCDATA structure values
%--------------------------------------------------------------------------
switch ConeId
    case 1 % SC CONE DATA
        JCDATA.SCCone.ConeAngle = [str2double(get(JGUIHandle.SCCone.EditAnglex, 'string'));
                                   str2double(get(JGUIHandle.SCCone.EditAngley, 'string'));
                                   str2double(get(JGUIHandle.SCCone.EditAnglez, 'string'))]*pi/180;
        JCDATA.SCCone.Dimensions = [str2double(get(JGUIHandle.SCCone.EditDimx, 'string'));
                                    str2double(get(JGUIHandle.SCCone.EditDimy, 'string'));
                                    str2double(get(JGUIHandle.SCCone.EditDimz, 'string'))];
    case 2 % AC CONE DATA
        JCDATA.ACCone.ConeAngle = [str2double(get(JGUIHandle.ACCone.EditAnglex, 'string'));
                                   str2double(get(JGUIHandle.ACCone.EditAngley, 'string'));
                                   str2double(get(JGUIHandle.ACCone.EditAnglez, 'string'))]*pi/180;
        JCDATA.ACCone.Dimensions = [str2double(get(JGUIHandle.ACCone.EditDimx, 'string'));
                                    str2double(get(JGUIHandle.ACCone.EditDimy, 'string'));
                                    str2double(get(JGUIHandle.ACCone.EditDimz, 'string'))];
    case 3 % GH CONE DATA
        JCDATA.GHCone.ConeAngle = [str2double(get(JGUIHandle.GHCone.EditAnglex, 'string'));
                                   str2double(get(JGUIHandle.GHCone.EditAngley, 'string'));
                                   str2double(get(JGUIHandle.GHCone.EditAnglez, 'string'))]*pi/180;
        JCDATA.GHCone.Dimensions = [str2double(get(JGUIHandle.GHCone.EditDimx, 'string'));
                                    str2double(get(JGUIHandle.GHCone.EditDimy, 'string'));
                                    str2double(get(JGUIHandle.GHCone.EditDimz, 'string'))];
end
return;