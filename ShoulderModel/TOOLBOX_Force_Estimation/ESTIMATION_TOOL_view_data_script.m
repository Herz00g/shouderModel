%--------------------------------------------------------------------------
%
%
% File Description :
% This is the script for creating individual force plots when the
% estimation process is over.
%
%--------------------------------------------------------------------------
% List of Muscle Naems
MSCNames = {'HU Joint Force',...% Scapulo-thoracic Force TS
            'RU Joint Force',...% Scapulo-thoracic Force AI
            'Subclavicular',...
            'Serratus Anterior Upper',...
            'Serratus Anterior Middle',...
            'Serratus Anterior Lower',...
            'Trapezius C1 - C6',...
            'Trapezius C7',...
            'Trapezius T1',...
            'Trapezius T2 - T7',...
            'Levator Scapulae',...
            'Rhomboid Minor',...
            'Rhomboid Major T1 - T2',...
            'Rhomboid Major T3 - T4',...
            'Pectorlis Minor',...
            'Pectoralis Major Clavicular',...
            'Pectoralis Major Sternal',...
            'Pectoralis Minor Ribs',...
            'Latissimus Dorsi Thoracic',...
            'Latissimus Dorsi Lumbar',...
            'Latissimus Dorsi Iliac',...
            'Deltoid Clavicular',...
            'Deltoid Acromial',...
            'Deltoid Scapular',...
            'Supraspinatus',...
            'Infraspinatus',...
            'Subscapularis',...
            'Teres Minor',...
            'Teres Major',...
            'Coracobrachialis',...
            'Triceps Brachii Long',...
            'Triceps Brachii Medial',...
            'Triceps Brachii Lateral',...
            'Biceps Brachii Short',...
            'Biceps Brachii Long',...
            'Brachialis',...
            'Brachioradialis',...
            'Supinator',...
            'Pronator Teres',...
            'Flexor Carpi Radialis',...
            'Flexor Carpi Ulnaris',...
            'Extensor Carpi Radialis Long',...
            'Extensor Carpi Radialis Brevis',...
            'Extensor Carpi Ulnaris',...
            'Joint Reaction Force',...
            'Stability'};
        
% in order to have the same ylim for the force graphs
for MuscleID = 1:44
    if MuscleID < 3
        maximum_forces(MuscleID) = max(JRDATA(1:end-2,4*(MuscleID+2)));
    else
        maximum_forces(MuscleID) = max(EFDATA{MuscleID, 1}.Forces(1:end-2,1));
    end   
end

ylimit = max(maximum_forces);



