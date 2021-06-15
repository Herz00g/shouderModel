function [EPlotHandles, EOPTDATA] = ELLIPSOID_TOOL_ribcage_selection_update(EPlotHandles_In, EGUIHandle, MEDATA, EOPTDATA_In)
% Uicontrol callback function for updating the points on the ribcage mesh.
%--------------------------------------------------------------------------
% Syntax :
% [EPlotHandles, EOPTDATA] = ELLIPSOID_TOOL_ribcage_selection_update(EPlotHandles_In, EGUIHandle, MEDATA, EOPTDATA_In)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function runs through all the ribcage points and selects the ones to
% be used for the optimisation given the bounds defined in the GUI's
% uicontrols.
%
%--------------------------------------------------------------------------

% Initialise the output
EPlotHandles = EPlotHandles_In;
EOPTDATA = EOPTDATA_In;

% Rebuild the set of points
points = [];
for i = 1:size(MEDATA.Thorax_Mesh.points,1)
    if MEDATA.Thorax_Mesh.points(i,1) > str2double(get(EGUIHandle.RibCage_Selection.Xmin, 'string')) && MEDATA.Thorax_Mesh.points(i,1) < str2double(get(EGUIHandle.RibCage_Selection.Xmax, 'string'))
        if MEDATA.Thorax_Mesh.points(i,2) > str2double(get(EGUIHandle.RibCage_Selection.Ymin, 'string')) && MEDATA.Thorax_Mesh.points(i,2) < str2double(get(EGUIHandle.RibCage_Selection.Ymax, 'string'))
            if MEDATA.Thorax_Mesh.points(i,3) > str2double(get(EGUIHandle.RibCage_Selection.Zmin, 'string')) && MEDATA.Thorax_Mesh.points(i,3) < str2double(get(EGUIHandle.RibCage_Selection.Zmax, 'string'))
                points = [points; [MEDATA.Thorax_Mesh.points(i,:)]];
            end
        end
    end
end

% Save the points
EOPTDATA.points = points;

% Update the visualisaton
set(EPlotHandles.RibCage, 'xdata', points(:,1), 'ydata', points(:,2), 'zdata', points(:,3));
return;