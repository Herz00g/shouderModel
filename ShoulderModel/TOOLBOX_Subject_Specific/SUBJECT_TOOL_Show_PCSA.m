function SUBJECT_TOOL_Show_PCSA(SGUIHandle, MWDATA)

%{
Function for showing the initial PCSA based on the choice of muscle from the popup menu.
--------------------------------------------------------------------------
Syntax :
SGUIHandle = SUBJECT_TOOL_Show_PCSA(SGUIHandle, MWDATA)
--------------------------------------------------------------------------
File Description :

--------------------------------------------------------------------------
%}


MuscleID = get(SGUIHandle.PCSA_Selection.MuscleName, 'value') - 1;

if MuscleID>0
set(SGUIHandle.PCSA_Selection.PCSA, 'String', num2str(1e4*MWDATA{MuscleID, 1}.MSCInfo.PCSA));
else
set(SGUIHandle.PCSA_Selection.PCSA, 'String', []);
end

return;