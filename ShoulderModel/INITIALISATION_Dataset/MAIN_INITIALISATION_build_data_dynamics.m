function DYDATA = MAIN_INITIALISATION_build_data_dynamics(REDATA, BLDATA)
% Function for initialising the dynamic model & data structure
%--------------------------------------------------------------------------
% Syntax :
% DYDATA = MAIN_INITIALISATION_build_data_dynamics(REDATA, BLDATA)
%--------------------------------------------------------------------------
%{
File Description:

This function creates the symbolic equations of motion using Lagrange
method.

It first defines:
        - generalized coordinates.
        - 10 bony landmarks.
        - mass and moment of inertia data.
        - rib-cage ellipsoid data.

Then it computes:
        - the linear acceleration of the centers of mass for
          humerus, ulna, and radius and writes them in
          /TOOLBOX_Force_Estimation/ESTIMATION_TOOL_acceleration_file.m

        - d2L/ddq2 (named 'MDYN') and dL/dq-d2L/dqddq*dq (named
          'RHS') and writes them both, along with 'dq', in
          /TOOLBOX_Force_Estimation/ESTIMATION_TOOL_dynamics_file.m

        - scapulo-thoraic constraints for TS and AI, including
          'PHIts', 'PHIai', 'dPHItsdq', 'dPHIaidq' and writes them in
          /TOOLBOX_Force_Estimation/ESTIMATION_TOOL_constraints_file.m

Then it constructs the DYDATA structure:
        - gives the numerical values already stored in BLDATA.Original_Points 
          to the aforesaid 10 landmarks and save them in DYDATA.
        - gives associated numerical values to mass, moment of inertia,
          rib-cage ellipsoides adn save them in DYDATA.
        - the associated numerical values of q, dq, and ddq will be defined 
          later on in the force estimation files and will be saved in 
          DYDATA.JEA, DYDATA.dJEAdt, and DYDATA.d2JEAdt2.
        - defines the data related to the GHJ stability cone and saves them
          in the DYDATA.
%}
%--------------------------------------------------------------------------

% Initialise the output
DYDATA = [];

%--------------------------------------------------------------------------
% DEFINE THE DYNAMIC VARIABLES
%--------------------------------------------------------------------------
% List of Dynamic Variables
syms xc yc zc dxc dyc dzc real;     % Clavicula joint angles and velocities
syms xs ys zs dxs dys dzs real;     % Scapula joint angles and velocities
syms zh yh zzh dzh dyh dzzh real;   % Humerus joint angles and velocities
syms xu dxu;                        % Ulna joint angle and velocity
syms zr dzr;                        % Radius joint angle and velocity

% joints accelerations
syms ddxc ddyc ddzc ddxs ddys ddzs ddzh ddyh ddzzh ddxu ddzr real;

% Constrained generalised coordinates
q = [xc; yc; zc; xs; ys; zs; zh; yh; zzh; xu; zr];
dq = [dxc; dyc; dzc; dxs; dys; dzs; dzh; dyh; dzzh; dxu; dzr];
ddq = [ddxc; ddyc; ddzc; ddxs; ddys; ddzs; ddzh; ddyh; ddzzh; ddxu; ddzr];

%--------------------------------------------------------------------------
% DEFINE THE STATIC PHYSICAL VARIABLES
%--------------------------------------------------------------------------
% List of Physical Constants. All these points are in local reference frame
syms SCx SCy SCz real;  % Thorax frame
syms ACx ACy ACz real;  % Clavicula frame
syms AAx AAy AAz real;  % Scapula frame 
syms TSx TSy TSz real;  % Scapula frame 
syms AIx AIy AIz real;  % Scapula frame 
syms GHx GHy GHz real;  % Scapula frame
syms HUx HUy HUz real;  % Humerus frame
syms CPx CPy CPz real;  % Ulna frame
syms USx USy USz real;  % Ulna frame
syms RSx RSy RSz real;  % Radius frame

