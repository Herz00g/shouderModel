function [] = MAIN_TOOL_save_data(BLDATA, MEDATA, REDATA, MWDATA, KEDATA, DYDATA, MADATA)
% Uicontrol callback function for saving all the data structures of the model.
%--------------------------------------------------------------------------
% Syntax :
% [] = MAIN_TOOL_save_data(BLDATA, MEDATA, REDATA, MWDATA, JCDATA, KEDATA, DYDATA, MADATA)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function saves all the data structures to a sub-folder.
%
% List of Structures to save
%   BLDATA : Bony Landmark Data
%   MEDATA : 3-D Bone Meshing Data
%   REDATA : Ribcage Ellipsoid Data
%   MWDATA : Muscle Wrapping Data
%   JCDATA : Joint Sinus Cone Data
%   KEDATA : Kinematic Motion Data
%   DYDATA : Dynamic Model Data
%   MADATA : Moment Arm Data
%--------------------------------------------------------------------------

% Differentiate between mac & pc system
if isunix       % SYSTEM IS UNIX SYSTEM (MAC OS X INCLUDED)
    % Get the Current Folder
    CurrentFolder = pwd;
    
    % Save Bony Landmark Data
    save([CurrentFolder, '/Data_Structures_and_Documentation/BLDATA.mat'], 'BLDATA');
    
    % Save Meshing Data
    save([CurrentFolder, '/Data_Structures_and_Documentation/MEDATA.mat'], 'MEDATA');
    
    % Save Ellipsoid Data
    save([CurrentFolder, '/Data_Structures_and_Documentation/REDATA.mat'], 'REDATA');
    
    % Save Muscle Wrapping Data
    save([CurrentFolder, '/Data_Structures_and_Documentation/MWDATA.mat'], 'MWDATA');
    
    % Save Joint Sinus Cone Data
    %save([CurrentFolder, '/Data_Structures_and_Documentation/JCDATA.mat'], 'JCDATA');
    
    % Save Kinematic Motion Data
    save([CurrentFolder, '/Data_Structures_and_Documentation/KEDATA.mat'], 'KEDATA');
    
    % Save Dynamic Model Data
    save([CurrentFolder, '/Data_Structures_and_Documentation/DYDATA.mat'], 'DYDATA');
    
    % Save Moment-Arm Data
    save([CurrentFolder, '/Data_Structures_and_Documentation/MADATA.mat'], 'MADATA');
    
else        % SYSTEM IS NOT UNIX (PC)
    % Get the Current Folder
    CurrentFolder = pwd;

    % Save Bony Landmark Data
    save([CurrentFolder, '\Data_Structures_and_Documentation\BLDATA.mat'], 'BLDATA');
    
    % Save Meshing Data
    save([CurrentFolder, '\Data_Structures_and_Documentation\MEDATA.mat'], 'MEDATA');
    
    % Save Ellipsoid Data
    save([CurrentFolder, '\Data_Structures_and_Documentation\REDATA.mat'], 'REDATA');
    
    % Save Muscle Wrapping Data
    save([CurrentFolder, '\Data_Structures_and_Documentation\MWDATA.mat'], 'MWDATA');
    
    % Save Joint Sinus Cone Data
    %save([CurrentFolder, '\Data_Structures_and_Documentation\JCDATA.mat'], 'JCDATA');
    
    % Save Kinematic Motion Data
    save([CurrentFolder, '\Data_Structures_and_Documentation\KEDATA.mat'], 'KEDATA');
    
    % Save Dynamic Model Data
    save([CurrentFolder, '\Data_Structures_and_Documentation\DYDATA.mat'], 'DYDATA');
    
    % Save Moment-Arm Data
    save([CurrentFolder, '\Data_Structures_and_Documentation\MADATA.mat'], 'MADATA');
end
return;