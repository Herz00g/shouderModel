function SSDATA = KINEMATICS_TOOL_reconstruct_motion(KRPlotHandles, KRGUIHandle, SSDATAin, BLDATA, REDATA)
%{
Function for reconstruction of a measured motion.
--------------------------------------------------------------------------
Syntax
KEDATA = KINEMATICS_TOOL_reconstruct_motion(KEDATAin, SSDATA, BLDATA, REDATA)
--------------------------------------------------------------------------
File Description:
Having filtered, transformed, and estimated the landmarks
this function takes the measured kinematics data from SSDATA and
reconstruct this motion using inverse kinematics. More precisely, it uses
global optimization technique to define the generalized coordinates for
each time step of the measured motion such that the tracking error is
globally (for all the landmarks at each time step) is minimized. It also
takes into account the constraints on the scapulothoracic joint using
KINEMATIC_TOOL_nonlinear_constraints.
--------------------------------------------------------------------------
%}

% initialize the output
SSDATA = SSDATAin;

%--------------------------------------------------------------------------
% solve the inverse kinematics problem
%--------------------------------------------------------------------------
% fmincon setting
options = optimoptions('fmincon','Display','off','Algorithm','interior-point', 'MaxFunEvals', 3000, 'MaxIter', 10000);

max_frame = 100*str2double(get(KRGUIHandle.TimeFrameEdit, 'string'));

for TimeId = 1:max_frame%length(SSDATA.Measured_Kinematics.IJ)
    
    % display
    disp(['Motion reconstruction, Time Stamp : ', num2str(TimeId), '/', num2str(floor(max_frame))]); % length(SSDATA.Measured_Kinematics.IJ)

    % initial guess for the nonlinear optimization
    if TimeId == 1
        q0 = zeros(11,1);
    else
        q0 = q_r(:,TimeId-1);
    end
    
    % define the nonlinear kinematics constraints associated with the
    % scapulothoracic joint
    nonlcon = @(q) KINEMATICS_TOOL_nonlinear_constraints(q, BLDATA, REDATA);
    
    % define the tracking cost function
    tracking_cost = @(q) KINEMATICS_TOOL_tracking_cost(TimeId, q, SSDATA, BLDATA);
    
    % solve the IK optimzation problem
    %q_r(:,TimeId) = fmincon(tracking_cost, q0, [], [], [], [], [], [], nonlcon, options);
    [q_r(:,TimeId),fval,exitflag,output,lambda,grad,hessian] = fmincon(tracking_cost, q0, [], [], [], [], [], [], nonlcon, options);
    % define tracking errors for landmarks associated with each segment
    [global_error(TimeId), thorax_error(TimeId), clavicle_error(TimeId), scapula_error(TimeId), humerus_error(TimeId), ulna_error(TimeId), radius_error(TimeId)] = tracking_cost(q_r(:,TimeId));
    
    
    [Hessian_est, Lost_factor] = KINEMATICS_TOOL_give_fiacco(q_r(:,TimeId), SSDATA, lambda.eqnonlin, TimeId);
    SSDATA.Lost_factors{TimeId} = Lost_factor;
    
    % save the rotation matrices for the robotic test setup
    SSDATA.Rmat(:,15*(TimeId-1)+1:15*TimeId) = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles', q_r(:,TimeId), BLDATA);

end

% save the reconstructed joint angels (generalized coordinates)
SSDATA.Joint_Angle_Reconstruction  = q_r;

% save the RMSE of the motion reconstruction
 SSDATA.RMSE_Reconstrution.Global   = (sum(global_error)/max_frame)^0.5; % length(SSDATA.Measured_Kinematics.IJ)
 SSDATA.RMSE_Reconstrution.Thorax   = (sum(thorax_error)/max_frame)^0.5;
 SSDATA.RMSE_Reconstrution.Clavicle = (sum(clavicle_error)/max_frame)^0.5;
 SSDATA.RMSE_Reconstrution.Scapula  = (sum(scapula_error)/max_frame)^0.5;
 SSDATA.RMSE_Reconstrution.Humerus  = (sum(humerus_error)/max_frame)^0.5;
 SSDATA.RMSE_Reconstrution.Ulna     = (sum(ulna_error)/max_frame)^0.5;
 SSDATA.RMSE_Reconstrution.Radius   = (sum(radius_error)/max_frame)^0.5;
 
%--------------------------------------------------------------------------
% approximate the resulted joint angels with smooth polynimials
%--------------------------------------------------------------------------
% take the motion time span
final_time = str2double(get(KRGUIHandle.TimeFrameEdit, 'string'));

% define the elapsed time necessary to connect knot i-1 to i
%h = final_time/(length(SSDATA.Measured_Kinematics.IJ)-1);
h = final_time/(max_frame-1);


% creat the time
time = 0: h: final_time;

% save the time for the robotic test setup
SSDATA.time = time;

