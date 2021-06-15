function SSDATA = ESTIMATION_TOOL_EMG_to_force(ESGUIHandle, SSDATAin, BLDATA, MWDATA, DYDATA)
%{
Function to define muscle forces from EMG data
--------------------------------------------------------------------------
Syntax :
SSDATA = ESTIMATION_TOOL_EMG_to_force(ESGUIHandle, SSDATAin, BLDATA)
--------------------------------------------------------------------------
File Description :
This function defines the muscle forces based on the EMG data and the
muscle-tendon length for the measured motion using the muscle model and
saves the results in SSDATA data structure.

muscle force          : SSDATA.f_T
muscle-tendon lengths : SSDATA.L_mt
--------------------------------------------------------------------------
%}
% set the scaling factor
if isfield(DYDATA, 'PCSA_scaling_factor') == 0
    DYDATA.PCSA_scaling_factor = 1;
else
    % do not need to do anything given that the field exists with its
    % proper value from scaling of the model in the subject-specific tool
end

% initialize the SSDATA
SSDATA = SSDATAin;

% define the time
t = linspace(0, str2double(get(ESGUIHandle.TimeFrameEdit, 'string')), length(SSDATA.Joint_Angle_Reconstruction));

% list of the muscle for which we have measured the EMG excitations
% the naming is based on our protocol for performing the experiminet
muscle_list = {'DANT' 'DMED' 'DPOS' 'TDES' 'TTRA' 'TASE' 'TERM' 'PECT' 'BICL',...
               'BICS' 'TLOH' 'TLAH' 'BRAC' 'FLCU' 'INFS'}; 

% muscle-tendon parameters (from untitle.m)
% the parameters here are basically from Garner and Pandy with some
% tweaking in order to lower the passive muscle forces

% modified Garner and Pandy muscle morphological data                 
% muscle_parameters = [277.48   14.68e-2   0         5.5*14.68e-2   1.64e-2;  % DANT
%                      1860.52   6.69e-2   0         5.5*6.69e-2    8.56e-2;  % DMED
%                      567.15   17.02e-2   0         5.5*17.02e-2   5.93e-2;  % DPOS
%                      119.25   21.44e-2   0         5.5*21.44e-2   2.60e-2;  % TDES 
%                      409.23   17.91e-2   0         5.5*17.91e-2   2.42e-2;  % TTRA
%                      514.51   14.84e-2   0         5.5*14.84e-2   4.79e-2;  % TERM
%                      484.35   16.58e-2   0         5.5*16.58e-2   9.03e-2;  % PECT
%                      392.91   17.36e-2  10         5.5*17.36e-2   24.93e-2; % BICL
%                      361.76   12.07e-2  10         5.5*12.07e-2   26.98e-2; % BICS
%                      629.21   17.24e-2  15         5.5*17.24e-2   20.05e-2; % TLOH
%                      1068.87  12.17e-2  15         5.5*12.17e-2   22.64e-2; % TLAH
%                      753.90   15.28e-2  15         5.5*15.28e-2   4.75e-2;  % BRAC
%                      400.70    4.7e-2   15         4.7*5e-2       27.74e-2; % FLCU
%                      1099.61   10.76e-2   0         5.5*10.76e-2    6.58e-2]; % INFS

