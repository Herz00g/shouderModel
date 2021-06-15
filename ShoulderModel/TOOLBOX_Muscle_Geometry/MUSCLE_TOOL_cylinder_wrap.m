function [PATH, Length, wflag] = MUSCLE_TOOL_cylinder_wrap(Pv, Sv, Ov, Rv, Mobj, Np)
% UICONTROL Callback SINGLE-CYLINDER WRAPPING ALGORITHM
%--------------------------------------------------------------------------
% Syntax :
% [PATH, Length, wflag] = MUSCLE_TOOL_cylinder_wrap(Pv, Sv, Ov, Rv, Mobj, Np)
%--------------------------------------------------------------------------
%
% File Description :
% This function is the single-cylinder wrapping algorithm from the obstacle
% set method.
%--------------------------------------------------------------------------

% Initialise the Output
PATH = [];      % All points along the path
Length = [];    % Length of path (or more precisely the lenght of the obstacle path)
wflag = 0;      % flag indicating if the wrapping occurs or not
                % 0 : wrapping. 1 : no wrapping, 2: point inside cylinder
                
%--------------------------------------------------------------------------
%********* STEP 1 : Compute the insertion & Origin points in object frame
%--------------------------------------------------------------------------
% Compute transformed points
p = Mobj'*(Pv - Ov); px = p(1); py = p(2); pz = p(3);
s = Mobj'*(Sv - Ov); sx = s(1); sy = s(2); sz = s(3);

%--------------------------------------------------------------------------
%********* STEP 2 : Compute wrapping contact points & Test Wrapping condition
%--------------------------------------------------------------------------
Qx = px*Rv^2 - Rv*py*sqrt(px^2 + py^2 - Rv^2); Qx = real(Qx/(px^2 + py^2));
Qy = py*Rv^2 + Rv*px*sqrt(px^2 + py^2 - Rv^2); Qy = real(Qy/(px^2 + py^2));

Tx = sx*Rv^2 + Rv*sy*sqrt(sx^2 + sy^2 - Rv^2); Tx = real(Tx/(sx^2 + sy^2));
Ty = sy*Rv^2 - Rv*sx*sqrt(sx^2 + sy^2 - Rv^2); Ty = real(Ty/(sx^2 + sy^2));

%--------------------------------------------------------------------------
%********* STEP 3 : Compute wrapping contact points in object frame
%--------------------------------------------------------------------------
QTxy = abs(abs(Rv)*acos(1 - ((Qx - Tx)^2 + (Qy - Ty)^2)/(2*Rv^2)));
PQxy = sqrt((Qx - px)^2 + (Qy - py)^2);
TSxy = sqrt((Tx - sx)^2 + (Ty - sy)^2);

Qz = pz + (sz - pz)*PQxy/(PQxy + QTxy + TSxy);
Tz = sz - (sz - pz)*TSxy/(PQxy + QTxy + TSxy);

Q = [Qx; Qy; Qz];
T = [Tx; Ty; Tz];

% Does the wrapping occure?
if Rv*(Qx*Ty - Qy*Tx) < 0
    %disp('Wrapping does Not Occur');
    Length = norm(Pv - Sv);
    PATH = [Pv, Sv];
    wflag = 1;
    return;
end

%--------------------------------------------------------------------------
%********* STEP 4 : Compute length
%--------------------------------------------------------------------------
% Entire lenght of muscle
Length = norm(Q - p) + sqrt(QTxy^2 + (Tz - Qz)^2) + norm(s - T);

%--------------------------------------------------------------------------
%********* STEP 5 : Construct Wrapping Path
%--------------------------------------------------------------------------
% Rotate Txy & Qxy into a plane where Sx is the X-axis
Mpx = [sx; sy; 0];
Mpz = [0; 0; 1];
Mpy = cross(Mpz, Mpx);
Mp = [Mpx/norm(Mpx), Mpy/norm(Mpy), Mpz/norm(Mpz)];

% Transform the wrapping points into this frame
Tp = Mp'*[Tx; Ty; 0];
Qp = Mp'*[Qx; Qy; 0];
Pp = Mp'*[px; py; 0];

% Compute the angles
teta_T = atan2(Tp(2), Tp(1));
teta_Q = atan2(Qp(2), Qp(1));
teta_P = atan2(Pp(2), Pp(1));

% Define the change in circular coordinate and z-axis coordinate
teta = zeros(1,Np);
Zc = linspace(Qz, Tz, Np);

% Test the quadrant location of  T & Q
%           |
%      II   |   I
%           |
%  -------------------
%           |
%     III   |   IV
%           |
if teta_T > 1.e-6                              % T is I or II
    if teta_Q < -1.e-6                         % Q is III or IV: Correct
        teta_Q = teta_Q + 2*pi;             
    end
    teta = linspace(teta_Q, teta_T, Np);
elseif abs(teta_T) < 1.e-6  
    teta = linspace(teta_Q, teta_T, Np);
else                                        % T is III or IV
    if teta_Q > 1.e-6                       % Q is I or II: Correct
        teta_Q = teta_Q - 2*pi;
    end
    teta = linspace(teta_Q, teta_T, Np);
end

% Build the path
PATH = [Pv, (Mobj*Mp*[abs(Rv)*cos(teta); abs(Rv)*sin(teta); Zc]+diag(Ov)*ones(3,Np)), Sv];

% Avoid duplicate points
if norm(PATH(:,2) - PATH(:,1)) < 1.e-6
    PATH = PATH(:,2:end);
end

if norm(PATH(:,end) - PATH(:,end-1)) < 1.e-6
    PATH = PATH(:,1:end-1);
end

return;