function [SSDATA] = KINEMATICS_TOOL_data_filteration(task, varargin)
%{
Function for filtering and transforming the uploaded raw measured data.
--------------------------------------------------------------------------
Syntax
[SSDATA] = KINEMATICS_TOOL_data_filteration(task, varargin)
--------------------------------------------------------------------------
File Description :
This function performs the following tasks depending on what task argument
is defined:
    case 1: residual analysis
    case 2: harmonic analysis
    case 3: filter and transform the data
The residual and harmonic analysis are provided to provide the user with a
sense of the measured data in order to help him/her decide what cutoff
frequency should be chosen for the low-pass filtering of the data. At the
end, when the user input the data for the cutoff frequency and filter order
the next step is to filter the data and transform them into the Matlab
(thorax) coordinate system.
Note that if the imported raw data  has been already transformed and
filtered user should skip thi spart of the GUI.
--------------------------------------------------------------------------
%}

% define the landmarks list necessary for all the cases
landmark_list = {'IJ' 'PX' 'C7' 'T8' 'SC' 'Ac' 'AA' 'EL' 'EM' 'RS' 'US'}; 

% sampling frequency of VICON
fs = 100; 

% -------------------------------------------------------------------------
% CASE 1: Residual Analysis
% -------------------------------------------------------------------------
if isequal(task, 'Residual Analysis')
    
    % take the input data
    SSDATAin = varargin{1,1};
    raw_landmarks = SSDATAin.Measured_Kinematics;
    
    % define the range of cutoff frequency required for the residual
    % analysis
    cutoff_frequency_range = 1:0.1:4;
    
    % filter the all the data over the given range of cutoff frequency
    for CF_Id = 1:length(cutoff_frequency_range)
        
        % design the filter for the given cutoff frequency
        [B_filt A_filt] = butter(4, cutoff_frequency_range(CF_Id)*2/fs);
            
            % filter all the data over for each CF_Id
            for LM_Id = 1:11 % for landmark id
                
                % take the raw data of the landmark LM_Id and put it in X 
                X = (raw_landmarks.(landmark_list{LM_Id})(:,:))';
                
                % filter the raw data in X
                X_filtered = filtfilt(B_filt, A_filt, X);
                
                % define the residual of the landmark LM_Id for the cutoff
                % frequency CF_Id and save it in the structure named
                % residual
                residual.(landmark_list{LM_Id})(:, CF_Id) = diag((X-X_filtered)'*(X-X_filtered))/length(X);
            end
    end
    
    % show the results of the residual analysis
    figure('units', 'normalized',...
           'position', [0.2, 0.3, 0.9, 0.9],...
           'name', 'residual analysis');
    
    for LM_Id = 1 :11 % for landmarks id
            subplot(3,4,LM_Id)
            resdiue = residual.(landmark_list{LM_Id});       
            p = plot(cutoff_frequency_range, resdiue, 'o', 'MarkerSize', 8);
            p(1).Color = 'r'; p(2).Color = 'g'; p(3).Color = 'b';
            title([landmark_list{LM_Id}])
            xlabel('frequency [Hz]');
            ylabel('residual');
            legend('x','y','z');
            set(gca,'FontSize',16);
            grid on
    end

% -------------------------------------------------------------------------
% CASE 1: Harmonic Analysis
% -------------------------------------------------------------------------
elseif isequal(task, 'Harmonic Analysis')
    
    % take the input data
    SSDATAin = varargin{1,1};
    raw_landmarks = SSDATAin.Measured_Kinematics;
    
    % show the results of harmonic analysis for all the landmarks (I do not
    % need to save them)
    figure('units', 'normalized',...
           'position', [0.2, 0.3, 0.9, 0.9],...
           'name', 'Harmonic Analysis');
    
       for LM_Id = 1 :11 % for landmarks id
            subplot(3,4,LM_Id)
            
            % take the raw data of the landmark LM_Id
            X = (raw_landmarks.(landmark_list{LM_Id}))'; 
            
            % define the PSD of the landmark            
            [Pxx, f] = pwelch(X, floor(fs/2), [], [], fs);
            
            p = plot(f, Pxx, 'LineWidth', 2);
            p(1).Color = 'r'; p(2).Color = 'g'; p(3).Color = 'b';
            title([landmark_list{LM_Id}]);
            xlabel('frequency');
            ylabel('signal power');
            legend('x','y','z');
            set(gca,'FontSize',16);
            grid on
       end
% -------------------------------------------------------------------------
% CASE 3: Filter and Transform Data
% -------------------------------------------------------------------------
elseif isequal(task, 'Filter Data')
        
    % take the input data
    SSDATAin = varargin{1,1};
    raw_landmarks = SSDATAin.Measured_Kinematics;
    
    % take the cutoff frequency from the user inputted data in the GUI
    KRGUIHandlein = varargin{1,2};
    CF = str2num(KRGUIHandlein.Cutoff_Frequency.Edit.String);
    
    % take the filter order from the data provided by the user
    filter_order = str2num(KRGUIHandlein.Filter_Order.Edit.String);

    % define the filter transfer function. We use 4th order butterworth filter
    % that will transfrom into 8th order zero-phase low-pass filter as we use
    % filtfilt in order to eliminate the phase lag of the forward filtering.
    [B_denom A_nom] = butter(filter_order, CF*2/fs);
    
    % 1) ------------------------------------------------------------------
    % low-pass filter the raw landmarks and plot them together with the raw
    % data
    figure('units', 'normalized',...
           'position', [0.2, 0.3, 0.9, 0.9],...
           'name', ['filtered data yet in VICON frame']);
       
        for LM_Id = 1 :11 % for landmarks id
            subplot(3,4,LM_Id)
            
            % get the landmarks' coordinates
            X = (raw_landmarks.(landmark_list{LM_Id}))'; 
            
            % filter the landmark data
            X_filtered.(landmark_list{LM_Id}) = filtfilt(B_denom, A_nom, X)'; 
            
            % construct the time for each landmark, in fact it's the same for all the landmarks of an activity-trial
            time = 0:1/fs:length(X)/fs-1/fs;
            
            % plot both the raw and filter data
            p = plot(time, X_filtered.(landmark_list{LM_Id}),...
                     time, X, '--', 'LineWidth', 2);
            p(1).Color = 'r'; p(2).Color = 'g'; p(3).Color = 'b';
            p(4).Color = 'r'; p(5).Color = 'g'; p(6).Color = 'b';
            title([landmark_list{LM_Id}]);
            xlabel('time [s]');
            ylabel('position in VICON frame [mm]');
            legend('filtered x','filtered y','filtered z', 'raw x', 'raw y', 'raw z');
            set(gca,'FontSize',16);
            grid on
        end

    % 2) ------------------------------------------------------------------
    % transform the data from VICON coordinate to the Matlab (thorax)
    % coordinate system
    
    % go over all the data frames
    for frameId = 1: length(X_filtered.(landmark_list{1}))
        
        % get the landmarks' coordinates for the current frame
        for LM_Id = 1 : 11 % for landmarks id
            
            X_current.(landmark_list{LM_Id}) = X_filtered.(landmark_list{LM_Id})(:, frameId);
                                  
        end
        
        if frameId == 1
        % VICON -> MATLAB Rotation Matrix for the current frame
        Zt = (X_current.C7 + X_current.IJ)/2 - (X_current.T8 + X_current.PX)/2;
        Xt = cross(X_current.C7 - X_current.IJ, (X_current.T8 + X_current.PX)/2-X_current.IJ); 
        Yt = cross(Zt, Xt); 
        R_am = [Xt/norm(Xt), Yt/norm(Yt), Zt/norm(Zt)]'; %R_am=R_matlab', which means
            %R_matlab map the points in matlab to AMIRA. For instance if you think
            %about R_matlab*[1 0 0]' it returns the associated vector (point) related
            %to the x axis of matlab in amira. Obviously it will be the first column of
            %the R_matlab.
        
        
        % Homogeneous transformation Matrix which maps a point in AMIRA to matlab
        % coordinate system
        H_am = [[R_am, -R_am*X_current.IJ]; [0, 0, 0, 1]];
        
        end
        
        % Transform all points to MATLAB reference frame and then get rid of the
        % homegeneous part
            for LM_Id = 1 : 11 % for landmarks id
                
                X_current.(landmark_list{LM_Id}) = H_am*[X_current.(landmark_list{LM_Id}); 1];
                
            end
            