% BRAC changes that made increase the BRAC force at least 200%
% INFS changes (increase) decrease the INFS force 150% but not that much
% changes in the contact force
% delft muscle morphological data
% muscle_parameters = [DYDATA.PCSA_scaling_factor*277.48   14.68e-2   0         5.5*14.68e-2   1.64e-2;% DANT
%                      DYDATA.PCSA_scaling_factor*1860.52  9e-2       0         5.5*9e-2       8.56e-2;% DMED
%                      DYDATA.PCSA_scaling_factor*567.15   17.02e-2   0         5.5*17.02e-2   5.93e-2;% DPOS
%                      DYDATA.PCSA_scaling_factor*119.25   21.44e-2   0         5.5*21.44e-2   0.60e-2;% TDES (trapezius C7)
%                      DYDATA.PCSA_scaling_factor*114.01   19.37e-2   0         5.5*19.37e-2   0.32e-2;% 1/6 of TTRA(trapezius T1)
%                      DYDATA.PCSA_scaling_factor*409.23   15.91e-2   0         5.5*15.91e-2   0.42e-2;% 5/6 of TTRA + 1/6 of TASE (trapezius T2-T7)
%                      DYDATA.PCSA_scaling_factor*514.51   14.84e-2   0         5.5*14.84e-2   5.79e-2;% TERM
%                      DYDATA.PCSA_scaling_factor*484.35   16.58e-2   0         5.5*16.58e-2   9.03e-2;% PECT
%                      DYDATA.PCSA_scaling_factor*392.91   15.36e-2  10         5.5*15.36e-2  22.93e-2;% BICL
%                      DYDATA.PCSA_scaling_factor*461.76   13.07e-2  10         5.5*13.07e-2  22.98e-2;% BICS
%                      DYDATA.PCSA_scaling_factor*629.21   15.24e-2  15         5.5*15.24e-2  19.05e-2;% TLOH
%                      DYDATA.PCSA_scaling_factor*1268.87   6.17e-2  15         5.5*6.17e-2   19.64e-2;% TLAH
%                      DYDATA.PCSA_scaling_factor*853.90   10.28e-2  15         5.5*10.28e-2   1.75e-2;% BRAC 
%                      DYDATA.PCSA_scaling_factor*560.70    4.78e-2  15         5.5*4.78e-2   27.14e-2;% FLCU
%                      DYDATA.PCSA_scaling_factor*1099.61   9.76e-2   0         5.5*9.76e-2    5.58e-2];% INFS    
                 
                 
muscle_parameters = [DYDATA.PCSA_scaling_factor*32.9703*1e4*MWDATA{20, 1}.MSCInfo.PCSA   14.68e-2   0         5.5*14.68e-2   1.64e-2;% DANT
                     DYDATA.PCSA_scaling_factor*32.9996*1e4*MWDATA{21, 1}.MSCInfo.PCSA   9e-2       0         5.5*9e-2       8.56e-2;% DMED
                     DYDATA.PCSA_scaling_factor*32.9930*1e4*MWDATA{22, 1}.MSCInfo.PCSA   17.02e-2   0         5.5*17.02e-2   5.93e-2;% DPOS
                     DYDATA.PCSA_scaling_factor*33.0332*1e4*MWDATA{6, 1}.MSCInfo.PCSA    21.44e-2   0         5.5*21.44e-2   0.60e-2;% TDES (trapezius C7)
                     DYDATA.PCSA_scaling_factor*33.0464*1e4*MWDATA{7, 1}.MSCInfo.PCSA    19.37e-2   0         5.5*19.37e-2   0.32e-2;% 1/6 of TTRA(trapezius T1)
                     DYDATA.PCSA_scaling_factor*33.0024*1e4*MWDATA{8, 1}.MSCInfo.PCSA    15.91e-2   0         5.5*15.91e-2   0.42e-2;% 5/6 of TTRA + 1/6 of TASE (trapezius T2-T7)
                     DYDATA.PCSA_scaling_factor*32.7922*1e4*MWDATA{27, 1}.MSCInfo.PCSA   14.84e-2   0         5.5*14.84e-2   5.79e-2;% TERM
                     DYDATA.PCSA_scaling_factor*32.9939*1e4*MWDATA{15, 1}.MSCInfo.PCSA   16.58e-2   0         5.5*16.58e-2   9.03e-2;% PECT
                     DYDATA.PCSA_scaling_factor*32.9899*1e4*MWDATA{33, 1}.MSCInfo.PCSA   15.36e-2  10         5.5*15.36e-2  22.93e-2;% BICL
                     DYDATA.PCSA_scaling_factor*33.0064*1e4*MWDATA{32, 1}.MSCInfo.PCSA   13.07e-2  10         5.5*13.07e-2  22.98e-2;% BICS
                     DYDATA.PCSA_scaling_factor*32.9948*1e4*MWDATA{29, 1}.MSCInfo.PCSA   15.24e-2  15         5.5*15.24e-2  19.05e-2;% TLOH
                     DYDATA.PCSA_scaling_factor*33.0005*1e4*MWDATA{31, 1}.MSCInfo.PCSA    6.17e-2  15         5.5*6.17e-2   19.64e-2;% TLAH
                     DYDATA.PCSA_scaling_factor*32.9946*1e4*MWDATA{34, 1}.MSCInfo.PCSA   10.28e-2  15         5.5*10.28e-2   1.75e-2;% BRAC 
                     DYDATA.PCSA_scaling_factor*33.0018*1e4*MWDATA{39, 1}.MSCInfo.PCSA    4.78e-2  15         5.5*4.78e-2   27.14e-2;% FLCU
                     DYDATA.PCSA_scaling_factor*33.0015*1e4*MWDATA{24, 1}.MSCInfo.PCSA    9.76e-2   0         5.5*9.76e-2    5.58e-2];% INFS 
                 
