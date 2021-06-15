function CBScript = MUSCLE_TOOL_script_generator(task, varargin)
% UICONTROL Callback Script Generator for the Muscle tool GUI controls.
%--------------------------------------------------------------------------
% Syntax :
% CBScript = MUSCLE_TOOL_script_generator(task, varargin)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function generates scripts for the muscle tool GUI. The scripts are
% generated as text arrays. The task input variable inidicates which script
% to return. 
% varargin contains extra information: muscle identification number,
% interpolation type, number of segments.
%
% List of Scripts :
%           Close Muscle Tool
%           Save Visualisation
%           Menu Functions I    Change Visibility
%           Menu Functions II   Change Object Visibility
%           Menu Functions III  Change Interpolation Type
%           Menu Functions IV   Change Segment Numbers
%           Menu Functions V    Change Radius Adjustment Factor
%           Menu Functions VI   Change All Visibilities
%           Menu Functions VII  Change All Interpolations
%           Menu Functions VIII Change All Segment Numbers
%           Update Visualisation  
%           Update Joint Angles
%           Reset Joint Angles
%           Help
%
%--------------------------------------------------------------------------

% Initialise the output
CBScript = [];

% Create the 
InitiScript = 'PRE_PROCESSING_callback_muscle_wrap_tool_';

%--------------------------------------------------------------------------
% Task 1 : Close the Muscle Wrapping GUI
%--------------------------------------------------------------------------
if isequal(task, 'Close Muscle Tool')
    CBScript = [...
       'clear MGUIHandle;',...
       'clear MPlotHandles;',...
       'clear MuscleVisualisationAxes;',...
       'close gcf;',...
       'clear MHandle;'];

%--------------------------------------------------------------------------
% Task 2 : Save the Visualisation
%--------------------------------------------------------------------------
elseif isequal(task, 'Save Visualisation')
    CBScript =  'MAIN_TOOL_save_visualisation(MHandle, 3);';
    
%--------------------------------------------------------------------------
% Task 3.1 : Change Muscle Visibility
%--------------------------------------------------------------------------
elseif isequal(task, 'Menu Functions I')
    MuscleId = varargin{1,1};
    
    CBScript = [...
        'MGUIHandle = MUSCLE_TOOL_menu_functions(''Change Visibility'', MGUIHandle, ',...
        num2str(MuscleId), ');'];

%--------------------------------------------------------------------------
% Task 3.2 : Change Wrapping Object Visibility
%--------------------------------------------------------------------------
elseif isequal(task, 'Menu Functions II')
    MuscleId = varargin{1,1};
 
    CBScript = [...
        'MGUIHandle = MUSCLE_TOOL_menu_functions(''Change Object Visibility'', MGUIHandle, ',...
        num2str(MuscleId),');'];
    
%--------------------------------------------------------------------------
% Task 3.3 : Change Interpolation type
%--------------------------------------------------------------------------
elseif isequal(task, 'Menu Functions III')
    MuscleId = varargin{1,1};
    InterpId = varargin{1,2};
    
    CBScript = [...
        'MGUIHandle = MUSCLE_TOOL_menu_functions(''Change Interpolation Type'', MGUIHandle, ',...
        num2str(MuscleId),',',...
        num2str(InterpId), ');'];
    
%--------------------------------------------------------------------------
% Task 3.4 : Change the Number of Segements
%--------------------------------------------------------------------------
elseif isequal(task, 'Menu Functions IV')
    MuscleId = varargin{1,1};
    SegNbId = varargin{1,2};
    CBScript = [...
        'MGUIHandle = MUSCLE_TOOL_menu_functions(''Change Segment Numbers'', MGUIHandle, ',...
        num2str(MuscleId),',',...
        num2str(SegNbId), ');'];

%--------------------------------------------------------------------------
% Task 3.5 : Change The Radius Adjustment Factor
%--------------------------------------------------------------------------
elseif isequal(task, 'Menu Functions V')
    MuscleId = varargin{1,1};
    
    CBScript = [...
        'MGUIHandle = MUSCLE_TOOL_menu_functions(''Change Radius Adjustment Factor'', MGUIHandle, ',...
        num2str(MuscleId), ');'];
    
%--------------------------------------------------------------------------
% Task 4.1 : Change All The Visibilities
%--------------------------------------------------------------------------
elseif isequal(task, 'Menu Functions VI')
    MuscleId = varargin{1,1};
    
    CBScript = [...
        'MGUIHandle = MUSCLE_TOOL_menu_functions(''Change All Visibilities'', MGUIHandle, ',...
        num2str(MuscleId), ');'];
    
