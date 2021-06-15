function a_muscle = muscle_activation_dynamics(excitation, tspan)
%{
function for defining the muscle activation based on the muscle excitation.
--------------------------------------------------------------------------
Syntax :
a_muscle = muscle_activation_dynamics(excitation, tspan)
--------------------------------------------------------------------------
Description :
Muscle activation is based on the muscle excitation. This activation
dynamic is adapted from two papers, including Thelen 2003 and Millard 2013.
--------------------------------------------------------------------------
%}
% set integration properties
odeoptions = odeset('RelTol',1e-5,'MaxStep',1e-3);

% lower band on the activation to avoid singularity
a_min = 0.00;

% define the initial condition such that the system will start off
% following the slow manifold of the solution
activation_0 = (1 - a_min)*excitation(1, 2) + a_min; % initial condition


% solve the differential equation
sol = ode45(@(t, activation) activation_statespace(t, activation, excitation), tspan, activation_0, odeoptions);

% output the result
a_muscle = sol;

return;

% -------------------------------------------------------------------------
% this function is the activation dynamics state space
% -------------------------------------------------------------------------
function dadt = activation_statespace(t, activation, excitation)

% lower band on the activation to avoid singularity
a_min = 0.00;

% time constants for activation and deactiation
tau_act  =  30e-3;  % [s]
tau_dact = 40e-3; % [s]

% define the transformed dynamics
a_hat = (activation - a_min)/(1 - a_min);

% get the excitation
u = interp1(excitation(:,1), excitation(:,2), t);

if u <0
    u = 0;
end

% define the time constant
if le(u, a_hat) % muscle in deactivation regime
    tau = tau_dact/(0.5 + 1.5*a_hat);
else
    tau = tau_act*(0.5 + 1.5*a_hat);
end

% define the activation dynamics
dadt = (u - a_hat)/tau;

return;
