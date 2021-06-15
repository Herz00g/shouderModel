function CBScript = ELLIPSOID_TOOL_script_generator(task)
% Uicontrol Callback Script Generator for Ellipsoid Tool GUI.
%--------------------------------------------------------------------------
% Syntax :
% CBScript = ELLIPSOID_TOOL_script_generator(task)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function generates the uicontrol callback scripts for the ellipsoid 
% tool GUI. The scripts are generated as text arrays. The task input 
% variable inidicates which script to return. 
%
% List of Scripts :
%           Task 1: Close Ellipsoid Tool
%           Task 2: Build Ellipsoid
%           Task 3: View Ellipsoid
%           Task 4: Save Visualisation
%           Task 5: Update Ribcage Points
%           Task 6: Set Optimisation Parameters
%           Task 7: Set Optimisation Settings
%           Task 8: Help
%--------------------------------------------------------------------------

% Initialise the output
CBScript = [];

%--------------------------------------------------------------------------
% Task 1 : Close the Ellipsoid GUI
% Closes the ellipsoid tool GUI and deletes the variables that are no
% longer needed. The dynamic dataset is also updated to acount for the
% change in the scapulothoracic constraints.
%--------------------------------------------------------------------------
if isequal(task, 'Close Ellipsoid Tool')
    CBScript = [...
       'DYDATA = MAIN_INITIALISATION_build_data_dynamics_noequations(REDATA, BLDATA);',...
       'clear EGUIHandle;',...
       'clear EPlotHandles;',...
       'clear EllipseVisualisationAxes;',...
       'clear EOPTDATA',...
       'clear Xmin Xmax Ymin Ymax Zmin Zmax;',...
       'close gcf;',...
       'clear EHandle;'];

%--------------------------------------------------------------------------
% Task 2 : Build the Ellipsoid
% Runs the optimisation overhead function which controls the
% optimsation routine.
%--------------------------------------------------------------------------
elseif isequal(task, 'Build Ellipsoid')
    CBScript = 'REDATA = ELLIPSOID_TOOL_run_optimisation(EOPTDATA, BLDATA);';
    
%--------------------------------------------------------------------------
% Task 3 : Update the Visualisation
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Visualisation')
    CBScript = 'EPlotHandles = ELLIPSOID_TOOL_update_visualisation(EGUIHandle, EPlotHandles, EOPTDATA, REDATA, MEDATA);';

%--------------------------------------------------------------------------
% Task 4 : Save Current Visualisation
% Calls the main function for saving visualisations
%--------------------------------------------------------------------------
elseif isequal(task, 'Save Visualisation')
    CBScript =   'MAIN_CALLBACK_save_visualisation(EHandle, 5);';

%--------------------------------------------------------------------------
% Task 5 : Update Selected Ribcage points
% Updates the selected points on the ribcage that are selected given the
% current bounds.
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Ribcage Points')
    CBScript = '[EPlotHandles, EOPTDATA] = ELLIPSOID_TOOL_ribcage_selection_update(EPlotHandles, EGUIHandle, MEDATA, EOPTDATA);';

%--------------------------------------------------------------------------
% Task 6 : Set Optimisation Parameters
% Sets the data structure is the inial values or bounds are changed.
%--------------------------------------------------------------------------
elseif isequal(task, 'Set Optimisation Parameters')
    CBScript = '[EOPTDATA] =  ELLIPSOID_TOOL_optimisation_setup(EGUIHandle, EOPTDATA);';
    
%--------------------------------------------------------------------------
% Task 7 : Set Optimisation Settings
% When an optimisation setting is changed, this callback sets the data
% structure.
%--------------------------------------------------------------------------
elseif isequal(task, 'Set Optimisation Settings')
    CBScript = '[EOPTDATA] =  ELLIPSOID_TOOL_optimisation_setup(EGUIHandle, EOPTDATA);';

%--------------------------------------------------------------------------
% Task 8 : Help
% Displays a help message in the command window when the help menu option
% is clicked.
%--------------------------------------------------------------------------
elseif isequal(task, 'Help')
    CBScript = [...
        'sprintf([''------------- INTERFACE FOR BUILDING THE RIBCAGE ELLIPSOID -----------------\n'',',...
        ' ''This GUI helps you build the ribcage ellipsoid by optimisation.\n'',',...
        ' ''You can impose bounds on the ellipsoid centre coordinates and the axis dimensions.\n'',',...
        ' ''The optimisation cost function is the sum of the norms beteen points on the\n'',',...
        ' ''ribcage meshing and their projection onto the ellipsoid surface.\n'', ',...
        ' ''You can impose the bounds on the points to be used for the optimisation. The points\n'',',...
        ' ''are shown in blue in the visualisation. This procedure has already been carried out\n'',',...
        ' ''and the result is the default parameters. The initial values of the GUI when it opens\n'','...
        ' ''yield the original values loaded when the main GUI starts.'']);',...
        'disp(ans);'];
    
%--------------------------------------------------------------------------
% Throw an error if task is not valid
%--------------------------------------------------------------------------
else
    % Throw an error. No valid task was given
    ErrorMsg = [...
        'The user supplied task is not valid.',...
        'ELLIPSOID_TOOL_script_generator requires a valid task as input.\n',...
        'Try the Following : \n',...
        '1) Close Ellipsoid Tool,\n',...
        '2) Build Ellipsoid,\n',...
        '3) Update Visualisation,\n',...
        '4) Save Visualisation,\n',... 
        '5) Update Ribcage Points,\n',...
        '6) Set Optimisation Parameters,\n',...
        '7) Set Optimisation Settings.'];
    error('ScptGen:ErrorMsg', ErrorMsg);
end


return;
