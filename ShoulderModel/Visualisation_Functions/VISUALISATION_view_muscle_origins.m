function MuscleHandle = VISUALISATION_view_muscle_origins(MWHandle, MWDATA, BLDATA, MuscleId)
% Function for visualising the muscle origin parameterisation.
%--------------------------------------------------------------------------
% Syntax :
% MuscleHandle = VISUALISATION_view_muscle_origins(MWHandle, MWDATA, BLDATA, MuscleId)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function either creates a visualisation of the muscle origins or 
% updates an already existing one.
%
% MWHandle contains the handle
% MWDATA msucle wrapping data structure
% MuscleId is the muscle identification number
% BLDATA bony landmark data structure
%--------------------------------------------------------------------------

% Initialise the output
MuscleHandle = MWHandle;

% Get the Origin Data
Origins = MWDATA{MuscleId,1}.AnchorOrigin;
Origins = cell2mat(Origins);

% Build the Spline
WayPoints = MUSCLE_TOOL_spline_build(MWDATA{MuscleId,1}.AnchorOrigin, MWDATA{MuscleId,1}.MSCInfo.InterpType, 100);

% Rotate the Points into absolute frame
Origins = MAIN_TOOL_geometry_functions(...
    'Rotate Points From Local To Global Frame (Current)',...
    [Origins(:,1), WayPoints, Origins(:,end)], BLDATA, MWDATA{MuscleId,1}.MSCInfo.OriginRef);

%--------------------------------------------------------------------------
% The input handle is empty (no mesh plot has been created)
%--------------------------------------------------------------------------
if isempty(MWHandle) 
    % Create the plot
    MuscleHandle = plot3(Origins(1,:), Origins(2,:), Origins(3,:),...
        'color', 'green',...
        'linewidth', 2,...
        'marker', 'o',...
        'markerfacecolor', 'green',...
        'markersize', 6);
    
%--------------------------------------------------------------------------
% The input handle is not empty
%--------------------------------------------------------------------------
else
    % Create the plot
    set(MuscleHandle,'xdata', Origins(1,:), 'ydata', Origins(2,:), 'zdata', Origins(3,:));
end
return;