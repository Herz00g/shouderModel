function MPlotHandles = VISUALISATION_view_muscle_wrapping_object(MPlotHandles_in, MWDATA, MuscleId, BLDATA)
% Function for visualising the wrapping object in 3D.
%--------------------------------------------------------------------------
% Syntax :
% MPlotHandles = VISUALISATION_view_muscle_wrapping_object(MPlotHandles_in, MWDATA, MuscleId, BLDATA)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function either creates a visualisation of the muscle wrapping 
% object or updates an already existing one.
%
% MPlotHandles_in contains the handle
% MWDATA msucle wrapping data structure
% MuscleId is the muscle identification number
% BLDATA bony landmark data structure
%--------------------------------------------------------------------------
% Initialise the output
MPlotHandles = MPlotHandles_in;

% Construct a One-Time Muscle Structure for a single segment
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

% Get the Object Centre in the absolute reference frame
Object_Centre = MUSCLE_TOOL_geometry_functions('Rotate Object Centre To Absolute Frame', BLDATA, Muscle_Seg, [], []);

% Get the Object Rotation Matrix
Object_Rotation_Matrix = MUSCLE_TOOL_geometry_functions('Construct Object Rotation Matrix', BLDATA, Muscle_Seg, [], []);

%--------------------------------------------------------------------------
% The Muscle Has no Wrapping
% NO WRAPPING
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
if isequal(MWDATA{MuscleId, 1}.MSCInfo.ObjectType, 'none')
    % do nothing
    
%--------------------------------------------------------------------------
% The muscle has a wrapping
% SINGLE CYLINDER WRAPPING
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
elseif isequal(MWDATA{MuscleId, 1}.MSCInfo.ObjectType, 'single')
    [Cx, Cy, Cz] = cylinder(abs(MWDATA{MuscleId, 1}.MSCInfo.ObjectRadii*MWDATA{MuscleId,1}.MSCInfo.ObjectRadiiscale), 20);
    
    % Lengthen the cylinder
    Cx = [Cx; Cx(1,:)];
    Cy = [Cy; Cy(1,:)];
    Cz = [-100*Cz(2,:); 100*Cz];
    
    % Run through all the points
    for i = 1:size(Cx,1)
        for j = 1:size(Cx,2)
            P = Object_Rotation_Matrix*[Cx(i,j); Cy(i,j); Cz(i,j)] + Object_Centre;
            Cx(i,j) = P(1);
            Cy(i,j) = P(2);
            Cz(i,j) = P(3);
        end
    end
    
    % Create the object
    set(MPlotHandles.MuscleObject(MuscleId,1), 'xdata', Cx, 'ydata', Cy, 'zdata', Cz);
    
%--------------------------------------------------------------------------
% The muscle has a wrapping
% DOUBLE CYLINDER WRAPPING
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------  
elseif isequal(MWDATA{MuscleId, 1}.MSCInfo.ObjectType, 'double')
    % Construct the First Cylinder
    [Cx, Cy, Cz] = cylinder(abs(MWDATA{MuscleId, 1}.MSCInfo.ObjectRadii(1)*MWDATA{MuscleId,1}.MSCInfo.ObjectRadiiscale), 20);
    
    % Lengthen the cylinder
    Cx = [Cx; Cx(1,:)];
    Cy = [Cy; Cy(1,:)];
    Cz = [-100*Cz(2,:); 100*Cz];
    
    % Run through all the points
    for i = 1:size(Cx,1)
        for j = 1:size(Cx,2)
            P = Object_Rotation_Matrix(:,1:3)*[Cx(i,j); Cy(i,j); Cz(i,j)] + Object_Centre(:,1);
            Cx(i,j) = P(1);
            Cy(i,j) = P(2);
            Cz(i,j) = P(3);
        end
    end
    
    % Create the object
    set(MPlotHandles.MuscleObject(MuscleId,1), 'xdata', Cx, 'ydata', Cy, 'zdata', Cz);
    
    % Construct the First Cylinder
    [Cx, Cy, Cz] = cylinder(abs(MWDATA{MuscleId, 1}.MSCInfo.ObjectRadii(2)*MWDATA{MuscleId,1}.MSCInfo.ObjectRadiiscale), 20);
    
    % Lengthen the cylinder
    Cx = [Cx; Cx(1,:)];
    Cy = [Cy; Cy(1,:)];
    Cz = [-100*Cz(2,:); 100*Cz];
    
    % Run through all the points
    for i = 1:size(Cx,1)
        for j = 1:size(Cx,2)
            P = Object_Rotation_Matrix(:,4:6)*[Cx(i,j); Cy(i,j); Cz(i,j)] + Object_Centre(:,2);
            Cx(i,j) = P(1);
            Cy(i,j) = P(2);
            Cz(i,j) = P(3);
        end
    end
    
    % Create the object
    set(MPlotHandles.MuscleObject(MuscleId,2), 'xdata', Cx, 'ydata', Cy, 'zdata', Cz);
    
%--------------------------------------------------------------------------
% The muscle has a wrapping
% SPHERE CAPPED CYLINDER WRAPPING
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------    
elseif isequal(MWDATA{MuscleId, 1}.MSCInfo.ObjectType, 'stub')
    % Build the Cylinder
    [Cx, Cy, Cz] = cylinder(abs(MWDATA{MuscleId, 1}.MSCInfo.ObjectRadii*MWDATA{MuscleId,1}.MSCInfo.ObjectRadiiscale), 20);
    
    % Lengthen the cylinder
    Cz = -100*Cz;
    
    % Run through all the points
    for i = 1:size(Cx,1)
        for j = 1:size(Cx,2)
            P = Object_Rotation_Matrix*[Cx(i,j); Cy(i,j); Cz(i,j)] + Object_Centre;
            Cx(i,j) = P(1);
            Cy(i,j) = P(2);
            Cz(i,j) = P(3);
        end
    end
    
    % Create the object
    set(MPlotHandles.MuscleObject(MuscleId,1), 'xdata', Cx, 'ydata', Cy, 'zdata', Cz);
    
    % Build the Spherical Cap
    [Sx, Sy, Sz] = sphere(20);
    
    % Cut the Sphere in half
    Sx = Sx(11:end,:);
    Sy = Sy(11:end,:);
    Sz = Sz(11:end,:);
    
    % Get the Radii
    R = abs(MWDATA{MuscleId, 1}.MSCInfo.ObjectRadii*MWDATA{MuscleId,1}.MSCInfo.ObjectRadiiscale);
    
    % Run through all the points
    for i = 1:size(Sx,1)
        for j = 1:size(Sx,2)
            P = Object_Rotation_Matrix*R*[Sx(i,j); Sy(i,j); Sz(i,j)] + Object_Centre;
            Sx(i,j) = P(1);
            Sy(i,j) = P(2);
            Sz(i,j) = P(3);
        end
    end
    
    % Create the object
    set(MPlotHandles.MuscleObject(MuscleId,2), 'xdata', Sx, 'ydata', Sy, 'zdata', Sz);
end
return