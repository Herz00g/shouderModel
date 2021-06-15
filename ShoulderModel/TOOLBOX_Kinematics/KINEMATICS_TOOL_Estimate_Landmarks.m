function [SSDATA, BLDATA] = KINEMATICS_TOOL_Estimate_Landmarks(KRHandle, KRPlotHandles, SSDATAin, BLDATAin)
%{
Function to load/check a measured kinematics to the model.
--------------------------------------------------------------------------
Syntax :

--------------------------------------------------------------------------
File Description :

--------------------------------------------------------------------------
%}

% initialize the SSDATA
SSDATA = SSDATAin;
BLDATA = BLDATAin;
% ------------------------------------------------------------------------
% 1) Estimate the AC landmark
% ------------------------------------------------------------------------
% The anathomical AC landmark is normally covered by the anterior deltoid.
% Therefore, a good practice is to pulpate a point on clavicle right before
% where the anterior deltoid wraps over the clavicle. Nevertheless, we now
% need to estimate the real AC landmark. To this end, the length of SC-AC
% is required. Provided this length we can define the AC (real) by the
% intersection of a sphere centered at SC with SC-AC radius and a line
% passing from SC to Ac (measured). SC-AC is clavicle length.

% display message
disp(['Estimating AC']);

% Given value for the clavicle length
clavicle_length = norm(BLDATA.Initial_Points.SC(:,1) - BLDATA.Initial_Points.AC(:,1));

% run throughout the measured motion
for TimeId = 1:length(SSDATA.Measured_Kinematics.IJ)
    
    % define the line unit direction vector
    direction_vector = SSDATA.Measured_Kinematics.Ac(:,TimeId) - SSDATA.Measured_Kinematics.SC(:,TimeId);
    direction_vector = direction_vector/norm(direction_vector);
    
    % deine the line parameter at the intersections point
    lambda = ((clavicle_length^2)/(norm(direction_vector)^2))^0.5;
    
    % define the real AC landmark
    SSDATA.Measured_Kinematics.AC(:,TimeId) = SSDATA.Measured_Kinematics.SC(:,TimeId) + lambda*direction_vector;
 
end

% ------------------------------------------------------------------------
% 2) Estimate the GH landmark
% ------------------------------------------------------------------------
% one single initial configuration for (AC, AA, GH) and (EM, EL, GH). In
% fact we just need one single Radiology or MRI to see where GH is in the
% thorax frame. If we do not have this then we can define this single
% configuration though predictive equations of body segments and landmarks.

% AC, AA, GH
initial_configuration1 = [SSDATA.Measured_Kinematics.AC(:,1), ...
                          SSDATA.Measured_Kinematics.AA(:,1), ...
                          BLDATA.Initial_Points.GH(:,1)]; % for now we take GH from our scaled model, which is
                                                          % correct as it's the same subject that we had MRI for
% EM, EL, GH                                                   
initial_configuration2 = [SSDATA.Measured_Kinematics.EM(:,1), ...%EM
                          SSDATA.Measured_Kinematics.EL(:,1), ...
                          BLDATA.Initial_Points.GH(:,1)];

