%
%
% File Description :
% This script is run when a graph in the main kinematics GUI is clicked on.
%
%--------------------------------------------------------------------------
% List of joint angles to be used as titles
MvtList = {...
        'Clavicula Axial Rotation',...
        'Clavicula Depression (-) / Elevation (+)',...
        'Clavicula Retraction (-) / Protraction (+)',...
        'Scapula External Tilt(-)/ Internal Tilt (+)',...
        'Scapula Depression (-) / Elevation (+)',...
        'Scapula Retraction (-) / Protraction (+)',...
        'Humerus Axial Rotation',...
        'Humerus Adduction (-) / Abduction (+)',...
        'Humerus Elevation Plan: Posterior (-) / Anterior (+)',...
        'Ulna Extension (-) / Flexion (+)',...
        'Radius Supination (-) / Pronation (+)'};
    
 % Compute the kinematics
[jea, djeadt, d2jeadt2, xdata] = KINEMATICS_TOOL_compute_kinematics(AngleId, KEDATA);

% Create a figure
figure('color', 'white');
% The angle plot
subplot(3,1,1);
plot(xdata, jea, 'linewidth', 2);
set(gca, 'XDir', 'reverse', 'fontsize', 14);
title([MvtList{1, AngleId},' [DEG]'],...
    'fontsize', 16,...
    'fontweight', 'bold',...
    'fontname', 'sansserif');
ylabel('Angle [DEG]',...
    'fontsize', 16,...
    'fontweight', 'bold',...
    'fontname', 'sansserif');
grid on;

% The velocity plot
subplot(3,1,2);
plot(xdata(1,1:end-1), djeadt, 'linewidth', 2);
set(gca, 'XDir', 'reverse', 'fontsize', 14);
ylabel('Velocity [DEG/s]',...
    'fontsize', 16,...
    'fontweight', 'bold',...
    'fontname', 'sansserif');
grid on;

% The acceleration plot
subplot(3,1,3);
plot(xdata(1,1:end-2), d2jeadt2, 'linewidth', 2);
set(gca, 'XDir', 'reverse', 'fontsize', 14);
grid on;
ylabel('Acceleration [DEG/s^2]',...
    'fontsize', 16,...
    'fontweight', 'bold',...
    'fontname', 'sansserif');
xlabel('Humeral Abduction [DEG]',...
    'fontsize', 16,...
    'fontweight', 'bold',...
    'fontname', 'sansserif');