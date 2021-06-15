function MADATA = MOMENT_ARM_TOOL_compute_all(MWDATA, BLDATA, KEDATA, WBHandle, SSDATA)
%{
Computes all the muscle moment-arms using both methods
--------------------------------------------------------------------------
Syntax :
MDATA = MOMENT_ARM_TOOL_compute_all(MWDATA, BLDATA, KEDATA, WBHandle)
--------------------------------------------------------------------------
Function Description :
This function computes the moment arms of all the muscle segments using
both the geometric method and the tendon excursion method. Note that the
moment arm calculated here includes only the matrix C of page 86 of the
thesis. In other world, it's not the generalized moment arm matrix (W*C).
The muscle lengths, and the moment arms computed in the scapular plane are
included in the function's outputs. The scapular plane means the body-fixed
frame attached to the scapula. The scapular plane is defined according 
to both the Garner's definition and the ISB convention (Rs). The function
also gives a matrix consisting of the unit vectors of the forces acting on
different bodies. It's a 15xnumber of segments matrix. Its 7-8th rows
includes the direction of the forces acting on the humerus.

The Output Data Structure is defined as follows
  MADATA{MuscleId,1}.MomentArms
  MADATA{MuscleId,1}.FDirection
  MADATA{MuscleId,1}.ScapularPlane_GnP
  MADATA{MuscleId,1}.ScapularPlane

--------------------------------------------------------------------------
%}
% Initialise the MADATA structure
MADATA = cell(42, 1);