% run the model through the measured kinematics to have the muscle-tendon lengths
% They are saved in SSDATA.L_mt field
SSDATA = muscle_length(t, SSDATA, BLDATA, MWDATA);

% define the muscle forces using the muscle model
for muscle_id = 1 : length(muscle_list)
    
    disp(['Calculating EMG to force in ' muscle_list{muscle_id} '(' num2str(muscle_id) '/' num2str(length(muscle_list)) ')']);
    
    bound = 1; % which part of the EMG data should be considered (1: mean, 2: +sigma, 3:-sigma)
    
    if muscle_id == 5
        [sol, f_l, f_p, f_v, f_t, tendon_length, a_muscle, cos_alpha] = EMG_based_force_prediction(muscle_parameters(muscle_id, :), [t(1, 1) t(1, end)],...
                                                                           [SSDATA.EMG_data.(muscle_list{muscle_id})(4, :); (1/6)*SSDATA.EMG_data.(muscle_list{muscle_id})(bound, :)],...                                                       
                                                                            eval(['SSDATA.L_mt.' (muscle_list{muscle_id}) '_length']));         
    elseif muscle_id == 6
        [sol, f_l, f_p, f_v, f_t, tendon_length, a_muscle, cos_alpha] = EMG_based_force_prediction(muscle_parameters(muscle_id, :), [t(1, 1) t(1, end)],...
                                                                           [SSDATA.EMG_data.(muscle_list{muscle_id})(4, :); (1/6)*SSDATA.EMG_data.(muscle_list{muscle_id})(bound, :)+(5/6)*SSDATA.EMG_data.(muscle_list{muscle_id-1})(bound, :)],...                                                       
                                                                            eval(['SSDATA.L_mt.' (muscle_list{muscle_id}) '_length']));         
    else
        [sol, f_l, f_p, f_v, f_t, tendon_length, a_muscle, cos_alpha] = EMG_based_force_prediction(muscle_parameters(muscle_id, :), [t(1, 1) t(1, end)],...
                                                                           [SSDATA.EMG_data.(muscle_list{muscle_id})(4, :); SSDATA.EMG_data.(muscle_list{muscle_id})(bound, :)],...                                                       
                                                                            eval(['SSDATA.L_mt.' (muscle_list{muscle_id}) '_length'])); 
    end
    % syntax: [sol, f_t, tendon_length] = EMG_based_force_prediction(muscle_par, tspan, excitation, l_MT_length)
                                                       
                                                
     %time.(muscle_list{muscle_id}) = sol.x;
     SSDATA.f_T.(muscle_list{muscle_id})  = f_t;
%      f_V.(muscle_list{muscle_id})  = f_v;
      SSDATA.f_P.(muscle_list{muscle_id})  = f_p;
