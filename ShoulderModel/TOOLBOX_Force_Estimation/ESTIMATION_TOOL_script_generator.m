function CBScript = ESTIMATION_TOOL_script_generator(task, varargin)
%{
 Function for generating the uicontrol callback scripts.
--------------------------------------------------------------------------
Syntax :
CBScript = ESTIMATION_TOOL_script_generator(task, varargin)
--------------------------------------------------------------------------
File Description :
This function generates scripts for the muscle tool GUI. The scripts are
generated as text arrays. The task input variable inidicates which script
to return. 
varargin contains extra information: muscle identification number,
interpolation type, number of segments.

List of Scripts :
        1) Close Estimation Tool
        2) Save Visualisation
        3) Estimate Muscle Forces
        4) View Data
        5) Update UIMenu
           Load EMG
           EMG to Force
        6) Help
--------------------------------------------------------------------------
%}
% Initialise the output
CBScript = [];

%--------------------------------------------------------------------------
% Task 1 : Close the Muscle Force Estimation Tool GUI
% Closes the GUI and deletes unused variables.
%--------------------------------------------------------------------------
if isequal(task, 'Close Estimation Tool')
    CBScript = [...
       'clear ESGUIHandle;',...
       'clear ESPlotHandles;',...
       'clear ESVisualisationAxes;',...
       'close gcf;',...
       'clear ESHandle;'];
   
%--------------------------------------------------------------------------
% Task 2 : Estimate Muscle Forces
% Runs the force estimation script
%--------------------------------------------------------------------------
elseif isequal(task, 'Estimate Forces')    
    CBScript = ['[EFDATA, JRDATA, MADATA, SSDATA] = ESTIMATION_TOOL_estimate_forces(ESGUIHandle, MWDATA, REDATA, BLDATA, KEDATA, DYDATA, SSDATA);',...
        'ESTIMATION_TOOL_visualisation_script;'];
   
%--------------------------------------------------------------------------
% Task 3 : Save Data
% Saves the data to .mat files
%--------------------------------------------------------------------------
elseif isequal(task, 'Save Data')    
    CBScript = [...
        'CurrentFolder = pwd;',...
        'if isunix;',...
        'save([CurrentFolder, ''/Data_Structures_and_Documentation/EFDATA.mat''], ''EFDATA'');',...
        'save([CurrentFolder, ''/Data_Structures_and_Documentation/JRDATA.mat''], ''JRDATA'');',...
        'save([CurrentFolder, ''/Data_Structures_and_Documentation/MADATA.mat''], ''MADATA'');',...
        'else;',...
        'save([CurrentFolder, ''\Data_Structures_and_Documentation\EFDATA.mat''], ''EFDATA'');',...
        'save([CurrentFolder, ''\Data_Structures_and_Documentation\JRDATA.mat''], ''JRDATA'');',...
        'save([CurrentFolder, ''\Data_Structures_and_Documentation\MADATA.mat''], ''MADATA'');',...
        'end;'];

%--------------------------------------------------------------------------
% Task 2 : Load EMG data
% loads the EMG data
%--------------------------------------------------------------------------
elseif isequal(task, 'Load EMG')
    CBScript = 'SSDATA = ESTIMATION_TOOL_Load_EMG(ESGUIHandle, SSDATA);';

%--------------------------------------------------------------------------
% Task 2 : EMG to Force
% defines muscle force based on the imported EMG data
%--------------------------------------------------------------------------
elseif isequal(task, 'EMG to Force')
    CBScript = 'SSDATA = ESTIMATION_TOOL_EMG_to_force(ESGUIHandle, SSDATA, BLDATA, MWDATA, DYDATA);';

%--------------------------------------------------------------------------
% Task 4.1 : Update the UIMENU
% Updates the menu option of using the dynamic maximum force constraints
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Uimenu I')  
        CBScript = ['ESGUIHandle = ESTIMATION_TOOL_menu_functions(''Menu I'', ESGUIHandle);'];

%--------------------------------------------------------------------------
% Task 4.2 : Update the UIMENU
% Menu function to update the option of using the stability condition
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Uimenu II')   
        CBScript = ['ESGUIHandle = ESTIMATION_TOOL_menu_functions(''Menu II'', ESGUIHandle);'];

%--------------------------------------------------------------------------
% Task 4.2 : Update the UIMENU
% Menu function to update the option of using the stability condition
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Uimenu III')   
        CBScript = ['ESGUIHandle = ESTIMATION_TOOL_menu_functions(''Menu III'', ESGUIHandle);'];
        
        
%--------------------------------------------------------------------------
% Task 5 : View Data
% This script is run to create an enlarged visualisation of the muscle
% forces
%--------------------------------------------------------------------------
elseif isequal(task, 'View Data') 
    MuscleId = varargin{1,1};

    CBScript = ['MuscleId = ', num2str(MuscleId), ';',...
        'ESTIMATION_TOOL_view_data_script;'];

%--------------------------------------------------------------------------
% Task 6 : Help
% Script displayed in the command window when the GUI help menu is clicked
% on.
%--------------------------------------------------------------------------
elseif isequal(task, 'Help')
    CBScript = [...
        'sprintf([''------------------ FORCE ESTIMATION TOOL ----------------------\n'', '...
        ' ''This is the muscle and joint force estimation GUI interface.\n'', ',...
        ' ''You can add weight in the hand and change the time horizon.\n'', ',...
        ' ''In the menu you can change options of the estimation.'', ',...
        ' ''Clicking on the graphs will open a figure where they are completely displayed.'']);',...
        'disp(ans);'];   

%--------------------------------------------------------------------------
% Throw an error. No valid task was given
%--------------------------------------------------------------------------
else
    ErrorMsg = [...
        'The user supplied task is not valid. ',...
        'ESTIMATION_TOOL_script_generator requires a valid task as input.\n',...
        'Try the Following : \n',...
        '1) Close Estimation Tool,\n',...
        '2) Estimate Forces,\n',...
        '3) Save Data,\n',...
        '4) Update Uimenu,\n',... 
        '5) View Data,\n',...
        '6) Help.'];
    error('ScptGen:ErrorMsg', ErrorMsg);
end


return;
