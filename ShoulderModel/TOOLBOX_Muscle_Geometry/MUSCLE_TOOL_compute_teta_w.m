function [Wv, teta_p, teta_q, teta_s, teta_w, qx, qy] = MUSCLE_TOOL_compute_teta_w(Mobj, Ov, px, py, pz, sx, sy, sz, Rv)
% Function for computing the point W for the stub wrapping algorithm.
%--------------------------------------------------------------------------
% Syntax :
% [Wv, teta_p, teta_q, teta_s, teta_w, qx, qy] = MUSCLE_TOOL_compute_teta_w(Mobj, Ov, px, py, pz, sx, sy, sz, Rv)
%--------------------------------------------------------------------------
%
% File Description :
% This function computes the point W on the sphere-cylinder interface. This
% function is used by the stub wrapping algorithm.
%
%--------------------------------------------------------------------------

% Compute the XY coordinates of Q
qx = px*Rv^2 - Rv*py*sqrt(px^2 + py^2 - Rv^2); qx = real(qx/(px^2 + py^2));
qy = py*Rv^2 + Rv*px*sqrt(px^2 + py^2 - Rv^2); qy = real(qy/(px^2 + py^2));

% Iteratively compute theta_w
teta_s = atan2(sy,sx);
teta_p = atan2(py,px);
teta_q = atan2(qy,qx);
teta_w = teta_p - (teta_s - teta_p)*pz/(sz - pz);

%return;
Tol = 1.e-6;
Err = 1;
Niter = 1000;
k = 1;
while Err > Tol && k < Niter
    % Compute the values of the function
    f =  (-pz*sqrt(sx^2 + sy^2))*sin(teta_w - teta_s) + (sz*abs(Rv))*(teta_w - teta_q) + (sz*sqrt((px - qx)^2 + (py - qy)^2))*sign(Rv);
    df = (-pz*sqrt(sx^2 + sy^2))*cos(teta_w - teta_s) + (sz*abs(Rv));

    % Update the value of thete_w
    teta_w = teta_w - f/df;

    % Update the error
    Err = abs(f/df);
    k = k+1;
end

% Compute the position of W
wx = abs(Rv)*cos(teta_w);
wy = abs(Rv)*sin(teta_w);
wz = 0;
qz = wz + abs(Rv*(teta_w - teta_q))*pz/(abs(Rv*(teta_w - teta_q)) + sqrt((px - qx)^2 + (py - qy)^2));

% Compute W in original frame
Wv = Mobj*[wx; wy; wz] + Ov;

return;