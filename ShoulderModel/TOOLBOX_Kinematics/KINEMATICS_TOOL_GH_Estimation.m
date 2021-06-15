
%%
figure
set(gcf,'position',[825   918   1600   900])
%view([90, 125]); % Setup the initial camera postion [0,0] is behind horizontally.
for i = 1:1:size(KEDATA.Point_Evolution.AC,2)
    
    
    center1 = KEDATA.Point_Evolution.AC(:,i);
    center2 = KEDATA.Point_Evolution.AA(:,i);
    center3 = KEDATA.Point_Evolution.EM(:,i);
    center4 = KEDATA.Point_Evolution.EL(:,i);
    
    % define one known configuration
    common_point = KEDATA.Point_Evolution.GH(:,1);
    initial_configuration1 = [KEDATA.Point_Evolution.AC(:,1), KEDATA.Point_Evolution.AA(:,1), common_point];
    initial_configuration2 = [KEDATA.Point_Evolution.EM(:,1), KEDATA.Point_Evolution.EL(:,1), common_point];
    
    if i == 1
        alpha0in = [0 0];
    else
        alpha0in = alpha;
    end
    
    [estimated_GH, alpha]= KINEMATICS_TOOL_four_sphere_intersect(center1, center2, center3, center4, initial_configuration1, initial_configuration2, alpha0in);
    
    if i== 1 
        zoom(1.8);
        view([330, 25]); % Setup the initial camera postion [0,0] is behind horizontally.
    end
    
    pause(0.2)
    cla
    estimated_GH_final(:,i) = 0.5*(estimated_GH(:,1) + estimated_GH(:,2));
end

% time = 1:1:size(KEDATA.Point_Evolution.AC,2);
% figure
% plot(time, KEDATA.Point_Evolution.GH(1,:),'r', time, estimated_GH_final(1,:),'b');
%%

i = 80;
 time = 1:1:size(KEDATA.Point_Evolution.AC,2);
figure
plot(time, KEDATA.Point_Evolution.GH);
hold on
plot(time, estimated_GH_final);


figure
for i = 1:1:size(KEDATA.Point_Evolution.AC,2)
    check_value(i) = norm(KEDATA.Point_Evolution.GH(:,i)-estimated_GH_final(:,i))
end

time = 1:1:size(KEDATA.Point_Evolution.AC,2);
plot(time,check_value)






