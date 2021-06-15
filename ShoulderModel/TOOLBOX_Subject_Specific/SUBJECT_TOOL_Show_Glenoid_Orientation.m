
function SUBJECT_TOOL_Show_Glenoid_Orientation(SGUIHandle, BLDATA)

%{
Function for showing the glenoid orientations in the model.
--------------------------------------------------------------------------
Syntax :

--------------------------------------------------------------------------
File Description :

--------------------------------------------------------------------------
%}

% get the orientation value from the GUI
AngleID = get(SGUIHandle.Glenoid_Orientations.Popupmenu, 'value') - 1;

% update the orientation angles
if AngleID>0 && AngleID<3
    % glenoid version and inclination, respectively
    %set(SGUIHandle.Glenoid_Orientations.Value, 'String', num2str(BLDATA.Glenoid_Orientations(AngleID)));
    set(SGUIHandle.Glenoid_Orientations.Value, 'String', num2str(BLDATA.Glenoid_Orientations(AngleID)));
elseif AngleID==3 % set the implant/HH diameter
    set(SGUIHandle.Glenoid_Orientations.Value, 'String', num2str(BLDATA.Glenoid_Orientations(AngleID)));    
elseif AngleID>3
    % glenoid fossa center in the scapula frame of each patient
    set(SGUIHandle.Glenoid_Orientations.Value, 'String', num2str(BLDATA.Glenoid_Orientations(1, AngleID:6)));
else
    set(SGUIHandle.Glenoid_Orientations.Value, 'String', []);
end


return;
