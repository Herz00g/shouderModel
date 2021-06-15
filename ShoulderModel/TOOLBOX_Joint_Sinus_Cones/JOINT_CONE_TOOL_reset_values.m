function [JGUIHandle] = JOINT_CONE_TOOL_reset_values(JCDATA, JGUIHandle_in)
% Function which resets the cones to their original settings.
%--------------------------------------------------------------------------
% Syntax :
% [JGUIHandle] = JOINT_CONE_TOOL_reset_values(JCDATA, JGUIHandle_in)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function resets all the joint sinus cone data to the original
% values.
%--------------------------------------------------------------------------

% Initialise the output
JGUIHandle = JGUIHandle_in;

% List of parameters
ParamList = {'Dimx', 'Dimy', 'Dimz', 'Anglex', 'Angley', 'Anglez'};

for i = 1:3
    %----------------------------------------------------------------------
    % RESET SC CONE PARAMETETS
    %----------------------------------------------------------------------
    eval(['set(JGUIHandle.SCCone.Slider', ParamList{1,i}, ', ''value'', JCDATA.SCCone.Dimensions(', num2str(i), '));']);
    eval(['set(JGUIHandle.SCCone.Slider', ParamList{1,i+3}, ', ''value'', JCDATA.SCCone.ConeAngle(', num2str(i), ')*180/pi);']);
    eval(['set(JGUIHandle.SCCone.Edit', ParamList{1,i}, ', ''string'', num2str(JCDATA.SCCone.Dimensions(', num2str(i), ')));']);
    eval(['set(JGUIHandle.SCCone.Edit', ParamList{1,i+3}, ', ''string'', num2str(JCDATA.SCCone.ConeAngle(', num2str(i), ')*180/pi));']);
    
    %----------------------------------------------------------------------
    % RESET AC CONE PARAMETETS
    %----------------------------------------------------------------------
    eval(['set(JGUIHandle.ACCone.Slider', ParamList{1,i}, ', ''value'', JCDATA.ACCone.Dimensions(', num2str(i), '));']);
    eval(['set(JGUIHandle.ACCone.Slider', ParamList{1,i+3}, ', ''value'', JCDATA.ACCone.ConeAngle(', num2str(i), ')*180/pi);']);
    eval(['set(JGUIHandle.ACCone.Edit', ParamList{1,i}, ', ''string'', num2str(JCDATA.ACCone.Dimensions(', num2str(i), ')));']);
    eval(['set(JGUIHandle.ACCone.Edit', ParamList{1,i+3}, ', ''string'', num2str(JCDATA.ACCone.ConeAngle(', num2str(i), ')*180/pi));']);
    
    %----------------------------------------------------------------------
    % RESET GH CONE PARAMETETS
    %----------------------------------------------------------------------
    eval(['set(JGUIHandle.GHCone.Slider', ParamList{1,i}, ', ''value'', JCDATA.GHCone.Dimensions(', num2str(i), '));']);
    eval(['set(JGUIHandle.GHCone.Slider', ParamList{1,i+3}, ', ''value'', JCDATA.GHCone.ConeAngle(', num2str(i), ')*180/pi);']);
    eval(['set(JGUIHandle.GHCone.Edit', ParamList{1,i}, ', ''string'', num2str(JCDATA.GHCone.Dimensions(', num2str(i), ')));']);
    eval(['set(JGUIHandle.GHCone.Edit', ParamList{1,i+3}, ', ''string'', num2str(JCDATA.GHCone.ConeAngle(', num2str(i), ')*180/pi));']);
end
return;