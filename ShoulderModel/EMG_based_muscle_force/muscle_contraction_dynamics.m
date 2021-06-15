function [sol f_l f_p f_v f_t tendon_length cos_alpha] = muscle_contraction_dynamics(muscle_par, activation, l_MT, initial_cond, tspan)
%{
function for solving the muscle dynamics, either differential equations or 
the alegbraic equilibrium equations. 
--------------------------------------------------------------------------
Syntax :
[sol f_l f_p f_v f_t tendon_length cos_alpha] = muscle_contraction_dynamics
                                                (muscle_par, activation, l_MT, initial_cond, tspan)
--------------------------------------------------------------------------
Function Descriptions:
This function solve the differential equation associated with the muscle
contraction dynamics.
--------------------------------------------------------------------------
%}
% set the initial conditions
l_n_M0 = initial_cond;

% case 1: differential equations
% -------------------------------------------------------------------------
% set integration properties
odeoptions = odeset('RelTol',1e-8,'MaxStep',1e-3);

% solve the differential equation
% there are two options available, including explicit and implicit. I
% decided to go with the implicit as it's faster and is more robost and
% less prone to the singularities
% sol = ode45(@(t, l_n_M) contraction_statespace(t, l_n_M, muscle_data, activation, l_MT), tspan, l_n_M0, options);
sol = ode15i(@(t, l_n_M, v_n_M) contraction_statespace(t, l_n_M, v_n_M, muscle_par, activation, l_MT), tspan, l_n_M0, 0, odeoptions);

% case 1: algebraic equilibrium equations
% -------------------------------------------------------------------------
% options = optimoptions('fsolve','Algorithm','trust-region-dogleg','MaxIter',1e3,'TolFun',1e-10);
% sol = fzero(@(l_n_M) contraction_statespace(l_n_M, muscle_data, activation, l_MT), l_n_M0, options);


% to calculate the associated forces and tendon length (not the case for
% the equilibrium case)
%[f_l f_p f_t f_v tendon_length cos_alpha] = force_generator(muscle_par, activation, l_MT, [sol.x; sol.y]', tspan);
[f_l f_p f_t f_v tendon_length cos_alpha] = force_generator(muscle_par, activation, l_MT, sol, tspan);

return


% -------------------------------------------------------------------------
% function for calculating the associated forces and tendon length
% -------------------------------------------------------------------------
function [f_l f_p f_t f_v tendon_length cos_alpha] = force_generator(muscle_data, activation, l_MT, sol, tspan)

% take the muscle parameters
F_0     = muscle_data(1,1);
l_M_0   = muscle_data(1,2);
alpha_0 = muscle_data(1,3);
v_M_0   = muscle_data(1,4);
l_S_0   = muscle_data(1,5);

% get the time from the solution of the system dynamics
% t = muscle_length(:,1);
% or define an arbitrary time vector based on the tspan
t = linspace(tspan(1), tspan(2), length(l_MT));

% re-evaluate the system solution for the time vector defined above and
% define also the v_n_M
[muscle_length v_n_M] = deval(sol, t);

% pennation angel and normalized muscle and tendon lengths
l_M = l_M_0*muscle_length;

for time_id = 1:length(l_M)
    
    % this part of the code is a bit different comparing to the other code
    % that I have regarding the dimension of the vectors here 1byn or nby2
    % in the other cases.
    l_n_M = muscle_length(1, time_id);
    
    sin_alpha = l_M_0*sind(alpha_0)/l_M(1, time_id);
    
    cos_alpha(time_id) = sqrt(1 - sin_alpha^2);

    l_T = interp1(l_MT(:,1),l_MT(:,2),t(1, time_id)) - l_M(1, time_id)*cos_alpha(time_id);
    % l_T = interp1(musculotendon_length(:,1),l_MT(:,1),muscle_length(time_id,1)) - l_M(time_id,1)*cos_alpha;
    % l_T = l_S_0+l_M_0*cosd(alpha_0)+0.2*l_M_0.*sin(2*pi*t(time_id,1)) - l_M(time_id,1)*cos_alpha;
    % l_T = l_MT - l_M(time_id,1)*cos_alpha;
    l_n_T = l_T/l_S_0;

    tendon_length(time_id) = l_n_T;
    
    % musculotendon curve constants
    k_l = [0.0955];%0.0082 % 0.0955
    %k_p = [0.0758 5.2275 -0.0054];
    %k_p = [0.1002 19.5828 -0.00378];
    k_p = [0.0370    1.8320    -0.0239];
    %k_t = [0.3441 23.6968 -0.0443];
    %k_t = [0.0842   52.3663   -0.0062];
    k_t = [0.3791   26.3570    -0.03627];
    k_v = [1.5108 -4.9940];

    % 1) muscle force-length relationship
    f_l(time_id) = F_0*(exp((-(l_n_M - 1)^2)/k_l(1)));

    % 2) muscle passive force relationship
    f_p(time_id) = F_0*(k_p(1)*exp(k_p(2)*(l_n_M - 1))- k_p(3));

    % 3) tendon force-length relationship
    f_t(time_id) = F_0*(k_t(1)*exp(k_t(2)*(l_n_T - 1))- k_t(3));

    % 4) muscle force-velocity relation
    f_v(time_id) = F_0*(k_v(1)/(1 + exp(k_v(2)*(l_M_0/v_M_0)*v_n_M(1, time_id))));

end


return;
