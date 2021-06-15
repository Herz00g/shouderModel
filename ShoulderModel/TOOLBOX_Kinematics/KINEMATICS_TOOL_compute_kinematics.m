function [jea, djeadt, d2jeadt2, xdata] = KINEMATICS_TOOL_compute_kinematics(AngleId, KEDATA)
% function for building the kinematics of a given motion
%--------------------------------------------------------------------------
% Syntax :
% [jea, djeadt, d2jeadt2, xdata] = KINEMATICS_TOOL_compute_kinematics(AngleId, KEDATA)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function generates the kinematics for one of the joint angles. Used
% when a graph in the kinematics tool gui is clicked on.
%--------------------------------------------------------------------------

% Define the Time Vector
t = linspace(0, 1, size(KEDATA.Joint_Angle_Evolution, 2));

% Compute the Velocity and Acceleration
djeat = zeros(1,size(KEDATA.Joint_Angle_Evolution, 2)-1);
d2jeadt2 = zeros(1,size(KEDATA.Joint_Angle_Evolution, 2)-2);

% Run through the motion
for TimeId = 1:size(KEDATA.Joint_Angle_Evolution, 2)-1
    % Compute Velocity
    djeadt(1,TimeId) = (KEDATA.Joint_Angle_Evolution(AngleId,TimeId+1) - KEDATA.Joint_Angle_Evolution(AngleId, TimeId))/(t(1,TimeId+1) - t(1,TimeId));
    
    % Compute Acceleration
    if TimeId < size(KEDATA.Joint_Angle_Evolution, 2)-1
        d2jeadt2(1,TimeId) = (KEDATA.Joint_Angle_Evolution(AngleId,TimeId+2) - 2*KEDATA.Joint_Angle_Evolution(AngleId, TimeId+1) + KEDATA.Joint_Angle_Evolution(AngleId, TimeId))/((t(1,TimeId+2) - t(1,TimeId+1))*(t(1,TimeId+1) - t(1,TimeId)));
    else
    end
end

% Define the outputs
jea = KEDATA.Joint_Angle_Evolution(AngleId,:)*180/pi;
djeadt = djeadt*180/pi;
d2jeadt2 = d2jeadt2*180/pi;

% The humeral abduction angle
xdata = KEDATA.Joint_Angle_Evolution(8,:)*180/pi;
return;