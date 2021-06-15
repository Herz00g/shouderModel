function [SegmentHandle, MWDATA] = VISUALISATION_view_muscle_segement(SEGHandle, MWDATAin, BLDATA, MuscleId, SegmentId)
% Function for visualising the muscle segments.
%--------------------------------------------------------------------------
% Syntax :
% [SegmentHandle, MWDATA] = VISUALISATION_view_muscle_segement(SEGHandle, MWDATA, BLDATA, MuscleId, SegmentId)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram (LA - EPFL)
%
% File Description :
% This function either creates a visualisation of the muscle segments or 
% updates an already existing one.
%
% SEGHandle contains the handle
% MWDATA msucle wrapping data structure
% MuscleId is the muscle identification number
% SegmentId is the segment identification number
% BLDATA bony landmark data structure
%--------------------------------------------------------------------------

% Initialise the output
SegmentHandle = SEGHandle;
MWDATA = MWDATAin; 

% Construct a One-Time Muscle Structure for a single segment
Muscle_Seg.Origin       = MWDATA{MuscleId,1}.Origin{1,SegmentId};
Muscle_Seg.ViaA         = MWDATA{MuscleId,1}.ViaA{1,SegmentId};
Muscle_Seg.ViaB         = MWDATA{MuscleId,1}.ViaB{1,SegmentId};
Muscle_Seg.Insertion    = MWDATA{MuscleId,1}.Insertion{1,SegmentId};
Muscle_Seg.OriginRef    = MWDATA{MuscleId,1}.MSCInfo.OriginRef;
Muscle_Seg.ViaARef      = MWDATA{MuscleId,1}.MSCInfo.ViaARef;
Muscle_Seg.ViaBRef      = MWDATA{MuscleId,1}.MSCInfo.ViaBRef;
Muscle_Seg.InsertionRef = MWDATA{MuscleId,1}.MSCInfo.InsertionRef;
Muscle_Seg.ObjectCentre = MWDATA{MuscleId,1}.MSCInfo.ObjectCentre;
Muscle_Seg.ObjectType   = MWDATA{MuscleId,1}.MSCInfo.ObjectType;
Muscle_Seg.ObjectZaxis  = MWDATA{MuscleId,1}.MSCInfo.ObjectZaxis;
Muscle_Seg.ObjectRef    = MWDATA{MuscleId,1}.MSCInfo.ObjectRef;
Muscle_Seg.ObjectRadii  = MWDATA{MuscleId,1}.MSCInfo.ObjectRadiiscale*MWDATA{MuscleId,1}.MSCInfo.ObjectRadii;
Muscle_Seg.NbPlot       = MWDATA{MuscleId,1}.MSCInfo.NbPlotPoints;

% Compute the Wrapping
WRDATA = MUSCLE_TOOL_compute_wrapping(BLDATA, Muscle_Seg);

%--------------------------------------------------------------------------
% The input handle is empty (no mesh plot has been created)
%--------------------------------------------------------------------------
if isempty(SEGHandle) == 1
    SegmentHandle = plot3(...
    	WRDATA.PathPoints(1,:),... 
        WRDATA.PathPoints(2,:),...
        WRDATA.PathPoints(3,:),...
        'color', 'red',...
        'linewidth', 2,...
        'marker', 'o',...
        'markersize', 6,...
        'markerfacecolor', 'red');
    
%--------------------------------------------------------------------------
% The input handle is not empty
%--------------------------------------------------------------------------
else
     % Plot the Wrapping
     set(SegmentHandle, 'xdata', WRDATA.PathPoints(1,:), 'ydata', WRDATA.PathPoints(2,:), 'zdata', WRDATA.PathPoints(3,:));

end
return;