% Ellipsoid data
syms OEx OEy OEz real;
syms Ats Bts Cts real;
syms Aai Bai Cai real;

% Inertial Data
syms Icl Ict real;
syms Isl Ist real;
syms Ihl Iht real;
syms Iul Iut real;
syms Irl Irt real;
syms Mc Ms Mh M_u Mr g real;

% Inertia Matrices
Inc = diag([Icl, Ict, Ict]);
Ins = diag([Isl, Ist, Ist]);
Inh = diag([Iht, Iht, Ihl]);
Inu = diag([Iut, Iut, Iul]);
Inr = diag([Irt, Irt, Irl]);

%--------------------------------------------------------------------------
% Create the Rotation Matrices (local to inertial)
%--------------------------------------------------------------------------
% Clavicula Matrix
Rcx = [1,       0,        0; 
       0, cos(xc), -sin(xc); 
       0, sin(xc),  cos(xc)];

Rcy = [cos(yc), 0, -sin(yc); 
             0, 1, 0; 
       sin(yc), 0,  cos(yc)];
   
Rcz = [cos(zc), -sin(zc), 0; 
       sin(zc),  cos(zc), 0; 
             0,        0, 1];
        
Rc = Rcz*Rcy'*Rcx;

% Scapula Matrix
Rsx = [1,      0,        0; 
       0, cos(xs), -sin(xs); 
       0, sin(xs),  cos(xs)];

Rsy = [cos(ys), 0, -sin(ys); 
             0, 1, 0; 
       sin(ys), 0,  cos(ys)];
   
Rsz = [cos(zs), -sin(zs), 0; 
       sin(zs),  cos(zs), 0; 
             0,        0, 1];
        
Rs = Rsz*Rsy'*Rsx;

% Humerus Matrix
Rhz = [cos(zh), -sin(zh), 0; 
       sin(zh),  cos(zh), 0; 
             0,        0, 1];
         
Rhy = [cos(yh), 0, -sin(yh); 
             0, 1, 0; 
       sin(yh), 0,  cos(yh)];
   
Rhzz = [cos(zzh), -sin(zzh), 0; 
        sin(zzh),  cos(zzh), 0; 
               0,         0, 1];
           
Rh = Rhzz*Rhy'*Rhz;

% Ulna Matrix
% Ruy = [cos(beta), 0, sin(beta); 
%                0, 1, 0; 
%        -sin(beta), 0, cos(beta)]; %beta constant
      
Rux = [1,       0,        0; 
       0, cos(xu), -sin(xu); 
       0, sin(xu),  cos(xu)];% ulna to the proximal segment (humerus)
   
Ru_h = BLDATA.Original_Matrices_L2A.Rh'*BLDATA.Original_Matrices_L2A.Ru;

%Ru_u2h = Rux*Ruy;   % ulna to the proximal segment (humerus)
Ru = Rh*Ru_h*Rux;      % ulna to the inertial frame (thorax)

% Radiu Matrix
Rrz = [cos(zr), -sin(zr), 0; 
       sin(zr),  cos(zr), 0; 
             0,        0, 1]; % radius to the proximal segment (ulna)
         
Rr_u = BLDATA.Original_Matrices_L2A.Ru'*BLDATA.Original_Matrices_L2A.Rr;

Rr = Ru*Rr_u*Rrz;                  % radius to the inertial frame (thorax)

%--------------------------------------------------------------------------
% Compute the locations of the centres of gravity
%--------------------------------------------------------------------------
% Clavicula centre of gravity, midway along the x-axis
CGc = simplify(expand(Rc*(1/2*[ACx; ACy; ACz]) + [SCx; SCy; SCz]));

% Scapula centre of gravity, 1/3 from AC to AI
CGs = simplify(expand(Rs*(1/3*[AIx; AIy; AIz]) + Rc*[ACx; ACy; ACz] + [SCx; SCy; SCz]));

