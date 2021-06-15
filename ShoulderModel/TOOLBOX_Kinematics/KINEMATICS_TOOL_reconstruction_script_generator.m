function CBScript = KINEMATICS_TOOL_reconstruction_script_generator(task, varargin)
%{
Uicontrol Callback Script Generator for build motion (option 2) Tool GUI.
--------------------------------------------------------------------------
Syntax :
CBScript = KINEMATICS_TOOL_reconstruction_script_generator(task)
--------------------------------------------------------------------------



File Description :
This function generates the uicontrol callback scripts for the subject
specific tool GUI. The task input variable inidicates which script to return. 

List of Scripts :
          Task 1: Close Build Motion
          Task 2: Residual Analysis
          Task 3: Harmonic Analysis
          Task 4: Filter Data
          Task 5: Estimate Data
          Task 6: Inverse Kinematics
          Task 7: Help
          Task 8: Click On

* varagin is used for the sake of only Task 6 (Click ON), as we need to
input the number of the plot that the user clicks on to see more detailed
plots.
--------------------------------------------------------------------------
%}
% Initialise the output
CBScript = [];

%--------------------------------------------------------------------------
% Task 1 : Close the Subject GUI
% Closes the subject specific tool GUI and deletes the variables that are no
% longer needed. indicate other parts that are updated to account for these
% changes.
%--------------------------------------------------------------------------
if isequal(task, 'Close Build Motion')
    CBScript = [...
       'clear KRHandle;',...
       'clear KRPlotHandles;',...
       'clear KRGUIHandle;',...
       'close gcf;'];
%--------------------------------------------------------------------------
% Task 2 : Residual Analysis
% performs residual analysis on all of the measured data provided in order
% to help the user decides on the value of the cutoff frequency of the
% filter and also to given the user an idea of the quality of the measured
% data.
%--------------------------------------------------------------------------
elseif isequal(task, 'Residual Analysis')
    CBScript = 'KINEMATICS_TOOL_data_filteration(''Residual Analysis'', SSDATA);';

%--------------------------------------------------------------------------
% Task 3 : Harmonic Analysis
% performs harmonic analysis on all of the measured data provided in order
% to help the user decides on the value of the cutoff frequency of the
% filter and also to given the user an idea of the quality of the measured
% data.
%--------------------------------------------------------------------------
elseif isequal(task, 'Harmonic Analysis')
    CBScript = 'KINEMATICS_TOOL_data_filteration(''Harmonic Analysis'', SSDATA);';
    
%--------------------------------------------------------------------------
% Task 4 : Filter Data
% takes the settings provided and filters the data and replaces them with
% the filtered and transformed (to the matlab coordinate) data. 
%--------------------------------------------------------------------------
elseif isequal(task, 'Filter Data')
    CBScript = 'SSDATA = KINEMATICS_TOOL_data_filteration(''Filter Data'', SSDATA, KRGUIHandle);';
    
    
%--------------------------------------------------------------------------
% Task 5 : Estimate Data
% Estimates the evolutions of landmarks missing from the measurement data
% including TS, AI, GH, HU, CP.
%--------------------------------------------------------------------------
elseif isequal(task, 'Estimate Data')
    CBScript = '[SSDATA, BLDATA] = KINEMATICS_TOOL_Estimate_Landmarks(KRHandle, KRPlotHandles, SSDATA, BLDATA);';    
    

%--------------------------------------------------------------------------
% Task 6 : Inverse Kinematics
% Perform inverse kinematics such that the error associated with tracking
% the measured data is globally minimized.
%--------------------------------------------------------------------------
elseif isequal(task, 'Inverse Kinematics')
    CBScript = 'SSDATA = KINEMATICS_TOOL_reconstruct_motion(KRPlotHandles, KRGUIHandle, SSDATA, BLDATA, REDATA);';     
    
%--------------------------------------------------------------------------
% Task 7 : View Motion
% View both of the reconstructed motion resulted from IK and the measured
% and estimated motion.
%--------------------------------------------------------------------------
elseif isequal(task, 'View Motion')
    CBScript = 'KINEMATICS_TOOL_view_reconstructed_motion;'; 

%--------------------------------------------------------------------------
% Task 8 : Click On
% Runs a scripts that plots the generalized velocities and accelerations.
%--------------------------------------------------------------------------
elseif isequal(task, 'Click On')
    GC_id = varargin{1,1};
    CBScript = [...
                'GC_id = ', num2str(GC_id), ';',...
                'KINEMATICS_TOOL_click_on_script;'];
 
%--------------------------------------------------------------------------
% Task 9 : Help
% Displays a help message in the command window when the help menu option
% is clicked.
%--------------------------------------------------------------------------
elseif isequal(task, 'Help')
    CBScript = [...
        'sprintf([''------------- INTERFACE FOR BUILD MOTION (Option 2): reconstruction of a measured motion -----------------\n'',',...
        ' ''This GUI helps you to reconstruct a meaured motion.\n'',',...
        ' ''First, you need to filter the measured motion and transform it in the Thorax (Matlab) frame.\n'',',...
        ' ''Second, given that there are missing landmarks in the experiment, you need to estimate them.\n'',',...
        ' ''Now, you can perform inverse kinematics that defines the joint Euler angels\n'', ',...
        ' ''(generalized coordinates) such that the error associated with tracking the measured landmarks is globally minimized.\n'',',...
        ' ''You can see the RMSE of the tracking in the SSDATA. Also, the joint angels will be ploted on this same GUI page.\n'',',...
        ' ''The reconstructed motion together with the measured motion can be animated subject to you pressing the View Motions puss botton\n'','...
        ' '''']);',...
        'disp(ans);'];
    
%--------------------------------------------------------------------------
% Throw an error if task is not valid
%--------------------------------------------------------------------------
else
    % Throw an error. No valid task was given
    ErrorMsg = [...
        'The user supplied task is not valid.',...
        'KINEMATICS_TOOL_reconstruction_script_generator requires a valid task as input.\n',...
        'Try the Following : \n',...
        '1) Close Build Motion,\n',...
        '2) Residual Analysis,\n',...
        '3) Harmonic Analysis,\n',...
        '4) Filter Data,\n',...
        '5) Estimate Data,\n',...
        '6) Inverse Kinematics,\n',... 
        '7) Click On,\n',...
        '8) Help,\n',...
        '9) .'];
    error('ScptGen:ErrorMsg', ErrorMsg);
end

return;
