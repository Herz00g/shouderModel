function FDATA = ESTIMATION_TOOL_run_optimisation(ESTDATA, DYDATA, MWDATA, BLDATA, REDATA)
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
[MDYN, RHS, PHI, dPHIdq, TPmat, ACGh, FDYN] = ESTIMATION_TOOL_get_dynamics(DYDATA, BLDATA);

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
FMAX = ESTIMATION_TOOL_maximum_muscle_forces(ESTDATA, DYDATA, MWDATA);

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
Fmin = zeros(size(Fmax,1),1);

% if isequal(ESTDATA.RconOption, 'on');
%     A = [N; -N; -Cmat*(Dm(7:9,:)+Dm(10:12,:)+Dm(13:15,:))*N];
%     b = [Fmax-F0; F0; Cmat*((Dm(7:9,:)+Dm(10:12,:)+Dm(13:15,:))*F0 - FDYN)];
% else
%     A = [N; -N];
%     b = [Fmax-F0; -Fmin+F0];
% end

% Initial Condition
% xopt = zeros(size(A,2),1);

% Optimization Options
options = optimset(...
    'Display', 'off',...
    'Diagnostics', 'off',...
    'LargeScale', 'on',...
    'Algorithm', 'active-set',...
    'TolX', 1.e-8,...
    'TolFun', 1.e-8,...
    'TolCon', 1.e-8,...
    'MaxFunEval', 10000,...
    'MaxIter', 10000);

f1min=0;
f2min=0;


% Run the Optimization
%[xopt,fval,exitflag] = quadprog(H,hk, A,b, [], [], [], [], [], options);%
[xopt, f1min, exitflag] = fmincon(@NL_FOPT,zeros(size(Fmax,1),1),[],[], Wm, Jtorque, zeros(size(Fmax,1),1), Fmax, [], options, Dm, Em, FDYN, BLDATA, DYDATA, Finit, 0, 0,0, Fro);

% Save the Data
% FDATA.Force = F0+N*xopt;
% FDATA.ForceMax = (F0+N*xopt)./Fmax;
% FDATA.JointReact = [(FDYN - Dm(7:9,:)*FDATA.Force)', norm(FDYN - Dm(7:9,:)*FDATA.Force)];
FDATA.Force = xopt;
FDATA.ForceMax = FDATA.Force./Fmax;
FDATA.JointReact = [(FDYN - (Dm(10:12,:) + Dm(7:9,:))*FDATA.Force)', norm(FDYN - (Dm(10:12,:) + Dm(7:9,:))*FDATA.Force)];
Finit = xopt;

% WW = TPmat*ESTDATA.Moment_Arm_Matrix;
% F = FDATA.Force(3:end,1);
% Jtorque(1)
% WW(1, [1,5,6,7,8,9,18,24])
% WW(1, [1,5,6,7,8,9,18,24])*F([1,5,6,7,8,9,18,24],1)
return;













