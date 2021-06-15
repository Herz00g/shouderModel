function [PATH, Length, wflag] = MUSCLE_TOOL_stub_wrap(Pv, Sv, Ov, Rv, Mobj, Np, Switchflag)
% UICONTROL Callback SPHERE CAPPED CYLINDER WRAPPING ALGORITHM
%--------------------------------------------------------------------------
% Syntax :
% [PATH, Length, wflag] = MUSCLE_TOOL_stub_wrap(Pv, Sv, Ov, Rv, Mobj, Np)
%--------------------------------------------------------------------------
%
% File Description :
% This function is the sphere capped cylinder (stub) wrapping algorithm
% from the obstacle set method.
%--------------------------------------------------------------------------

% Initialise the Output
PATH = [];      % All points along the path
Length = [];    % Length of path
wflag = 0;      % flag indicating if the wrapping occurs or not
                % 0 : wrapping. 1 : sphere only wrapping, 
                % 2 : cylinder only wrapping
                % 3 : no wrapping
                
%--------------------------------------------------------------------------
%********* STEP 1 : Compute the insertion & Origin points in object frame
%--------------------------------------------------------------------------
p = Mobj'*(Pv - Ov); px = p(1); py = p(2); pz = p(3);
s = Mobj'*(Sv - Ov); sx = s(1); sy = s(2); sz = s(3);

%--------------------------------------------------------------------------
%********* STEP 2 : Wrapping is either sphere or cylinder only
%--------------------------------------------------------------------------
if pz > 0 && sz > 0                 % Both points are on sphere side -> Single-sphere    
    % Compute single-sphere wrapping
    [PATH, Length, wflag] = MUSCLE_TOOL_sphere_wrap(Pv, Sv, Ov, abs(Rv), Np);
    
    return;
    
elseif pz <= 0 && sz <= 0           % Both points are on cylinder side -> Single-cylinder
    if Switchflag == 1
        Rv = -Rv;
    end

    % Compute single-cylinder wrapping
    [PATH, Length, wflag] = MUSCLE_TOOL_cylinder_wrap(Pv, Sv, Ov, Rv, Mobj, Np);
    
    return;
else
    % The wrapping is both or neither
end

%--------------------------------------------------------------------------
%********* STEP 3 : Wrapping is maybe cylinder only
%--------------------------------------------------------------------------
% Is s outside cylinder?
if sqrt(sx^2 + sy^2) > abs(Rv)
    if Switchflag == 1
        Rv = -Rv;
    end
    % Single Cylinder algorithm
    [PATH, Length, wflag] = MUSCLE_TOOL_cylinder_wrap(Pv, Sv, Ov, Rv, Mobj, Np);
    
    % Compute Q & T in object frame
    q = Mobj'*(PATH(:,2) - Ov);
    t = Mobj'*(PATH(:,end-1) - Ov);
        
    % Test the inactivity of Q % T
    if size(PATH,2) == 2 || (q(3) <= 0 && t(3) <= 0)
        return;
    end
    if Switchflag == 1
        Rv = -Rv;
    end
end

%--------------------------------------------------------------------------
%********* STEP 4 : Wrapping is maybe sphere only
%--------------------------------------------------------------------------
% Single Sphere algorithm
[PATH, Length, wflag] = MUSCLE_TOOL_sphere_wrap(Pv, Sv, Ov, abs(Rv), Np);

q = Mobj'*(PATH(:,2) - Ov);
t = Mobj'*(PATH(:,end-1) - Ov);

% Test inactivity of Q & T
if size(PATH,2) == 2 || (q(3) > 0 && t(3) > 0)
    return;
end

%--------------------------------------------------------------------------
%********* STEP 5 : The wrapping is both
%--------------------------------------------------------------------------
[Wv, teta_p, teta_q, teta_s, teta_w, qx, qy] = MUSCLE_TOOL_compute_teta_w(Mobj, Ov, px, py, pz, sx, sy, sz, abs(Rv));

% Test Conditions on teta_w
if Rv < 0 && teta_w <= teta_q
    % Test inactivity of Q & T
    if size(PATH,2) == 2
        if wflag == 0
            wflag = 1;
        else
            wflag = 3;
        end
        return;
    end
elseif Rv > 0 && teta_w >= teta_q
    % Test inactivity of Q & T
    if size(PATH,2) == 2
        if wflag == 0
            wflag = 1;
        else
            wflag = 3;
        end
        return;
    end
end

PATHc = []; PATHs = [];
Lengths = []; Lengthc = []; 

[PATHs, Lengths, wflag] = MUSCLE_TOOL_sphere_wrap(Wv, Sv, Ov, abs(Rv), Np);

n1 = PATHs(:,2) - PATHs(:,1); n1 = n1/norm(n1);

if Switchflag == 1
        Rv = -Rv;
end

[PATHc, Lengthc, wflag] = MUSCLE_TOOL_cylinder_wrap(Pv, Wv, Ov, Rv, Mobj, Np);
PATH = [PATHc, PATHs(:,2:end)];
Length = Lengths + Lengthc;
    
n2 = PATHc(:,end) - PATHc(:,end-1); n2 = n2/norm(n2);

% Compute a version with opposit sign
if 1-abs(n1'*n2) > 5.e-3
    if Switchflag == 1
        Rv = -Rv;
    end

    [Wv, teta_p, teta_q, teta_s, teta_w, qx, qy] = MUSCLE_TOOL_compute_teta_w(Mobj, Ov, px, py, pz, sx, sy, sz, -abs(Rv));
    
    % Test Conditions on teta_w
    if Rv < 0 && teta_w <= teta_q
        % Test inactivity of Q & T
        if size(PATH,2) == 2
            if wflag == 0
                wflag = 1;
            else
                wflag = 3;
            end
            return;
        end
    elseif Rv > 0 && teta_w >= teta_q
        % Test inactivity of Q & T
        if size(PATH,2) == 2
            if wflag == 0
                wflag = 1;
            else
                wflag = 3;
            end
            return;
        end
    end
    
    PATHc = []; PATHs = [];
    Lengths = []; Lengthc = [];
    
    [PATHs, Lengths, wflag] = MUSCLE_TOOL_sphere_wrap(Wv, Sv, Ov, abs(Rv), Np);
    
    
    if Switchflag == 1
        Rv = -Rv;
    end
    
    [PATHc, Lengthc, wflag] = MUSCLE_TOOL_cylinder_wrap(Pv, Wv, Ov, Rv, Mobj, Np);
    
    PATH = [PATHc, PATHs(:,2:end)];
    Length = Lengths + Lengthc;
else
    
end
return