% radii1 = [norm(initial_configuration1(:,1) - initial_configuration1(:,3)), ...
%          norm(initial_configuration1(:,2) - initial_configuration1(:,3))];
% radii2 = [norm(initial_configuration2(:,1) - initial_configuration2(:,3)), ...
%          norm(initial_configuration2(:,2) - initial_configuration2(:,3))];     
% run throughout the measured motion
for TimeId = 1:length(SSDATA.Measured_Kinematics.IJ)
    
    % display message
    disp(['Estimating GH, Time Stamp : ', num2str(TimeId), '/', num2str(length(SSDATA.Measured_Kinematics.IJ))]);
    
    %{
    % Approach 2: ---------------------------------------------------------
    % estimating the GH as the intersection of four spheres
    
    center1 = SSDATA.Measured_Kinematics.AC(:,TimeId);
    center2 = SSDATA.Measured_Kinematics.AA(:,TimeId);
    center3 = SSDATA.Measured_Kinematics.EM(:,TimeId);%EM
    center4 = SSDATA.Measured_Kinematics.EL(:,TimeId);
    
    if TimeId == 1
        alpha0in = [0.3 0.3]; % initial guess for the parametrization angles of the two intersecting conic sections.
                      % A conic section is a function of alpha.
    else
        alpha0in = alpha_GH;
    end
     
    
    if TimeId == 1
        initial_guess = 0*ones(1, 4);
    else
        initial_guess = centers_parameters;
    end
    
    
    
    
    
    [estimated_GH, alpha_GH, H_PS2T1, H_PS2T2, centers_parameters] = KINEMATICS_TOOL_four_sphere_intersect(center1, center2,...
                                                       center3, center4, initial_configuration1, initial_configuration2, alpha0in, initial_guess);
                                                   
   
%         if TimeId == 1
% 
%         [estimated_GH, alpha_GH, H_PS2T1, H_PS2T2] = KINEMATICS_TOOL_four_sphere_intersect(center1, center2,...
%                                                          center3, center4, radii1, radii2, alpha0in);
%         d1 = norm(estimated_GH(:, 1) - H_PS2T1(1:3, 4));
%         d2 = norm(estimated_GH(:, 2) - H_PS2T2(1:3, 4));
%         
%         p = norm(estimated_GH(:, 1) - estimated_GH(:, 2));
%         
%         Zh = (estimated_GH(:,1) + estimated_GH(:,2))/2 - (center3+center4)/2; Zh = Zh/norm(Zh);
%         Yh = cross((estimated_GH(:,1) + estimated_GH(:,2))/2 - center4, center3 - center4); Yh = Yh/norm(Yh);
%         Xh = cross(Yh, Zh); Xh = Xh/norm(Xh);
%         Rh = [Xh, Yh, Zh];
%         
%         end
%     
%         
%         [estimated_GH, alpha_GH, H_PS2T1, H_PS2T2] = KINEMATICS_TOOL_four_sphere_intersect(center1, center2,...
%                                         center3-Rh*[0 0 p]', center4-Rh*[0 0 p]', radii1, radii2, alpha0in);  
% 
%         Zh = (estimated_GH(:,1) + estimated_GH(:,2))/2 - (center3+center4)/2; Zh = Zh/norm(Zh);
%         Yh = cross((estimated_GH(:,1) + estimated_GH(:,2))/2 - center4, center3 - center4); Yh = Yh/norm(Yh);
%         Xh = cross(Yh, Zh); Xh = Xh/norm(Xh);
%         Rh = [Xh, Yh, Zh]; 
%         
%         
%         
%         
%         
%         
% 
%          p = norm(estimated_GH(:, 1) - estimated_GH(:, 2))
%          
%          r_cor_AC = sqrt((norm(estimated_GH(:, 1) - H_PS2T1(1:3, 4)) - p/(1 + d2/d1))^2 + ...
%                          norm(SSDATA.Measured_Kinematics.AC(:,TimeId) - H_PS2T1(1:3, 4))^2);
%          r_cor_AA = sqrt((norm(estimated_GH(:, 1) - H_PS2T1(1:3, 4)) - p/(1 + d2/d1))^2 + ...
%                          norm(SSDATA.Measured_Kinematics.AA(:,TimeId) - H_PS2T1(1:3, 4))^2);
%          r_cor_EM = sqrt((norm(estimated_GH(:, 2) - H_PS2T2(1:3, 4)) - p/(1 + d1/d2))^2 + ...
%                          norm(SSDATA.Measured_Kinematics.EM(:,TimeId) - H_PS2T2(1:3, 4))^2);                                            
%          r_cor_EL = sqrt((norm(estimated_GH(:, 2) - H_PS2T2(1:3, 4)) - p/(1 + d1/d2))^2 + ...
%                          norm(SSDATA.Measured_Kinematics.EL(:,TimeId) - H_PS2T2(1:3, 4))^2);
%                      
%          [estimated_GH, alpha_GH, H_PS2T1, H_PS2T2] = KINEMATICS_TOOL_four_sphere_intersect(center1, center2,...
%                                         center3-Rh*[0 0 p]', center4-Rh*[0 0 p]', radii1, radii2, alpha0in);            
%     
         
         SSDATA.Measured_Kinematics.GH(:,TimeId) = (estimated_GH(:,1) + estimated_GH(:,2))/2;
    
%     if TimeId > 1
%     if norm(estimated_GH(:, 2) - H_PS2T1(1:3, 4)) > 0.99*pen_criteria
%         SSDATA.Measured_Kinematics.GH(:,TimeId) = estimated_GH(:,2);
%     else
%         r_compensation = pen_criteria - norm(estimated_GH(:, 2) - H_PS2T1(1:3, 4));
%         
%         r1_new = sqrt((norm(estimated_GH(:, 2) - H_PS2T2(1:3, 4)) - r_compensation)^2 + norm(H_PS2T2(1:3, 4) - center3)^2);
%         r2_new = sqrt((norm(estimated_GH(:, 2) - H_PS2T2(1:3, 4)) - r_compensation)^2 + norm(H_PS2T2(1:3, 4) - center4)^2);
%     radii2 = [r1_new r2_new];    
%     [estimated_GH, alpha_GH, H_PS2T1, H_PS2T2] = KINEMATICS_TOOL_four_sphere_intersect(center1, center2,...
%                                                         center3, center4, radii1, radii2, alpha0in);        
%     end
%     end
    
    % save the estimated GH evolutions. Note that above gives always to estimated point for each time step.                
    %SSDATA.Measured_Kinematics.GH(:,TimeId) = estimated_GH(:,2);

%    pause(0.3)
%     str1 = ['frame = ',num2str(TimeId)]; % show the abduction angle on the plot
%     str1_prop = annotation('textbox',[0.01 0.01 0.5 0.05],'String',str1,'FitBoxToText','off','BackgroundColor','w');
%     str1_prop.FontSize = 16;
%     cla
%     if TimeId == 1
%         pen_criteria = norm(SSDATA.Measured_Kinematics.GH(:,1) - H_PS2T1(1:3, 4));
%      
%     end
    
 %}   
  
    % approach 2: ---------------------------------------------------------
    % estimating the GH based on a fixed displacement with respect to AC
    % and AA
    GH_cor1 = BLDATA.Initial_Points.GH - BLDATA.Initial_Points.AC;
    GH_cor2 = BLDATA.Initial_Points.GH - BLDATA.Initial_Points.AA;
    
    GH_est1 = SSDATA.Measured_Kinematics.AC(:,TimeId) + GH_cor1;
    GH_est2 = SSDATA.Measured_Kinematics.AA(:,TimeId) + GH_cor2;
    
    SSDATA.Measured_Kinematics.GH(:,TimeId) = (GH_est1 + GH_est2)/2;
    %}
    
    % approach 3: regression model from doi:10.1016/j.jbiomech.2009.03.039
