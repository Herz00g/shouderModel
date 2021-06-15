function CBScript = MAIN_TOOL_script_generator(task)
%{
 Uicontrol callback script generator for the main GUI.
--------------------------------------------------------------------------
Syntax :
CBScript = MAIN_TOOL_script_generator(task)
--------------------------------------------------------------------------

Function Description :
This function generates scripts for the main GUI uicontrols. MATLAB's
uicontrols (pushbuttons, edit boxes, etc...) allow for a script to be
executed when the user interacts with them. The script is called
callback. The scripts are generated as text arrays. The task input 
variable inidicates which script to return. No other inputs are
necessary. 
The list of possible tasks is the following :

         1) Save & Close
         2) Save Visualisation
         3) Save All Data Structures
         4) Update Visualisation
         5) Open Subject Specific Tool
         6) Open Initial Configuration Tool
         7) Open Muscle Tool
         8) Open Joint Sinus Cone Tool
         9) Open Ribcage Ellipsoid Tool
         10) Open Kinematics Tool
        11) Open Check Muscle Moment Arms Tool
        12) Open Muscle Force Estimation Tool
        13) Help

---------------------------------------------------------------------------
%}

% Initialise the output
CBScript = [];

%--------------------------------------------------------------------------
% Task 1 : Close the GUI & Save All related data
%--------------------------------------------------------------------------
if isequal(task, 'Save & Close')
    CBScript = [...
    'MAIN_TOOL_save_data(BLDATA, MEDATA, REDATA, MWDATA, KEDATA, DYDATA, MADATA);',...
    'close all; clear all; clc;'];

%--------------------------------------------------------------------------
% Task 2 : Save the Visualisation
%--------------------------------------------------------------------------
elseif isequal(task, 'Save Visualisation')
    CBScript = 'MAIN_TOOL_save_visualisation(MAINHandle, 1);';
    
%--------------------------------------------------------------------------
% Task 3 : Save the Current Data Strutures
%--------------------------------------------------------------------------
elseif isequal(task, 'Save All Data Structures')
    CBScript = [...
        'MAIN_TOOL_save_data',... 
        '(BLDATA, MEDATA, REDATA, MWDATA, KEDATA, DYDATA, MADATA);'];
    
%--------------------------------------------------------------------------
% Task 5 : Subject Specific Tool
%--------------------------------------------------------------------------
elseif isequal(task, 'Open Subject Specific Tool')
    CBScript = 'SUBJECT_TOOL_main_file;';    
    
%--------------------------------------------------------------------------
% Task 6 : Update the Visualisation
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Visualisation')
    CBScript = 'PlotHandles = MAIN_TOOL_update_visualisation(MAINGUIHandle, PlotHandles, BLDATA, MEDATA, MWDATA, REDATA);';
    
%--------------------------------------------------------------------------
% Task 5 : Open The Initial Configuration Tool
%--------------------------------------------------------------------------
elseif isequal(task, 'Open Initial Configuration Tool')
    CBScript = 'INITIAL_CONFIGURATION_main_file;';
    
%--------------------------------------------------------------------------
% Task 7 : Open The Muscle Wrapping Tool
%--------------------------------------------------------------------------
elseif isequal(task, 'Open Muscle Tool')
    CBScript = 'MUSCLE_TOOL_main_file;';
    
%--------------------------------------------------------------------------
% Task 8 : Open The Joint Sinus Cone Tool
%--------------------------------------------------------------------------
elseif isequal(task, 'Open Joint Tool')
    CBScript = 'JOINT_CONE_TOOL_main_file;';
    
%--------------------------------------------------------------------------
% Task 9 : Open The Ellipsoid Fitting Tool
%--------------------------------------------------------------------------
elseif isequal(task, 'Open Ellipsoid Tool')
    CBScript = 'ELLIPSOID_TOOL_main_file;';
    
%--------------------------------------------------------------------------
% Task 10 : Open The Kinematics Tool
%--------------------------------------------------------------------------
elseif isequal(task, 'Open Kinematics Tool')
    CBScript = 'KINEMATICS_TOOL_main_file;';
      
%--------------------------------------------------------------------------
% Task 11 : Open the moment arms verification tool
%--------------------------------------------------------------------------
elseif isequal(task, 'Check Moment Arms')
    CBScript = 'MOMENT_ARM_TOOL_main_file;';
    
%--------------------------------------------------------------------------
% Task 12 : Open the muscle force estimation tool
%--------------------------------------------------------------------------
elseif isequal(task, 'Estimate Forces')
    CBScript = 'ESTIMATION_TOOL_main_file;';
    
%--------------------------------------------------------------------------
% Task 13 : Help
%--------------------------------------------------------------------------
elseif isequal(task, 'Help')
    CBScript = [...
        'sprintf([''------------------ LBO - EPFL UPPER EXTREMITY MODEL GUI ----------------------\n'', '...
        ' ''This is the main upper extremity model interface GUI.\n'', ',...
        ' ''From here you can run the different tools and change what you wisht to be visualised.\n'', ',...
        ' ''The tool boxes are created as new GUIs.'']);',...
        'disp(ans);'];
%--------------------------------------------------------------------------
% Throw an error if task is not valid
%--------------------------------------------------------------------------
else
    % Throw an error. No valid task was given
    ErrorMsg = [...
        'The user supplied task is not valid.',...
        'MAIN_TOOL_script_generator requires a valid task as input.\n',...
        'Try the Following : \n',...
        '1) Save & Close,\n',...
        '2) Save Visualisation,\n',...
        '3) Save the Data,\n',...
        '4) Update Visualisation,\n',...
        '5) Open Subject Specific Toolbox,\n',...
        '6) Open Initial Configuration Tool,\n',...
        '7) Open Muscle Tool,\n',...
        '8) Open Joint Tool,\n',...
        '9) Open Ellipsoid Tool,\n',...
        '10) Open Kinematics Tool,\n',...
       '11) Check Moment Arms,\n',...
       '12) Estimate Forces,\n',...
       '13) Help.'];
    error('ScptGen:ErrorMsg', ErrorMsg);
end


return;
