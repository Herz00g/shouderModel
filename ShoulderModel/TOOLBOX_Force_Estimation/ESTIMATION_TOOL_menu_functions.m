function OutHandle = ESTIMATION_TOOL_menu_functions(task, InHandle)
% UICONTROL Callback handles all the muscle tool menu functions
%--------------------------------------------------------------------------
% Syntax :
% OutHandle = ESTIMATION_TOOL_menu_functions(task, InHandle, MuscleId, varargin)
%--------------------------------------------------------------------------
%
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
% SET MUSCLE FORCE VISIBILITY AXIS 1
%--------------------------------------------------------------------------
if isequal(task, 'Menu I')
    % Get the current state
    state = get(InHandle.MenuOptions(2,3), 'Checked');
    
    % Change the state to opposite state
    if isequal(state, 'on')
        set(OutHandle.MenuOptions(2,3), 'Checked', 'off');
    else
        set(OutHandle.MenuOptions(2,3), 'Checked', 'on');
    end
%--------------------------------------------------------------------------
% SET MUSCLE FORCE VISIBILITY AXIS 2
%--------------------------------------------------------------------------
elseif isequal(task, 'Menu II')
    % Get the current state
    state = get(InHandle.MenuOptions(2,2), 'Checked');

    if isequal(state, 'on')
        set(OutHandle.MenuOptions(2,2), 'Checked', 'off');
    else
        set(OutHandle.MenuOptions(2,2), 'Checked', 'on');
    end

%--------------------------------------------------------------------------
% SET MUSCLE FORCE VISIBILITY AXIS 2
%--------------------------------------------------------------------------
elseif isequal(task, 'Menu III')
    % Get the current state
    state = get(InHandle.MenuOptions(2,4), 'Checked');

    if isequal(state, 'on')
        set(OutHandle.MenuOptions(2,4), 'Checked', 'off');
    else
        set(OutHandle.MenuOptions(2,4), 'Checked', 'on');
    end
    
%--------------------------------------------------------------------------
% Throw an error if the task is not valid
%--------------------------------------------------------------------------
else
    % Throw an error. No valid task was given
    ErrorMsg = [...
        'The user supplied task is not valid.',...
        'ESTIMATION_TOOL_menu_functions requires a valid task as input.\n',...
        'Try the Following : \n',...
        '1) Menu I,\n',...
        '2) Menu II.\n'];
    error('ScptGen:ErrorMsg', ErrorMsg);
end
return;