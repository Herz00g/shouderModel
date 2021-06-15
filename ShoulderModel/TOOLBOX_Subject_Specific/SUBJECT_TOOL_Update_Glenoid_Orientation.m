function BLDATA = SUBJECT_TOOL_Update_Glenoid_Orientation(SGUIHandle, BLDATAin)

%{
Function for updating the glenoid orientations in the model.
--------------------------------------------------------------------------
Syntax :
BLDATA = SUBJECT_TOOL_Update_Glenoid_Orientation(SGUIHandle, BLDATAin)
--------------------------------------------------------------------------
File Description :

--------------------------------------------------------------------------
%}

% initialize the DYDATA
BLDATA = BLDATAin;

% get the orientation value from the GUI
AngleID = get(SGUIHandle.Glenoid_Orientations.Popupmenu, 'value') - 1;

% update the orientation angles
if AngleID>0 && AngleID<3
    % set the version and inclination, respectively
    BLDATA.Glenoid_Orientations(AngleID) = str2double(get(SGUIHandle.Glenoid_Orientations.Value, 'String'));
elseif AngleID==3 % set the implant/HH diameter
    BLDATA.Glenoid_Orientations(AngleID) = str2double(get(SGUIHandle.Glenoid_Orientations.Value, 'String'));     
elseif AngleID>3
    % set the GC_SA (glenoid fossa center in the scapula coordinate)
    BLDATA.Glenoid_Orientations(1, AngleID:6) = str2num(get(SGUIHandle.Glenoid_Orientations.Value, 'String'));
else
    % do nothing because the user will not put values under the "slected"
    % popup
end

return;

