function CBScript = MOMENT_ARM_TOOL_script_generator(task, varargin)
%{
Uicontrol callback script generator for the moment-arm tool GUI.
--------------------------------------------------------------------------
Syntax :
CBScript = MOMENT_ARM_TOOL_script_generator(task, varargin)
--------------------------------------------------------------------------


Function Description :
This function generates scripts for the moment-arm GUI uicontrols. 
MATLAB's uicontrols (pushbuttons, edit boxes, etc...) allow for a script 
to be executed when the user interacts with them. The script is called
callback. The scripts are generated as text arrays. The task input 
variable inidicates which script to return. No other inputs are
necessary. 
The list of possible tasks is the following :

         1) Close GUI
         2) View Moment-Arm Data
         2) Save Moment-Arm Data
         3) GUI Help
--------------------------------------------------------------------------
%}
% Initialise the output
CBScript = [];

%--------------------------------------------------------------------------
% Task 1 : Close the moment arm GUI
% Closes the GUI and deletes unsused variables
%--------------------------------------------------------------------------
if isequal(task, 'Close GUI')
    CBScript = [...
        'clear MAGUIHandle;',...
        'clear MAPlotHandles;',...
        'clear MAVisualisationAxes;',...
        'close gcf;',...
        'clear MAHandle;'];
%--------------------------------------------------------------------------
% Task 2 : View Data when clicked
% This script is run when a figure is clicked on.
%--------------------------------------------------------------------------
elseif isequal(task, 'View Data')
    % Get the Muscle Id number
    MuscleId = varargin{1,1};
    
    % Define the script
    CBScript = [...
        'MuscleId = ', num2str(MuscleId), ';',...
        'MOMENT_ARM_TOOL_click_figure_script;'];

%--------------------------------------------------------------------------
% Task 3 : Save Moment-Arm Data
% This script saves the moment-arm data
%--------------------------------------------------------------------------
elseif isequal(task, 'Save Data')
    CBScript = [...
        'CurrentFolder = pwd;',...
        'if isunix;',...
        'save([CurrentFolder, ''/Data_Structures_and_Documentation/MADATA.mat''], ''MADATA'');',...
        'else;',...
        'save([CurrentFolder, ''\Data_Structures_and_Documentation\MADATA.mat''], ''MADATA'');',...
        'end;'];
%--------------------------------------------------------------------------
% Task 4 : Help
% Script displayed in the command window when the GUI help menu is clicked
% on.
%--------------------------------------------------------------------------
elseif isequal(task, 'Help')
    CBScript = [...
        'sprintf([''------------------ MOMENT-ARMS TOOL ----------------------\n'', '...
        ' ''This is a GUI for computing and viewing the moment-arms. By clicking\n'', ',...
        ' ''on the different figures, you open larger views of the selected moment-arms.\n'', ',...
        ' ''The save data button lets you save the moment arm data.'']);',...
        'disp(ans);'];
%--------------------------------------------------------------------------
% Throw an error if task is not valid
%--------------------------------------------------------------------------
else
    % Throw an error. No valid task was given
    ErrorMsg = [...
        'The user supplied task is not valid.',...
        'MOMENT_ARM_TOOL_script_generator requires a valid task as input.\n',...
        'Try the Following : \n',...
        '1) Close GUI,\n',...
        '2) View Data,\n',...
        '3) Save Data,\n',...
        '4) Help.'];
    error('ScptGen:ErrorMsg', ErrorMsg);
end
return;