%     SSDATA.Measured_Kinematics.GH(:,TimeId) = [(66.468-(0.531*norm(0.5*(SSDATA.Measured_Kinematics.AA(:,TimeId)+SSDATA.Measured_Kinematics.AC(:,TimeId))-0.5*(SSDATA.Measured_Kinematics.IJ(:,TimeId)+SSDATA.Measured_Kinematics.C7(:,TimeId))))+(0.571*85.5));
%                                                (96.2-(0.302*norm(SSDATA.Measured_Kinematics.IJ(:,TimeId)-SSDATA.Measured_Kinematics.C7(:,TimeId)))-(0.364*186)+(0.385*85.5));
%                                               -66.32+(0.3*norm(SSDATA.Measured_Kinematics.IJ(:,TimeId)-SSDATA.Measured_Kinematics.C7(:,TimeId)))-(0.432*85.5)];


%    SSDATA.Measured_Kinematics.GH(:,TimeId) = SSDATA.Measured_Kinematics.AA(:,TimeId) + [0 0 -70]';

%    SSDATA.Measured_Kinematics.GH(:,TimeId) = 0.5*(SSDATA.Measured_Kinematics.AA(:,TimeId)+SSDATA.Measured_Kinematics.AC(:,TimeId)) + [6 12 -49]';
end