% Humerus centre of gravity
CGh = simplify(expand(Rh*(1/2*[HUx; HUy; HUz]) + Rs*[GHx; GHy; GHz] + Rc*[ACx; ACy; ACz] + [SCx; SCy; SCz]));

% Ulna centre of gravity
CGu = simplify(expand(Ru*(1/2*[USx; USy; USz]) + Rh*[HUx; HUy; HUz] + Rs*[GHx; GHy; GHz] + Rc*[ACx; ACy; ACz] + [SCx; SCy; SCz]));

% Radius centre of gravity
CGr = simplify(expand(Rr*(1/2*[RSx; RSy; RSz]) + Rh*[CPx; CPy; CPz] + Rs*[GHx; GHy; GHz] + Rc*[ACx; ACy; ACz] + [SCx; SCy; SCz]));%Rh*[HUx; HUy; HUz]

%--------------------------------------------------------------------------
% Compute the linear velocities of the centres of gravity
%--------------------------------------------------------------------------
VCGc = simplify(expand(jacobian(CGc, q)*dq));
VCGs = simplify(expand(jacobian(CGs, q)*dq));
VCGh = simplify(expand(jacobian(CGh, q)*dq));
VCGu = simplify(expand(jacobian(CGu, q)*dq));
VCGr = simplify(expand(jacobian(CGr, q)*dq));
%--------------------------------------------------------------------------
% Compute the angular velocities (in local frame)
%--------------------------------------------------------------------------
Wc = Rcx'*Rcy*[0; 0; dzc] + Rcx'*[0; dyc; 0] + [dxc; 0; 0];
Ws = Rsx'*Rsy*[0; 0; dzs] + Rsx'*[0; dys; 0] + [dxs; 0; 0];
Wh = Rhz'*Rhy*[0; 0; dzzh] + Rhz'*[0; dyh; 0] + [0; 0; dzh];
%Wu = Ru_u2h'*Wh + Ruy'*[dxu; 0; 0];
%Wr = Rr_r2u'*Wu + [0; 0; dzr];
Wu = Rux'*Ru_h'*Wh + [dxu; 0; 0];
Wr = Rrz'*Rr_u'*Wu + [0; 0; dzr];

%--------------------------------------------------------------------------
% Compute the angular velocities (in inertial frame)
%--------------------------------------------------------------------------
Wac =  Rcz*Rcy'*[dxc; 0; 0] +  Rcz*[0; dyc; 0] + [0; 0; dzc];%or simply Rc*Wc
Was =  Rsz*Rsy'*[dxs; 0; 0] +  Rsz*[0; dys; 0] + [0; 0; dzs];%or simply Rs*Ws
Wah =  Rhzz*Rhy'*[0; 0; dzh] + Rhzz*[0; dyh; 0] + [0; 0; dzzh];%or simply Rh*Wh
Wau =  Ru*Wu;  
War =  Rr*Wr;

%--------------------------------------------------------------------------
% Linear Accelerations of Humerus, Ulna, and Radius
%--------------------------------------------------------------------------
ACGh = jacobian(VCGh, q)*dq + jacobian(VCGh, dq)*ddq;
ACGu = jacobian(VCGu, q)*dq + jacobian(VCGu, dq)*ddq;
ACGr = jacobian(VCGr, q)*dq + jacobian(VCGr, dq)*ddq;

% Definition of the file name (Differentiate for UNIX & non-UNIX systems)
CurrentPath = pwd;
File_name = [];
if isunix
    File_name = [CurrentPath, '/TOOLBOX_Force_Estimation/ESTIMATION_TOOL_acceleration_file.m'];
else
    File_name = [CurrentPath, '\TOOLBOX_Force_Estimation\ESTIMATION_TOOL_acceleration_file.m'];
end

% List of variables to save
List_of_variables = {'ACGh','ACGu','ACGr'};