%      f_L.(muscle_list{muscle_id})  = f_l;
%      l_T.(muscle_list{muscle_id}) = tendon_length;
%      a_m.(muscle_list{muscle_id}) = deval(a_muscle, time);
%      cos_alp.(muscle_list{muscle_id}) = cos_alpha;
%      %f_T_try1.(muscle_list{muscle_id})  = cos_alpha.*(deval(a_muscle, time).*f_l.*f_v/muscle_parameters(muscle_id, 1));
     clear sol f_t f_v f_p f_l tendon_length a_muscle cos_alpha
end

% plot the results together with the optimization-based results
figure('name', 'EMG to force',...
       'Units','normalized', 'position', [0.2, 0.3, 0.8, 0.7])
for muscle_id = 1 : length(muscle_list)
    subplot(3, 5, muscle_id)
    
%     %plot(time, f_L.(muscle_list{muscle_id}), '--k', 'linewidth', 1)
     hold on
     plot(t(1,:), SSDATA.f_P.(muscle_list{muscle_id}), '-.k', 'linewidth', 1)
%     %plot(time, f_V.(muscle_list{muscle_id}), ':k', 'linewidth', 1)
%     plot(time, cos_alp.(muscle_list{muscle_id}).*(a_m.(muscle_list{muscle_id}).*f_L.(muscle_list{muscle_id}).*f_V.(muscle_list{muscle_id})/muscle_parameters(muscle_id, 1) + f_P.(muscle_list{muscle_id}) - f_P.(muscle_list{muscle_id})), 'k.', 'MarkerSize', 8)
%     plot(time, f_T.(muscle_list{muscle_id}), 'r', 'linewidth', 3)
%     plot(time, eval([muscle_list{muscle_id} '_force' '(2, :)']), 'b', 'linewidth', 3)
    plot(t(1,:), SSDATA.f_T.(muscle_list{muscle_id}), 'k', 'linewidth', 3)
    xlabel('time [s]')
    ylabel('force in muscle [N]')
    ylim([0 inf])
    xlim([0 t(1, end)])
    grid on
    title(['average ' muscle_list{muscle_id}])
    %legend('f^l', 'f^p', 'f^v', 'f^{lvp}','f^t', 'f_{opt}', 'Location','best')
    set(gca,'FontSize',20);
    
end

return;


% -------------------------------------------------------------------------
% function to define the muscle-tendon lengths for the measured motion
% -------------------------------------------------------------------------
function SSDATA = muscle_length(t, SSDATA, BLDATA, MWDATA)

% Define Angles, Velocities, & Accelerations
% first chose among the two available options for the kinematics
% for ja_id = 1:11
%     JEA(ja_id,:)      = polyval(SSDATA.Joint_Angle_Coefficients(ja_id,:),t);
%     dJEAdt(ja_id,:)   = polyval(SSDATA.Joint_Velocity_Coefficients(ja_id,:),t);
%     d2JEAdt2(ja_id,:) = polyval(SSDATA.Joint_Acceleration_Coefficients(ja_id,:),t);
% end
JEA = SSDATA.Joint_Angle_Reconstruction; % direct use of the IK results instead of smoothening them as it's the case for the lines above

% Initialise the MADATA structure
MADATA = cell(42, 1);

% Each element in the cell will contain a 9 x N matrix
for MuscleId = 1:42
    for SegmentId = 1:20
        MADATA{MuscleId, 1}.MuscleLength(:,SegmentId) = zeros(size(JEA,2),1);
    end
end


