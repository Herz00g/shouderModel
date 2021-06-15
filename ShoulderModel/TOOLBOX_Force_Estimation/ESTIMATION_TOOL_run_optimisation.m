function FDATA = ESTIMATION_TOOL_run_optimisation(time, ESTDATA, DYDATA, MWDATA, BLDATA, REDATA, SSDATA)
%{
 Function for estiming muscle forces using null-space optimisation
--------------------------------------------------------------------------
Syntax :
FDATA = ESTIMATION_TOOL_run_optimisation(Wmat, Dmat, Lmat, ESTDATA, DYDATA, MWDATA, BLDATA, REDATA)
--------------------------------------------------------------------------


The Output Data Structure is defined as follows
  FDATA.Force = (Nb muscle + 2) x 1
  FDATA.JointForce = 1 x 4
  FDATA.JointReact = 1 x 4
--------------------------------------------------------------------------
%}
% Initialise the Output
FDATA.Force = zeros(size(ESTDATA.Moment_Arm_Matrix,2)+2,1);
FDATA.ForceMax = zeros(size(ESTDATA.Moment_Arm_Matrix,2)+2,1);
FDATA.JointForce = zeros(1,4);

%--------------------------------------------------------------------------
% JOINT TORQUE
%--------------------------------------------------------------------------
% Get the All The Dynamics
%[MDYN, RHS, PHI, dPHIdq, TPmat, ACGh, FDYN] = ESTIMATION_TOOL_get_dynamics(DYDATA, BLDATA);

[MDYN, RHS, PHI, dPHIdq, TPmat, ACGh, ACGu, ACGr, FDYN, FDYN_u, FDYN_r] = ESTIMATION_TOOL_get_dynamics(DYDATA, BLDATA);

% Define the total Joint torque
Jtorque = (MDYN*DYDATA.d2JEAdt2 - RHS);

%--------------------------------------------------------------------------
% SCAPULO THORACIC MOMENT ARMS
%--------------------------------------------------------------------------
% Compute the Scapulo-thoracic moment arms
TS = BLDATA.Current_Points.TS; MA_TS = zeros(15,1);
E_TS = diag([1/REDATA.TSaxes(1)^2; 1/REDATA.TSaxes(2)^2; 1/REDATA.TSaxes(3)^2]);
d_TS = 2*E_TS*(TS - REDATA.Centre); d_TS = d_TS/norm(d_TS);
r_TS = [BLDATA.Current_Points.AC-BLDATA.Current_Points.SC, BLDATA.Current_Points.TS-BLDATA.Current_Points.AC];
MA_TS(1:3,1) = cross(r_TS(:,1),d_TS); MA_TS(4:6,1) = cross(r_TS(:,2), d_TS); 

AI = BLDATA.Current_Points.AI; MA_AI = zeros(15,1);
E_AI = diag([1/REDATA.AIaxes(1)^2; 1/REDATA.AIaxes(2)^2; 1/REDATA.AIaxes(3)^2]);
d_AI = 2*E_AI*(AI - REDATA.Centre); d_AI = d_AI/norm(d_AI);
r_AI = [BLDATA.Current_Points.AC-BLDATA.Current_Points.SC, BLDATA.Current_Points.AI-BLDATA.Current_Points.AC];
MA_AI(1:3,1) = cross(r_AI(:,1),d_TS); MA_AI(4:6,1) = cross(r_AI(:,2), d_AI);

% Define the total Moment Arms Matrix
Wm = [TPmat*MA_TS, TPmat*MA_AI, TPmat*ESTDATA.Moment_Arm_Matrix];
Dm = [zeros(15,2), ESTDATA.Force_Direction_Matrix];

%--------------------------------------------------------------------------
% GLENOID STABILITY CONE
%--------------------------------------------------------------------------
Cmat = ESTIMATION_TOOL_glenoid_cone_make(DYDATA, BLDATA);
     
%--------------------------------------------------------------------------
% COMPUTE MAXIMUM FORCES
%--------------------------------------------------------------------------
% define the upper bounds on muscle forces
% chose whether or not the EMG data is used

if isequal(ESTDATA.EmgOption, 'off')
    % no EMG
    FMAX = ESTIMATION_TOOL_maximum_muscle_forces(ESTDATA, DYDATA, MWDATA);
    
else % use the EMG based bounds
    EMG_muscle_list = {'DANT' 'DMED' 'DPOS' 'TDES' 'TTRA' 'TASE' 'TERM' 'PECT' 'BICL' 'BICS' 'TLOH' 'TLAH' 'BRAC' 'FLCU' 'INFS'};

    EMG_muscle_no = [20 21 22 6 7 8 27 15 33 32 29 31 34 39 24];
    
    time_interp = linspace(0, ESTDATA.Tmax, length(SSDATA.Joint_Angle_Reconstruction));

    % define the confidence interval on the EMG-based forces
    lam_u = 0.7;
    lam_l = 0.3;
    parameters = [1 1 1 1];

    k = 0;
    for MuscleId = 1:42
        if MuscleId == EMG_muscle_no(1, 1)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{1}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 2)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = parameters(1)*lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{2}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 3)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{3}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 4)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{4}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 5)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{5}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 6)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{6}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 7)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{7}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 8)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{8}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 9)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{9}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 10)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{10}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 11)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{11}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 12)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{12}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 13)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{13}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 14)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = parameters(2)*lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{14}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 15)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = 100*lam_u*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{15}), time);
            end    
        else
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMAX(k,1) = MWDATA{MuscleId, 1}.MSCInfo.Fmax;
            end
        end

    end