% Saving algorithm
fid = fopen(File_name,'wt');
index_equ = 1;
for k = 1:length(List_of_variables)
    Var_name = List_of_variables{k};
    size_var = size(eval(Var_name));
    for i = 1:size_var(1)
        for j = 1:size_var(2)
            Var_name_ij = strcat(Var_name,'(',num2str(i),',',num2str(j),')');
            Equation = strcat(Var_name_ij,' = ',char(eval(Var_name_ij)),';');
            fprintf(fid,'%s \n',Equation);
        end
    end
end
fclose(fid);

%--------------------------------------------------------------------------
% Compute the Lagrangian
%--------------------------------------------------------------------------
Lag = 0.5*Mc*transpose(VCGc)*VCGc + 0.5*transpose(Wc)*Inc*Wc + ...
      0.5*Ms*transpose(VCGs)*VCGs + 0.5*transpose(Ws)*Ins*Ws + ...
      0.5*Mh*transpose(VCGh)*VCGh + 0.5*transpose(Wh)*Inh*Wh + ...
      0.5*M_u*transpose(VCGu)*VCGu + 0.5*transpose(Wu)*Inu*Wu + ...
      0.5*Mr*transpose(VCGr)*VCGr + 0.5*transpose(Wr)*Inr*Wr - ...
      Mc*g*CGc(3) - Ms*g*CGs(3) - Mh*g*CGh(3) - M_u*g*CGu(3) - Mr*g*CGr(3);
  
%--------------------------------------------------------------------------
% Compute the Dynamic (MDYN*ddq=RHS+generalized forces including the constraints)
%--------------------------------------------------------------------------  
% d2L/ddq2
MDYN = jacobian(jacobian(Lag, dq), dq);

% dL/dq-d2L/dqddq*dq (right-hand side of the Lagrange equation)
RHS = transpose(jacobian(Lag, q)) - jacobian(jacobian(Lag, dq), q)*dq;

% Definition of the file name (Differentiate for UNIX & non-UNIX systems)
CurrentPath = pwd;
File_name = [];
if isunix
    File_name = [CurrentPath, '/TOOLBOX_Force_Estimation/ESTIMATION_TOOL_dynamics_file.m'];
else
    File_name = [CurrentPath, '\TOOLBOX_Force_Estimation\ESTIMATION_TOOL_dynamics_file.m'];
end

% List of variables to save
List_of_variables = {'dq', 'MDYN', 'RHS'};

% Saving algorithm
fid = fopen(File_name,'wt');
index_equ = 1;
for k = 1:length(List_of_variables)
    Var_name = List_of_variables{k};
    size_var = size(eval(Var_name));
    for i = 1:size_var(1)
        for j = 1:size_var(2)
            Var_name_ij = strcat(Var_name,'(',num2str(i),',',num2str(j),')');
            Equation = strcat(Var_name_ij,' = ',char(eval(Var_name_ij)),';');
            fprintf(fid,'%s \n',Equation);
        end
    end
end
fclose(fid);

%--------------------------------------------------------------------------
% Define the Scapulo-Thoracic Gliding Plane Constraints
%--------------------------------------------------------------------------
% Constraint Number 1
TS = Rs*([TSx; TSy; TSz]) + Rc*[ACx; ACy; ACz] + [SCx; SCy; SCz];
PHIts = (TS - [OEx; OEy; OEz])'*diag([1/Ats^2; 1/Bts^2; 1/Cts^2])*(TS - [OEx; OEy; OEz]) - 1;

% Jacobian
dPHItsdq = jacobian(PHIts, q);

dPHItsdt = dPHItsdq*dq; % for inverse kinematics

ddPHItsdt = jacobian(dPHItsdt, q)*dq + jacobian(dPHItsdt, dq)*ddq; % for inverse kinematics



% Constraint Number 2
AI = Rs*([AIx; AIy; AIz]) + Rc*[ACx; ACy; ACz] + [SCx; SCy; SCz];
PHIai = (AI - [OEx; OEy; OEz])'*diag([1/Aai^2; 1/Bai^2; 1/Cai^2])*(AI - [OEx; OEy; OEz]) - 1;

% Jacobian
dPHIaidq = jacobian(PHIai, q);