% Each element in the cell will contain an N x 15 matrix
for MuscleId = 1:42
    MADATA{MuscleId, 1}.MomentArms    = cell(1,20);
    MADATA{MuscleId, 1}.MomentArmsNum = cell(1,20);
    MADATA{MuscleId, 1}.FDirection    = cell(1,20);
    MADATA{MuscleId, 1}.ScapularPlane_GnP = cell(1,20);
    MADATA{MuscleId, 1}.ScapularPlane = cell(1,20);
    for SegmentId = 1:20
        MADATA{MuscleId, 1}.MomentArms{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
        MADATA{MuscleId, 1}.MomentArmsNum{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
        MADATA{MuscleId, 1}.FDirection{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
        MADATA{MuscleId, 1}.MuscleLength(:,SegmentId) = zeros(size(KEDATA.Joint_Angle_Evolution,2),1);
        MADATA{MuscleId, 1}.ScapularPlane_GnP{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
        MADATA{MuscleId, 1}.ScapularPlane {1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
    end
end


%--------------------------------------------------------------------------
% Define Angles, Velocities, & Accelerations
%--------------------------------------------------------------------------
% first chose among the two available options for the kinematics

if isfield(SSDATA, 'Joint_Angle_Reconstruction')
    % Create the Time
    % t = linspace(0,ESTDATA.Tmax,size(KEDATA.Joint_Angle_Evolution,2));
    % Pre-Define the Joint Angles, Velocities, and Accelerations
    JEA = SSDATA.Joint_Angle_Reconstruction;
%     dJEAdt = [];
%     d2JEAdt2 = []; 
%     for TimeId = 1:size(t,2)-1
%         % Velocity
%         dJEAdt = [dJEAdt, (JEA(:,TimeId+1) - JEA(:,TimeId))/(t(TimeId+1) - t(TimeId))];
%     
%         if TimeId < size(t,2)-1
%             % Acceleration
%             d2JEAdt2 = [d2JEAdt2, (JEA(:,TimeId+2) - 2*JEA(:,TimeId+1) + JEA(:,TimeId))/((t(TimeId+2) - t(TimeId+1))*(t(TimeId+1) - t(TimeId)))];
%         end
%     end
else
    % option 1: use the joint angles acieved directly from the IK
    JEA = KEDATA.Joint_Angle_Evolution;
%     t = linspace(0,ESTDATA.Tmax,length(SSDATA.Joint_Angle_Reconstruction));
%     dJEAdt = [];
%     d2JEAdt2 = [];
%     for TimeId = 1:length(t)-1
%         dJEAdt = [dJEAdt, (JEA(:,TimeId+1) - JEA(:,TimeId))/(t(TimeId+1) - t(TimeId))];
%         if TimeId < length(t)-1
%             % Acceleration
%             d2JEAdt2 = [d2JEAdt2, (JEA(:,TimeId+2) - 2*JEA(:,TimeId+1) + JEA(:,TimeId))/((t(TimeId+2) - t(TimeId+1))*(t(TimeId+1) - t(TimeId)))];
%         end
%     end
%     
%     % the clavicle axial rotation is always noisy
%     dJEAdt(1,:) = polyval(SSDATA.Joint_Velocity_Coefficients(1, :), t(1, 1:end-1));
% 	d2JEAdt2(1,:) = polyval(SSDATA.Joint_Acceleration_Coefficients(1, :), t(1, 1:end-2));
    
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
% Run through all the motion
%--------------------------------------------------------------------------
for TimeId = 1:size(JEA,2)
    waitbar(TimeId/size(JEA,2), WBHandle);
    
    % Display
    disp(['Computing All Moment-Arms, Time Stamp : ', num2str(TimeId), '/', num2str(size(JEA,2))]);
    
    % Get the Current Rotation Matrices
    Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles', JEA(:,TimeId), BLDATA);
    
    % Update the current configuration
    BLDATA = MAIN_TOOL_geometry_functions(...
        'Update Current Bony Landmark Data from Joint Rotation Matrices', Rmat(:,1:3), Rmat(:,4:6), Rmat(:,7:9), Rmat(:,10:12), Rmat(:,13:15), BLDATA);
    
    % Pre-define data matrices
    Wmat = [];      % moment arm using geometrical method
    Wmatnum = [];   % moment arm using tendon excursion
    Dmat = [];      % used to be the direction of the forces acting on the humerus. But, it's now a 15xnumber of segments force direction matrix.
    Lmat = [];      % muscle length
    
    % Run through all the muscles and their segments
    for MuscleId = 1:42
        for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
            %----------------------------------------------------------------------
            % MOMENT ARMS: GEOMETRIC METHOD FOR EACH MUSCLE
            %----------------------------------------------------------------------
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
            
            % Fill The matrix
            Wmat = [Wmat, MAi];
            
            %----------------------------------------------------------------------
            % MUSCLE LENGTH & GH JOINT FORCE DIRECTIONS
            %----------------------------------------------------------------------
            % Fill The Length
            Lmat = [Lmat, 1.e-3*WRDATA.PathLength];
            
            %{
            This part here is not useful anymore. Because, we did some
            modifications in the MOMENT_ARM_TOOL_compute_moment_arms that
            results in a 15x1 unit direction vector for the forces. The
            forces acting on the humerus have been already stored in rows
            (7-9) of this vector.
            %Compute the force directions applied to the humerus
            if WRDATA.PathRefList(1,end) == 3
                % Augment the force direction vector
                Dmat = [Dmat, DVi];
            else
                Dmat = [Dmat, zeros(3,1)];
            end
            %}
            Dmat = [Dmat, DVi]; % a 15xnumber of segments force direction matrix
            
            %----------------------------------------------------------------------
            % MOMENT ARMS : NUMERIC METHOD
            %----------------------------------------------------------------------
            % To find the moment arm matrix using the tendon excursion
            % method one needs to first find the dl/dq that is the
            % variation of the length with respect to the variation of the
            % generalized coordinates. Then having defined dW/ddq
            % (projection matrix), the moment arm (C) can be found by solving
            % dW/ddq * C = dl/dq. Therefore, C = (dW/ddq) \ (dl/dq).
            
            % Initialise
            MAit = zeros(11,1); % dl/dq
            
            % Joint Angle Variations Vector.
            JEA_Variation = zeros(11,1);
            
            % List of small angle changes
            dJEA = [1.e-6, -1.e-6, 1.e-6, 1.e-6, -1.e-6, 1.e-6, 1.e-6, -1.e-6, 1.e-6, -1.e-6, 1.e-6];
            for AngleId = 1:11
                JEA_Variation(AngleId,1) = dJEA(AngleId);
                
                % Get the Current Rotation Matrices with small variation
                Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles', [JEA(:,TimeId)+JEA_Variation], BLDATA);
                
                % Update the current configuration
                BLDATA = MAIN_TOOL_geometry_functions(...
                    'Update Current Bony Landmark Data from Joint Rotation Matrices', Rmat(:,1:3), Rmat(:,4:6), Rmat(:,7:9), Rmat(:,10:12), Rmat(:,13:15), BLDATA);
                
                % Compute the Wrapping with updated bony landmark positions
                WRDATAi = MUSCLE_TOOL_compute_wrapping(BLDATA, Muscle_Seg);
                
                % Compute the length derivative
                MAit(AngleId,1) = -1.e-3*(WRDATAi.PathLength - WRDATA.PathLength)/dJEA(AngleId);
                
                % Reset BLDATA to the actual current values (without small variation)
                Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles', JEA(:,TimeId), BLDATA);
                BLDATA = MAIN_TOOL_geometry_functions(...
                    'Update Current Bony Landmark Data from Joint Rotation Matrices', Rmat(:,1:3), Rmat(:,4:6), Rmat(:,7:9), Rmat(:,10:12), Rmat(:,13:15), BLDATA);
                
                % Reset the variation to zero
                JEA_Variation(AngleId,1) = 0;
            end
            
            % Compute the projection matrices
            TPmat = MOMENT_ARM_TOOL_projection_matrices(JEA(:,TimeId)'); % 11 x 15
            
            % Fill the matrix
            Wmatnum = [Wmatnum, TPmat\MAit]; % 15 x 1
        end
    end
    Rss = [cos(pi/6), -sin(pi/6), 0;
           sin(pi/6),  cos(pi/6), 0;
                   0,          0, 1];
    %----------------------------------------------------------------------
    % SAVE DATA FOR ITH TIME STEP
    %---------------------------------------------------------------------- 
    valueId = 1;
    for MuscleId = 1:42
        for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
            MADATA{MuscleId, 1}.MomentArms{1,SegmentId}(TimeId, :) = Wmat(:,valueId)';
            MADATA{MuscleId, 1}.MomentArmsNum{1,SegmentId}(TimeId, :) = Wmatnum(:,valueId)';
            MADATA{MuscleId, 1}.FDirection{1,SegmentId}(TimeId, :) = Dmat(:,valueId)';
            MADATA{MuscleId, 1}.MuscleLength(TimeId,SegmentId) = Lmat(1, valueId);
            MADATA{MuscleId, 1}.ScapularPlane_GnP{1,SegmentId}(TimeId, :) = [Wmat(1:6,valueId); BLDATA.Current_GnP.Rs'*Wmat(7:9,valueId); Wmat(10:15,valueId)]';
            MADATA{MuscleId, 1}.ScapularPlane{1,SegmentId}(TimeId, :) = [Wmat(1:6,valueId); BLDATA.Current_Matrices_L2A.Rs'*Wmat(7:9,valueId); Wmat(10:15,valueId)]';
            valueId = valueId + 1;
        end
    end
end

return;