end

% Add the Scapulothoraci Upper Bounds (These values are guessed)
Fmax = [100; 100; FMAX];    
    
Emi = [1/(1.e-4*0.25)^2; 1/(1.e-4*0.25)^2];

% Build the PCSA weight matrix
for MuscleId = 1:42
    Emj = [];
    for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
        Emj = [Emj; 1/(MWDATA{MuscleId, 1}.MSCInfo.PCSA*MWDATA{MuscleId, 1}.MSCInfo.NbSegments)^2];
    end
    Emi = [Emi; Emj];
end
% Define the Weighting Matrix
Em = diag(Emi);

% Compute initial solution
F0 = Em*Wm'*inv(Wm*Em*Wm')*(Jtorque);
N = null(Wm);
H = 0.5*N'*Em*N;
H = 0.5*(H+H');  % Corrects for Non Symetric Matrix
hk = F0'*Em*N;

% Optimization Constraints
A= []; b = [];

% define the lower bounds on muscle forces
% chose whether or not the EMG data is used

if isequal(ESTDATA.EmgOption, 'off')
    % no EMG
    Fmin = zeros(size(Fmax,1),1);
        
else % use the EMG based bounds
    k = 0;
    for MuscleId = 1:42
        if MuscleId == EMG_muscle_no(1, 1)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{1}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 2)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = parameters(3)*lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{2}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 3)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{3}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 4)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{4}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 5)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{5}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 6)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{6}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 7)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{7}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 8)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{8}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 9)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{9}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 10)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{10}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 11)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{11}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 12)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{12}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 13)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{13}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 14)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = parameters(4)*lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{14}), time);
            end
        elseif MuscleId == EMG_muscle_no(1, 15)
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = lam_l*interp1(time_interp, SSDATA.f_T.(EMG_muscle_list{15}), time);
            end    
        else
            for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
                k = k+1;
                FMIN(k,1) = 0;
            end
        end

    end
    
    Fmin = [0; 0; FMIN];

end

    
if isequal(ESTDATA.RconOption, 'on');
    A = [N; -N; -Cmat*(Dm(7:9,:)+Dm(10:12,:)+Dm(13:15,:))*N];
    b = [Fmax-F0; -Fmin+F0; Cmat*((Dm(7:9,:)+Dm(10:12,:)+Dm(13:15,:))*F0 - FDYN)];
else
    A = [N; -N];
    b = [Fmax-F0; -Fmin+F0];
end

% Initial Condition
% xopt = zeros(size(A,2),1);

% Optimization Options
options = optimset(...
    'Diagnostics','off',...
    'Display', 'off',...
    'LargeScale', 'on',...
    'Algorithm', 'interior-point-convex',...
    'TolX', 1.e-8,...
    'TolFun', 1.e-8,...
    'TolCon', 1.e-8,...
    'MaxFunEval', 10000,...
    'MaxIter', 10000,...
    'UseParallel',true);

% Run the Optimization
[xopt,fval,exitflag] = quadprog(H,hk, A,b, [], [], [], [], [], options);

% Save the Data
FDATA.Force = F0+N*xopt;
FDATA.ForceMax = (F0+N*xopt)./Fmax;
% FDATA.JointReact = [(FDYN - Dm(7:9,:)*FDATA.Force)', norm(FDYN - Dm(7:9,:)*FDATA.Force)];
FDATA.JointReact = [(FDYN - (Dm(7:9,:) + Dm(10:12,:) + Dm(13:15,:))*FDATA.Force)', norm(FDYN - (Dm(7:9,:) + Dm(10:12,:) + Dm(13:15,:))*FDATA.Force)];
FDATA.Exitflag = exitflag;

% HU joint reaction force
FDATA.HUJointReact = [(FDYN_u - (Dm(10:12,:) + Dm(13:15,:))*FDATA.Force)', norm(FDYN_u - (Dm(10:12,:) + Dm(13:15,:))*FDATA.Force)];

% RU joint reaction force
FDATA.RUJointReact = [(FDYN_r - (Dm(13:15,:))*FDATA.Force)', norm(FDYN_r - (Dm(13:15,:))*FDATA.Force)];


% WW = TPmat*ESTDATA.Moment_Arm_Matrix;
% F = FDATA.Force(3:end,1);
% Jtorque(1)
% WW(1, [1,5,6,7,8,9,18,24])
% WW(1, [1,5,6,7,8,9,18,24])*F([1,5,6,7,8,9,18,24],1)
return;