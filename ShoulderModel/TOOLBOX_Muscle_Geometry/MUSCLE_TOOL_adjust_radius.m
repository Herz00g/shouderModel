function [Robj, rflag] = MUSCLE_TOOL_adjust_radius(Pv, Sv, O, R, Mobj, type)
% UICONTROL Callback computes an adjusted radius for wrapping (if necess.)
%--------------------------------------------------------------------------
% Syntax :
% [Robj, rflag] = MUSCLE_TOOL_adjust_radius(Pv, Sv, O, R, Mobj, type)
%--------------------------------------------------------------------------
%
% File Description :
% This function computes a new object radius if necessary for the muscle.
% This is done such that if an origin or insertion point penetrates the
% object surface, the wrapping still occurs but with a reduced radius.
%
%--------------------------------------------------------------------------
Robj = 0;
rflag = 0;  % Inidicates if the radius changes

if isequal(type, 'single')

    % Rotate insertion and origin into object frame
    p = Mobj'*(Pv - O); px = p(1); py = p(2); pz = p(3);
    s = Mobj'*(Sv - O); sx = s(1); sy = s(2); sz = s(3);

    Rp = sqrt(px^2 + py^2);
    Rs = sqrt(sx^2 + sy^2);
    Robj = min([Rp, Rs, abs(R)]);
    Robj = sign(R)*Robj;
    
    if isequal(Robj, R) == 0
        rflag = 1;
    end

elseif isequal(type, 'double')
    % Get the Data
    Ou = O(:,1); Ru = R(1);
    Ov = O(:,2); Rv = R(2);
    
    % Object Rotation Matrices
    Mu = Mobj(:,1:3);
    Mv = Mobj(:,4:6);
    
    % Rotate insertion and origin into object frame
    p = Mu'*(Pv - Ou); px = p(1); py = p(2); pz = p(3);
    s = Mv'*(Sv - Ov); sx = s(1); sy = s(2); sz = s(3);
    
    Rp = sqrt(px^2 + py^2);
    Rs = sqrt(sx^2 + sy^2);
    
    Robju = min([Rp, abs(Ru)]);
    Robj(1) = sign(Ru)*Robju;
    
    Robjv = min([Rs, abs(Rv)]);
    Robj(2) = sign(Rv)*Robjv;
    
    if isequal(Robj(1), Ru) == 0 || isequal(Robj(2), Rv) == 0
        rflag = 1;
    end
elseif isequal(type, 'stub') 
    % Rotate insertion and origin into object frame
    p = Mobj'*(Pv - O); px = p(1); py = p(2); pz = p(3);
    s = Mobj'*(Sv - O); sx = s(1); sy = s(2); sz = s(3);

    if sz >= 0 && pz >= 0
        Rs = norm(s);
        Rp = norm(p);
        Robj = min([Rp, Rs, abs(R)]);
        Robj = sign(R)*(Robj);
    elseif sz >= 0 && pz < 0
        
        Rp = sqrt(px^2 + py^2);
        Rs = sqrt(sx^2 + sy^2 + sz^2);
        Robj = min([Rp, Rs, abs(R)]);
        Robj = sign(R)*(Robj);
    elseif sz < 0 && pz >= 0
        
        Rp = sqrt(px^2 + py^2 + pz^2);
        Rs = sqrt(sx^2 + sy^2);
        Robj = min([Rp, Rs, abs(R)]);
        Robj = sign(R)*(Robj);
    elseif sz < 0 && pz < 0
        Rp = sqrt(px^2 + py^2);
        Rs = sqrt(sx^2 + sy^2);
        Robj = min([Rp, Rs, abs(R)]);
        Robj = sign(R)*(Robj);
    end
    
    if isequal(Robj, R) == 0
        rflag = 1;
    end
end
    
return;