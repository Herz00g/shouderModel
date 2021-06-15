function [PlotHandles] = INITIAL_CONFIGURATION_update_visualisation(PHandles, BLDATA, MEDATA)
% Function for updating the initial configuration GUI visulisation.
%--------------------------------------------------------------------------
% Syntax :
% [PlotHandles] = INITIAL_CONFIGURATION_update_visualisation(PHandles, BLDATA, MEDATA)
%--------------------------------------------------------------------------
%

% File Description :
% This function updates the current visualisation of the initial
% configuration tool.
%--------------------------------------------------------------------------

% Initialise the Output
PlotHandles = PHandles;

%--------------------------------------------------------------------------
% Update All the Meshings
%--------------------------------------------------------------------------
PlotHandles.MeshHandle(1) = VISUALISATION_view_bone_meshing(PlotHandles.MeshHandle(1), MEDATA, 0, BLDATA);
PlotHandles.MeshHandle(2) = VISUALISATION_view_bone_meshing(PlotHandles.MeshHandle(2), MEDATA, 1, BLDATA);
PlotHandles.MeshHandle(3) = VISUALISATION_view_bone_meshing(PlotHandles.MeshHandle(3), MEDATA, 2, BLDATA);
PlotHandles.MeshHandle(4) = VISUALISATION_view_bone_meshing(PlotHandles.MeshHandle(4), MEDATA, 3, BLDATA);
PlotHandles.MeshHandle(5) = VISUALISATION_view_bone_meshing(PlotHandles.MeshHandle(5), MEDATA, 4, BLDATA);
PlotHandles.MeshHandle(6) = VISUALISATION_view_bone_meshing(PlotHandles.MeshHandle(6), MEDATA, 5, BLDATA);
PlotHandles.MeshHandle(7) = VISUALISATION_view_bone_meshing(PlotHandles.MeshHandle(7), MEDATA, 6, BLDATA);


%--------------------------------------------------------------------------
% Update All the Wire Frames
%--------------------------------------------------------------------------
PlotHandles.WireFrameHandle(1) = VISUALISATION_view_bone_wireframe(PlotHandles.WireFrameHandle(1), 0, BLDATA);
PlotHandles.WireFrameHandle(2) = VISUALISATION_view_bone_wireframe(PlotHandles.WireFrameHandle(2), 1, BLDATA);
PlotHandles.WireFrameHandle(3) = VISUALISATION_view_bone_wireframe(PlotHandles.WireFrameHandle(3), 2, BLDATA);
PlotHandles.WireFrameHandle(4) = VISUALISATION_view_bone_wireframe(PlotHandles.WireFrameHandle(4), 3, BLDATA);
PlotHandles.WireFrameHandle(5) = VISUALISATION_view_bone_wireframe(PlotHandles.WireFrameHandle(5), 4, BLDATA);
PlotHandles.WireFrameHandle(6) = VISUALISATION_view_bone_wireframe(PlotHandles.WireFrameHandle(6), 5, BLDATA);

return;