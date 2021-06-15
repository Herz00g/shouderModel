function OutHandle = KINEMATICS_TOOL_menu_functions(task, InHandle, CoordId, varargin)
% UICONTROL Callback handles all the kinematics tool menu functions
%--------------------------------------------------------------------------
% Syntax :
% OutHandle = KINEMATICS_TOOL_menu_functions(task, InHandle, Coord, varargin)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function handles all the kinematics tool menu tasks.
%
% List of Single Muscle Tasks:
%   Change Polynomial Order
%   Change All Polynomial Orders
%
%--------------------------------------------------------------------------

% Initialise the output
OutHandle = InHandle;

%--------------------------------------------------------------------------
% CHANFE THE POLYNOMIAL ORDER OF A SINGLE COORDINATE
%--------------------------------------------------------------------------
if isequal(task, 'Change Order')
    OrderId = varargin{1,1};
    
    % Run through all the orders
    for j = 1:4
        if j == OrderId
            % Get the current state
            state = get(OutHandle.Polynomial_Order_Menu.Options(CoordId, j+1), 'Checked');

            % Change the state to opposite state
            if isequal(state, 'on')
                set(OutHandle.Polynomial_Order_Menu.Options(CoordId, j+1), 'Checked', 'off');
            elseif j == OrderId
                set(OutHandle.Polynomial_Order_Menu.Options(CoordId, j+1), 'Checked', 'on');
            end
        else
            set(OutHandle.Polynomial_Order_Menu.Options(CoordId, j+1), 'Checked', 'off');
        end
    end
%--------------------------------------------------------------------------
% CHANFE THE POLYNOMIAL ORDER OF ALL COORDINATES
%--------------------------------------------------------------------------
elseif isequal(task, 'Change All Order')
    OrderId = varargin{1,1};
    for i = 1:9
        for j = 1:4
            if j == OrderId
                % Get the current state
                state = get(InHandle.Polynomial_Order_Menu.Options(i, j+1), 'Checked');
            
                % Change the state to opposite state
                if isequal(state, 'on')
                    set(OutHandle.Polynomial_Order_Menu.Options(i, j+1), 'Checked', 'off');
                else
                    set(OutHandle.Polynomial_Order_Menu.Options(i, j+1), 'Checked', 'on');
                end
            else
                set(OutHandle.Polynomial_Order_Menu.Options(i, j+1), 'Checked', 'off');
            end
        end
    end
    
    for j = 1:4
        if j == OrderId
            % Get the current state
            state = get(InHandle.Polynomial_Order_Menu.Options(10, j+1), 'Checked');
            
            % Change the state to opposite state
            if isequal(state, 'on')
                set(OutHandle.Polynomial_Order_Menu.Options(10, j+1), 'Checked', 'off');
            else
                set(OutHandle.Polynomial_Order_Menu.Options(10, j+1), 'Checked', 'on');
            end
        else
            set(OutHandle.Polynomial_Order_Menu.Options(10, j+1), 'Checked', 'off');
        end
    end
else
end
return;