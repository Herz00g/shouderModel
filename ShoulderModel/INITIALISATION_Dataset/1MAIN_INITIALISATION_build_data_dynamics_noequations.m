function DYDATA = 1MAIN_INITIALISATION_build_data_dynamics_noequations(REDATA, BLDATA)
% Function for initialising the dynamic data structure only without equa.
%--------------------------------------------------------------------------
% Syntax :
% DYDATA = MAIN_INITIALISATION_build_data_dynamics_noequations(REDATA, BLDATA)
%--------------------------------------------------------------------------
%{
The same file as MAIN_INITIALISATION_build_data_dynamics but it does not
calculate the equations of motion.
It just:
        - gives the numerical values already stored in BLDATA.Original_Points 
          to the aforesaid 10 landmarks and save them in DYDATA.
        - gives associated numerical values to mass, moment of inertia,
          rib-cage ellipsoides adn save them in DYDATA.
        - the associated numerical values of q, dq, and ddq will be defined 
          later on in the force estimation files and will be saved in 
          DYDATA.JEA, DYDATA.dJEAdt, and DYDATA.d2JEAdt2.
        - defines the data related to the GHJ stability cone and saves them
          in the DYDATA (this data is a bit of different from the one of 
          MAIN_INITIALISATION_build_data_dynamics).
%}

%--------------------------------------------------------------------------

% Initialise the output
DYDATA = [];

%--------------------------------------------------------------------------
% CONSTRUCT THE DYDATA STRUCTURE
%--------------------------------------------------------------------------
%{
To define the position of the bony landmarks in their local coordinates
accroding to the description given in begining of the current function
(MAIN_INITIALISATION_build_data_dynamics).
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
DYDATA.CP = BLDATA.Original_Matrices_L2A.Ru'*(BLDATA.Original_Points.CP - BLDATA.Original_Points.HU);
DYDATA.RS = BLDATA.Original_Matrices_L2A.Rr'*(BLDATA.Original_Points.RS - BLDATA.Original_Points.CP);

% Ribcage Ellipsoid Data for scapulothoracic constraints
DYDATA.OE = REDATA.Centre;
DYDATA.AE = [REDATA.TSaxes, REDATA.AIaxes];

% Mass Parameters
Mc = 0.156;
Ms = 0.704;
Mh = 2.052;  % The body weight of our male subject is Mh*100/2.4 (=85.5 Kg) according to R. Dumas 
M_u = 0.9012; % not in the paper by Breteler but close to "A multibody biomechanical model of the upper limb including the shoulder girdle"
Mr = 0.5523; % not in the paper by Breteler "

DYDATA.MHand = 0;% The Radius mass can also contain a weight carried in the hand.
DYDATA.LHand = 0;% The inertia will be MHand*LHand^2, the position from CP;

% Gravitational Constant
g = 9.81;

% Inertia Parameters
Ict = 0.001; Icl = 0.003; % from before, but I do not like them as they are not consistent with the other segments values or the portugease paper
Ist = 0.007; Isl = 0.007; % the same as above
Iht = 0.0165; Ihl = 0.0033; % these values are quite different that what it was before.
Iut = 0.0060; Iul = 9.6437e-04; % defined using the SUBJECT_TOOL_Update_Weight by giving 85.5kg and 1.86 m, and the values are comparable to those of Portugease
Irt = 0.0037; Irl = 5.9107e-04; % the same as above

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
% Cone Scaling Factor
Pf = 1;

% Cone Base Dimensions
Hay = 0.0108*Pf;
Haz = 0.0142*Pf;

% Set the Cone Dimensions
DYDATA.ConeDimensions = [Hay, Haz];

% Cone Base Center (In Thorax Reference System)
DYDATA.ConeCentre = [-21.630343; -12.295269; -3.156106]/1000;

% The Glenohumeral joint center is defined to be to tip of the cone with
% the X-axis running from the GH joint center to the Cone Base center
GH = [0; 0; 0];

% Compute Reference Frame of Cone Base
Xaxis = GH - DYDATA.ConeCentre; Xaxis = Xaxis/norm(Xaxis);
Zaxis = [0; 0; 1]; Zaxis = Zaxis/norm(Zaxis);
Yaxis = cross(Zaxis, Xaxis); Yaxis = Yaxis/norm(Yaxis);
Zaxis = cross(Xaxis, Yaxis); Zaxis = Zaxis/norm(Zaxis);

% Construct the Rotation Matrix
DYDATA.Cone_Rb = [Xaxis, Yaxis, Zaxis];

% Number of cutting planes representing the cone
DYDATA.NbConstraints = 40;
return;