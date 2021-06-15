%{
--------------------------------------------------------------------------
  Small script for plotting the smoothened generalized velocities and accelerations
--------------------------------------------------------------------------
File Description :
This script upon on clicking on one of the plots in the KRPlotHandles.Plot_IK_UiPanel
panel will be activated and will plot a detailed graph including the
generalized coordinates, velocities, and accelerations associated with the
initial plot.
--------------------------------------------------------------------------
%}
% creat the time
    % take the motion time span
    final_time = str2double(get(KRGUIHandle.TimeFrameEdit, 'string'));

    % define the elapsed time necessary to connect knot i-1 to i
    max_frame = 100*final_time;
    %h = final_time/(length(SSDATA.Measured_Kinematics.IJ)-1);
    h = final_time/(max_frame-1);


    % creat the time
    time = 0: h: final_time;
    
% define numerical values of the acceleration, velocity, and coordinate for
% the specific GC_id
if GC_id == 1
    
    % option 2: smoothening them first and then using them
    GC(1,:) = polyval(SSDATA.Joint_Angle_Coefficients(GC_id, :), time);
	GV(1,:) = polyval(SSDATA.Joint_Velocity_Coefficients(GC_id, :), time(1, 1:end-1));
	GA(1,:) = polyval(SSDATA.Joint_Acceleration_Coefficients(GC_id, :), time(1, 1:end-2));

else
    
    % option 1: direct use of the reconstructed angles from IK
    GC(1,:) = SSDATA.Joint_Angle_Reconstruction(GC_id, :);
    GV = [];
    GA = [];
    for TimeId = 1:length(time)-1
        GV = [GV, (GC(1,TimeId+1) - GC(1,TimeId))/(time(TimeId+1) - time(TimeId))];
        if TimeId < length(time)-1
            % Acceleration
            GA = [GA, (GC(1,TimeId+2) - 2*GC(1,TimeId+1) + GC(1,TimeId))/((time(TimeId+2) - time(TimeId+1))*(time(TimeId+1) - time(TimeId)))];
        end
    end
end

% option 2: smoothening them first and then using them
GC(1,:) = polyval(SSDATA.Joint_Angle_Coefficients(GC_id, :), time);
% GV(1,:) = polyval(SSDATA.Joint_Velocity_Coefficients(GC_id, :), time);
% GA(1,:) = polyval(SSDATA.Joint_Acceleration_Coefficients(GC_id, :), time);
    
% creat plot title list
title_list = {'clavicle axial rotation',...
              'clavicle depression/elevation',...
              'clavicle retraction/protraction',...
              'scapula external/internal tilt',...
              'scapula depression/elevation',...
              'scapula retraction/protraction',...
              'humerus axial rotation',...
              'humerus adduction/abduction',...
              'humerus flexion/extension',...%plan humerus elevation plane posterior/anterior
              'ulna extension/flexion',...
              'radius supination/pronation'};
          
% creat figure name          
KRPlotHandles.ClickOn = figure('color', 'white',...
                               'units', 'normalized',...
                               'position', [0.2, 0.3, 0.2, 0.4],...
                               'name', 'EPFL - LBO Upper Extremity Model: Click On plots, reconstructed motion');

% creat the plots
% GC
    subplot(3,1,1);
    plot(time, (180/pi)*GC(1,:), 'k', 'LineWidth', 2); hold on;
    plot(time, (180/pi)*SSDATA.Joint_Angle_Reconstruction(GC_id,:),'o', 'MarkerFaceColor', 'b','MarkerSize', 3);
    xlabel('time [s]','fontsize',14);
    ylabel(['q_',num2str(GC_id),'[deg]'],'fontsize',14);
    set(gca,'FontSize',14);
    title(title_list{1, GC_id},'fontsize',16,'fontweight','normal' );
    xlim([0,final_time]);
    legend('point-wise IK solution','smoothened solution', 'Location','best')
    grid on
% GV
    subplot(3,1,2);
    plot(time(1,1:end - 1), GV(1,:), 'k', 'LineWidth', 2); % for option 2: time(1, :)
    xlabel('time [s]','fontsize',14);
    ylabel(['dq_',num2str(GC_id),'[rad/s]'],'fontsize',14);
    set(gca,'FontSize',14);
    %title(title_list{1, GC_id},'fontsize',16,'fontweight','normal' );
    xlim([0,final_time]);
    grid on
% GA
    subplot(3,1,3);
    plot(time(1,1:end - 2), GA(1,:), 'k','LineWidth', 2); % for option 2: time(1, :)
    xlabel('time [s]','fontsize',14);
    yLabel = ylabel(['ddq_',num2str(GC_id),'[rad/s^2]'],'fontsize',14);
    set(gca,'FontSize',14);
    %title(title_list{1, GC_id},'fontsize',16,'fontweight','normal' );
    xlim([0,final_time]);    
    grid on
clear GC GV GA