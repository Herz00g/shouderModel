%
% POSTPROCESSING CSA ANALYSIS
%

clear all; close all; clc;

% create plots
figure();
plotDeltoidAnt = subplot(2,3,1); hold on; title('Anterior Deltoid'); xlabel('Abduction Angle [deg]');ylabel('Muscle Force [N]');
plotDeltoidMid = subplot(2,3,2); hold on; title('Middle Deltoid'); xlabel('Abduction Angle [deg]');ylabel('Muscle Force [N]');
plotDeltoidPost = subplot(2,3,3); hold on; title('Posterior Deltoid'); xlabel('Abduction Angle [deg]');ylabel('Muscle Force [N]');
plotSupraspinatus = subplot(2,3,4); hold on; title('Supraspinatus'); xlabel('Abduction Angle [deg]');ylabel('Muscle Force [N]');
plotInfraspinatus = subplot(2,3,5); hold on; title('Infraspinatus'); xlabel('Abduction Angle [deg]');ylabel('Muscle Force [N]');
plotSubscapularis = subplot(2,3,6); hold on; title('Subscapularis'); xlabel('Abduction Angle [deg]');ylabel('Muscle Force [N]');

overalltitle = suptitle(sprintf('CSA Dependant Shoulder Muscle Forces\nblue=28°, green=33°, red=38°'));

files={'25','33','41'};
colors={'blue','green','red'};

figure();
plotJointReaction = subplot(1,2,1); hold on; title('Joint Reaction Force');xlabel('Abduction Angle [deg]'); ylabel('Reaction Force [N]');
plotJointStability = subplot(1,2,2); hold on; title('Joint Stability (green x = start');
teta = linspace(0, 2*pi, 100);
Hay = 0.0119;
Haz = 0.0156;    
Py = Hay*cos(teta);
Pz = Haz*sin(teta);
plot(Py, Pz, 'color', 'red', 'linewidth', 2);
axis([-0.03,0.03,-0.03,0.03]);
axis equal;
overalltitle = suptitle(sprintf('CSA Dependant Glenohumeral Joint Reaction Forces\nblue=28°, green=33°, red=38°'));

plotlimit = 62;

% pythonstyle: for file in names:

for i=1:length(files)
    
    efdata=['EFDATA_CSA' files{i} '.mat'];
    jrdata=['JRDATA_CSA' files{i} '.mat'];
    kedata=['KEDATA_CSA' files{i} '.mat'];
    
    load(efdata);
    load(jrdata);    
    load(kedata);
    
    % plot Deltoid forces 22 23 24
    plot(plotDeltoidAnt, -KEDATA.Joint_Angle_Evolution(8,1:plotlimit)'*180/pi, sum(EFDATA{22, 1}.Forces(1:plotlimit,1:20)'), 'linewidth', 2, 'color', colors{i});
    plot(plotDeltoidMid,  -KEDATA.Joint_Angle_Evolution(8,1:plotlimit)'*180/pi, sum(EFDATA{23, 1}.Forces(1:plotlimit,1:20)'), 'linewidth', 2, 'color', colors{i});
    plot(plotDeltoidPost, -KEDATA.Joint_Angle_Evolution(8,1:plotlimit)'*180/pi,  sum(EFDATA{24, 1}.Forces(1:plotlimit,1:20)'), 'linewidth', 2, 'color', colors{i});
    
    % rotator cuff 25 26 27
    plot(plotSupraspinatus, -KEDATA.Joint_Angle_Evolution(8,1:plotlimit)'*180/pi,  sum(EFDATA{25, 1}.Forces(1:plotlimit,1:20)'), 'linewidth', 2, 'color', colors{i});
    plot(plotInfraspinatus, -KEDATA.Joint_Angle_Evolution(8,1:plotlimit)'*180/pi,  sum(EFDATA{26, 1}.Forces(1:plotlimit,1:20)'), 'linewidth', 2, 'color', colors{i});
    plot(plotSubscapularis, -KEDATA.Joint_Angle_Evolution(8,1:plotlimit)'*180/pi,  sum(EFDATA{27, 1}.Forces(1:plotlimit,1:20)'), 'linewidth', 2, 'color', colors{i});
    
    % joint reaction force
    plot(plotJointReaction,-KEDATA.Joint_Angle_Evolution(8,1:plotlimit)'*180/pi, JRDATA(1:plotlimit,4), 'linewidth', 2, 'color', colors{i});
    
    % joint stability
    plot(plotJointStability,JRDATA(1:plotlimit,6), JRDATA(1:plotlimit,7), 'linewidth', 2, 'marker', 'x','color', colors{i});
    plot(plotJointStability,JRDATA(1,6), JRDATA(1,7), 'linewidth', 2, 'marker', 'x', 'color', 'green');
    plot(plotJointStability,JRDATA(plotlimit,6), JRDATA(plotlimit,7), 'linewidth', 2, 'marker', 'x', 'color', 'red');
end
    
