function MWDATA = MUSCLE_TOOL_build_muscle(MGUIHandle, MWDATA_in, MuscleId)
% UICONTROL Callback constructs the muscle segements from muscle GUI
%--------------------------------------------------------------------------
% Syntax :
% MWDATA = MUSCLE_TOOL_build_muscle(MGUIHandle, MWDATA_in, MuscleId)
%--------------------------------------------------------------------------
%
% File Description :
% This function constructs the muscle data given the user input from the
% muscle tool gui.
%
%--------------------------------------------------------------------------

% Initialise the output
MWDATA = MWDATA_in;

% Get the visulisation option
MWDATA{MuscleId,1}.MSCInfo.Visualise = get(MGUIHandle.Muscle_Wrap_Menu.Options(MuscleId,2), 'Checked');

% Get the object visulisation option
MWDATA{MuscleId,1}.MSCInfo.ObjectVisualise = get(MGUIHandle.Muscle_Wrap_Menu.Options(MuscleId,3), 'Checked');

% Get the object radius scaling factor
%MWDATA{MuscleId,1}.MSCInfo.Rscale = get(MGUIHandle.Muscle_Wrap_Menu.Options(MuscleId,6), 'UserData')/2;
MWDATA{MuscleId,1}.MSCInfo.ObjectRadiiscale = get(MGUIHandle.Muscle_Wrap_Menu.Options(MuscleId,6), 'UserData');

InterpTypes = {'Linear', 'Bi-Linear', '3rd Order'};

% Get the Interpolation & Number of muscle segments
for i = 1:20
    % Get the Interpolation type
    if i < 4
        Status = get(MGUIHandle.Muscle_Wrap_Menu.Interpolation(MuscleId,i), 'Checked');

        if isequal(Status, 'on')
            MWDATA{MuscleId,1}.MSCInfo.InterpType = InterpTypes{1,i};
        else
        end
        % Get the Number of Muscle Segements
        NbSeg = get(MGUIHandle.Muscle_Wrap_Menu.SegNumber(MuscleId,i), 'Checked');
        if isequal(NbSeg, 'on')
            MWDATA{MuscleId,1}.MSCInfo.NbSegments = i;
        else
        end
    else
        % Get the Number of Muscle Segements
        NbSeg = get(MGUIHandle.Muscle_Wrap_Menu.SegNumber(MuscleId,i), 'Checked');
        if isequal(NbSeg, 'on')
            MWDATA{MuscleId,1}.MSCInfo.NbSegments = i;
        else
        end
    end
end

% Build the Interpolation for the origins
WayPoints.Origin = MUSCLE_TOOL_spline_build(...
    MWDATA{MuscleId,1}.AnchorOrigin,...
    MWDATA{MuscleId,1}.MSCInfo.InterpType,...
    MWDATA{MuscleId,1}.MSCInfo.NbSegments);

% Build the Interpolation for the Insertion
WayPoints.Insertion = MUSCLE_TOOL_spline_build(...
    MWDATA{MuscleId,1}.AnchorInsertion,...
    MWDATA{MuscleId,1}.MSCInfo.InterpType,...
    MWDATA{MuscleId,1}.MSCInfo.NbSegments);

% Build the Interpolation for the Via points A
if isempty(MWDATA{MuscleId,1}.AnchorViaA{1,1}) == 0
    WayPoints.ViaA = MUSCLE_TOOL_spline_build(...
        MWDATA{MuscleId,1}.AnchorViaA,...
        MWDATA{MuscleId,1}.MSCInfo.InterpType,...
        MWDATA{MuscleId,1}.MSCInfo.NbSegments);
else
end

% Build the Interpolation for the Via points B
if isempty(MWDATA{MuscleId,1}.AnchorViaB{1,1}) == 0
    WayPoints.ViaB = MUSCLE_TOOL_spline_build(...
        MWDATA{MuscleId,1}.AnchorViaB,...
        MWDATA{MuscleId,1}.MSCInfo.InterpType,...
        MWDATA{MuscleId,1}.MSCInfo.NbSegments);
else
end

% Fill the usable points
for i = 1:MWDATA{MuscleId,1}.MSCInfo.NbSegments
    MWDATA{MuscleId,1}.Origin{1,i} = WayPoints.Origin(:,i);
    MWDATA{MuscleId,1}.Insertion{1,i} = WayPoints.Insertion(:,i);
    
    if isempty(MWDATA{MuscleId,1}.AnchorViaA{1,1}) == 0
        MWDATA{MuscleId,1}.ViaA{1,i} = WayPoints.ViaA(:,i);
    else
    end
    
    if isempty(MWDATA{MuscleId,1}.AnchorViaB{1,1}) == 0
        MWDATA{MuscleId,1}.ViaB{1,i} = WayPoints.ViaB(:,i);
    else
    end
end

return;