function PlotHandles = ELLIPSOID_TOOL_update_visualisation(EGUIHandle, PHandles, EOPTDATA, REDATA, MEDATA)
% Function for updating the ellipsoid tool GUI visualisation.
%--------------------------------------------------------------------------
% Syntax :
% PlotHandles = ELLIPSOID_TOOL_update_visualisation(EGUIHandle, PHandles, EOPTDATA, REDATA, MEDATA)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function updates the visualisation of the ellipsoid tool gui.
%
%--------------------------------------------------------------------------

% Initialise the output
PlotHandles = PHandles;

% Get the Visualisation Options
ViewEllipsoid = get(EGUIHandle.Ellipsoid_Radio_Button, 'value');

% Update the Ellipsoid
if ViewEllipsoid
    PlotHandles.Ellipsoid = VISUALISATION_view_ribcage_ellipsoid(PlotHandles.Ellipsoid, REDATA);
else
    set(PlotHandles.Ellipsoid, 'xdata', [], 'ydata', [], 'zdata', []);
end

% Update the Ribcage Points
ViewPoints    = get(EGUIHandle.Points_Radio_Button, 'value');
if ViewPoints
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
    set(PlotHandles.RibCage, 'xdata', points(:,1), 'ydata', points(:,2), 'zdata', points(:,3));
else
    set(PlotHandles.RibCage, 'xdata', [], 'ydata', [], 'zdata', []);
end
return;