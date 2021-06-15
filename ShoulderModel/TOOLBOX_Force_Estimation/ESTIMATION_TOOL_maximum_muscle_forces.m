function FMAX = ESTIMATION_TOOL_maximum_muscle_forces(ESTDATA, DYDATA, MWDATA)

% Initialise the Output
FMAX = [];
    
% Initialise a local indexing variable
k = 0;
Pesh = 50;

% Use the Model which depends on the muscle length and velocity
if isequal(ESTDATA.FmaxOption, 'on') % it would not be on anymore
    for MuscleId = 1:42
        for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
            k = k+1;
            
            % Get the Muscle Length
            Lm = ESTDATA.Muscle_Length(MuscleId, SegmentId);

            % Get the Muscle Velocity (invert muscle velocity, positive = contraction, negative = elongation)
            dLmdt = -ESTDATA.Moment_Arm_Matrix(:,k)'*DYDATA.dJEAdt;

            % Define the Maximum and Minimum muscle lengths
            Lm_max = 2.5*MWDATA{MuscleId, 1}.MSCInfo.Lmax;
            Lm_min = 0.4*MWDATA{MuscleId, 1}.MSCInfo.Lmin;
            
            % Get the Optimum Fiber Length
            Lopt = 0.7;
            
            % All these parameters are guessed...
            Lsh = 0.6;      % [m]
            Ver = 0.5;      % [-]
            Vml = 1.3;      % [-]
            Lt = 0.02;      % [m]
            Lce0 = Lm_min + Lopt*(Lm_max - Lm_min) - Lt;  % [m]
            Vvm = 6*Lce0;   % [m/s]
            Vsh = 0.3;      % [-]
            Vshl = 0.23;    % [-]
            Lce = Lm - Lt;  % [m]
            Lcesh = Lsh*(Lm_max - Lm_min);  % [m]
            
            % Compute the Length Function
            Flce = exp(-((Lce - Lce0)/Lcesh)^2);
            
            % Compute the Muscle Velocity Function
            Fvce = Flce;
            
            Vmax = Vvm*(1 - Ver*(1 - Flce));
  
            if dLmdt <= -Vmax
                Fvce = 0;
            elseif dLmdt > -Vmax && dLmdt < 0
                Fvce = Vsh*(Vmax + dLmdt)/(Vsh*Vmax - dLmdt);
            elseif dLmdt >= 0
                Fvce = (Vsh*Vshl*Vmax + Vml*dLmdt)/(Vsh*Vshl*Vmax + dLmdt);
            else
                Fvce = 0;
            end

            % Compute the Maximum Muscle Force (Activation is set to 1)
            FMAX(k,1) = Flce.*Fvce.*MWDATA{MuscleId, 1}.MSCInfo.Fmax + MWDATA{MuscleId, 1}.MSCInfo.Fmax/exp(Pesh)*(exp(Pesh/Lm_max*Lm) - 1); 
        end
    end
% Simply use the maximum forces as is
else
    for MuscleId = 1:42
        for SegmentId = 1:MWDATA{MuscleId, 1}.MSCInfo.NbSegments
            k = k+1;
            FMAX(k,1) = MWDATA{MuscleId, 1}.MSCInfo.Fmax;
        end
    end
end

return;