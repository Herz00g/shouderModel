function MEDATA = MAIN_INITIALISATION_build_data_3D_meshing()
%{
Function to initialise the 3D bone meshing.
--------------------------------------------------------------------------
Syntax :
MEDATA = MAIN_INITIALISATION_build_data_3D_meshing()
--------------------------------------------------------------------------

File Description:
The function loads the meshing data of the bones in *.mat format from 
Visualisation_Original_Meshings and saves them into MEDATA following the
below general format. The meshing data were achieved from AMIRA and
presented in the bone fixed frame of each of the bones.
          MEDATA.Thorax_Mesh.tri
          MEDATA.Thorax_Mesh.points
          MEDATA.Clavicula_Mesh.tri
          MEDATA.Clavicula_Mesh.points
          MEDATA.Scapula_Mesh.tri
          MEDATA.Scapula_Mesh.points
          MEDATA.Humerus_Mesh.tri
          MEDATA.Humerus_Mesh.points
          MEDATA.Ulna_Mesh.tri
          MEDATA.Ulna_Mesh.points
          MEDATA.Radius_Mesh.tri
          MEDATA.Radius_Mesh.points
notes:
*.points contains the geometric location of the points forming the
mehsing.
*.tri contains the connectivity table to build the meshing using MATLAB's
trisurf function.
%}
%--------------------------------------------------------------------------

% Initialiase the Output
MEDATA = [];

%--------------------------------------------------------------------------
% LOAD INDIVIDUAL MESH DATA [from the folder: Visualisation_Original_Meshings]
%--------------------------------------------------------------------------
% Get the Current Folder
Current_Folder = pwd;% pwd displays the MATLAB current folder.
%CurrentFolder = pwd returns the current folder as a string to Current_Folder.

% Differentiate between unix and non-unix
if isunix
    load([Current_Folder, '/Visualisation_Original_Meshings/Thorax_Mesh0']);
    load([Current_Folder, '/Visualisation_Original_Meshings/Clavicula_Mesh0']);
    load([Current_Folder, '/Visualisation_Original_Meshings/Scapula_Mesh0']);
    load([Current_Folder, '/Visualisation_Original_Meshings/Humerus_Mesh0']);
    load([Current_Folder, '/Visualisation_Original_Meshings/Ulna_Mesh_Try32']);
    load([Current_Folder, '/Visualisation_Original_Meshings/Radius_Mesh_Try32']);
    load([Current_Folder, '/Visualisation_Original_Meshings/Hand_Mesh_Try2']);

else
    load([Current_Folder, '\Visualisation_Original_Meshings\Thorax_Mesh0']);
    load([Current_Folder, '\Visualisation_Original_Meshings\Clavicula_Mesh0']);
    load([Current_Folder, '\Visualisation_Original_Meshings\Scapula_Mesh0']);
    load([Current_Folder, '\Visualisation_Original_Meshings\Humerus_Mesh0']);
    load([Current_Folder, '\Visualisation_Original_Meshings\Ulna_Mesh_Try32']);
    load([Current_Folder, '\Visualisation_Original_Meshings\Radius_Mesh_Try32']);
    load([Current_Folder, '\Visualisation_Original_Meshings\Hand_Mesh_Try2']);

end

%--------------------------------------------------------------------------
% CREATE A DATA STRUCTURE WITH ALL MESHINGS
%--------------------------------------------------------------------------
% Thorax Frame, No Modification Will Be required
MEDATA.Thorax_Mesh.tri = Thorax_Mesh0.tri;
% Scale data into mm
MEDATA.Thorax_Mesh.points = 1.e3*Thorax_Mesh0.points;

% Defined in Clavicula frame centred at SC joint
MEDATA.Clavicula_Mesh.tri = Clavicula_Mesh0.tri;
% Scale data into mm
MEDATA.Clavicula_Mesh.points = 1.e3*Clavicula_Mesh0.points;

% Defined in Scapula frame centred at AA point [or AC joint?]
MEDATA.Scapula_Mesh.tri = Scapula_Mesh0.tri;
% Scale data into mm
MEDATA.Scapula_Mesh.points = 1.e3*Scapula_Mesh0.points;

% Defined in Humerus frame centred at GH joint
MEDATA.Humerus_Mesh.tri = Humerus_Mesh0.tri;
% Scale data into mm
MEDATA.Humerus_Mesh.points = 1.e3*Humerus_Mesh0.points;

% Defined in Ulna frame centred at HU joint (the HU point is the same)
MEDATA.Ulna_Mesh.tri = Ulna_Mesh_Try3.tri;%Ulna_Mesh0
% Scale data into mm
MEDATA.Ulna_Mesh.points = Ulna_Mesh_Try3.points;%1.e3*

% Defined in Radius frame centred at CP point
MEDATA.Radius_Mesh.tri = Radius_Mesh_Try3.tri;%Radius_Mesh0
% Scale data into mm
MEDATA.Radius_Mesh.points = Radius_Mesh_Try3.points;%1.e3*

% Defined in Radius frame centred at CP point
MEDATA.Hand_Mesh.tri = Hand_Mesh_Try2.tri;%Radius_Mesh0
% Scale data into mm
MEDATA.Hand_Mesh.points = Hand_Mesh_Try2.points;%1.e3*

return;