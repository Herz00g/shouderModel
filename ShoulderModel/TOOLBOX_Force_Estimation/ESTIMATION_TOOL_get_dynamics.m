function [MDYN, RHS, PHI, dPHIdq, TPmat, ACGh, ACGu, ACGr, FDYN, FDYN_u, FDYN_r] = ESTIMATION_TOOL_get_dynamics(DYDATA,BLDATA)

% Get the Joint Angles
xc = DYDATA.JEA(1,1);
yc = DYDATA.JEA(2,1);
zc = DYDATA.JEA(3,1);
xs = DYDATA.JEA(4,1); 
ys = DYDATA.JEA(5,1);
zs = DYDATA.JEA(6,1);
zh = DYDATA.JEA(7,1); 
yh = DYDATA.JEA(8,1); 
zzh = DYDATA.JEA(9,1);
xu = DYDATA.JEA(10,1);
zr = DYDATA.JEA(11,1);

% Get the Joint Angular Velocities
dxc = DYDATA.dJEAdt(1,1);
dyc = DYDATA.dJEAdt(2,1);
dzc = DYDATA.dJEAdt(3,1);
dxs = DYDATA.dJEAdt(4,1); 
dys = DYDATA.dJEAdt(5,1);
dzs = DYDATA.dJEAdt(6,1);
dzh = DYDATA.dJEAdt(7,1); 
dyh = DYDATA.dJEAdt(8,1); 
dzzh = DYDATA.dJEAdt(9,1);
dxu = DYDATA.dJEAdt(10,1);
dzr = DYDATA.dJEAdt(11,1);

% Get the Joint Angular Accelerations
ddxc = DYDATA.d2JEAdt2(1,1);
ddyc = DYDATA.d2JEAdt2(2,1);
ddzc = DYDATA.d2JEAdt2(3,1);
ddxs = DYDATA.d2JEAdt2(4,1); 
ddys = DYDATA.d2JEAdt2(5,1);
ddzs = DYDATA.d2JEAdt2(6,1);
ddzh = DYDATA.d2JEAdt2(7,1); 
ddyh = DYDATA.d2JEAdt2(8,1); 
ddzzh = DYDATA.d2JEAdt2(9,1);
ddxu = DYDATA.d2JEAdt2(10,1);
ddzr = DYDATA.d2JEAdt2(11,1);

% Convert all to meters
SCx = DYDATA.SC(1)/1000; SCy = DYDATA.SC(2)/1000; SCz = DYDATA.SC(3)/1000;
ACx = DYDATA.AC(1)/1000; ACy = DYDATA.AC(2)/1000; ACz = DYDATA.AC(3)/1000;
AAx = DYDATA.AA(1)/1000; AAy = DYDATA.AA(2)/1000; AAz = DYDATA.AA(3)/1000;
TSx = DYDATA.TS(1)/1000; TSy = DYDATA.TS(2)/1000; TSz = DYDATA.TS(3)/1000;
AIx = DYDATA.AI(1)/1000; AIy = DYDATA.AI(2)/1000; AIz = DYDATA.AI(3)/1000;
GHx = DYDATA.GH(1)/1000; GHy = DYDATA.GH(2)/1000; GHz = DYDATA.GH(3)/1000;
HUx = DYDATA.HU(1)/1000; HUy = DYDATA.HU(2)/1000; HUz = DYDATA.HU(3)/1000;
USx = DYDATA.US(1)/1000; USy = DYDATA.US(2)/1000; USz = DYDATA.US(3)/1000;
CPx = DYDATA.CP(1)/1000; CPy = DYDATA.CP(2)/1000; CPz = DYDATA.CP(3)/1000;
RSx = DYDATA.RS(1)/1000; RSy = DYDATA.RS(2)/1000; RSz = DYDATA.RS(3)/1000;
OEx = DYDATA.OE(1)/1000; OEy = DYDATA.OE(2)/1000; OEz = DYDATA.OE(3)/1000;
Ats = DYDATA.AE(1,1)/1000; Bts = DYDATA.AE(2,1)/1000; Cts = DYDATA.AE(3,1)/1000;
Aai = DYDATA.AE(1,2)/1000; Bai = DYDATA.AE(2,2)/1000; Cai = DYDATA.AE(3,2)/1000;

% Earth's Gravitational Constant
g = DYDATA.Inertia(7,1);

