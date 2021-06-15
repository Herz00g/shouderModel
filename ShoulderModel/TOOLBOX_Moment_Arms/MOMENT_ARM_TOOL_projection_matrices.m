function TPmat = MOMENT_ARM_TOOL_projection_matrices(JEA)
%{
Function for computing the virtual displacement projection matrices
--------------------------------------------------------------------------
Syntax :
TPmat = MOMENT_ARM_TOOL_projection_matrices(JEA)
--------------------------------------------------------------------------
Function Description :
This function computes the projection matrices for MOMENT_ARM_TOOL_compute_all.
There are five matrices grouped into a larger diagonal matrix. The
matrixes are the jacobians of the angular velocity vectors defined in
the inertial frame. These matrices are used here to project the moment arms
computed by the tendon excursion method into the absolute referenc
system. A brief review of this method is given in
MOMENT_ARM_TOOL_compute_all.
--------------------------------------------------------------------------
%}

% Initialise the output
TPmat = [];

% Get the SC Joint Angles
psic    = JEA(1); thetac  = JEA(2); phic    = JEA(3);

% Get the AC Joint Angles
psis    = JEA(4); thetas  = JEA(5); phis    = JEA(6);

% Get the GH Joint Angles
psih    = JEA(7); thetah  = JEA(8); phih    = JEA(9);

% Get the HU Joint Angles
psiu    = JEA(10);

% Get the RU Joint Angles
psir    = JEA(11);

% Projection Matrix associated to the SC joint
Pc = [cos(phic)*cos(thetac), -sin(phic), 0;
      sin(phic)*cos(thetac),  cos(phic), 0;
               -sin(thetac),          0, 1];

% Projection Matrix associated to the AC joint
Ps = [cos(phis)*cos(thetas), -sin(phis), 0;
      sin(phis)*cos(thetas),  cos(phis), 0;
               -sin(thetas),          0, 1];

% Projection Matrix associated to the GH joint
Ph = [cos(phih)*sin(thetah), -sin(phih), 0;
      sin(phih)*sin(thetah),  cos(phih), 0;
                cos(thetah),          0, 1];
            
% Projection Matrix associated to the HU joint
% The partial velocity vectors that build the so-called projection matrix
% are in essense the unit vectors about whose directions the Euler angle
% transformations were conducted. Therefore, e_psiu = dW/ddq is equal to
% the unit vector along the x axis of the ulna fixed-body frame. That is
% the first column of rotation matrix Ru.
% Humerus Matrix
Rhz = [cos(psih), -sin(psih), 0; 
       sin(psih),  cos(psih), 0; 
               0,          0, 1];
         
Rhy = [cos(thetah), 0, -sin(thetah); 
                 0, 1, 0; 
       sin(thetah), 0,  cos(thetah)];
   
Rhzz = [cos(phih), -sin(phih), 0; 
        sin(phih),  cos(phih), 0; 
                0,         0, 1];
           
Rh = Rhzz*Rhy'*Rhz;
     
Rux = [1,       0,        0; 
       0, cos(psiu), -sin(psiu); 
       0, sin(psiu),  cos(psiu)];% ulna to the proximal segment (humerus)

Ru = Rh*Rux;      % ulna to the inertial frame (thorax)

Pu = Ru(:,1);

% Projection Matrix associated to the RU joint
Rrz = [cos(psir), -sin(psir), 0; 
       sin(psir),  cos(psir), 0; 
               0,          0, 1]; % radius to the proximal segment (ulna)
           
Rr = Ru*Rrz;                      % radius to the inertial frame (thorax)

Pr = Rr(:,3); % psir performs around the z axis of the radius fixed-body frame.

% Larger diagonal matrix containing all three matrices
TPmat = [Pc', zeros(3,12);
        zeros(3,3), Ps', zeros(3,9);
        zeros(3,6), Ph', zeros(3,6);
        zeros(1,9), Pu', zeros(1,3);
          zeros(1,12)  ,       Pr'];
return;