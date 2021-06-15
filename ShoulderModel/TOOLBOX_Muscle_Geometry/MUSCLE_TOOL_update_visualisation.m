function [MPlotHandles, MWDATA] = MUSCLE_TOOL_update_visualisation(MPlotHandles_in, MGUIHandle, BLDATA, MEDATA, MWDATAin)
% UICONTROL Callback updates the muscle GUI visualisation
%--------------------------------------------------------------------------
% Syntax :
% [MPlotHandles, MWDATA] = MUSCLE_TOOL_update_visualisation(MPlotHandles_in, MGUIHandle, BLDATA, MWDATA_in)
%--------------------------------------------------------------------------
%
% File Description :
% This function updates the muscle tool GUI visualisation
%
%--------------------------------------------------------------------------

% Initialise the Output
MWDATA = MWDATAin;
MPlotHandles = MPlotHandles_in;

%--------------------------------------------------------------------------
% Update All the Meshings
%--------------------------------------------------------------------------
MPlotHandles.MeshHandle(1) = VISUALISATION_view_bone_meshing(MPlotHandles.MeshHandle(1), MEDATA, 0, BLDATA);
MPlotHandles.MeshHandle(2) = VISUALISATION_view_bone_meshing(MPlotHandles.MeshHandle(2), MEDATA, 1, BLDATA);
MPlotHandles.MeshHandle(3) = VISUALISATION_view_bone_meshing(MPlotHandles.MeshHandle(3), MEDATA, 2, BLDATA);
MPlotHandles.MeshHandle(4) = VISUALISATION_view_bone_meshing(MPlotHandles.MeshHandle(4), MEDATA, 3, BLDATA);
MPlotHandles.MeshHandle(5) = VISUALISATION_view_bone_meshing(MPlotHandles.MeshHandle(5), MEDATA, 4, BLDATA);
MPlotHandles.MeshHandle(6) = VISUALISATION_view_bone_meshing(MPlotHandles.MeshHandle(6), MEDATA, 5, BLDATA);
MPlotHandles.MeshHandle(7) = VISUALISATION_view_bone_meshing(MPlotHandles.MeshHandle(7), MEDATA, 6, BLDATA);
axis equal

%--------------------------------------------------------------------------
% Update All the Wire Frames
%--------------------------------------------------------------------------
MPlotHandles.WireFrameHandle(1) = VISUALISATION_view_bone_wireframe(MPlotHandles.WireFrameHandle(1), 0, BLDATA);
MPlotHandles.WireFrameHandle(2) = VISUALISATION_view_bone_wireframe(MPlotHandles.WireFrameHandle(2), 1, BLDATA);
MPlotHandles.WireFrameHandle(3) = VISUALISATION_view_bone_wireframe(MPlotHandles.WireFrameHandle(3), 2, BLDATA);
MPlotHandles.WireFrameHandle(4) = VISUALISATION_view_bone_wireframe(MPlotHandles.WireFrameHandle(4), 3, BLDATA);
MPlotHandles.WireFrameHandle(5) = VISUALISATION_view_bone_wireframe(MPlotHandles.WireFrameHandle(5), 4, BLDATA);
MPlotHandles.WireFrameHandle(6) = VISUALISATION_view_bone_wireframe(MPlotHandles.WireFrameHandle(6), 5, BLDATA);

%--------------------------------------------------------------------------
% RUN THROUGH ALL THE MUSCLES
%--------------------------------------------------------------------------
for MuscleId = 1:42
    % Get the latest options for the muscle
    MWDATA = MUSCLE_TOOL_build_muscle(MGUIHandle, MWDATA, MuscleId);

    % The muscle is to be visualised
    if isequal(get(MGUIHandle.Muscle_Wrap_Menu.Options(MuscleId, 2), 'Checked'), 'on')
        
        % Visulise the Origins?
        if get(MGUIHandle.Origin_Visualisation_Button, 'value')
            MPlotHandles.MuscleOriginHandle(MuscleId)    = VISUALISATION_view_muscle_origins(MPlotHandles.MuscleOriginHandle(MuscleId), MWDATA, BLDATA, MuscleId);
        else
            set(MPlotHandles.MuscleOriginHandle(MuscleId), 'xdata', [], 'ydata', [], 'zdata', []);
        end
        
        % Visulise the Origins?
        if get(MGUIHandle.Insertion_Visualisation_Button, 'value')
            MPlotHandles.MuscleInsertionHandle(MuscleId) = VISUALISATION_view_muscle_insertions(MPlotHandles.MuscleInsertionHandle(MuscleId), MWDATA, BLDATA, MuscleId);
        else
            set(MPlotHandles.MuscleInsertionHandle(MuscleId), 'xdata', [], 'ydata', [], 'zdata', []);
        end
        
        for SegmentId = 1:20
            if SegmentId < MWDATA{MuscleId,1}.MSCInfo.NbSegments+1
                [MPlotHandles.MuscleSegments(MuscleId, SegmentId), MWDATA] = VISUALISATION_view_muscle_segement(MPlotHandles.MuscleSegments(MuscleId, SegmentId), MWDATA, BLDATA, MuscleId, SegmentId);
            else
                set(MPlotHandles.MuscleSegments(MuscleId, SegmentId), 'xdata', [], 'ydata', [], 'zdata', []);
            end
            
        end

    % The Muscle is not to be visualised
    else
        set(MPlotHandles.MuscleOriginHandle(MuscleId), 'xdata', [], 'ydata', [], 'zdata', []);
        set(MPlotHandles.MuscleInsertionHandle(MuscleId), 'xdata', [], 'ydata', [], 'zdata', []);
        for SegmentId = 1:20
            set(MPlotHandles.MuscleSegments(MuscleId, SegmentId), 'xdata', [], 'ydata', [], 'zdata', []);
            
        end
    end
    
    % The Muscle Object is to be visualised
    if isequal(get(MGUIHandle.Muscle_Wrap_Menu.Options(MuscleId, 3), 'Checked'), 'on');
       MPlotHandles = VISUALISATION_view_muscle_wrapping_object(MPlotHandles, MWDATA, MuscleId, BLDATA);
    % The Muscle Object is not to be visualised
    else
        set(MPlotHandles.MuscleObject(MuscleId,1), 'xdata', zeros(2,2), 'ydata', zeros(2,2), 'zdata', zeros(2,2));
        set(MPlotHandles.MuscleObject(MuscleId,2), 'xdata', zeros(2,2), 'ydata', zeros(2,2), 'zdata', zeros(2,2));
    end
    
end

return;