dPHIaidt = dPHIaidq*dq; % for inverse kinematics

ddPHIaidt = jacobian(dPHIaidt, q)*dq + jacobian(dPHIaidt, dq)*ddq; % for inverse kinematics

% Definition of the file name (Differentiate for UNIX & non-UNIX systems)
CurrentPath = pwd;
File_name = [];
if isunix
    File_name = [CurrentPath, '/TOOLBOX_Force_Estimation/ESTIMATION_TOOL_constraints_file.m'];
else
    File_name = [CurrentPath, '\TOOLBOX_Force_Estimation\ESTIMATION_TOOL_constraints_file.m'];
end

% List of variables to save
List_of_variables = {'PHIts', 'PHIai', 'dPHItsdq', 'dPHIaidq', 'dPHItsdt', 'dPHIaidt', 'ddPHItsdt', 'ddPHIaidt'};

% Saving algorithm
fid = fopen(File_name,'wt');
index_equ = 1;
for k = 1:length(List_of_variables)
    Var_name = List_of_variables{k};
    size_var = size(eval(Var_name));
    for i = 1:size_var(1)
        for j = 1:size_var(2)
            Var_name_ij = strcat(Var_name,'(',num2str(i),',',num2str(j),')');
            Equation = strcat(Var_name_ij,' = ',char(eval(Var_name_ij)),';');
            fprintf(fid,'%s \n',Equation);
        end
    end
end
fclose(fid);

%--------------------------------------------------------------------------
% CONSTRUCT THE DYDATA STRUCTURE
%--------------------------------------------------------------------------
%{
To define the position of the bony landmarks in their local coordinates
accroding to the description given in begining of the current function.
It's just needed to have the data in one configuration. The only one we
have so far is the original data.
BLDATA.Original_Points: contains the position of the bony landmarks in
the inertial frame.
BLDATA.Original_Matrices_L2A: contains the rotation matrix from local to
inertial coordinate.
%}
DYDATA.SC = BLDATA.Original_Points.SC;
DYDATA.AC = BLDATA.Original_Matrices_L2A.Rc'*(BLDATA.Original_Points.AC - BLDATA.Original_Points.SC);
DYDATA.AA = BLDATA.Original_Matrices_L2A.Rs'*(BLDATA.Original_Points.AA - BLDATA.Original_Points.AC);
DYDATA.TS = BLDATA.Original_Matrices_L2A.Rs'*(BLDATA.Original_Points.TS - BLDATA.Original_Points.AC);
DYDATA.AI = BLDATA.Original_Matrices_L2A.Rs'*(BLDATA.Original_Points.AI - BLDATA.Original_Points.AC);
DYDATA.GH = BLDATA.Original_Matrices_L2A.Rs'*(BLDATA.Original_Points.GH - BLDATA.Original_Points.AC);
DYDATA.HU = BLDATA.Original_Matrices_L2A.Rh'*(BLDATA.Original_Points.HU - BLDATA.Original_Points.GH);
DYDATA.US = BLDATA.Original_Matrices_L2A.Ru'*(BLDATA.Original_Points.US - BLDATA.Original_Points.HU);
DYDATA.CP = BLDATA.Original_Matrices_L2A.Rh'*(BLDATA.Original_Points.CP - BLDATA.Original_Points.GH);
DYDATA.RS = BLDATA.Original_Matrices_L2A.Rr'*(BLDATA.Original_Points.RS - BLDATA.Original_Points.CP);

% Ribcage Ellipsoid Data for scapulothoracic constraints
DYDATA.OE = REDATA.Centre;
DYDATA.AE = [REDATA.TSaxes, REDATA.AIaxes];

% the mass and moment of inertia for the generic model are from
% M.D. Klein Breteler et al., Journal of Biomechanics 32 (1999) 1191.
% The body weight is not mentioned in this paper so I approximated it using
% the R. Dumas et al., Journal of Biomechanics 40 (2007) 543?553.