%--------------------------------------------------------------------------
% Task 4.2 : Change All The Interpolations
%--------------------------------------------------------------------------
elseif isequal(task, 'Menu Functions VII')
    MuscleId = varargin{1,1};
    InterpId = varargin{1,2};
    
    CBScript = [...
        'MGUIHandle = MUSCLE_TOOL_menu_functions(''Change All Interpolations'', MGUIHandle, ',...
        num2str(MuscleId),',',...
        num2str(InterpId), ');'];
    
%--------------------------------------------------------------------------
% Task 4.3 : Change All The Segment Numbers
%--------------------------------------------------------------------------
elseif isequal(task, 'Menu Functions VIII')
    MuscleId = varargin{1,1};
    SegNbId = varargin{1,2};
    
    CBScript = [...
        'MGUIHandle = MUSCLE_TOOL_menu_functions(''Change All Segment Numbers'', MGUIHandle, ',...
        num2str(MuscleId),',',...
        num2str(SegNbId), ');'];
    
%--------------------------------------------------------------------------
% Task 5 : Update the Visualisation
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Visualisation')
    CBScript = '[MWPlotHandles, MWDATA] = MUSCLE_TOOL_update_visualisation(MPlotHandles, MGUIHandle, BLDATA, MEDATA, MWDATA);';    
 
%--------------------------------------------------------------------------
% Task 6 : Update the Joint Angles
%--------------------------------------------------------------------------
elseif isequal(task, 'Update Joint Angles')
    % Get the uicontrol modification type
    Mode = varargin{1,1};
    
    % Create script for the type of uicontrol that was modified
    if isequal(Mode, 'Slider Modified')
        CBScript = [...
            '[BLDATA, MGUIHandle] =',...
            'MUSCLE_TOOL_slider_modification(''Slider Modified'', BLDATA, MGUIHandle);',...
            '[MPlotHandles, MWDATA] = MUSCLE_TOOL_update_visualisation(MPlotHandles, MGUIHandle, BLDATA, MEDATA, MWDATA);'];
    elseif isequal(Mode, 'Value Modified')
        CBScript = [...
            '[BLDATA, MGUIHandle] =',...
            'MUSCLE_TOOL_slider_modification(''Value Modified'', BLDATA, MGUIHandle);',...
            '[MPlotHandles, MWDATA] = MUSCLE_TOOL_update_visualisation(MPlotHandles, MGUIHandle, BLDATA, MEDATA, MWDATA);'];
    else
    
    end
    
%--------------------------------------------------------------------------
% Task 7 : Reset the Joint Angles
%--------------------------------------------------------------------------
elseif isequal(task, 'Reset Angles')
    CBScript = [...
        '[BLDATA, MGUIHandle] = ',...
        'MUSCLE_TOOL_reset_angles(BLDATA, MGUIHandle);',...
        '[MPlotHandles, MWDATA] = MUSCLE_TOOL_update_visualisation(MPlotHandles, MGUIHandle, BLDATA, MEDATA, MWDATA);'];
    
%--------------------------------------------------------------------------
% Task 8 : Help
%--------------------------------------------------------------------------
elseif isequal(task, 'Help')
    CBScript = [...
        'display([''This is the muscle wrapping tool interface GUI. '',',...
        '''From here you can define the muscle geometry for each muscle. '',',...
        '''You can also change the current joint angles to see if all the wrappings are correct or not. '']);'];        
%--------------------------------------------------------------------------
% Throw an error if task is not valid
%--------------------------------------------------------------------------
else
    % Throw an error. No valid task was given
    ErrorMsg = [...
        'The user supplied task is not valid.',...
        'MAIN_TOOL_script_generator requires a valid task as input.\n',...
        'Try the Following : \n',...
        '1) Close Tool,\n',...
        '2) Save Visualisation,\n',...
        '3.1) Menu Functions I,\n',...
        '3.2) Menu Functions II,\n',...
        '3.3) Menu Functions III,\n',...
        '3.4) Menu Functions IV,\n',...
        '3.5) Menu Functions V,\n',...
        '4.1) Menu Functions VI,\n',...
        '4.2) Menu Functions VII,\n',...
        '4.3) Menu Functions VIII,\n',...
        '5) Update Visualisation,\n',...
        '6) Update Joint Angles,\n',...
        '7) Reset Angles,\n',...
        '8) Help.'];
    error('ScptGen:ErrorMsg', ErrorMsg);
end


return;