% ------------------------------------------------------------------------
% 3) Estimate the HU landmark
% ------------------------------------------------------------------------    
% This landmark is very easy to estimate as it lies on the middle point of
% EM and EL throughout the motion.

% display message
disp(['Estimating HU']);

SSDATA.Measured_Kinematics.HU = 0.5*(SSDATA.Measured_Kinematics.EM + SSDATA.Measured_Kinematics.EL);

% ------------------------------------------------------------------------
% 4) Estimate the CP landmark
% ------------------------------------------------------------------------
% defining where CP lies between EM and EL, and use the same ratio
% throughout the motion. In fact, what I did for HU and what I am doing for
% CP can be categorized in using the predictive equations to find out where
% the missing points are.

% display message
disp(['Estimating CP']);

a_factor = norm(BLDATA.Initial_Points.EM(:,1)-BLDATA.Initial_Points.CP(:,1));
b_factor = norm(BLDATA.Initial_Points.EL(:,1)-BLDATA.Initial_Points.CP(:,1));

SSDATA.Measured_Kinematics.CP = SSDATA.Measured_Kinematics.EM + (a_factor/(a_factor + b_factor))*(SSDATA.Measured_Kinematics.EL - SSDATA.Measured_Kinematics.EM);

% ------------------------------------------------------------------------
% 5) Estimate the TS and AI landmark (scapula kinematics)
% ------------------------------------------------------------------------
% Given that we do not have any specific scapula measurement tools, the
% evolutions of lanmarks TS and AI should be also estimated. To this end,
% we build on the estimated evolutions of landmark GH estimate the landmarks
% AI and TS. TS for instance, lies at the intersections of 3 spheres
% centered at AA, AC, and GH with radii that can be defined from one known
% initial configuration of the scapula using for instance one single MRI or
% Radiology image. I use the intersection of 4 spheres considering one
% redundant sphere, for instance AC. In other words, intersection of
% spheres centered at AA, AC, AC, and GH.

% AC, AA, TS
initial_configuration1 = [SSDATA.Measured_Kinematics.AC(:,1), ...
                          SSDATA.Measured_Kinematics.AA(:,1), ...
                          BLDATA.Initial_Points.TS(:,1)];
                      
% GH, AC, TS                                                   
initial_configuration2 = [SSDATA.Measured_Kinematics.GH(:,1), ...
                          SSDATA.Measured_Kinematics.AC(:,1), ...
                          BLDATA.Initial_Points.TS(:,1)];
                      
                      
% AC, AA, AI
initial_configuration3 = [SSDATA.Measured_Kinematics.AC(:,1), ...
                          SSDATA.Measured_Kinematics.AA(:,1), ...
                          BLDATA.Initial_Points.AI(:,1)];
                      
% GH, AC, AI                                                   
initial_configuration4 = [SSDATA.Measured_Kinematics.GH(:,1), ...
                          SSDATA.Measured_Kinematics.AC(:,1), ...
                          BLDATA.Initial_Points.AI(:,1)];                      
                      
                      