for AngleId = 1 : 11
    
    fitting_options = optimoptions('lsqcurvefit','Display', 'off', 'Algorithm',...
                                   'trust-region-reflective','TolFun', 1e-15,'MaxFunEvals',1000);                                                                                     
    
    initial_guess = ones(1, 9);
    
    lb = [-inf -inf -inf -inf -inf -inf -inf -inf -inf];
    
    ub = [inf inf inf inf inf inf inf inf inf];
    
    [coefficients,resnorm, residual] = lsqcurvefit(@angle_curve, initial_guess , time ,...
                                                   q_r(AngleId, :), lb, ub, fitting_options);


    SSDATA.Joint_Angle_Coefficients(AngleId, :)        = coefficients;
    SSDATA.Joint_Velocity_Coefficients(AngleId, :)     = polyder(coefficients);
    SSDATA.Joint_Acceleration_Coefficients(AngleId, :) = polyder(polyder(coefficients));
end



% display message
disp(['Motion reconstruction was finished and the results smoothened.']);

%--------------------------------------------------------------------------
% show the resulted generalized coordinates in the GUI
%--------------------------------------------------------------------------
% display message
disp(['Plot the resulted generalized coordinates (joint angels)']);

% plot the results in the appropriate place on the BUILD MOTION (Option 2)
% GUI page (i.e.: Plot_IK_Axes)
% Unfortunately, subplot does not work with axes as it's an axis itself.
% Therefore, to plot the data in the Plot_IK_Axes I defined KRPlotHandles.Plot_IK_Axes
% as a "uipanel" and also mentioned it in the subplot "Parent".

% creat title list for the plots
title_list = {'clavicle axial rotation',...
              'clavicle depression/elevation',...
              'clavicle retraction/protraction',...
              'scapula anterior/posterior tilt',...
              'scapula lateral/medial rotation',...
              'scapula protraction/retraction',...
              'humerus axial rotation',...
              'humerus adduction/abduction',...
              'humerus flexion/extension',...%plan humerus elevation plane posterior/anterior
              'ulna extension/flexion',...
              'radius supination/pronation'};

% creat the plots
for plot_id = 1:11 % number of generalized coordinates
    subplot(4,3,plot_id,'Parent',KRPlotHandles.Plot_IK_UiPanel);
    plot(time, (180/pi)*q_r(plot_id,:),'o', 'MarkerFaceColor', 'b','MarkerSize', 3,...
        'buttondownfcn', KINEMATICS_TOOL_reconstruction_script_generator('Click On',plot_id));
    xlabel('time [s]','fontsize',12);
    ylabel(['q',num2str(plot_id),'[deg]'],'fontsize',12);
    set(gca,'FontSize',12);
    title(title_list{1, plot_id},'fontsize',12,'fontweight','normal' );
    xlim([0,final_time]);
    grid on

end

% Text for captioning the reconstructed generalized coordinates
KRGUIHandle.GCTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.29, 0.45, 0.5, 0.03],...
    'style', 'text',...
    'string', 'Reconstructed generalized coordinates (click on each of the plots below for further plots including the associated generalized velocities and accelerations)',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'HorizontalAlignment','center',...
    'fontweight', 'bold');

return;


    function angle = angle_curve(coeff, time)
    
    coefficients = [coeff(1) coeff(2) coeff(3) coeff(4) coeff(5) coeff(6) ...
                    coeff(7) coeff(8) coeff(9)];
                
    angle = polyval(coefficients, time);
    return;
    

%--------------------------------------------------------------------------
% code for piece-wise spline parametrization of the joint space
%--------------------------------------------------------------------------
% this approach failed given the simulation that I made on simple example
% in OneBarModel.