if isequal(get(ESGUIHandle.MenuOptions(2,4), 'checked'), 'off')
% -------------------------------------------------------------------------
% without kinematics data
% -------------------------------------------------------------------------
% Create a figure
figure('color', 'white')
colorList = {'red', 'blue', [0, 156, 0]/256, 'black', 'magenta', 'cyan'};
% Scapulothoracic plot
if MuscleId < 3
    % plot the constraint forces
    %plot(KEDATA.Joint_Angle_Evolution(8,1:end-2)'*180/pi, EFDATA{MuscleId, 1}.Forces(1:end-2,1), 'linewidth', 2, 'color', 'red');
    % plot the HU and RU joint reaction forces
    plot(KEDATA.Joint_Angle_Evolution(8,1:end-2)'*180/pi, JRDATA(1:end-2,4*(MuscleId+2)),'linewidth', 2);
    set(gca, 'XDir', 'reverse', 'fontsize', 14);
    ylim([0 ylimit]);
    grid on;
    box on
    title(MSCNames{1,MuscleId}, 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    xlabel('Humeral Abduction Angle [DEG]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    ylabel('Force [N]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');

% Muscle Force Plot
elseif MuscleId > 2 && MuscleId < 45
    hold on;
    for SegmentId = 1:MWDATA{MuscleId-2, 1}.MSCInfo.NbSegments
        plot(KEDATA.Joint_Angle_Evolution(8,1:end-2)'*180/pi, EFDATA{MuscleId, 1}.Forces(1:end-2,SegmentId), 'linewidth', 2, 'color', colorList{1, SegmentId});
        set(gca, 'XDir', 'reverse', 'fontsize', 14);
        ylim([0 ylimit]);
    end
    grid on;
    box on
    title([MSCNames{1,MuscleId}, ' Muslce Force'], 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    xlabel('Humeral Abduction Angle [DEG]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    ylabel('Force [N]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');

% Joint Force Intensity plot
elseif MuscleId == 45
    plot(KEDATA.Joint_Angle_Evolution(8,1:end-2)'*180/pi, JRDATA(1:end-2,4),'linewidth', 2);
    set(gca, 'XDir', 'reverse', 'fontsize', 14)
    grid on;
    title([MSCNames{1,MuscleId}], 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    xlabel('Humeral Abduction Angle [DEG]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    ylabel('Force [N]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');

% Glenohumeral Joint Stability plot
elseif MuscleId == 46

    teta = linspace(0, 2*pi, 100);
    Hay = DYDATA.ConeDimensions(1);
    Haz = DYDATA.ConeDimensions(2);
    
    Py = Hay*cos(teta);
    Pz = Haz*sin(teta);
    plot(Py, Pz, 'color', [0.7 0.7 0.7], 'linewidth', 2);
    hold on;
    scatter(JRDATA(1:end-2,6), JRDATA(1:end-2,7),'marker', 'o');
    plot(JRDATA(1,6), JRDATA(1,7), 'marker', 'o','markersize', 12, 'MarkerFaceColor', 'green');
    plot(JRDATA(end-2,6), JRDATA(end-2,7),  'marker', 'o', 'markersize', 12, 'MarkerFaceColor', 'red');
    title('intersection locus of the GHJ reaction force and the glenoid fossa (green o = start, red o = end)', 'fontsize', 12, 'fontname', 'sansserif', 'fontweight', 'bold');
    xlabel('posterior-anterior', 'fontsize', 14, 'fontname', 'sansserif');
    ylabel('inferior-superior', 'fontsize', 14, 'fontname', 'sansserif');
    axis equal
end


else
% -------------------------------------------------------------------------
% with kinematics data
% -------------------------------------------------------------------------

% Create a figure
figure('units', 'normalized',...
       'position', [0.2, 0.3, 0.3, 0.3], 'color', 'white')
colorList = {'red', 'blue', [0, 156, 0]/256, 'black', 'magenta', 'cyan'};
% Scapulothoracic plot
if MuscleId < 3
    % plot the constraint forces
    plot(SSDATA.Joint_Angle_Reconstruction(8,1:end-2)'*180/pi, EFDATA{MuscleId, 1}.Forces(:,1), 'linewidth', 2, 'color', 'red');
    % plot the HU and RU joint reaction forces
    plot(SSDATA.Joint_Angle_Reconstruction(8,1:end-2)'*180/pi, JRDATA(:,4*(MuscleId+2)),'linewidth', 2);
    set(gca, 'XDir', 'reverse', 'fontsize', 14);
    ylim([0 ylimit]);
    box on
    grid on;
    title(MSCNames{1,MuscleId}, 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    xlabel('Humeral Abduction Angle [DEG]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    ylabel('Force [N]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
  
% Muscle Force Plot
elseif MuscleId > 2 && MuscleId < 45
    hold on;
    for SegmentId = 1:MWDATA{MuscleId-2, 1}.MSCInfo.NbSegments
        plot(SSDATA.Joint_Angle_Reconstruction(8,1:end-2)'*180/pi, EFDATA{MuscleId, 1}.Forces(:,SegmentId), 'linewidth', 2, 'color', colorList{1, SegmentId});
        set(gca, 'XDir', 'reverse', 'fontsize', 14);
        ylim([0 ylimit]);
    end
    box on
    grid on;
    title([MSCNames{1,MuscleId}, ' Muscle Force'], 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    xlabel('Humeral Abduction Angle [DEG]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    ylabel('Force [N]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');

% Joint Force Intensity plot
elseif MuscleId == 45
    plot(SSDATA.Joint_Angle_Reconstruction(8,1:end-2)'*180/pi, JRDATA(:,4),'linewidth', 2);
    set(gca, 'XDir', 'reverse', 'fontsize', 14)
    grid on;
    title([MSCNames{1,MuscleId}], 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    xlabel('Humeral Abduction Angle [DEG]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    ylabel('Force [N]', 'fontsize', 14, 'fontname', 'sansserif', 'fontweight', 'bold');
    
% Glenohumeral Joint Stability plot
elseif MuscleId == 46

    teta = linspace(0, 2*pi, 100);
    Hay = DYDATA.ConeDimensions(1);
    Haz = DYDATA.ConeDimensions(2);
    
    Py = Hay*cos(teta);
    Pz = Haz*sin(teta);
    plot(Py, Pz, 'color', [0.7 0.7 0.7], 'linewidth', 2);
    hold on;
    scatter(JRDATA(:,6), JRDATA(:,7),'marker', 'o');
    plot(JRDATA(1,6), JRDATA(1,7), 'marker', 'o','markersize', 12, 'MarkerFaceColor', 'green');
    plot(JRDATA(end,6), JRDATA(end,7),  'marker', 'o', 'markersize', 12, 'MarkerFaceColor', 'red');
    title('intersection locus of the GHJ reaction force and the glenoid fossa (green o = start, red o = end)', 'fontsize', 12, 'fontname', 'sansserif', 'fontweight', 'bold');
    xlabel('posterior-anterior', 'fontsize', 14, 'fontname', 'sansserif');
    ylabel('inferior-superior', 'fontsize', 14, 'fontname', 'sansserif');
    axis equal
    set(gca, 'fontsize', 14);
end

end

%clear MSCNames LineTypeList t_org t MuscleID maximum_forces ylimit MuscleId teta Hay Haz Py Pz