% run throughout the measured motion
for TimeId = 1:length(SSDATA.Measured_Kinematics.IJ)
    
    % display message
    disp(['Estimating TS and AI, Time Stamp : ', num2str(TimeId), '/', num2str(length(SSDATA.Measured_Kinematics.IJ))]);

    
    Zs = (SSDATA.Measured_Kinematics.AA(:,TimeId) + SSDATA.Measured_Kinematics.AC(:,TimeId))/2 - ...
         SSDATA.Measured_Kinematics.GH(:,TimeId);
    Xs = cross(SSDATA.Measured_Kinematics.AA(:,TimeId) - SSDATA.Measured_Kinematics.AC(:,TimeId) , ...
               SSDATA.Measured_Kinematics.GH(:,TimeId) - SSDATA.Measured_Kinematics.AC(:,TimeId));
    Ys = cross(Zs, Xs);
    R_s2m = [Xs/norm(Xs) Ys/norm(Ys) Zs/norm(Zs)];
    
    if TimeId == 1
    TS_in_s = R_s2m'*BLDATA.Initial_Points.TS(:,1) - R_s2m'*SSDATA.Measured_Kinematics.AC(:,TimeId);
    AI_in_s = R_s2m'*BLDATA.Initial_Points.AI(:,1) - R_s2m'*SSDATA.Measured_Kinematics.AC(:,TimeId);
    end
    
    SSDATA.Measured_Kinematics.TS(:,TimeId) = R_s2m*TS_in_s + SSDATA.Measured_Kinematics.AC(:,TimeId);
    SSDATA.Measured_Kinematics.AI(:,TimeId) = R_s2m*AI_in_s + SSDATA.Measured_Kinematics.AC(:,TimeId);
    %}   
    %{
    % Estimate TS
    center1 = SSDATA.Measured_Kinematics.AC(:,TimeId);
    center2 = SSDATA.Measured_Kinematics.AA(:,TimeId);
    center3 = SSDATA.Measured_Kinematics.GH(:,TimeId);
    center4 = SSDATA.Measured_Kinematics.AC(:,TimeId);
    
    if TimeId == 1
        alpha0in = [0.1 0.1]; % initial guess for the parametrization angles of the two intersecting conic sections.
                      % A conic section is a function of alpha.
    else
        alpha0in = alpha_TS;
    end
    [estimated_TS, alpha_TS] = KINEMATICS_TOOL_four_sphere_intersect(center1, center2,...
                            center3, center4, initial_configuration1, initial_configuration2, alpha0in,0);
                    
    % save the estimated TS evolutions. Note that above gives always to estimated point for each time step.                
    SSDATA.Measured_Kinematics.TS(:,TimeId) = estimated_TS(:,1);
    
    % Estimate AI
    center1 = SSDATA.Measured_Kinematics.AC(:,TimeId);
    center2 = SSDATA.Measured_Kinematics.AA(:,TimeId);
    center3 = SSDATA.Measured_Kinematics.GH(:,TimeId);
    center4 = SSDATA.Measured_Kinematics.AC(:,TimeId);
    if TimeId == 1
        alpha0in = [0.1 0.5]; % initial guess for the parametrization angles of the two intersecting conic sections.
                       % A conic section is a function of alpha.
                       % ******alpha0in is sometimes very important****
    else
        alpha0in = alpha_AI;
    end
    
    [estimated_AI, alpha_AI] = KINEMATICS_TOOL_four_sphere_intersect(center1, center2,...
                            center3, center4, initial_configuration3, initial_configuration4, alpha0in,0);
                    
    % save the estimated TS evolutions. Note that above gives always to estimated point for each time step.                
    SSDATA.Measured_Kinematics.AI(:,TimeId) = estimated_AI(:,2);
    %}
end

% ------------------------------------------------------------------------
% 6) Show the estimated results on the BUILD MOTION (Option 2) GUI page
% ------------------------------------------------------------------------
% display message
disp(['Show the estimated/measured landmarks in GREEN for the first time Stamp']);

