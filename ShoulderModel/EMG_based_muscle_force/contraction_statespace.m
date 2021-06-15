function [dl_n_Mdt] = contraction_statespace(t, l_n_M, v_n_M, muscle_par, activation, l_MT) % don't use t for euilibrium case
%{
Function for generating the state space of the muscle dynamics.
--------------------------------------------------------------------------
Syntax :
case 1: differential equation
[dl_n_Mdt] = contraction_statespace(t, l_n_M, muscle_data, activation, l_MT)
case 2: algebraic equilibrium equaation
[dl_n_Mdt] = contraction_statespace(l_n_M, muscle_data, activation, l_MT)
--------------------------------------------------------------------------
Function Description :
This function provides the state space equations of the muscle contraction
dynamics.
--------------------------------------------------------------------------
%}
% muscle data
l_M_0   = muscle_par(1,2);
alpha_0 = muscle_par(1,3);
v_M_0   = muscle_par(1,4);
l_S_0   = muscle_par(1,5);

% singularity avoidance constraints for the differntial equations
% if le(l_n_M, max(0.8, sind(alpha_0)))
%     l_n_M = max(0.8, sind(alpha_0));
% elseif ge(l_n_M, 1.2)
%     l_n_M = 1.2;
% else
%     l_n_M = l_n_M;
% end

% pennation angel and normalized muscle and tendon lengths
l_M = l_M_0*l_n_M;

sin_alpha = l_M_0*sind(alpha_0)/l_M;

cos_alpha = sqrt(1 - sin_alpha^2);

% if l_MT is a vector
 l_MT = interp1(l_MT(:,1),l_MT(:,2),t);
 a = interp1(activation(:,1),activation(:,2),t);

 l_T = l_MT - l_M*cos_alpha;
% if l_MT is a function of time
% l_T = l_S_0+l_M_0*cosd(alpha_0)+0.2*l_M_0*sin(2*pi*t)-l_M*cos_alpha;
% if l_MT is a constant 
%l_T = l_MT-l_M*cos_alpha;

l_n_T = l_T/l_S_0;

% musculotendon curve constants
k_l = [0.0955];%0.1558   % to have a wider feasible range use 0.1558
%k_p = [0.0758 5.2275 -0.0054];
%k_p = [0.1002 19.5828 -0.00378];
k_p = [0.0370    1.8320    -0.0239];
%k_t = [0.3441 23.6968 -0.0443];
%k_t = [0.0842   52.3663   -0.0062];
k_t = [0.3791   26.3570    -0.03627];
k_v = [1.5108 -4.9940];

% 1) muscle force-length relationship
f_l = exp((-(l_n_M - 1)^2)/k_l(1));

% 2) muscle passive force relationship
f_p = k_p(1)*exp(k_p(2)*(l_n_M - 1))- k_p(3);

% 3) tendon force-length relationship
f_t = k_t(1)*exp(k_t(2)*(l_n_T - 1))- k_t(3);

% 4) muscle force-velocity relation
f_v = k_v(1)/(1 + exp(k_v(2)*(l_M_0/v_M_0)*v_n_M));

% muscle velocity
%v_n_M = (v_M_0/l_M_0)*(1/k_v(2))*log(k_v(1)/((f_t/cos_alpha - f_p)/(activation*f_l)) - 1);
% v_n_M = (v_M_0/l_M_0)*(1/k_v(2))*log(k_v(1)/((f_t/cos_alpha - f_p)/(a*f_l)) - 1);

dl_n_Mdt = f_t - (a*f_l*f_v + f_p + 0.01*(l_M_0/v_M_0)*v_n_M)*cos_alpha;
% to avoid complex values for the v_n_M while dealing with the differential
% equations
% if isreal(v_n_M)
%     v_n_M = v_n_M;
% else
%     v_n_M = real(v_n_M);
% end

% singularity avoidance constraints for the differntial equations
if le(l_n_M, max(0.4, sind(alpha_0))) && v_n_M < 0
    v_n_M = 0;
else
    v_n_M = v_n_M;
end

% muscle dynamics (differential equations)
% dl_n_Mdt = v_n_M;
% muscle dynamics (algebraic equations)
%dl_n_Mdt = f_t - (activation*f_l*k_v(1)*0.5 + f_p)*cos_alpha;

return;
