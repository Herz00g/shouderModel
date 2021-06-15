function KEDATA = KINEMATICS_TOOL_update_uicontrols(KEDATAin, KGUIHandle)
% Function for updating kinematic parameters in the kinematics GUI.
%--------------------------------------------------------------------------
% Syntax
% KEDATA = KINEMATICS_TOOL_update_uicontrols(KEDATAin, KGUIHandle)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function updates the kinematic data structure from the kinematics
% GUI.
%--------------------------------------------------------------------------
% Initialise the output
KEDATA = KEDATAin;

KEDATA.NbPoints = str2double(get(KGUIHandle.MinCord.NbPointsEdit, 'string'));

% Get the initial values
KEDATA.Initial_Minimal_Coordinate(1,1) = str2double(get(KGUIHandle.MinCord.M1ValueI, 'string'))*pi/180;
KEDATA.Initial_Minimal_Coordinate(2,1) = str2double(get(KGUIHandle.MinCord.M2ValueI, 'string'))*pi/180;
KEDATA.Initial_Minimal_Coordinate(3,1) = str2double(get(KGUIHandle.MinCord.M3ValueI, 'string'))*pi/180;
KEDATA.Initial_Minimal_Coordinate(4,1) = str2double(get(KGUIHandle.MinCord.M4ValueI, 'string'));
KEDATA.Initial_Minimal_Coordinate(5,1) = str2double(get(KGUIHandle.MinCord.M5ValueI, 'string'))*pi/180;
KEDATA.Initial_Minimal_Coordinate(6,1) = str2double(get(KGUIHandle.MinCord.M6ValueI, 'string'))*pi/180;
KEDATA.Initial_Minimal_Coordinate(7,1) = str2double(get(KGUIHandle.MinCord.M7ValueI, 'string'))*pi/180;
KEDATA.Initial_Minimal_Coordinate(8,1) = str2double(get(KGUIHandle.MinCord.M8ValueI, 'string'))*pi/180;
KEDATA.Initial_Minimal_Coordinate(9,1) = str2double(get(KGUIHandle.MinCord.M9ValueI, 'string'))*pi/180;

% Get the final values
KEDATA.Final_Minimal_Coordinate(1,1) = str2double(get(KGUIHandle.MinCord.M1ValueT, 'string'))*pi/180;
KEDATA.Final_Minimal_Coordinate(2,1) = str2double(get(KGUIHandle.MinCord.M2ValueT, 'string'))*pi/180;
KEDATA.Final_Minimal_Coordinate(3,1) = str2double(get(KGUIHandle.MinCord.M3ValueT, 'string'))*pi/180;
KEDATA.Final_Minimal_Coordinate(4,1) = str2double(get(KGUIHandle.MinCord.M4ValueT, 'string'));
KEDATA.Final_Minimal_Coordinate(5,1) = str2double(get(KGUIHandle.MinCord.M5ValueT, 'string'))*pi/180;
KEDATA.Final_Minimal_Coordinate(6,1) = str2double(get(KGUIHandle.MinCord.M6ValueT, 'string'))*pi/180;
KEDATA.Final_Minimal_Coordinate(7,1) = str2double(get(KGUIHandle.MinCord.M7ValueT, 'string'))*pi/180;
KEDATA.Final_Minimal_Coordinate(8,1) = str2double(get(KGUIHandle.MinCord.M8ValueT, 'string'))*pi/180;
KEDATA.Final_Minimal_Coordinate(9,1) = str2double(get(KGUIHandle.MinCord.M9ValueT, 'string'))*pi/180;

% Get the Polynomial orders
STR = {'3'; '5'; '7'; '9'};
for CoordId = 1:9
    for OrderId = 1:4
        % Get the current state
        state = get(KGUIHandle.Polynomial_Order_Menu.Options(CoordId, OrderId+1), 'Checked');
        if isequal(state, 'on')
            KEDATA.Order(CoordId,1) = str2double(STR{OrderId,1});
        end
    end
end
% Get the Derivative Initial & Final Conditions
eval(['KEDATA.DerCond(1,:) = ', get(KGUIHandle.MinCord.M1DerivCondEdit, 'string'), ';']);
eval(['KEDATA.DerCond(2,:) = ', get(KGUIHandle.MinCord.M2DerivCondEdit, 'string'), ';']);
eval(['KEDATA.DerCond(3,:) = ', get(KGUIHandle.MinCord.M3DerivCondEdit, 'string'), ';']);
eval(['KEDATA.DerCond(4,:) = ', get(KGUIHandle.MinCord.M4DerivCondEdit, 'string'), ';']);
eval(['KEDATA.DerCond(5,:) = ', get(KGUIHandle.MinCord.M5DerivCondEdit, 'string'), ';']);
eval(['KEDATA.DerCond(6,:) = ', get(KGUIHandle.MinCord.M6DerivCondEdit, 'string'), ';']);
eval(['KEDATA.DerCond(7,:) = ', get(KGUIHandle.MinCord.M7DerivCondEdit, 'string'), ';']);
eval(['KEDATA.DerCond(8,:) = ', get(KGUIHandle.MinCord.M8DerivCondEdit, 'string'), ';']);
eval(['KEDATA.DerCond(9,:) = ', get(KGUIHandle.MinCord.M9DerivCondEdit, 'string'), ';']);
return;