% set the current axis
set(KRHandle, 'currentaxes', KRPlotHandles.View_Motion_Axes); hold on;

% define the wireframe of the measured motion
Measured_WF_Thorax      =      [SSDATA.Measured_Kinematics.IJ(:,1),...
                               SSDATA.Measured_Kinematics.PX(:,1),...
                               SSDATA.Measured_Kinematics.T8(:,1),...
                               SSDATA.Measured_Kinematics.C7(:,1),...
                               SSDATA.Measured_Kinematics.IJ(:,1)];
                           
Measured_WF_Clavicula   =      [SSDATA.Measured_Kinematics.SC(:,1),...
                               SSDATA.Measured_Kinematics.AC(:,1)];
                           
Measured_WF_Scapula     =      [SSDATA.Measured_Kinematics.AC(:,1),...
                               SSDATA.Measured_Kinematics.AA(:,1),...
                               SSDATA.Measured_Kinematics.TS(:,1),...
                               SSDATA.Measured_Kinematics.AI(:,1),...
                               SSDATA.Measured_Kinematics.GH(:,1),...
                               SSDATA.Measured_Kinematics.AC(:,1)];
                           
Measured_WF_Humerus     =      [SSDATA.Measured_Kinematics.GH(:,1),...
                               SSDATA.Measured_Kinematics.HU(:,1),...
                               SSDATA.Measured_Kinematics.EL(:,1),...
                               SSDATA.Measured_Kinematics.EM(:,1)];
                           
Measured_WF_Ulna        =      [SSDATA.Measured_Kinematics.CP(:,1),...
                               SSDATA.Measured_Kinematics.HU(:,1),...
                               SSDATA.Measured_Kinematics.EM(:,1),...
                               SSDATA.Measured_Kinematics.US(:,1)];
                           
Measured_WF_Radius      =      [SSDATA.Measured_Kinematics.CP(:,1),...
                               SSDATA.Measured_Kinematics.RS(:,1)];

% plot the wireframes of the measured motion associated with the first time
% stamp
plot3(Measured_WF_Thorax(1,:),...
          Measured_WF_Thorax(2,:),...
          Measured_WF_Thorax(3,:),...
          'color', 'black',...
          'linewidth', 2,...
          'marker', '*',...
          'markerfacecolor', 'green',...
          'markeredgecolor', 'green');
plot3(Measured_WF_Clavicula(1,:),...
          Measured_WF_Clavicula(2,:),...
          Measured_WF_Clavicula(3,:),...
          'color', 'black',...
          'linewidth', 2,...
          'marker', '*',...
          'markerfacecolor', 'green',...
          'markeredgecolor', 'green');
plot3(Measured_WF_Scapula(1,:),...
          Measured_WF_Scapula(2,:),...
          Measured_WF_Scapula(3,:),...
          'color', 'black',...
          'linewidth', 2,...
          'marker', '*',...
          'markerfacecolor', 'green',...
          'markeredgecolor', 'green');
plot3(Measured_WF_Humerus(1,:),...
          Measured_WF_Humerus(2,:),...
          Measured_WF_Humerus(3,:),...
          'color', 'black',...
          'linewidth', 2,...
          'marker', '*',...
          'markerfacecolor', 'green',...
          'markeredgecolor', 'green');      
plot3(Measured_WF_Ulna(1,:),...
          Measured_WF_Ulna(2,:),...
          Measured_WF_Ulna(3,:),...
          'color', 'black',...
          'linewidth', 2,...
          'marker', '*',...
          'markerfacecolor', 'green',...
          'markeredgecolor', 'green');      
plot3(Measured_WF_Radius(1,:),...
          Measured_WF_Radius(2,:),...
          Measured_WF_Radius(3,:),...
          'color', 'black',...
          'linewidth', 2,...
          'marker', '*',...
          'markerfacecolor', 'green',...
          'markeredgecolor', 'green');



return;

