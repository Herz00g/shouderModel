function [PlotHandles, MWDATA] = MAIN_TOOL_update_visualisation(MAINGUIHandle, PHandles, BLDATA, MEDATA, MWDATAin, REDATA)

%{
Function for updating the main GUI's visualisation of the model
--------------------------------------------------------------------------
Syntax :
[PlotHandles, MWDATA] = MAIN_TOOL_update_visualisation(MAINGUIHandle, PHandles, BLDATA, MEDATA, MWDATA, REDATA, JCDATA)
--------------------------------------------------------------------------

File Description :
This function updates the current visualisation of the main GUI.

Function Inputs :
1) MAINGUIHandle, contains the uicontrol information for deciding what to
plot and what not to plot.

2) PHandles, contains in a single structure all the plot handles. This
input is also an output.

3) BLDATA, MEDATA, MWDATAin, REDATA, JCDATA, all the data structures
containing the anatomical data and geometric data.

Function Outputs :
1) PlotHandles, contains the updated handles of all the plots

2) MWDATA, contains the updated muscle wrapping data, if the object
radius adjustment factor was changed.

%}
% --------------------------------------------------------------------------

% Initialise the Outputs
PlotHandles = PHandles;
MWDATA = MWDATAin;

% Get the Visualisation Options. They are all stored in the value option of
% the main GUI radiobutton handles.
ViewClavicula = get(MAINGUIHandle.VisClaviculaOption, 'value');
ViewScapula   = get(MAINGUIHandle.VisScapulaOption, 'value');
ViewHumerus   = get(MAINGUIHandle.VisHumerusOption, 'value');
ViewUlna      = get(MAINGUIHandle.VisUlnaOption, 'value');
ViewRadius    = get(MAINGUIHandle.VisRadiusOption, 'value');
ViewMuscles   = get(MAINGUIHandle.VisMuscleOption, 'value');
ViewMusclesO  = get(MAINGUIHandle.VisMuscleOOption, 'value');
ViewMusclesI  = get(MAINGUIHandle.VisMuscleIOption, 'value');
%ViewJoints    = get(MAINGUIHandle.VisJointSinusConeOption, 'value');
ViewEllipse   = get(MAINGUIHandle.VisEllipsoidOption, 'value');

%--------------------------------------------------------------------------
% Update The Thorax Visualisation
%--------------------------------------------------------------------------
% Update meshing visualisation
PlotHandles.MeshHandle(1) =...
    VISUALISATION_view_bone_meshing(PlotHandles.MeshHandle(1), MEDATA, 0, BLDATA);

% Update the wire frame visualisation
PlotHandles.WireFrameHandle(1)  = VISUALISATION_view_bone_wireframe(PlotHandles.WireFrameHandle(1), 0, BLDATA);

%--------------------------------------------------------------------------
% Update The Thorax, Clavicula, Scapula, Humerus, Ulna, Radius Visualisation
%--------------------------------------------------------------------------
FrameIdList = [0,1,2,3,4,5];
ViewOnList  = [1, ViewClavicula, ViewScapula, ViewHumerus, ViewUlna, ViewRadius];
for BoneId = 1:6
    if ViewOnList(1,BoneId)
        % Update meshing visualisation
        PlotHandles.MeshHandle(BoneId) = VISUALISATION_view_bone_meshing(PlotHandles.MeshHandle(BoneId), MEDATA, FrameIdList(1,BoneId), BLDATA);
        
        % Update the wire frame visualisation
        PlotHandles.WireFrameHandle(BoneId) = VISUALISATION_view_bone_wireframe(PlotHandles.WireFrameHandle(BoneId), FrameIdList(1,BoneId), BLDATA);
    else
        set(PlotHandles.MeshHandle(BoneId), 'vertices', []);
        set(PlotHandles.WireFrameHandle(BoneId), 'xdata', [], 'ydata', [], 'zdata', []);
    end
end

%--------------------------------------------------------------------------
% Muscle Visualisation
%--------------------------------------------------------------------------
for MuscleId = 1:42
    % Update the origin visualisation
    if ViewMusclesO
        PlotHandles.MuscleOriginHandle(MuscleId) =...
            VISUALISATION_view_muscle_origins(PlotHandles.MuscleOriginHandle(MuscleId), MWDATA, BLDATA, MuscleId);
    else
        set(PlotHandles.MuscleOriginHandle(MuscleId), 'xdata', [], 'ydata', [], 'zdata', []);
    end
    
    % Update the insertion visualisation
    if ViewMusclesI
        PlotHandles.MuscleInsertionHandle(MuscleId) =...
            VISUALISATION_view_muscle_insertions(PlotHandles.MuscleInsertionHandle(MuscleId), MWDATA, BLDATA, MuscleId);
    else
        set(PlotHandles.MuscleInsertionHandle(MuscleId), 'xdata', [], 'ydata', [], 'zdata', []);
    end
    
    % Update the muscle segment visualisations
    if ViewMuscles
        % Run through all the segments
        for SegmentId = 1:20
            if SegmentId < MWDATA{MuscleId, 1}.MSCInfo.NbSegments+1;
                [PlotHandles.MuscleSegments(MuscleId, SegmentId), MWDATA] =...
                VISUALISATION_view_muscle_segement(PlotHandles.MuscleSegments(MuscleId, SegmentId), MWDATA, BLDATA, MuscleId, SegmentId);
            else
                set(PlotHandles.MuscleSegments(MuscleId, SegmentId), 'xdata', [], 'ydata', [], 'zdata', []);
            end
        end
    else
        % Run through all the segments
        for SegmentId = 1:20
            set(PlotHandles.MuscleSegments(MuscleId, SegmentId), 'xdata', [], 'ydata', [], 'zdata', []);
        end
    end
end
%{
%--------------------------------------------------------------------------
% Joint Sinus Cone Visualisation
%--------------------------------------------------------------------------
for ConeId = 1:3
    if ViewJoints
        PlotHandles.JointSinusCone(1,ConeId) = ...
            VISUALISATION_view_joint_sinus_cones(PlotHandles.JointSinusCone(1,ConeId), JCDATA, BLDATA, ConeId);
    else
        set(PlotHandles.JointSinusCone(1,ConeId), 'xdata', [], 'ydata', [], 'zdata', []);
    end
end
%}
%--------------------------------------------------------------------------
% Ribcage Ellipsoid Visualisation
%--------------------------------------------------------------------------
if ViewEllipse
    PlotHandles.Ellispoid = VISUALISATION_view_ribcage_ellipsoid(PlotHandles.Ellispoid, REDATA);
else
    set(PlotHandles.Ellispoid, 'xdata', [], 'ydata', [], 'zdata', []);
end
return;