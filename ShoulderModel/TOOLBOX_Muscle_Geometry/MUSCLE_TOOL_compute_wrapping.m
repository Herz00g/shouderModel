function [WRDATA] = MUSCLE_TOOL_compute_wrapping(BLDATA, MWDATA)
% UICONTROL Callback computes the muscle wrapping
%--------------------------------------------------------------------------
% Syntax :
% [WRDATA, MWDATA] = MUSCLE_TOOL_compute_wrapping(BLDATA, MWDATAin)
%--------------------------------------------------------------------------
%
% File Description :
% This function computes the muscle wrapping using the obstacle set
% methods.
%--------------------------------------------------------------------------

% Initialise the Output
WRDATA.PathPoints = [];
WRDATA.PathRefList = [];
WRDATA.PathLength = 0;

% Create the list of already known points
PointsList = [MWDATA.Origin, MWDATA.ViaA, MWDATA.ViaB, MWDATA.Insertion];
RefList = [MWDATA.OriginRef, MWDATA.ViaARef, MWDATA.ViaBRef, MWDATA.InsertionRef];

% Transform the list of points to the absolute reference frame
PointsList = MUSCLE_TOOL_geometry_functions('Rotate Points To Absolute Frame', BLDATA, MWDATA, PointsList, RefList);

% Get the Object Centre in the absolute reference frame
Object_Centre = MUSCLE_TOOL_geometry_functions('Rotate Object Centre To Absolute Frame', BLDATA, MWDATA, PointsList, RefList);

% Get the Object Rotation Matrix
Object_Rotation_Matrix = MUSCLE_TOOL_geometry_functions('Construct Object Rotation Matrix', BLDATA, MWDATA, PointsList, RefList);

%--------------------------------------------------------------------------
% The Muscle Has no Wrapping
% NO WRAPPING
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
if isequal(MWDATA.ObjectType, 'none')
    % Set the list of points as the output
    WRDATA.PathPoints = PointsList;
    WRDATA.PathRefList = RefList;
    

    % Compute the length
    WRDATA.PathLength = 0;
    for i = 1:size(PointsList,2)-1
        WRDATA.PathLength = WRDATA.PathLength + norm(PointsList(:,i+1) - PointsList(:,i));
    end
%--------------------------------------------------------------------------
% The Muscle has a Wrapping
% SINGLE CYLINDER WRAPPING
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
elseif isequal(MWDATA.ObjectType, 'single')
    % Identify which end-points should be used
    Origin    = zeros(3,1);
    Insertion = zeros(3,1);
    OriginFlag = [];
    InsertionFlag = [];
    
    % There is no Via point A
    if isempty(MWDATA.ViaA)
        Origin = PointsList(:,1);
        OriginFlag = [];
    else
        Origin = PointsList(:,2);
        OriginFlag = 1;
        WRDATA.PathLength = norm(PointsList(:,2) - PointsList(:,1));
    end
    
    % There is no Via point B
    if isempty(MWDATA.ViaB)
        Insertion = PointsList(:,end);
        InsertionFlag = [];
    else
        Insertion = PointsList(:,end-1);
        InsertionFlag = size(PointsList,2);
        WRDATA.PathLength = WRDATA.PathLength + norm(PointsList(:,end) - PointsList(:,end-1));
    end
    
    % Adjust the wrapping radius
    [Robj, rflag] = MUSCLE_TOOL_adjust_radius(...
        Origin, Insertion, Object_Centre, MWDATA.ObjectRadii, Object_Rotation_Matrix, 'single');
    
    % Compute the Wrapping
    [PATH, Length, wflag] = MUSCLE_TOOL_cylinder_wrap(...
        Origin, Insertion, Object_Centre, Robj, Object_Rotation_Matrix, MWDATA.NbPlot);
    
    % Define the Total Muscle Length
    WRDATA.PathLength = WRDATA.PathLength + Length;
    
    % Define the Full Path
    WRDATA.PathPoints = [PointsList(:,OriginFlag), PATH, PointsList(:,InsertionFlag)];
    
    % Create the list of reference for each point
    if wflag ~= 0
        WRDATA.PathRefList = RefList;
    else
        WRDATA.PathRefList = [MWDATA.OriginRef, MWDATA.ViaARef, MWDATA.ObjectRef*ones(1,size(PATH,2)-2), MWDATA.ViaBRef, MWDATA.InsertionRef];
    end
    