%{
function SSDATA = KINEMATICS_TOOL_reconstruct_motion(KRHandle, KRPlotHandles, KRGUIHandle, SSDATAin, BLDATA, REDATA)
%{
Function for reconstruction of a measured motion.
--------------------------------------------------------------------------
Syntax
KEDATA = KINEMATICS_TOOL_reconstruct_motion(KEDATAin, SSDATA, BLDATA, REDATA)
--------------------------------------------------------------------------
File Description:
Having filtered, transformed, and estimated the landmarks
this function takes the measured kinematics data from SSDATA and
reconstruct this motion using inverse kinematics. More precisely, it uses
global optimization technique to define the generalized coordinates for
each time step of the measured motion such that the tracking error is
globally (for all the landmarks at each time step) is minimized. It also
takes into account the constraints on the scapulothoracic joint using
KINEMATIC_TOOL_nonlinear_constraints.
--------------------------------------------------------------------------
%}

% initialize the output
SSDATA = SSDATAin;

%--------------------------------------------------------------------------
% solve the inverse kinematics problem
%--------------------------------------------------------------------------
% fmincon setting
options = optimoptions('fmincon','Display','off','Algorithm','interior-point', 'MaxFunEvals', 30000000, 'MaxIter', 10000000);

% take the motion time span
final_time = str2double(get(KRGUIHandle.TimeFrameEdit, 'string'));

% define the elapsed time necessary to connect knots i-1 to i (we consider
% a constant h throughout the motion)
h = final_time/(length(SSDATA.Measured_Kinematics.IJ)-1);

for TimeId = 1:15%length(SSDATA.Measured_Kinematics.IJ)-1
    
    % display
    disp(['Motion reconstruction, Time Stamp : ', num2str(TimeId), '/', num2str(length(SSDATA.Measured_Kinematics.IJ)-1)]);

    % initial guess for fmincon
%     if TimeId == 1
%         q0 = zeros(11,1);%KEDATA.Initial_Minimal_Coordinate % the optimization performance highly depends on the initial guess, subject calibration therefore plays a crucial role in the accuracy of the inverse kinematics method used here to reconstruct a measured motion.
%     else
%         q0 = q_r(:,TimeId-1);
%     end
    
    if TimeId == 1
        p0 = zeros(88,1);%KEDATA.Initial_Minimal_Coordinate % the optimization performance highly depends on the initial guess, subject calibration therefore plays a crucial role in the accuracy of the inverse kinematics method used here to reconstruct a measured motion.
        %p0 = [0 0 0 0 -0.564132493902317 0 0 0 -0.214764871747718 0 0 0 -0.156019331780188 0 0 0 -0.0861735779288405 0 0 0 0.511358098061857 0 0 0 0 0 0 0 -0.0174532925199433 0 0 0 0.523598775598299 0 0 0 1.45354644869875e-07 0 0 0 1.92101179658819e-06 0 0 0]';
        %p0 = [-0.000164540366356678,-0.000215733774585342,-4.31007637943093e-05,-0.000158493616265167,-1.99855811433464e-05,-3.76219856551492e-05,-6.62547442762208e-05,-0.000173913860631478,-0.557723405398277,-0.0637280623612501,-0.00655236393765927,-0.000575830080996079,-8.63923355778279e-05,-9.15656949976923e-05,-0.000238359506635549,0.000197771959155057,-0.212097560828090,-0.0266110386341692,-0.00267021031451718,-0.000134173546356082,0.000133578830290244,-5.02058292118835e-05,2.59372368582600e-05,-7.31645962464165e-05,-0.154377114652456,-0.0162871179732386,-0.00175490258015439,-0.000316441287487749,-0.000245470888584129,-7.60988159398986e-05,-0.000116377016300341,-0.000104231967879678,-0.0851851396653414,-0.0101581091150401,-0.00108748423595922,-0.000267204842032184,-0.000157039703655863,-0.000208899427238212,-1.07597951986509e-05,-8.75819547709709e-05,0.506153442037870,0.0514383098303354,0.00515694247744514,0.000550991320466978,6.54757072420986e-05,-0.000134460257351088,-0.000109380021424611,0.000106426813501772,0.000228508882418582,0.000420738237007040,0.000158417797467613,-0.000212060768535289,-0.000154573963816205,-6.23897021272805e-05,-1.15760401426098e-05,1.19532793166336e-05,-0.0145656215790827,-0.0285095478897334,-0.00320419459476407,-0.000216688380456114,9.84948766512566e-05,6.77354431053911e-05,-1.98553466598604e-05,-9.68544243144834e-05,0.518055299854908,0.0521040091493882,0.00519783428810392,0.000627275369321812,0.000111127813129812,0.000126980455071050,1.67702443261878e-06,4.76179296399936e-05,-0.000144800265631832,0.00152093836662297,0.000217137172484246,5.48529901703834e-05,-3.11632474315280e-05,6.68120923442096e-06,-1.78661611097418e-05,4.14676664004516e-05,1.27640558205095e-05,5.66130901687052e-06,-4.21606877977659e-05,-7.46006433440686e-05,1.15454680339875e-05,-8.98937574077408e-05,-5.68573335620947e-05,-8.07387173875655e-05]';
    else
        p0 = p_r(:,TimeId-1);
    end  
    
    %--------------------------------------------------------------------------
    % linear equality constraint to assure continuity of the GC, GV, and GA
    %--------------------------------------------------------------------------
                     
    if TimeId == 1
        % Aeq for one coordinate
        Aeq_diagonal = [0 1 0 0 0 0 0 0; 0 0 1 0 0 0 0 0];
        
        % define Aeq for all the coordinates
        Aeq = blkdiag(Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,...
                  Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,...
                  Aeq_diagonal,Aeq_diagonal,Aeq_diagonal);

        
        beq = zeros(22,1);
        
%     elseif TimeId == length(SSDATA.Measured_Kinematics.IJ)
%         % Aeq for one coordinate
%         Aeq_diagonal = [0 1 0 0 0 0 0 0; 0 0 2 0 0 0 0 0;...
%                         0 1 2*h 3*h^2 4*h^3 5*h^4 6*h^5 7*h^6; 0 0 2 6*h 12*h^2 20*h^3 30*h^4 42*h^5];
%                     
%         % define Aeq for all the coordinates
%         Aeq = blkdiag(Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,...
%                       Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,...
%                       Aeq_diagonal,Aeq_diagonal,Aeq_diagonal);
%                  
%         for GC_id = 1:11
%         beq(3*GC_id-2:3*GC_id, 1) = [coeff_matrix0(GC_id,1)+coeff_matrix0(GC_id,2)*h+coeff_matrix0(GC_id,3)*h^2+coeff_matrix0(GC_id,4)*h^3+coeff_matrix0(GC_id,5)*h^4+coeff_matrix0(GC_id,6)*h^5+coeff_matrix0(GC_id,7)*h^6+coeff_matrix0(GC_id,8)*h^7;...
%                                      coeff_matrix0(GC_id,2)+2*coeff_matrix0(GC_id,3)*h+3*coeff_matrix0(GC_id,4)*h^2+4*coeff_matrix0(GC_id,5)*h^3+5*coeff_matrix0(GC_id,6)*h^4+6*coeff_matrix0(GC_id,7)*h^5+7*coeff_matrix0(GC_id,8)*h^6;...
%                                      2*coeff_matrix0(GC_id,3)+6*coeff_matrix0(GC_id,4)*h+12*coeff_matrix0(GC_id,5)*h^2+20*coeff_matrix0(GC_id,6)*h^3+30*coeff_matrix0(GC_id,7)*h^4+42*coeff_matrix0(GC_id,8)*h^5;...
%                                      0;...
%                                      0];
%         end
        
    else
           
    % Aeq for one coordinate
    Aeq_diagonal = [1 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 0 2 0 0 0 0 0];

    % define Aeq for all the coordinates
    Aeq = blkdiag(Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,...
                  Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,Aeq_diagonal,...
                  Aeq_diagonal,Aeq_diagonal,Aeq_diagonal);
              
    % take the coeff_matrix of the knot i-1
    coeff_matrix0   =   [p_r(1,TimeId-1)  p_r(2,TimeId-1)  p_r(3,TimeId-1)  p_r(4,TimeId-1)  p_r(5,TimeId-1)  p_r(6,TimeId-1)  p_r(7,TimeId-1)  p_r(8,TimeId-1);...
                         p_r(9,TimeId-1)  p_r(10,TimeId-1) p_r(11,TimeId-1) p_r(12,TimeId-1) p_r(13,TimeId-1) p_r(14,TimeId-1) p_r(15,TimeId-1) p_r(16,TimeId-1);...
                         p_r(17,TimeId-1) p_r(18,TimeId-1) p_r(19,TimeId-1) p_r(20,TimeId-1) p_r(21,TimeId-1) p_r(22,TimeId-1) p_r(23,TimeId-1) p_r(24,TimeId-1);...
                         p_r(25,TimeId-1) p_r(26,TimeId-1) p_r(27,TimeId-1) p_r(28,TimeId-1) p_r(29,TimeId-1) p_r(30,TimeId-1) p_r(31,TimeId-1) p_r(32,TimeId-1);...
                         p_r(33,TimeId-1) p_r(34,TimeId-1) p_r(35,TimeId-1) p_r(36,TimeId-1) p_r(37,TimeId-1) p_r(38,TimeId-1) p_r(39,TimeId-1) p_r(40,TimeId-1);...
                         p_r(41,TimeId-1) p_r(42,TimeId-1) p_r(43,TimeId-1) p_r(44,TimeId-1) p_r(45,TimeId-1) p_r(46,TimeId-1) p_r(47,TimeId-1) p_r(48,TimeId-1);...
                         p_r(49,TimeId-1) p_r(50,TimeId-1) p_r(51,TimeId-1) p_r(52,TimeId-1) p_r(53,TimeId-1) p_r(54,TimeId-1) p_r(55,TimeId-1) p_r(56,TimeId-1);...
                         p_r(57,TimeId-1) p_r(58,TimeId-1) p_r(59,TimeId-1) p_r(60,TimeId-1) p_r(61,TimeId-1) p_r(62,TimeId-1) p_r(63,TimeId-1) p_r(64,TimeId-1);...
                         p_r(65,TimeId-1) p_r(66,TimeId-1) p_r(67,TimeId-1) p_r(68,TimeId-1) p_r(69,TimeId-1) p_r(70,TimeId-1) p_r(71,TimeId-1) p_r(72,TimeId-1);...
                         p_r(73,TimeId-1) p_r(74,TimeId-1) p_r(75,TimeId-1) p_r(76,TimeId-1) p_r(77,TimeId-1) p_r(78,TimeId-1) p_r(79,TimeId-1) p_r(80,TimeId-1);...
                         p_r(81,TimeId-1) p_r(82,TimeId-1) p_r(83,TimeId-1) p_r(84,TimeId-1) p_r(85,TimeId-1) p_r(86,TimeId-1) p_r(87,TimeId-1) p_r(88,TimeId-1)];

                     
    % define beq            
    for GC_id = 1:11
        beq(3*GC_id-2:3*GC_id, 1) = [coeff_matrix0(GC_id,1)+coeff_matrix0(GC_id,2)*h+coeff_matrix0(GC_id,3)*h^2+coeff_matrix0(GC_id,4)*h^3+coeff_matrix0(GC_id,5)*h^4+coeff_matrix0(GC_id,6)*h^5+coeff_matrix0(GC_id,7)*h^6+coeff_matrix0(GC_id,8)*h^7;...
                                     coeff_matrix0(GC_id,2)+2*coeff_matrix0(GC_id,3)*h+3*coeff_matrix0(GC_id,4)*h^2+4*coeff_matrix0(GC_id,5)*h^3+5*coeff_matrix0(GC_id,6)*h^4+6*coeff_matrix0(GC_id,7)*h^5+7*coeff_matrix0(GC_id,8)*h^6;...
                                     2*coeff_matrix0(GC_id,3)+6*coeff_matrix0(GC_id,4)*h+12*coeff_matrix0(GC_id,5)*h^2+20*coeff_matrix0(GC_id,6)*h^3+30*coeff_matrix0(GC_id,7)*h^4+42*coeff_matrix0(GC_id,8)*h^5];
    end
    end
%     else
%     Aeq = [];
%     beq = [];
%     end
    % define the nonlinear kinematics constraints    
    nonlcon = @(p) KINEMATICS_TOOL_nonlinear_constraints(p, BLDATA, REDATA, SSDATA, KRGUIHandle);
    
    % define the cost function
    tracking_cost = @(p) KINEMATICS_TOOL_tracking_cost(TimeId, p, SSDATA, BLDATA, KRGUIHandle);
    
    % solve the IK optimzation problem
    %q_r(:,TimeId) = fmincon(@(q)KINEMATICS_TOOL_tracking_cost(TimeId, q, SSDATA, BLDATA),q0,[],[],[],[],[],[],nonlcon, options);
    p_r(:,TimeId) = fmincon(tracking_cost,p0,[],[],Aeq,beq,[],[],nonlcon, options);
    
    % define tracking errors for landmarks associated with each segment
    [global_error(TimeId), thorax_error(TimeId), clavicle_error(TimeId), scapula_error(TimeId), humerus_error(TimeId), ulna_error(TimeId), radius_error(TimeId)] = tracking_cost(p_r(:,TimeId));
    
    % define q_r by based on the resulted spline p_r
%     q_r(:,TimeId) = [p_r(1,TimeId)  p_r(2,TimeId)  p_r(3,TimeId)  p_r(4,TimeId);...
%                      p_r(5,TimeId)  p_r(6,TimeId)  p_r(7,TimeId)  p_r(8,TimeId);...
%                      p_r(9,TimeId)  p_r(10,TimeId) p_r(11,TimeId) p_r(12,TimeId);...
%                      p_r(13,TimeId) p_r(14,TimeId) p_r(15,TimeId) p_r(16,TimeId);...
%                      p_r(17,TimeId) p_r(18,TimeId) p_r(19,TimeId) p_r(20,TimeId);...
%                      p_r(21,TimeId) p_r(22,TimeId) p_r(23,TimeId) p_r(24,TimeId);...
%                      p_r(25,TimeId) p_r(26,TimeId) p_r(27,TimeId) p_r(28,TimeId);...
%                      p_r(29,TimeId) p_r(30,TimeId) p_r(31,TimeId) p_r(32,TimeId);...
%                      p_r(33,TimeId) p_r(34,TimeId) p_r(35,TimeId) p_r(36,TimeId);...
%                      p_r(37,TimeId) p_r(38,TimeId) p_r(39,TimeId) p_r(40,TimeId);...
%                      p_r(41,TimeId) p_r(42,TimeId) p_r(43,TimeId) p_r(44,TimeId)]*[1 h h^2 h^3]';

%     q_r(:,TimeId) =  [p_r(1,TimeId)  p_r(2,TimeId)  p_r(3,TimeId)  p_r(4,TimeId)  p_r(5,TimeId)  p_r(6,TimeId);...
%                       p_r(7,TimeId)  p_r(8,TimeId)  p_r(9,TimeId)  p_r(10,TimeId) p_r(11,TimeId) p_r(12,TimeId);...
%                       p_r(13,TimeId) p_r(14,TimeId) p_r(15,TimeId) p_r(16,TimeId) p_r(17,TimeId) p_r(18,TimeId);...
%                       p_r(19,TimeId) p_r(20,TimeId) p_r(21,TimeId) p_r(22,TimeId) p_r(23,TimeId) p_r(24,TimeId);...
%                       p_r(25,TimeId) p_r(26,TimeId) p_r(27,TimeId) p_r(28,TimeId) p_r(29,TimeId) p_r(30,TimeId);...
%                       p_r(31,TimeId) p_r(32,TimeId) p_r(33,TimeId) p_r(34,TimeId) p_r(35,TimeId) p_r(36,TimeId);...
%                       p_r(37,TimeId) p_r(38,TimeId) p_r(39,TimeId) p_r(40,TimeId) p_r(41,TimeId) p_r(42,TimeId);...
%                       p_r(43,TimeId) p_r(44,TimeId) p_r(45,TimeId) p_r(46,TimeId) p_r(47,TimeId) p_r(48,TimeId);...
%                       p_r(49,TimeId) p_r(50,TimeId) p_r(51,TimeId) p_r(52,TimeId) p_r(53,TimeId) p_r(54,TimeId);...
%                       p_r(55,TimeId) p_r(56,TimeId) p_r(57,TimeId) p_r(58,TimeId) p_r(59,TimeId) p_r(60,TimeId);...
%                       p_r(61,TimeId) p_r(62,TimeId) p_r(63,TimeId) p_r(64,TimeId) p_r(65,TimeId) p_r(66,TimeId)]*[1 h h^2 h^3 h^4 h^5]';
%     
%     q_r(:,TimeId) = [p_r(1,TimeId)  p_r(2,TimeId)  p_r(3,TimeId)  p_r(4,TimeId)  p_r(5,TimeId)  p_r(6,TimeId)  p_r(7,TimeId);...
%                      p_r(8,TimeId)  p_r(9,TimeId)  p_r(10,TimeId) p_r(11,TimeId) p_r(12,TimeId) p_r(13,TimeId) p_r(14,TimeId);...
%                      p_r(15,TimeId) p_r(16,TimeId) p_r(17,TimeId) p_r(18,TimeId) p_r(19,TimeId) p_r(20,TimeId) p_r(21,TimeId);...
%                      p_r(22,TimeId) p_r(23,TimeId) p_r(24,TimeId) p_r(25,TimeId) p_r(26,TimeId) p_r(27,TimeId) p_r(28,TimeId);...
%                      p_r(29,TimeId) p_r(30,TimeId) p_r(31,TimeId) p_r(32,TimeId) p_r(33,TimeId) p_r(34,TimeId) p_r(35,TimeId);...
%                      p_r(36,TimeId) p_r(37,TimeId) p_r(38,TimeId) p_r(39,TimeId) p_r(40,TimeId) p_r(41,TimeId) p_r(42,TimeId);...
%                      p_r(43,TimeId) p_r(44,TimeId) p_r(45,TimeId) p_r(46,TimeId) p_r(47,TimeId) p_r(48,TimeId) p_r(49,TimeId);...
%                      p_r(50,TimeId) p_r(51,TimeId) p_r(52,TimeId) p_r(53,TimeId) p_r(54,TimeId) p_r(55,TimeId) p_r(56,TimeId);...
%                      p_r(57,TimeId) p_r(58,TimeId) p_r(59,TimeId) p_r(60,TimeId) p_r(61,TimeId) p_r(62,TimeId) p_r(63,TimeId);...
%                      p_r(64,TimeId) p_r(65,TimeId) p_r(66,TimeId) p_r(67,TimeId) p_r(68,TimeId) p_r(69,TimeId) p_r(70,TimeId);...
%                      p_r(71,TimeId) p_r(72,TimeId) p_r(73,TimeId) p_r(74,TimeId) p_r(75,TimeId) p_r(76,TimeId) p_r(77,TimeId)]*[1 h h^2 h^3 h^4 h^5 h^6]';
if TimeId == 1
    q_r(:,TimeId) = [p_r(1,TimeId)  p_r(2,TimeId)  p_r(3,TimeId)  p_r(4,TimeId)  p_r(5,TimeId)  p_r(6,TimeId)  p_r(7,TimeId)  p_r(8,TimeId);...
                     p_r(9,TimeId)  p_r(10,TimeId) p_r(11,TimeId) p_r(12,TimeId) p_r(13,TimeId) p_r(14,TimeId) p_r(15,TimeId) p_r(16,TimeId);...
                     p_r(17,TimeId) p_r(18,TimeId) p_r(19,TimeId) p_r(20,TimeId) p_r(21,TimeId) p_r(22,TimeId) p_r(23,TimeId) p_r(24,TimeId);...
                     p_r(25,TimeId) p_r(26,TimeId) p_r(27,TimeId) p_r(28,TimeId) p_r(29,TimeId) p_r(30,TimeId) p_r(31,TimeId) p_r(32,TimeId);...
                     p_r(33,TimeId) p_r(34,TimeId) p_r(35,TimeId) p_r(36,TimeId) p_r(37,TimeId) p_r(38,TimeId) p_r(39,TimeId) p_r(40,TimeId);...
                     p_r(41,TimeId) p_r(42,TimeId) p_r(43,TimeId) p_r(44,TimeId) p_r(45,TimeId) p_r(46,TimeId) p_r(47,TimeId) p_r(48,TimeId);...
                     p_r(49,TimeId) p_r(50,TimeId) p_r(51,TimeId) p_r(52,TimeId) p_r(53,TimeId) p_r(54,TimeId) p_r(55,TimeId) p_r(56,TimeId);...
                     p_r(57,TimeId) p_r(58,TimeId) p_r(59,TimeId) p_r(60,TimeId) p_r(61,TimeId) p_r(62,TimeId) p_r(63,TimeId) p_r(64,TimeId);...
                     p_r(65,TimeId) p_r(66,TimeId) p_r(67,TimeId) p_r(68,TimeId) p_r(69,TimeId) p_r(70,TimeId) p_r(71,TimeId) p_r(72,TimeId);...
                     p_r(73,TimeId) p_r(74,TimeId) p_r(75,TimeId) p_r(76,TimeId) p_r(77,TimeId) p_r(78,TimeId) p_r(79,TimeId) p_r(80,TimeId);...
                     p_r(81,TimeId) p_r(82,TimeId) p_r(83,TimeId) p_r(84,TimeId) p_r(85,TimeId) p_r(86,TimeId) p_r(87,TimeId) p_r(88,TimeId)]*[1 0 0 0 0 0 0 0]';

    q_r(:,TimeId+1) = [p_r(1,TimeId)  p_r(2,TimeId)  p_r(3,TimeId)  p_r(4,TimeId)  p_r(5,TimeId)  p_r(6,TimeId)  p_r(7,TimeId)  p_r(8,TimeId);...
                     p_r(9,TimeId)  p_r(10,TimeId) p_r(11,TimeId) p_r(12,TimeId) p_r(13,TimeId) p_r(14,TimeId) p_r(15,TimeId) p_r(16,TimeId);...
                     p_r(17,TimeId) p_r(18,TimeId) p_r(19,TimeId) p_r(20,TimeId) p_r(21,TimeId) p_r(22,TimeId) p_r(23,TimeId) p_r(24,TimeId);...
                     p_r(25,TimeId) p_r(26,TimeId) p_r(27,TimeId) p_r(28,TimeId) p_r(29,TimeId) p_r(30,TimeId) p_r(31,TimeId) p_r(32,TimeId);...
                     p_r(33,TimeId) p_r(34,TimeId) p_r(35,TimeId) p_r(36,TimeId) p_r(37,TimeId) p_r(38,TimeId) p_r(39,TimeId) p_r(40,TimeId);...
                     p_r(41,TimeId) p_r(42,TimeId) p_r(43,TimeId) p_r(44,TimeId) p_r(45,TimeId) p_r(46,TimeId) p_r(47,TimeId) p_r(48,TimeId);...
                     p_r(49,TimeId) p_r(50,TimeId) p_r(51,TimeId) p_r(52,TimeId) p_r(53,TimeId) p_r(54,TimeId) p_r(55,TimeId) p_r(56,TimeId);...
                     p_r(57,TimeId) p_r(58,TimeId) p_r(59,TimeId) p_r(60,TimeId) p_r(61,TimeId) p_r(62,TimeId) p_r(63,TimeId) p_r(64,TimeId);...
                     p_r(65,TimeId) p_r(66,TimeId) p_r(67,TimeId) p_r(68,TimeId) p_r(69,TimeId) p_r(70,TimeId) p_r(71,TimeId) p_r(72,TimeId);...
                     p_r(73,TimeId) p_r(74,TimeId) p_r(75,TimeId) p_r(76,TimeId) p_r(77,TimeId) p_r(78,TimeId) p_r(79,TimeId) p_r(80,TimeId);...
                     p_r(81,TimeId) p_r(82,TimeId) p_r(83,TimeId) p_r(84,TimeId) p_r(85,TimeId) p_r(86,TimeId) p_r(87,TimeId) p_r(88,TimeId)]*[1 h h^2 h^3 h^4 h^5 h^6 h^7]';
else
    q_r(:,TimeId+1) = [p_r(1,TimeId)  p_r(2,TimeId)  p_r(3,TimeId)  p_r(4,TimeId)  p_r(5,TimeId)  p_r(6,TimeId)  p_r(7,TimeId)  p_r(8,TimeId);...
                     p_r(9,TimeId)  p_r(10,TimeId) p_r(11,TimeId) p_r(12,TimeId) p_r(13,TimeId) p_r(14,TimeId) p_r(15,TimeId) p_r(16,TimeId);...
                     p_r(17,TimeId) p_r(18,TimeId) p_r(19,TimeId) p_r(20,TimeId) p_r(21,TimeId) p_r(22,TimeId) p_r(23,TimeId) p_r(24,TimeId);...
                     p_r(25,TimeId) p_r(26,TimeId) p_r(27,TimeId) p_r(28,TimeId) p_r(29,TimeId) p_r(30,TimeId) p_r(31,TimeId) p_r(32,TimeId);...
                     p_r(33,TimeId) p_r(34,TimeId) p_r(35,TimeId) p_r(36,TimeId) p_r(37,TimeId) p_r(38,TimeId) p_r(39,TimeId) p_r(40,TimeId);...
                     p_r(41,TimeId) p_r(42,TimeId) p_r(43,TimeId) p_r(44,TimeId) p_r(45,TimeId) p_r(46,TimeId) p_r(47,TimeId) p_r(48,TimeId);...
                     p_r(49,TimeId) p_r(50,TimeId) p_r(51,TimeId) p_r(52,TimeId) p_r(53,TimeId) p_r(54,TimeId) p_r(55,TimeId) p_r(56,TimeId);...
                     p_r(57,TimeId) p_r(58,TimeId) p_r(59,TimeId) p_r(60,TimeId) p_r(61,TimeId) p_r(62,TimeId) p_r(63,TimeId) p_r(64,TimeId);...
                     p_r(65,TimeId) p_r(66,TimeId) p_r(67,TimeId) p_r(68,TimeId) p_r(69,TimeId) p_r(70,TimeId) p_r(71,TimeId) p_r(72,TimeId);...
                     p_r(73,TimeId) p_r(74,TimeId) p_r(75,TimeId) p_r(76,TimeId) p_r(77,TimeId) p_r(78,TimeId) p_r(79,TimeId) p_r(80,TimeId);...
                     p_r(81,TimeId) p_r(82,TimeId) p_r(83,TimeId) p_r(84,TimeId) p_r(85,TimeId) p_r(86,TimeId) p_r(87,TimeId) p_r(88,TimeId)]*[1 h h^2 h^3 h^4 h^5 h^6 h^7]';

             
end
end

% save the reconstructed joint angels (generalized coordinates)
% to smoothen data one approach was this that did not work out well
% for i = 1:11
% q_r(i,:) = smooth(q_r(i,:),'rlowess');
% end
SSDATA.Joint_Angle_Reconstruction  = q_r;
SSDATA.Coefficients  = p_r;


% save the RMSE of the motion reconstruction
 SSDATA.RMSE_Reconstrution.Global   = (sum(global_error)/length(SSDATA.Measured_Kinematics.IJ))^0.5;
 SSDATA.RMSE_Reconstrution.Thorax   = (sum(thorax_error)/length(SSDATA.Measured_Kinematics.IJ))^0.5;
 SSDATA.RMSE_Reconstrution.Clavicle = (sum(clavicle_error)/length(SSDATA.Measured_Kinematics.IJ))^0.5;
 SSDATA.RMSE_Reconstrution.Scapula  = (sum(scapula_error)/length(SSDATA.Measured_Kinematics.IJ))^0.5;
 SSDATA.RMSE_Reconstrution.Humerus  = (sum(humerus_error)/length(SSDATA.Measured_Kinematics.IJ))^0.5;
 SSDATA.RMSE_Reconstrution.Ulna     = (sum(ulna_error)/length(SSDATA.Measured_Kinematics.IJ))^0.5;
 SSDATA.RMSE_Reconstrution.Radius   = (sum(radius_error)/length(SSDATA.Measured_Kinematics.IJ))^0.5;
 
%--------------------------------------------------------------------------
% show the resulted generalized coordinates in the GUI
%--------------------------------------------------------------------------
% display message
disp(['Plot the resulted generalized coordinates (joint angels)']);

% plot the results in the appropriate place on the BUILD MOTION (Option 2)
% GUI page (i.e.: Plot_IK_Axes)
% Unfortunately, subplot does not work with axes as it's an axis itself.
% Therefore, to plot the data in the Plot_IK_Axes I defined KRPlotHandles.Plot_IK_Axes
% as a "uipanel" and also mentioned it in the subplot "Parent".

%set(KRHandle, 'currentaxes', KRPlotHandles.Plot_IK_Axes);

% creat the time
%time = linspace(0, final_time, length(SSDATA.Measured_Kinematics.IJ));
%time = linspace(0, final_time, 14);
time = 0:h:15*h;%final_time;
% creat title list
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

% creat the plots
for plot_id = 1:11 % number of generalized coordinates
    subplot(4,3,plot_id,'Parent',KRPlotHandles.Plot_IK_UiPanel);
    plot(time, (180/pi)*q_r(plot_id,:),'o', 'MarkerFaceColor', 'b','MarkerSize', 3,...
        'buttondownfcn', KINEMATICS_TOOL_reconstruction_script_generator('Click On',plot_id));
    xlabel('time [s]','fontsize',12);
    ylabel(['q',num2str(plot_id),'[deg]'],'fontsize',12);
    set(gca,'FontSize',12);
    title(title_list{1, plot_id},'fontsize',12,'fontweight','normal' );
    xlim([0,final_time]);

end

% Text for captioning the reconstructed generalized coordinates
KRGUIHandle.GCTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.29, 0.45, 0.5, 0.03],...
    'style', 'text',...
    'string', 'Reconstructed generalized coordinates (click on each of the plots below for further plots including the associated generalized velocities and accelerations)',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'HorizontalAlignment','center',...
    'fontweight', 'bold');

return;


%}
