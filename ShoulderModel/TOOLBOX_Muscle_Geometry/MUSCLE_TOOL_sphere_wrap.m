function [PATH, Length, wflag] = MUSCLE_TOOL_sphere_wrap(Pv, Sv, Ov, Rv, Np)
% UICONTROL Callback SINGLE SPHERE WRAPPING ALGORITHM
%--------------------------------------------------------------------------
% Syntax :
% [PATH, Length, wflag] = MUSCLE_TOOL_sphere_wrap(Pv, Sv, Ov, Rv, Np)
%--------------------------------------------------------------------------
%
% File Description :
% This function is the single-sphere wrapping algorithm from the obstacle
% set method.
%--------------------------------------------------------------------------

% Initialise the Output
PATH = [];      % All points along the path
Length = [];    % Length of path
wflag = 0;      % flag indicating if the wrapping occurs or not. 
                % 0 : wrapping. 1 : no wrapping, 2: point inside sphere

%--------------------------------------------------------------------------
% STEP 1 : Compute the insertion & Origin points in plane frame
M = MUSCLE_TOOL_sphere_rotation_matrix(Pv, Sv, Ov);

% Compute transformed points
p = M'*(Pv - Ov); px = p(1); py = p(2); pz = p(3);
s = M'*(Sv - Ov); sx = s(1); sy = s(2); sz = s(3);

%--------------------------------------------------------------------------
% STEP 2 : Compute wrapping contact points & Test Wrapping condition
Qx = px*Rv^2 - Rv*py*sqrt(px^2 + py^2 - Rv^2); Qx = real(Qx/(px^2 + py^2));
Qy = py*Rv^2 + Rv*px*sqrt(px^2 + py^2 - Rv^2); Qy = real(Qy/(px^2 + py^2));

Tx = sx*Rv^2 + Rv*sy*sqrt(sx^2 + sy^2 - Rv^2); Tx = real(Tx/(sx^2 + sy^2));
Ty = sy*Rv^2 - Rv*sx*sqrt(sx^2 + sy^2 - Rv^2); Ty = real(Ty/(sx^2 + sy^2));

% Wrapping condition
if Rv*(Qx*Ty - Qy*Tx) < 0
    %disp('Wrapping does Not Occur');
    Length = norm(Pv - Sv);
    PATH = [Pv, Sv];
    wflag = 1;
    return;
end

%--------------------------------------------------------------------------
% STEP 3 : Compute wrapping contact points in object frame
Q = M*[Qx; Qy; 0] + Ov;
T = M*[Tx; Ty; 0] + Ov;

%--------------------------------------------------------------------------
% STEP 4 : Compute length & Wrapping path
QTxy = abs(abs(Rv)*acos(1 - ((Qx - Tx)^2 + (Qy - Ty)^2)/(2*Rv^2)));
Length = norm(Q - Pv) + QTxy + norm(Sv - T);

% Compute the orientation angles of T and Q in plane frame
teta_T = atan2(Ty, Tx);
teta_Q = atan2(Qy, Qx);
Zc = zeros(1,Np);

% Test the quadrant location of  T & Q
%           |
%      II   |   I
%           |
%  -------------------
%           |
%     III   |   IV
%           |
if teta_T > 1.e-6                          % T is I or II
    if teta_Q < -1.e-6                  % Q is III or IV: Correct
        teta_Q = teta_Q + 2*pi;         
    end
    teta = linspace(teta_Q, teta_T, Np);
elseif abs(teta_T) < 1.e-6  
    teta = linspace(teta_Q, teta_T, Np);
else                                    % T is III or IV
    if teta_Q > 1.e-6                   % Q is I or II: Correct
        teta_Q = teta_Q - 2*pi;
    end
    teta = linspace(teta_Q, teta_T, Np);
end

% Build the path
PATH = [Pv, M*[abs(Rv)*cos(teta); abs(Rv)*sin(teta); Zc]+diag(Ov)*ones(3,Np), Sv];

% Avoid duplicate points
if norm(PATH(:,2) - PATH(:,1)) < 1.e-6
    PATH = PATH(:,2:end);
end

if norm(PATH(:,end) - PATH(:,end-1)) < 1.e-6
    PATH = PATH(:,1:end-1);
end
return