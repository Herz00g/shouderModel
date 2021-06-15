function [sol, f_l, f_p, f_v, f_t, tendon_length, a_muscle, cos_alpha] = EMG_based_force_prediction(muscle_par, tspan, excitation, l_MT_length)
%{
function for estimating the muscle force.
--------------------------------------------------------------------------
Syntax :
[sol, f_t, tendon_length, cos_alpha] = EMG_based_force_prediction(muscle_par, tspan, excitation,  l_MT_length)
--------------------------------------------------------------------------
Description :
It is based on 
decoupled
equilibrium
new framework that assures that the muscle response start off following the
slow manifold of the response and avoids perturbation due to wrong initial
conditions that comes from nonequilibrium states that causes the muscle
response to drift away from its slow manifold defined 
muscle_par is f_0 l_M_0 alpha_0 v_M_0 l_S_0
--------------------------------------------------------------------------
%}

% 1) ACTIVATION DYANMICS---------------------------------------------------
% get the excitation
excitation = excitation'; % the given matrix should be 2byn

% solve the activation dynamics
a_muscle = muscle_activation_dynamics(excitation, tspan);

% save the activation response in a way that is needed for the contraction
% dynamics
activation = [a_muscle.x; a_muscle.y]';

% 2) CONTRACTION DYANMICS---------------------------------------------------
% get the l_MT (muscle-tendon length)
l_MT  = l_MT_length'; % the given matrix should be 2byn

% defines the initial condition that assures the muscel response will start
% off following the slow manifold and avoids extra perturbations.

% give an initial guess to find the associated equilibrium for the given
% initial l_MT and initial activation
initial_guess = 1.5; %[0.8 1.30]; % can be also given as range

% solve the static system equation to find the equilibrium
initial_condition = muscle_contraction_statics(muscle_par, activation(1,2), l_MT(1,2), initial_guess);

    
% if the above line did not work for any reason here is a desprate
% alternative
% initial_condition = 0.8 ;

% solve the contraction dynamics
[sol f_l f_p f_v f_t tendon_length cos_alpha] = muscle_contraction_dynamics(muscle_par,...
                                                          activation, l_MT, initial_condition, tspan);


% show the results
plot_value = 0; % if one will plot the results

if plot_value == 1
figure('name', 'muscle response')
    % muscle fiber length
    subplot(2,2,1)
    plot(sol.x, sol.y, 'k', 'linewidth', 2)
    title('normalized muscle fiber length')
    xlabel('time [s]')
    ylabel('normalized l^m [mm]')
    grid on
    set(gca,'FontSize',14); 
    
    % force
    subplot(2,2,2)
    t = linspace(tspan(1), tspan(2), 200);
    plot(t, f_t, 'k', 'linewidth', 2)
    hold on
    plot(t, f_l, 'b', 'linewidth', 2)
    plot(t, f_p, 'g', 'linewidth', 2)
    plot(t, f_v, 'y', 'linewidth', 2)
    activation = deval(a_muscle, linspace(tspan(1), tspan(2), 200)); 
    plot(t, (activation.*f_l.*f_v/muscle_par(1,1) + f_p), '--r', 'linewidth', 2)
    legend('f^t', 'f^l', 'f^p', 'f^v', 'f^{lvp}')
    title('force')
    xlabel('time [s]')
    ylabel('force in muscle [N]')
    grid on
    set(gca,'FontSize',14);

    % muscle fiber length
    subplot(2,2,3)
    plot(t, tendon_length, 'k', 'linewidth', 2)
    title('normalized tendon length')
    xlabel('time [s]')
    ylabel('normalized l^t [mm]')
    grid on
    set(gca,'FontSize',14);

    % pennation angle
    subplot(2,2,4)
    plot(t, (180/pi)*acos(cos_alpha), 'k', 'linewidth', 2)
    title('pennation angle')
    xlabel('time [s]')
    ylabel('alpha [Deg]')
    grid on
    set(gca,'FontSize',14);
end
return;


                                       