%             IJ = H_am*[IJ; 1]; measurement_pure2_t1.IJ(:,FrameId) = IJ(1:3,1);
%             PX = H_am*[PX; 1]; measurement_pure2_t1.PX(:,FrameId) = PX(1:3,1); 
%             T8 = H_am*[T8; 1]; measurement_pure2_t1.T8(:,FrameId) = T8(1:3,1);
%             C7 = H_am*[C7; 1]; measurement_pure2_t1.C7(:,FrameId) = C7(1:3,1);
%             SC = H_am*[SC; 1]; measurement_pure2_t1.SC(:,FrameId) = SC(1:3,1);
%             Ac = H_am*[Ac; 1]; measurement_pure2_t1.Ac(:,FrameId) = Ac(1:3,1);
%             AA = H_am*[AA; 1]; measurement_pure2_t1.AA(:,FrameId) = AA(1:3,1);
%             EL = H_am*[EL; 1]; measurement_pure2_t1.EL(:,FrameId) = EL(1:3,1);
%             EM = H_am*[EM; 1]; measurement_pure2_t1.EM(:,FrameId) = EM(1:3,1);
%             US = H_am*[US; 1]; measurement_pure2_t1.US(:,FrameId) = US(1:3,1);
%             RS = H_am*[RS; 1]; measurement_pure2_t1.RS(:,FrameId) = RS(1:3,1);
            
            % save the filtered and transformed data per frame
            for LM_Id = 1 : 11 % for landmarks id
                
                Measured_Kinematics.(landmark_list{LM_Id})(:, frameId) = X_current.(landmark_list{LM_Id})(1:3,1);
            
            end
    end
    
% replace the unfiltered and untrasnformed data by the recent filtered and
% transformed data   
SSDATA.Measured_Kinematics = Measured_Kinematics;  

% display a message for the user
msgbox(['the imported raw data was filtered, transformed, and saved in',...
      'SSDATA.Measured_Kinematics data structure'], 'Success');
% -------------------------------------------------------------------------
% CASE 4: if not a valid task
% -------------------------------------------------------------------------
else
    % Throw an error. No valid task was given
    ErrorMsg = [...
        'The user supplied task is not valid.',...
        'KINEMATICS_TOOL_data_filteration requires a valid task as input.\n',...
        'Try the Following : \n',...
        '1) Residual Analysis,\n',...
        '2) Harmonic Analysis,\n',...
        '3) Filter Data,\n',...
        '4) :),\n',...
        '9) .'];
    error('ScptGen:ErrorMsg', ErrorMsg);
    
end


return



 