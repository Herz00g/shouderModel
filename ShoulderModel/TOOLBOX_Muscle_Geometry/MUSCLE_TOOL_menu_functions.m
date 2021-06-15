function OutHandle = MUSCLE_TOOL_menu_functions(task, InHandle, MuscleId, varargin)
% UICONTROL Callback handles all the muscle tool menu functions
%--------------------------------------------------------------------------
% Syntax :
% OutHandle = MUSCLE_TOOL_menu_functions(task, InHandle, MuscleId, varargin)
%--------------------------------------------------------------------------
%
% File Description :
% This function handles all the muscle tool menu tasks.
%
% List of Single Muscle Tasks:
%   Change Visibility
%   Change Object Visibility
%   Change Interpolation Type
%   Change Segment Numbers
%   Change Radius Adjustment Factor
%
% List of All Muscle Tasks:
%   Change All Visibilities
%   Change All Interpolations
%   Change All Segment Numbers
%--------------------------------------------------------------------------

% Initialise the output
OutHandle = InHandle;

%--------------------------------------------------------------------------
% VISIBILITY OF THE MUSCLE?
%--------------------------------------------------------------------------
if isequal(task, 'Change Visibility')
    % Get the current state
    state = get(InHandle.Muscle_Wrap_Menu.Options(MuscleId, 2), 'Checked');
    
    % Change the state to opposite state
    if isequal(state, 'on')
        set(OutHandle.Muscle_Wrap_Menu.Options(MuscleId, 2), 'Checked', 'off');
    else
        set(OutHandle.Muscle_Wrap_Menu.Options(MuscleId, 2), 'Checked', 'on');
    end
%--------------------------------------------------------------------------
% VISIBILITY OF THE WRAPPING OBJECT MUSCLE?
%--------------------------------------------------------------------------
elseif isequal(task, 'Change Object Visibility')
    % Get the current state
    state = get(InHandle.Muscle_Wrap_Menu.Options(MuscleId, 3), 'Checked');

    if isequal(state, 'on')
        set(OutHandle.Muscle_Wrap_Menu.Options(MuscleId, 3), 'Checked', 'off');
    else
        set(OutHandle.Muscle_Wrap_Menu.Options(MuscleId, 3), 'Checked', 'on');
    end
%--------------------------------------------------------------------------
% TYPE OF ORIGIN/INSERTION INTERPOLATION
%--------------------------------------------------------------------------
elseif isequal(task, 'Change Interpolation Type')
    % 1 : Linear end-to-end
    % 2 : Piece-Wise linear
    % 3 : 3rd Order polynomial
    InterpId = varargin{1,1};
    
    for i = 1:3
        if i == InterpId
            set(OutHandle.Muscle_Wrap_Menu.Interpolation(MuscleId, i), 'Checked', 'On');
        else
            set(OutHandle.Muscle_Wrap_Menu.Interpolation(MuscleId, i), 'Checked', 'Off');
        end
    end

%--------------------------------------------------------------------------
% NUMBER OF MUSCLE SEGEMENTS
%--------------------------------------------------------------------------
elseif isequal(task, 'Change Segment Numbers')
    
    SegNbId = varargin{1,1};
    
    % Run through all the possiblitlies
    for i = 1:20
        if i == SegNbId
            set(OutHandle.Muscle_Wrap_Menu.SegNumber(MuscleId, i), 'Checked', 'On');
        else
            set(OutHandle.Muscle_Wrap_Menu.SegNumber(MuscleId, i), 'Checked', 'Off');
        end
    end

%--------------------------------------------------------------------------
% RADIUS ADJUSTMENT FACTOR
%--------------------------------------------------------------------------
elseif isequal(task, 'Change Radius Adjustment Factor')
    % Input dialog box title
    dlg_title = 'Input';
    
    % Input parameter names
    prompt = {'Radius Adjustment factor:'};
    
    % Set the current value of the UImenu userdata as visible value
    def = {num2str(get(InHandle.Muscle_Wrap_Menu.Options(MuscleId, 6), 'UserData'))};
    
    % Get the user input
    answer = inputdlg(prompt,dlg_title,1,def);
    
    % Set the user input data to userdata
    set(OutHandle.Muscle_Wrap_Menu.Options(MuscleId, 6), 'UserData',  str2double(answer{1}));
    
%--------------------------------------------------------------------------
% SET ALL VISIBILITIES
%--------------------------------------------------------------------------
elseif isequal(task, 'Change All Visibilities')

    % Turn on
    if isequal(get(OutHandle.All_Muscle_Wrap_Menu.Options(1,1), 'Checked'), 'off')
        for i = 1:42
            set(OutHandle.Muscle_Wrap_Menu.Options(i, 2), 'Checked', 'on');
        end
        set(OutHandle.All_Muscle_Wrap_Menu.Options(1,1), 'Checked', 'on');
        
        % Turn off
    else
        for i = 1:42
            set(OutHandle.Muscle_Wrap_Menu.Options(i, 2), 'Checked', 'off');
        end
        set(OutHandle.All_Muscle_Wrap_Menu.Options(1,1), 'Checked', 'off');
    end
%--------------------------------------------------------------------------
% SET ALL INTERPOLATION TYPES
%--------------------------------------------------------------------------
elseif isequal(task, 'Change All Interpolations')
    InterpId = varargin{1,1};
    
    for MuscleId = 1:42
        for i = 1:3
            if i == InterpId
                set(OutHandle.Muscle_Wrap_Menu.Interpolation(MuscleId, i), 'Checked', 'On');
                set(OutHandle.All_Muscle_Wrap_Menu.Interpolation(1,i), 'Checked', 'On');
            else
                set(OutHandle.Muscle_Wrap_Menu.Interpolation(MuscleId, i), 'Checked', 'Off');
                set(OutHandle.All_Muscle_Wrap_Menu.Interpolation(1,i), 'Checked', 'Off');
            end
        end
    end   
%--------------------------------------------------------------------------
% SET ALL SEGEMENT NUMBERS
%--------------------------------------------------------------------------
elseif isequal(task, 'Change All Segment Numbers')
    SegNbId = varargin{1,1};
    
    % Run through all the possiblitlies
    for MuscleId = 1:42
        for i = 1:20
            if i == SegNbId
                set(OutHandle.Muscle_Wrap_Menu.SegNumber(MuscleId, i), 'Checked', 'On');
                set(OutHandle.All_Muscle_Wrap_Menu.SegNumber(1,i), 'Checked', 'On');
            else
                set(OutHandle.Muscle_Wrap_Menu.SegNumber(MuscleId, i), 'Checked', 'Off');
                set(OutHandle.All_Muscle_Wrap_Menu.SegNumber(1,i), 'Checked', 'Off');
            end
        end
    end
else
end
return;