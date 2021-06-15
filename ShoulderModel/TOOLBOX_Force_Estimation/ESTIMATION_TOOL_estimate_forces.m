function [EFDATA, JRDATA, MADATA, SSDATA] = ESTIMATION_TOOL_estimate_forces(ESGUIHandle, MWDATA, REDATA, BLDATA, KEDATA, DYDATA, SSDATA)
%{ 
Function for running the muscle force estimation routine.
--------------------------------------------------------------------------
Syntax :
[EFDATA, JRDATA, MADATA] = ESTIMATION_TOOL_estimate_forces(ESGUIHandle, MWDATA, REDATA, BLDATA, KEDATA, DYDATA)
--------------------------------------------------------------------------
Function Description :
This function computes the moment-arms, muscle forces, joint reaction
forces and scapulothoracic forces.
The Output Data Structure is defined as follows:

  EFDATA{MuscleId, 1}  Estimated forces (muscles and constraints)
  JRDATA = n x 7       Joint reaction, including the vector, its magnitude,
                       and the locus of the force projection on the fossa
  MADATA               Moment arms data
--------------------------------------------------------------------------
%}
% Initialise the output
EFDATA = cell(45,1);
JRDATA = zeros(size(KEDATA.Joint_Angle_Evolution,2),8);

% Each element in the cell will contain an Nx15 matrix
for MuscleId = 1:44
    EFDATA{MuscleId, 1}.MomentArms = cell(1,20);
    for SegmentId = 1:20
        EFDATA{MuscleId, 1}.Forces(:,SegmentId) = zeros(size(KEDATA.Joint_Angle_Evolution,2),1);
        EFDATA{MuscleId, 1}.ForcesMAx(:,SegmentId) = zeros(size(KEDATA.Joint_Angle_Evolution,2),1);
        EFDATA{MuscleId, 1}.MomentArms{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
    end
end

% Initialise the MADATA structure
MADATA = cell(42, 1);

% Each element in the cell will contain a 9 x N matrix
for MuscleId = 1:42
    MADATA{MuscleId, 1}.MomentArms    = cell(1,20);
    MADATA{MuscleId, 1}.FDirection    = cell(1,20);
    MADATA{MuscleId, 1}.ScapularPlane_GnP = cell(1,20);
    MADATA{MuscleId, 1}.ScapularPlane = cell(1,20);
    for SegmentId = 1:20
        MADATA{MuscleId, 1}.MomentArms{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
        MADATA{MuscleId, 1}.FDirection{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
        MADATA{MuscleId, 1}.MuscleLength(:,SegmentId) = zeros(size(KEDATA.Joint_Angle_Evolution,2),1);
        MADATA{MuscleId, 1}.ScapularPlane_GnP{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
        MADATA{MuscleId, 1}.ScapularPlane {1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
    end
end

%--------------------------------------------------------------------------
% Get the UIcontrol Options
%--------------------------------------------------------------------------
ESTDATA.Tmax = str2double(get(ESGUIHandle.TimeFrameEdit, 'string'));
DYDATA.MHand = str2double(get(ESGUIHandle.HandWeightEdit, 'string'));
%ESTDATA.FmaxOption = get(ESGUIHandle.MenuOptions(2,3), 'checked');
ESTDATA.FmaxOption = 'off';
ESTDATA.RconOption = get(ESGUIHandle.MenuOptions(2,2), 'checked');
ESTDATA.EmgOption  = get(ESGUIHandle.MenuOptions(2,3), 'checked'); % get the EMG-assisted option
ESTDATA.MeasKinOption  = get(ESGUIHandle.MenuOptions(2,4), 'checked'); % whether or not to use the measured kinematics

% This Data Structure will also contain the current moment arm matrix,
% Force Direction matrix and Muscle Length Vector
ESTDATA.Moment_Arm_Matrix = [];
ESTDATA.Force_Direction_Matrix = [];
ESTDATA.Muscle_Length = [];

%--------------------------------------------------------------------------
% Define Angles, Velocities, & Accelerations
%--------------------------------------------------------------------------
% first chose among the two available options for the kinematics

if isequal(ESTDATA.MeasKinOption, 'off')
    % Create the Time
    t = linspace(0,ESTDATA.Tmax,size(KEDATA.Joint_Angle_Evolution,2));
    % Pre-Define the Joint Angles, Velocities, and Accelerations
    JEA = KEDATA.Joint_Angle_Evolution;
    dJEAdt = [];
    d2JEAdt2 = []; 
    for TimeId = 1:size(t,2)-1
        % Velocity
        dJEAdt = [dJEAdt, (JEA(:,TimeId+1) - JEA(:,TimeId))/(t(TimeId+1) - t(TimeId))];
    
        if TimeId < size(t,2)-1
            % Acceleration
            d2JEAdt2 = [d2JEAdt2, (JEA(:,TimeId+2) - 2*JEA(:,TimeId+1) + JEA(:,TimeId))/((t(TimeId+2) - t(TimeId+1))*(t(TimeId+1) - t(TimeId)))];
        end
    end
else
    % option 1: use the joint angles acieved directly from the IK
    JEA = SSDATA.Joint_Angle_Reconstruction;
    t = linspace(0,ESTDATA.Tmax,length(SSDATA.Joint_Angle_Reconstruction));
    dJEAdt = [];
    d2JEAdt2 = [];
    for TimeId = 1:length(t)-1
        dJEAdt = [dJEAdt, (JEA(:,TimeId+1) - JEA(:,TimeId))/(t(TimeId+1) - t(TimeId))];
        if TimeId < length(t)-1
            % Acceleration
            d2JEAdt2 = [d2JEAdt2, (JEA(:,TimeId+2) - 2*JEA(:,TimeId+1) + JEA(:,TimeId))/((t(TimeId+2) - t(TimeId+1))*(t(TimeId+1) - t(TimeId)))];
        end
    end
    
    % the clavicle axial rotation is always noisy
    dJEAdt(1,:) = polyval(SSDATA.Joint_Velocity_Coefficients(1, :), t(1, 1:end-1));
	d2JEAdt2(1,:) = polyval(SSDATA.Joint_Acceleration_Coefficients(1, :), t(1, 1:end-2));
    
    % option 2: use the smoothened joint angles from IK  
%     t = linspace(0,ESTDATA.Tmax,100);
%     for ja_id = 1:11
%         JEA(ja_id,:)      = polyval(SSDATA.Joint_Angle_Coefficients(ja_id,:),t);
%         dJEAdt(ja_id,:)   = polyval(SSDATA.Joint_Velocity_Coefficients(ja_id,:),t);
%         d2JEAdt2(ja_id,:) = polyval(SSDATA.Joint_Acceleration_Coefficients(ja_id,:),t);
%     end
%     SSDATA.Smoothened_Joint_Angle_Reconstruction = JEA;
end

%--------------------------------------------------------------------------
% ESTIMATE FORCES OVER ENTIRE MOTION
%--------------------------------------------------------------------------
for TimeId = 1:size(d2JEAdt2,2)
    % Display
%     disp(['Estimating Muscle Forces, Time Stamp : ', num2str(TimeId), '/', num2str(size(KEDATA.Joint_Angle_Evolution,2))]);
    disp(['Estimating Muscle Forces, Time Stamp : ', num2str(TimeId), '/', num2str(size(d2JEAdt2,2))]);

    % Get the Current Rotation Matrices
    %Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles', KEDATA.Joint_Angle_Evolution(:,TimeId), BLDATA);
    Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles', JEA(:,TimeId), BLDATA);

    % Update the current configuration
    BLDATA = MAIN_TOOL_geometry_functions(...
    'Update Current Bony Landmark Data from Joint Rotation Matrices', Rmat(:,1:3), Rmat(:,4:6), Rmat(:,7:9), Rmat(:,10:12), Rmat(:,13:15), BLDATA);
    
    % Set the Dynamic Dataset entries
    DYDATA.JEA      = JEA(:,TimeId);
    DYDATA.dJEAdt   = dJEAdt(:,TimeId);
    DYDATA.d2JEAdt2 = d2JEAdt2(:,TimeId);
    
    %----------------------------------------------------------------------
    % MOMENT ARMS & FORCE DIRECTIONS : GEOMETRIC METHOD FOR EACH MUSCLE
    %----------------------------------------------------------------------
    % Pre-define Moment Arm Matrix
    Wmat = [];
    Dmat = [];
    Lmat = zeros(42,20);
    for MuscleId = 1:42
        for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
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
            
            % Compute the moment arms using the geometric method
            [MAi, DVi] = MOMENT_ARM_TOOL_compute_moment_arms(WRDATA.PathPoints, WRDATA.PathRefList, BLDATA);
            
            % Save the Moment Arms
            MADATA{MuscleId, SegmentId}.geometric(TimeId, :) = MAi';
            
            % Fill The matrix
            Wmat = [Wmat, MAi];
            
            % Fill The Length
            Lmat(MuscleId, SegmentId) = 1.e-3*WRDATA.PathLength;
            
            %{
            % If the muscle inserts on the humerus, use the DVi
            if WRDATA.PathRefList(1,end) == 3
                % Augment the force direction vector
                Dmat = [Dmat, DVi];
            else
                Dmat = [Dmat, zeros(3,1)];
            end
            %}
            
            % Augment the force direction vector
            Dmat = [Dmat, DVi];
        end
    end
    
    % Set the New Current Estimation Data
    ESTDATA.Moment_Arm_Matrix = Wmat;        % 15xnumber of muscles (segments)
    ESTDATA.Force_Direction_Matrix = Dmat;   % 15xnumber of muscles (segments)
    ESTDATA.Muscle_Length = Lmat;

    %----------------------------------------------------------------------
    % ESTIMATE THE FORCES
    %----------------------------------------------------------------------
    FDATA = ESTIMATION_TOOL_run_optimisation(t(TimeId), ESTDATA, DYDATA, MWDATA, BLDATA, REDATA, SSDATA);
    
    % Save the Joint Reaction Force
    JRDATA(TimeId, 1:4) = FDATA.JointReact;
    
    % Save the HU Joint Reaction Force
    JRDATA(TimeId, 9:12) = FDATA.HUJointReact;
    
    % Save the RU Joint Reaction Force
    JRDATA(TimeId, 13:16) = FDATA.RUJointReact;
    
    Exit_flag(TimeId) = FDATA.Exitflag;
%     % update the cone rotation matrix according to the glenoid orientations
%     % data from the subject specific toolbox
%     %       1) inclination
%     Inc = BLDATA.Glenoid_Orientations(1);
%     %       2) version (shown by declination)
%     Dec = BLDATA.Glenoid_Orientations(2);
% 
%     % get the generic values for inclination and version
%     Inc0 = BLDATA.Glenoid_Orientations_Unchanged(1);
%     Dec0 = BLDATA.Glenoid_Orientations_Unchanged(2);
% 
%     % define the rotational operator to rotate the cone base center in the cone
%     % frame by the given values for inclination and version (note that it's an
%     % operator and therefore a transpose of a rotation matrix)
%     R_opt = [cosd(Dec-Dec0) -sind(Dec-Dec0) 0;sind(Dec-Dec0) cosd(Dec-Dec0) 0;0 0 1]*...
%             [cosd(Inc-Inc0) 0 sind(Inc-Inc0);0 1 0;-sind(Inc-Inc0) 0 cosd(Inc-Inc0)];
      
    % Compute the Glenoid Projection
    % Compute Force Diretion In Glenoid Ref & Noramilze
    v = ((BLDATA.Current_Matrices_L2A.Rs*BLDATA.Initial_Matrices_L2A.Rs'*DYDATA.Cone_Rb)'*FDATA.JointReact(1,1:3)')';
    % v = ((BLDATA.Current_Matrices_L2A.Rs*BLDATA.Initial_Matrices_L2A.Rs'*New_Cone_Rb)'*FDATA.JointReact(1,1:3)')';
    % v = (R_opt'*v')'; % define the v in the rotated fossa according to the subject-specific data
    v = v/norm(v);
    
    % Center of Glenoid with respect to GH joint
    C = DYDATA.Cone_Rb'*DYDATA.ConeCentre; % this point is the same in the rotated frame as well, it's on the negative x axis anyway
    
    % To obtain the projection onto the glenoid, Line-Plane Intersection
    %
    % Equation To Solve : d * m = C + a * n1 + b * n2
    %
    % The idea is to find a and b which are the coordinates of the
    % projection onto the glenoid plane
    m = v;
    n1 = [0; 1; 0];
    n2 = [0; 0; 1];
    
    % Compute & Save the Projection of the Reaction Force Direction
    JRDATA(TimeId, 5:7) = (inv([-m', n1, n2])*(-C))';
    
    % Define the stability ratio
        % define the stability ratio 1 (-1 1) --> it distinguishes between points
        % on the boundary even
        % alpha_IS = atan(DYDATA.ConeDimensions(1,2)/norm(DYDATA.ConeCentre));
        % alpha_PA = atan(DYDATA.ConeDimensions(1,1)/norm(DYDATA.ConeCentre));
        % alpha_is = atan(JRDATA(TimeId,7)/norm(DYDATA.ConeCentre));
        % alpha_pa = atan(JRDATA(TimeId,6)/norm(DYDATA.ConeCentre));
        % JRDATA(TimeId, 8) = 1-((alpha_is/alpha_IS)^2 + (alpha_pa/alpha_PA)^2);

    % define the stability ratio 2 (0 1) --> all the points on the boundary
    % have 0 stability ratio here
        JRDATA(TimeId, 8) = 1-((JRDATA(TimeId,7)/DYDATA.ConeDimensions(1,2))^2 + (JRDATA(TimeId,6)/DYDATA.ConeDimensions(1,1))^2);

    % Save the Muscle Forces
    valueId = 1;
    for MuscleId = 1:44
        % Save the Scapulothoracic data
        if MuscleId < 3
            EFDATA{MuscleId, 1}.Forces(TimeId,1) = FDATA.Force(valueId, 1);
            EFDATA{MuscleId, 1}.ForcesMax(TimeId,1) = FDATA.ForceMax(valueId, 1);
            valueId = valueId + 1;
        else
            for SegmentId = 1:MWDATA{MuscleId-2, 1}.MSCInfo.NbSegments
                EFDATA{MuscleId, 1}.Forces(TimeId,SegmentId) = FDATA.Force(valueId, 1);
                EFDATA{MuscleId, 1}.ForcesMax(TimeId,SegmentId) = FDATA.ForceMax(valueId, 1);
                MADATA{MuscleId-2, 1}.MomentArms{1,SegmentId}(TimeId, :) = Wmat(:,valueId-2)';
                MADATA{MuscleId-2, 1}.FDirection{1,SegmentId}(TimeId, :) = Dmat(:,valueId-2)';
                MADATA{MuscleId-2, 1}.MuscleLength(TimeId,SegmentId) = Lmat(MuscleId-2, SegmentId);
                MADATA{MuscleId-2, 1}.ScapularPlane_GnP{1,SegmentId}(TimeId, :) = [Wmat(1:6,valueId-2); BLDATA.Current_GnP.Rs'*Wmat(7:9,valueId-2); Wmat(10:15,valueId-2)]';
                MADATA{MuscleId-2, 1}.ScapularPlane{1,SegmentId}(TimeId, :) = [Wmat(1:6,valueId-2); BLDATA.Current_Matrices_L2A.Rs'*Wmat(7:9,valueId-2); Wmat(10:15,valueId-2)]';
                valueId = valueId + 1;
            end
        end
    end
end

% to give an annouce to the user about the performance of the load-sharing
EFDATA{45, 1} = Exit_flag;
 
return;