% Mass Parameters [Kg]
Mc = 0.156;
Ms = 0.704;
Mh = 2.052;  % The body weight of our male subject is Mh*100/2.4 (=85.5 Kg) according to R. Dumas 
M_u = 0.9012; % not in the paper by Breteler but close to "A multibody biomechanical model of the upper limb including the shoulder girdle"
Mr = 0.5523; % not in the paper by Breteler "


% Inertia Parameters [Kg M^2]
Ict = 0.001; Icl = 0.003; % from before, but I do not like them as they are not consistent with the other segments values or the portugease paper
Ist = 0.007; Isl = 0.007; % the same as above
Iht = 0.0165; Ihl = 0.0033; % these values are quite different that what it was before.
Iut = 0.0060; Iul = 9.6437e-04; % defined using the SUBJECT_TOOL_Update_Weight by giving 85.5kg and 1.86 m, and the values are comparable to those of Portugease
Irt = 0.0037; Irl = 5.9107e-04; % the same as above

DYDATA.MHand = 0;% The Radius mass can also contain a weight carried in the hand.
DYDATA.LHand = 270e-3;% The inertia will be MHand*LHand^2, the position from CP;

% Gravitational Constant
g = 9.81;

% ATTENTION!! One needs to apply the parallel axis theorem to be correct.
%Iht = 1.32 + 0.612 + 0.064;
% This works, all axes are colinear
%Ihl = 0.199 + 0.091 + 0.019;

% Inertia Data
DYDATA.Inertia = [Mc, Ms, Mh, M_u, Mr;
                  Ict, Icl, 0 ,0 ,0;
                  Ist, Isl, 0 ,0 ,0;
                  Iht, Ihl, 0 ,0 ,0;
                  Iut, Iul, 0 ,0 ,0;
                  Irt, Irl, 0 ,0 ,0;
                    g,   0, 0 ,0 ,0];

%--------------------------------------------------------------------------
% GLENOID STABILITY CONE PARAMETERS
%--------------------------------------------------------------------------
% Cone Base Dimensions
Hay = 0.0119;%0.0108;%
Haz = 0.0156;%0.0142;%

% Set the Cone Dimensions
DYDATA.ConeDimensions = [Hay, Haz];

% Cone Base Center 
% (In Thorax Reference System with respect to the point GH)
% DYDATA.ConeCentre = [-13.8065; -15.4992; -2.4582]/1000;%[-21.630343; -12.295269; -3.156106]/1000;%
DYDATA.ConeCentre = (BLDATA.Original_Points.GC - BLDATA.Original_Points.GH)/1000;
%GI -7:
%DYDATA.ConeCentre =[-18.5596; -16.1417; 4.9769]/1000;

% GI 2: 
%DYDATA.ConeCentre = [-18.3432; -17.0867; 1.1618]/1000;

%GI 5.9:
%DYDATA.ConeCentre = [-18.1117; -17.3634; -0.5103]/1000;
 
% GI 15: 
%DYDATA.ConeCentre = [-17.2585; -17.6842; -4.3810]/1000;

% The Glenohumeral joint center is defined to be to tip of the cone with
% the X-axis running from the Cone Base center to GH joint center
GH = [0; 0; 0];

% Compute Reference Frame of Cone Base
Xaxis = GH - DYDATA.ConeCentre; Xaxis = Xaxis/norm(Xaxis);
Zaxis = [0; 0; 1]; Zaxis = Zaxis/norm(Zaxis);
Yaxis = cross(Zaxis, Xaxis); Yaxis = Yaxis/norm(Yaxis);
Zaxis = cross(Xaxis, Yaxis); Zaxis = Zaxis/norm(Zaxis);

% Construct the Rotation Matrix
DYDATA.Cone_Rb = [Xaxis, Yaxis, Zaxis]; % local ---> global (from glenoid frame to the frame attached to the GH, g to GH)

% Number of cutting planes representing the cone
DYDATA.NbConstraints = 40;
return;