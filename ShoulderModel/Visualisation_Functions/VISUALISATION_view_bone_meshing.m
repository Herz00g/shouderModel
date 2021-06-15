function MeshHandle = VISUALISATION_view_bone_meshing(MHandle, MEDATA, BoneId, BLDATA, varargin)
% Function for visualising the 3D meshings of the bones.
%--------------------------------------------------------------------------
% Syntax :
% MeshHandle = VISUALISATION_view_bone_meshing(MHandle, MEDATA, BoneId, BLDATA, varargin)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function either creates a visualisation of the bones or updates an
% already existing one.
% MHandle contains the handle
% MEDATA contains the meshing data
% BoneId is the bone identification number
% BLDATA bony landmark data structure
%--------------------------------------------------------------------------

% Initialise the Output
MeshHandle = MHandle;

%--------------------------------------------------------------------------
% The input handle is empty (no mesh plot has been created)
%--------------------------------------------------------------------------
if isempty(MHandle) == 1
    switch  BoneId
        case 0  % Thorax
            % Create the Meshing
            MeshHandle = trisurf(MEDATA.Thorax_Mesh.tri,...
                                 MEDATA.Thorax_Mesh.points(:,1),...
                                 MEDATA.Thorax_Mesh.points(:,2),...
                                 MEDATA.Thorax_Mesh.points(:,3));
   
        case 1  % Clavicula
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Clavicula_Mesh.points', BLDATA, 1);
            
            % Meshing Points must be columns
            Points = Points';
            
            % Create the meshing
            MeshHandle = trisurf(MEDATA.Clavicula_Mesh.tri, Points(:,1), Points(:,2), Points(:,3));
        case 2  % Scapula
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Scapula_Mesh.points', BLDATA, 2);
            
            % Meshing Points must be columns
            Points = Points';
            
            % Create the Meshing
            MeshHandle = trisurf(MEDATA.Scapula_Mesh.tri, Points(:,1), Points(:,2), Points(:,3));
        case 3  % Humerus
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Humerus_Mesh.points', BLDATA, 3);
            
            % Meshing Points must be columns
            Points = Points';
            
            % Create the Meshing
            MeshHandle = trisurf(MEDATA.Humerus_Mesh.tri, Points(:,1), Points(:,2), Points(:,3));
        case 4  % Ulna
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Ulna_Mesh.points', BLDATA, 4);

            % Meshing Points must be columns
            Points = Points';
            
            % Create the Meshing
            MeshHandle = trisurf(MEDATA.Ulna_Mesh.tri, Points(:,1), Points(:,2), Points(:,3));
        case 5  % Radius
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Radius_Mesh.points', BLDATA, 5);
            
            % Meshing Points must be columns
            Points = Points';
            
            % Create the Meshing
            MeshHandle = trisurf(MEDATA.Radius_Mesh.tri, Points(:,1), Points(:,2), Points(:,3));
            
        case 6  % Hand
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Hand_Mesh.points', BLDATA, 5);
            
            % Meshing Points must be columns
            Points = Points';
            
            % Create the Meshing
            MeshHandle = trisurf(MEDATA.Hand_Mesh.tri, Points(:,1), Points(:,2), Points(:,3));    
        otherwise
            % Do nothing
    end
    
%--------------------------------------------------------------------------
% The input handle is not empty
%--------------------------------------------------------------------------
else
    switch  BoneId
        case 0  % THORAX
            % Update the Meshing
            set(MeshHandle, 'Vertices', MEDATA.Thorax_Mesh.points);
            
        case 1  % CLAVICULA
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Clavicula_Mesh.points', BLDATA, 1);
            
            % Update the Meshing
            set(MeshHandle, 'Vertices', Points');
            
            
        case 2  % SCAPULA
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Scapula_Mesh.points', BLDATA, 2);
            
            % Update the Meshing
            set(MeshHandle, 'Vertices', Points');
            
        case 3  % HUMERUS
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Humerus_Mesh.points', BLDATA, 3);
                  
           % Update the Meshing
           set(MeshHandle, 'Vertices', Points');
        
        case 4  % Ulna
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Ulna_Mesh.points', BLDATA, 4);
                  
           % Update the Meshing
           set(MeshHandle, 'Vertices', Points');
           
        case 5  % Radius
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Radius_Mesh.points', BLDATA, 5);
                  
           % Update the Meshing
           set(MeshHandle, 'Vertices', Points');

        case 6  % Hand
            % Rotate the points
            Points = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', MEDATA.Hand_Mesh.points', BLDATA, 5);
                  
           % Update the Meshing
           set(MeshHandle, 'Vertices', Points');           
           
        otherwise
            % Do nothing
    end
end

% Minimise the edge effect
set(MeshHandle, 'edgecolor', 'none');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% SCRIPT ENDS HERE
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
return;