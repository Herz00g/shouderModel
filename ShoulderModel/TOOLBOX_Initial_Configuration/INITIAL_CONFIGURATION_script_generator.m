function CBScript = INITIAL_CONFIGURATION_script_generator(task, varargin)
% Intial Configuration GUI Callback script generator
%--------------------------------------------------------------------------
% Syntax :
% CBScript = INITIAL_CONFIGURATION_script_generator(task, varargin)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function generates scripts for the initial configuration GUI. The 
% scripts are generated as text arrays. The task input variable inidicates 
% which script to return.
% varargin contains extra information: type of uicontrol being modified,
% which angle is being changed.
%
% List of Scripts :
%           1) Close Intial Tool
%           2) Update Joint Angles
%           3) Reset Angles
%           4) Save Visualisation
%           5) Help
%
%--------------------------------------------------------------------------

% Initialise the Output
CBScript = [];

%--------------------------------------------------------------------------
% Task 1 : Close the GUI & Save All related data
% This script closes the gui and clears the variables. This script also
% redefined data which is necessary for other parts of the model like the
% kinematic data (initial values of the minimal coordinates). The ellipsoid
% data is also changed (scaling factors for TS and AI ellipsoid).
%--------------------------------------------------------------------------
if isequal(task, 'Close Intial Tool')
    % The data structures which are dependent on the initial bony landmark
    % configuration are recomputed.
   CBScript = [...
       'REDATA = MAIN_INITIALISATION_build_data_ribcage_ellipsoid(BLDATA);',...
       'KEDATA = MAIN_INITIALISATION_build_data_kinematics(REDATA, BLDATA);',...
       'clear ICGUIHandle;',...
       'clear IPlotHandles;',...
       'clear InitialVisualisationAxes;',...
       'close gcf;',...
       'clear IHandle;'];
   
%--------------------------------------------------------------------------
% Task 2 : Update the Joint Angles
% Script which is run when a slider or a edit box is changed by the user.
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Joint Angles')
    % Get the uicontrol modification type
    Mode = varargin{1,1};
    
    % Create script for the type of uicontrol that was modified
    if isequal(Mode, 'Slider Modified')
        CBScript = [...
            '[BLDATA, ICGUIHandle] =',...
            'INITIAL_CONFIGURATION_slider_modification(''Slider Modified'', BLDATA, ICGUIHandle);',...
            '[IPlotHandles] = INITIAL_CONFIGURATION_update_visualisation(IPlotHandles, BLDATA, MEDATA);'];
    elseif isequal(Mode, 'Value Modified')
        CBScript = [...
            '[BLDATA, ICGUIHandle] =',...
            'INITIAL_CONFIGURATION_slider_modification(''Value Modified'', BLDATA, ICGUIHandle);',...
            '[IPlotHandles] = INITIAL_CONFIGURATION_update_visualisation(IPlotHandles, BLDATA, MEDATA);'];
    else
    
    end
%--------------------------------------------------------------------------
% Task 3 : Reset the Joint Angles
% Resets the joint angles to the values in which they were initially
% obtained.
%--------------------------------------------------------------------------
elseif isequal(task, 'Reset Angles')
    CBScript = [...
        '[BLDATA, ICGUIHandle] = ',...
        'INITIAL_CONFIGURATION_reset_angles(BLDATA, ICGUIHandle);',...
        '[IPlotHandles] = INITIAL_CONFIGURATION_update_visualisation(IPlotHandles, BLDATA, MEDATA);'];
    
%--------------------------------------------------------------------------
% Task 4 : Save the Current Visualisation
% Saves the current visualisation using the main function
%--------------------------------------------------------------------------
elseif isequal(task, 'Save Visualisation')
    CBScript =  'MAIN_TOOL_save_visualisation(IHandle, 2);';

%--------------------------------------------------------------------------
% Task 5 : Help
% Displays the information text in the command window when the user clicks
% on the help menu.
%--------------------------------------------------------------------------
elseif isequal(task, 'Help')
    CBScript =  [
        'sprintf([''----------------- INITIAL CONFIGURATION TOOL -----------------------\n'', ',...
        ' ''This tool let you select an initial configuration for the model. The joint angles\n'',',...
        ' ''can be selected to impose a new configuration. If a mistake is made, the reset button\n'',',...
        ' ''will reset all the angles back to their original values in which they were obtained.'']);',...
        'disp(ans);'];
    
%--------------------------------------------------------------------------
% Throw an error if task is not valid
%--------------------------------------------------------------------------
else
    % Throw an error. No valid task was given
    ErrorMsg = [...
        'The user supplied task is not valid.',...
        'INITIAL_CONFIGURATION_script_generator requires a valid task as input.\n',...
        'Try the Following : \n',...
        '1) Close Intial Tool,\n',...
        '2) Update Joint Angles,\n',...
        '3) Reset Angles,\n',...
        '4) Save Visualisation.'];
    error('ScptGen:ErrorMsg', ErrorMsg);
end
return;