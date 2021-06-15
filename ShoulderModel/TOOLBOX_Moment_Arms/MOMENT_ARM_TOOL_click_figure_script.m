%{
--------------------------------------------------------------------------
Function Description :
This script is run when the a figure in the MOMENT_ARM_TOOL_main_file is
clicked on.
Note that the moment arm data includes only the matrix C of page 86. In
other world, it's not the generalized moment arm (W*C).
--------------------------------------------------------------------------
%}

% Create A new Figure
figure('color', 'white');

% first chose among the two available options for the kinematics
if isfield(SSDATA, 'Joint_Angle_Reconstruction')
    % Create the Time
    JEA = SSDATA.Joint_Angle_Reconstruction;
    %Time = linspace(0, 1, size(KEDATA.Joint_Angle_Evolution,2));    
else
    % option 1: use the joint angles acieved directly from the IK
    JEA = KEDATA.Joint_Angle_Evolution;
    %Time = SSDATA.time;
    
end
   

    for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments;
        % Create a plot of the SC joint moment arms
        subplot(4,2,1);
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MomentArms{1,SegmentId}(:,1:3), 'linewidth', 2);
        hold on;
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MomentArmsNum{1,SegmentId}(:,1:3), 'linewidth', 2, 'linestyle', '--');
        title('SC joint moment-arms (Geometric & Tendon Excursion)',...
            'fontweight', 'bold',...
            'fontsize', 16,...
            'fontname', 'sansserif');
        set(gca, 'XDir', 'reverse', 'fontsize', 14);

        % Create a plot of the AC joint moment arms
        subplot(4,2,2);
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MomentArms{1,SegmentId}(:,4:6), 'linewidth', 2);
        hold on;
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MomentArmsNum{1,SegmentId}(:,4:6), 'linewidth', 2, 'linestyle', '--');
        title('AC joint moment-arms (Geometric & Tendon Excursion)',...
            'fontweight', 'bold',...
            'fontsize', 16,...
            'fontname', 'sansserif');
        set(gca, 'XDir', 'reverse', 'fontsize', 14);

        % Create a plot of the GH joint moment arms
        subplot(4,2,3);
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MomentArms{1,SegmentId}(:,7:9), 'linewidth', 2);
        hold on;
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MomentArmsNum{1,SegmentId}(:,7:9), 'linewidth', 2, 'linestyle', '--');
        title('GH joint moment-arms (Geometric & Tendon Excursion)',...
            'fontweight', 'bold',...
            'fontsize', 16,...
            'fontname', 'sansserif');
        set(gca, 'XDir', 'reverse', 'fontsize', 14);

        % Create a plot of the HU joint moment arms
        subplot(4,2,4);
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MomentArms{1,SegmentId}(:,10:12), 'linewidth', 2);
        hold on;
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MomentArmsNum{1,SegmentId}(:,10:12), 'linewidth', 2, 'linestyle', '--');
        title('HU joint moment-arms (Geometric & Tendon Excursion)',...
            'fontweight', 'bold',...
            'fontsize', 16,...
            'fontname', 'sansserif');
        set(gca, 'XDir', 'reverse', 'fontsize', 14);

        % Create a plot of the RU joint moment arms
        subplot(4,2,5);
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MomentArms{1,SegmentId}(:,13:15), 'linewidth', 2);
        hold on;
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MomentArmsNum{1,SegmentId}(:,13:15), 'linewidth', 2, 'linestyle', '--');
        title('RU joint moment-arms (Geometric & Tendon Excursion)',...
            'fontweight', 'bold',...
            'fontsize', 16,...
            'fontname', 'sansserif');
        set(gca, 'XDir', 'reverse', 'fontsize', 14);

        % GH joint moment arms in the scapular plane
        subplot(4,2,7);
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.ScapularPlane{1,SegmentId}(:,7:9), 'linewidth', 2);
        title('GH joint moment-arms (scapular plane)',...
            'fontweight', 'bold',...
            'fontsize', 16,...
            'fontname', 'sansserif');
        set(gca, 'XDir', 'reverse', 'fontsize', 14);

        
        % GH joint moment arms in the Garner & Pandy scapular plane
        subplot(4,2,8);
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.ScapularPlane_GnP{1,SegmentId}(:,7:9), 'linewidth', 2);
        title('GH joint moment-arms (scapular plane, G & P)',...
            'fontweight', 'bold',...
            'fontsize', 16,...
            'fontname', 'sansserif');
        set(gca, 'XDir', 'reverse', 'fontsize', 14);

        % Plot the muscle length
        subplot(4,2,6);
        plot(JEA(8,:)'*180/pi, MADATA{MuscleId, 1}.MuscleLength(:,SegmentId), 'linewidth', 2);
        title('Muscle Segment Lengths [m]',...
            'fontweight', 'bold',...
            'fontsize', 16,...
            'fontname', 'sansserif');
        set(gca, 'XDir', 'reverse', 'fontsize', 14);
    end
   