Mc = DYDATA.Inertia(1,1);
Ms = DYDATA.Inertia(1,2);
Mh = DYDATA.Inertia(1,3);
M_u = DYDATA.Inertia(1,4);
Mr = DYDATA.Inertia(1,5) + DYDATA.MHand; % plus the weight carried in hand

Ict = DYDATA.Inertia(2,1); Icl = DYDATA.Inertia(2,2);
Ist = DYDATA.Inertia(3,1); Isl = DYDATA.Inertia(3,2);
Iht = DYDATA.Inertia(4,1); Ihl = DYDATA.Inertia(4,2);
Iut = DYDATA.Inertia(5,1); Iul = DYDATA.Inertia(5,2);

% Radius inertia with correction due to the weight in carried in hand
Irt = DYDATA.Inertia(6,1) + DYDATA.MHand*DYDATA.LHand^2; 
Irl = DYDATA.Inertia(6,2) + DYDATA.MHand*(2.5e-2)^2;

% Load the constraints and dynamics
ESTIMATION_TOOL_constraints_file;
ESTIMATION_TOOL_dynamics_file;
ESTIMATION_TOOL_acceleration_file;

PHI = [PHIts; PHIai];
dPHIdq = [dPHItsdq', dPHIaidq'];

% Projection Matrices
Pc = [cos(zc)*cos(yc), -sin(zc), 0;
      sin(zc)*cos(yc),  cos(zc), 0;
             -sin(yc),        0, 1];
           
Ps = [cos(zs)*cos(ys), -sin(zs), 0;
      sin(zs)*cos(ys),  cos(zs), 0;
             -sin(ys),        0, 1];
           
Ph = [cos(zzh)*sin(yh), -sin(zzh), 0;
      sin(zzh)*sin(yh),  cos(zzh), 0;
               cos(yh),         0, 1];

Rhz = [cos(zh), -sin(zh), 0; 
       sin(zh),  cos(zh), 0; 
             0,        0, 1];
         
Rhy = [cos(yh), 0, -sin(yh); 
             0, 1, 0; 
       sin(yh), 0,  cos(yh)];
   
Rhzz = [cos(zzh), -sin(zzh), 0; 
        sin(zzh),  cos(zzh), 0; 
               0,         0, 1];
           
Rh = Rhzz*Rhy'*Rhz; %humerus rotation matrix
           
Rux = [1,       0,        0; 
       0, cos(xu), -sin(xu); 
       0, sin(xu),  cos(xu)]; % ulna to the proximal segment (humerus)

Ru_h = BLDATA.Original_Matrices_L2A.Rh'*BLDATA.Original_Matrices_L2A.Ru;
   
%Ru = Rh*Rux;      % ulna to the inertial frame (thorax)
Ru = Rh*Ru_h*Rux;      % ulna to the inertial frame (thorax)

Pu = Ru(:,1);

Rrz = [cos(zr), -sin(zr), 0; 
       sin(zr),  cos(zr), 0; 
             0,        0, 1]; % radius to the proximal segment (ulna)
         
Rr_u = BLDATA.Original_Matrices_L2A.Ru'*BLDATA.Original_Matrices_L2A.Rr;

Rr = Ru*Rr_u*Rrz;                  % radius to the inertial frame (thorax)

%Rr = Ru*Rrz;                  % radius to the inertial frame (thorax)

Pr = Rr(:,3);                 % psir performs around the z axis of the
                              % radius fixed-body frame.

% Construction of Total Projection Matrix
TPmat = [Pc', zeros(3,12);
        zeros(3,3), Ps', zeros(3,9);
        zeros(3,6), Ph', zeros(3,6);
        zeros(1,9), Pu', zeros(1,3);
          zeros(1,12)  ,       Pr'];

% Dynamic Force to calculate the GH joint reaction force
FDYN = Mh*ACGh + Mh*[0; 0; g] + M_u*ACGu + M_u*[0; 0; g] + Mr*ACGr + Mr*[0; 0; g];

% Dynamic Force to calculate the HU joint reaction force
FDYN_u = M_u*ACGu + M_u*[0; 0; g] + Mr*ACGr + Mr*[0; 0; g];

% Dynamic Force to calculate the RU joint reaction force
FDYN_r = Mr*ACGr + Mr*[0; 0; g];


return;