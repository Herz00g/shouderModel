function initial_condition = muscle_contraction_statics(muscle_par, activation, l_MT, initial_guess)
%{
function for solving the muscle alegbraic equilibrium equations. 
--------------------------------------------------------------------------
Syntax:
initial_condition = muscle_contraction_statics(muscle_par, activation, l_MT, initial_guess)
--------------------------------------------------------------------------
Function Description:
This function solves the muscle equilibrium equation to provide an initial
condition for the muscle fiber length so that the response starts from a
state that is an equilibrium to ensures the reponse will not drift away
from the slo manifold even at the begining.
--------------------------------------------------------------------------
%}


% solve the algebraic equilibrium equations
options = optimset('Display','iter', 'TolX', 1e-10);

% find the root (equilibrium)
initial_condition = fzero(@(l_n_M) contraction_equilibria(l_n_M, muscle_par, activation,...
                          l_MT), initial_guess, options);

return

% -------------------------------------------------------------------------
% function that provides algebraic equilibrium equations of the muscle
% contraction
% -------------------------------------------------------------------------

function dl_n_Mdt = contraction_equilibria(l_n_M, muscle_par, activation, l_MT)
%{

Function for generating the muscle equilibrium equation.
--------------------------------------------------------------------------
Syntax :
dl_n_Mdt = contraction_equilibria(l_n_M, muscle_par, activation, l_MT)
--------------------------------------------------------------------------
Function Description :
Function that rpovides the equilibrium equations of the muscle contraction.
--------------------------------------------------------------------------
%}
% muscle data
l_M_0   = muscle_par(1,2);
alpha_0 = muscle_par(1,3);
v_M_0   = muscle_par(1,4); % no use for it here (static case)
l_S_0   = muscle_par(1,5);

% singularity avoidance constraints for the differntial equations
% if le(l_n_M, max(0.4, sind(alpha_0)))
%     l_n_M = max(0.4, sind(alpha_0));
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
% l_T = interp1(l_MT(:,1),l_MT(:,2),t) - l_M*cos_alpha;
% if l_MT is a function of time
% l_T = l_S_0+l_M_0*cosd(alpha_0)+0.2*l_M_0*sin(2*pi*t)-l_M*cos_alpha;
% if l_MT is a constant 
l_T = l_MT - l_M*cos_alpha;

l_n_T = l_T/l_S_0;

% musculotendon curve constants
k_l = [0.0955];%  0.0082 % to have a wider feasible range use 0.1558
%k_p = [0.0758 5.2275 -0.0054];
%k_p = [0.1002 19.5828 -0.00378];
k_p = [0.0370    1.8320    -0.0239];% 0.0670
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

% muscle dynamics (algebraic equations)
dl_n_Mdt = f_t - (activation*f_l*k_v(1)*0.5 + f_p)*cos_alpha;

return;