for TimeId = 1:size(JEA,2)

    % Get the Current Rotation Matrices
    %Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles', KEDATA.Joint_Angle_Evolution(:,TimeId), BLDATA);
    Rmat = MAIN_TOOL_geometry_functions('Build Rotation Matrices From Euler Angles', JEA(:,TimeId), BLDATA);

    % Update the current configuration
    BLDATA = MAIN_TOOL_geometry_functions(...
                    'Update Current Bony Landmark Data from Joint Rotation Matrices', Rmat(:,1:3), Rmat(:,4:6), Rmat(:,7:9), Rmat(:,10:12), Rmat(:,13:15), BLDATA);
    
    %----------------------------------------------------------------------
    % MOMENT ARMS & FORCE DIRECTIONS : GEOMETRIC METHOD FOR EACH MUSCLE
    %----------------------------------------------------------------------
    % Pre-define Moment Arm Matrix
    Wmat = [];
    Dmat = [];
    Lmat = zeros(42,20);
    for MuscleId = 1:42
        for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
            % Construct a One-Time Muscle Structure for a single segment
            Muscle_Seg.Origin       = MWDATA{MuscleId,1}.Origin{1,SegmentId};
            Muscle_Seg.ViaA         = MWDATA{MuscleId,1}.ViaA{1,SegmentId};
            Muscle_Seg.ViaB         = MWDATA{MuscleId,1}.ViaB{1,SegmentId};
            Muscle_Seg.Insertion    = MWDATA{MuscleId,1}.Insertion{1,SegmentId};
            Muscle_Seg.OriginRef    = MWDATA{MuscleId,1}.MSCInfo.OriginRef;
            Muscle_Seg.ViaARef      = MWDATA{MuscleId,1}.MSCInfo.ViaARef;
            Muscle_Seg.ViaBRef      = MWDATA{MuscleId,1}.MSCInfo.ViaBRef;
            Muscle_Seg.InsertionRef = MWDATA{MuscleId,1}.MSCInfo.InsertionRef;
            Muscle_Seg.ObjectCentre = MWDATA{MuscleId,1}.MSCInfo.ObjectCentre;
            Muscle_Seg.ObjectType   = MWDATA{MuscleId,1}.MSCInfo.ObjectType;
            Muscle_Seg.ObjectZaxis  = MWDATA{MuscleId,1}.MSCInfo.ObjectZaxis;
            Muscle_Seg.ObjectRef    = MWDATA{MuscleId,1}.MSCInfo.ObjectRef;
            Muscle_Seg.ObjectRadii  = MWDATA{MuscleId,1}.MSCInfo.ObjectRadiiscale*MWDATA{MuscleId,1}.MSCInfo.ObjectRadii;
            Muscle_Seg.NbPlot       = MWDATA{MuscleId,1}.MSCInfo.NbPlotPoints;
            
            % Compute the Wrapping
            WRDATA = MUSCLE_TOOL_compute_wrapping(BLDATA, Muscle_Seg);
            
            % Fill The Length
            Lmat(MuscleId, SegmentId) = 1.e-3*WRDATA.PathLength;
            

        end
    end


    % Save the Muscle Forces
    valueId = 1;
    for MuscleId = 1:44
        % Save the Scapulothoracic data
        if MuscleId < 3

            valueId = valueId + 1;
        else
            for SegmentId = 1:MWDATA{MuscleId-2, 1}.MSCInfo.NbSegments
                MADATA{MuscleId-2, 1}.MuscleLength(TimeId,SegmentId) = Lmat(MuscleId-2, SegmentId);
                valueId = valueId + 1;
            end
        end
    end
end

SSDATA.L_mt.DANT_length(:,:) = [t; MADATA{20, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.DMED_length(:,:) = [t; MADATA{21, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.DPOS_length(:,:) = [t; MADATA{22, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.TDES_length(:,:) = [t; MADATA{6, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.TTRA_length(:,:) = [t; MADATA{7, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.TASE_length(:,:) = [t; MADATA{8, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.TERM_length(:,:) = [t; MADATA{27, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.PECT_length(:,:) = [t; MADATA{15, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.BICL_length(:,:) = [t; MADATA{33, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.BICS_length(:,:) = [t; MADATA{32, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.TLOH_length(:,:) = [t; MADATA{29, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.TLAH_length(:,:) = [t; MADATA{31, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.BRAC_length(:,:) = [t; MADATA{34, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.FLCU_length(:,:) = [t; MADATA{39, 1}.MuscleLength(:,1)'];
SSDATA.L_mt.INFS_length(:,:) = [t; MADATA{24, 1}.MuscleLength(:,1)'];

return;