%--------------------------------------------------------------------------
% The Muscle has a Wrapping
% DOUBLE CYLINDER WRAPPING
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
elseif isequal(MWDATA.ObjectType, 'double')
    Origin    = zeros(3,1);
    Insertion = zeros(3,1);
    OriginFlag = [];
    InsertionFlag = [];
    
    % There is no Via point A
    if isempty(MWDATA.ViaA)
        Origin = PointsList(:,1);
        OriginFlag = [];
    else
        Origin = PointsList(:,2);
        OriginFlag = 1;
        WRDATA.PathLength = norm(PointsList(:,2) - PointsList(:,1));
    end
    
    % There is no Via point B
    if isempty(MWDATA.ViaB)
        Insertion = PointsList(:,end);
        InsertionFlag = [];
    else
        Insertion = PointsList(:,end-1);
        InsertionFlag = size(PointsList,2);
        WRDATA.PathLength = WRDATA.PathLength + norm(PointsList(:,end) - PointsList(:,end-1));
    end
    
    % Adjust the wrapping radius
    [Robj, rflag] = MUSCLE_TOOL_adjust_radius(...
        Origin, Insertion, Object_Centre, MWDATA.ObjectRadii, Object_Rotation_Matrix, 'double');
    
    % Compute the Wrapping
    [PATH, Length, wflag] = MUSCLE_TOOL_dcylinder_wrap(...
        Origin, Insertion, Object_Centre, Robj, Object_Rotation_Matrix, MWDATA.NbPlot);
    
    % Define the Total Muscle Length
    WRDATA.PathLength = WRDATA.PathLength + Length;
    
    % Define the Full Path
    WRDATA.PathPoints = [PointsList(:,OriginFlag), PATH, PointsList(:,InsertionFlag)];
    
    % Generate the Wrapping reference defnitions
    if wflag == 4
        WRDATA.PathRefList = [MWDATA.OriginRef, MWDATA.ViaARef,  MWDATA.ObjectRef(1)*ones(1,MWDATA.NbPlot),  MWDATA.ObjectRef(2)*ones(1,MWDATA.NbPlot), MWDATA.ViaBRef, MWDATA.InsertionRef];
    elseif wflag == 3
        WRDATA.PathRefList = [MWDATA.OriginRef, MWDATA.ViaARef,  MWDATA.ObjectRef(2)*ones(1,size(PATH,2)-2), MWDATA.ViaBRef, MWDATA.InsertionRef];
    elseif wflag == 2
        WRDATA.PathRefList = [MWDATA.OriginRef, MWDATA.ViaARef,  MWDATA.ObjectRef(1)*ones(1,size(PATH,2)-2), MWDATA.ViaBRef, MWDATA.InsertionRef];
    elseif wflag == 1
        WRDATA.PathRefList = RefList;
    end
%--------------------------------------------------------------------------
% The muscle has a wrapping
% SPHERE CAPPED CYLINDER WRAPPING
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
elseif isequal(MWDATA.ObjectType, 'stub')
    Origin    = zeros(3,1);
    Insertion = zeros(3,1);
    OriginFlag = [];
    InsertionFlag = [];
    
    % There is no Via point A
    if isempty(MWDATA.ViaA)
        Origin = PointsList(:,1);
        OriginFlag = [];
    else
        Origin = PointsList(:,2);
        OriginFlag = 1;
        WRDATA.PathLength = norm(PointsList(:,2) - PointsList(:,1));
    end
    
    % There is no Via point B
    if isempty(MWDATA.ViaB)
        Insertion = PointsList(:,end);
        InsertionFlag = [];
    else
        Insertion = PointsList(:,end-1);
        InsertionFlag = size(PointsList,2);
        WRDATA.PathLength = WRDATA.PathLength + norm(PointsList(:,end) - PointsList(:,end-1));
    end

    % Adjust the wrapping radius
    [Robj, rflag] = MUSCLE_TOOL_adjust_radius(...
        Origin, Insertion, Object_Centre, MWDATA.ObjectRadii, Object_Rotation_Matrix, 'stub');

    % Change direction? STUB wrapping must have S always with Sz > Pz.
    p = Object_Rotation_Matrix'*(Origin - Object_Centre);
    s = Object_Rotation_Matrix'*(Insertion - Object_Centre);

    Switchflag = 0;
    if p(3) > s(3)
        Sv = Origin;
        Origin = Insertion;
        Insertion = Sv;
        Switchflag = 1;
        
    end
    % Compute the Wrapping
    [PATH, Length, wflag] = MUSCLE_TOOL_stub_wrap(...
        Origin, Insertion, Object_Centre, Robj, Object_Rotation_Matrix, MWDATA.NbPlot, Switchflag);
    
    % Define the Full Path
    if Switchflag == 1
        WRDATA.PathPoints = [PointsList(:,OriginFlag), PATH(:,end:-1:1), PointsList(:,InsertionFlag)];
    else
        WRDATA.PathPoints = [PointsList(:,OriginFlag), PATH, PointsList(:,InsertionFlag)];
    end
    % Define the Total Muscle Length
    WRDATA.PathLength = WRDATA.PathLength + Length;
    
    if size(PATH,2) > 2
        WRDATA.PathRefList = [MWDATA.OriginRef, MWDATA.ViaARef, MWDATA.ObjectRef*ones(1,size(PATH,2)-2), MWDATA.ViaBRef, MWDATA.InsertionRef];
    else
        WRDATA.PathRefList = RefList;
    end
else
end
return