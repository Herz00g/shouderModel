function MuscleHandle = VISUALISATION_view_muscle_insertions(MWHandle, MWDATA, BLDATA, MuscleId)
% Function for visualising the muscle insertion parameterisation.
%--------------------------------------------------------------------------
% Syntax :
% MuscleHandle = VISUALISATION_view_muscle_insertions(MWHandle, MWDATA, BLDATA, MuscleId)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function either creates a visualisation of the muscle insertions or 
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
Insertions = MWDATA{MuscleId,1}.AnchorInsertion;
Insertions = cell2mat(Insertions);

% Build the Spline
WayPoints = MUSCLE_TOOL_spline_build(MWDATA{MuscleId,1}.AnchorInsertion, MWDATA{MuscleId,1}.MSCInfo.InterpType, 100);

% Rotate the Points into absolute frame
Insertions = MAIN_TOOL_geometry_functions(...
    'Rotate Points From Local To Global Frame (Current)',...
    [Insertions(:,1), WayPoints, Insertions(:,end)], BLDATA, MWDATA{MuscleId,1}.MSCInfo.InsertionRef);

%--------------------------------------------------------------------------
% The input handle is empty (no mesh plot has been created)
%--------------------------------------------------------------------------
if isempty(MWHandle)
    % Create the plot
    MuscleHandle = plot3(Insertions(1,:), Insertions(2,:), Insertions(3,:),...
        'color', 'cyan',...
        'linewidth', 2,...
        'marker', 'o',...
        'markerfacecolor', 'cyan',...
        'markersize', 6);
    
%--------------------------------------------------------------------------
% The input handle is not empty
%--------------------------------------------------------------------------
else
    % Create the plot
    set(MuscleHandle,'xdata', Insertions(1,:), 'ydata', Insertions(2,:), 'zdata', Insertions(3,:));
end
return;
