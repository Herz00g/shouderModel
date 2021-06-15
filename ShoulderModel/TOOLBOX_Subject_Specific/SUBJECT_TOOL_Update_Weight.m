function [DYDATA, MWDATA] = SUBJECT_TOOL_Update_Weight(SGUIHandle, DYDATAin, MWDATAin)

%{
Function for updating the inertia properties of the generic model based on
the subject weight and height
--------------------------------------------------------------------------
Syntax :
SUBJECT_TOOL_Update_PCSA(SGUIHandle, MWDATA)
--------------------------------------------------------------------------
File Description :
The scaling factors here are mainly choosen from: "R. Dumas et al. / Journal
of Biomechanics 40 (2007) 543?553".
For those properties such as scpula mass which there was not the associated
information in that paper I simply defined the scaling factor such that we
can have the same value for at least the generic model. This can be
improved later on easily in case we had the associated scaling factors for
these bones. Clavicle, ulna, and radius have the same story. Clavicle and 
scapula keep their generic inertia values
--------------------------------------------------------------------------
%}
DYDATA = DYDATAin; % initialize the inputs
MWDATA = MWDATAin;


Subject_Gender = get(SGUIHandle.Gender_Selection.Gender,'Value'); % import the subject's gender?from the GUI

Subject_Weight = str2double(get(SGUIHandle.Weight_Selection.Weight,'String')); % import the subject's weight [Kg]?from the GUI

Subject_Height = str2double(get(SGUIHandle.Height_Selection.Height,'String')); % import the subject's height [m]?from the GUI

DYDATA.Height_Scaling_Factor = [Subject_Height/1.86 0 0; 0 Subject_Height/1.86 0; 0 0 Subject_Height/1.86]; % define the scaling factor to scale the bony landmarks
%DYDATA.Height_Scaling_Factor = [1 0 0; 0 1 0; 0 0 Subject_Height/1.86]; % define the scaling factor to scale the bony landmarks

BMI = Subject_Weight/(Subject_Height^2); % BMI of the understudy subject
    
R_m_g = 1-(-0.09 + 0.0149*(85.5/(1.86^2)) - 0.00009*((85.5/(1.86^2))^2)); % body muscle percentage of the generic model
            
    
if Subject_Gender == 2 % male subject
    % for scaling the PCSA based on the body weight
        R_f = -0.09 + 0.0149*BMI - 0.00009*(BMI^2);
        R_m = 1 - R_f;
        PCSA_scaling_factor = R_m/R_m_g;
    % save this for the EMG assisted load-sharing
    DYDATA.PCSA_scaling_factor = PCSA_scaling_factor;
        
    DYDATA.Inertia(1,1) = 0.18e-2*Subject_Weight; % Mc
    DYDATA.Inertia(1,2) = 0.82e-2*Subject_Weight; % Ms
    DYDATA.Inertia(1,3) = 2.4e-2*Subject_Weight;  % Mh
    DYDATA.Inertia(1,4) = 0.62*1.7e-2*Subject_Weight; % Mu: This one is a bit messy, because the forearm is mentioned in the BSIP studies and I deceided to consider 62% of the forearm mass as the ulna
    DYDATA.Inertia(1,5) = 0.38*1.7e-2*Subject_Weight; % Mr: The same as above.
%     DYDATA.Inertia(2,1) =  % Ict: Clavicle and scapula keep their generic inertia values
%     DYDATA.Inertia(2,2) =  % Icl 
%     DYDATA.Inertia(3,1) =  % Ist
%     DYDATA.Inertia(3,2) =  % Isl

    DYDATA.Segments_Lenghts.Humerus = (27.1/177)*Subject_Height; % scale the humerus lenght according to the body height
    DYDATA.Segments_Lenghts.Ulna = (28.3/177)*Subject_Height; % scale the ulna lenght according to the body height
    DYDATA.Segments_Lenghts.Radius = (28.3/177)*Subject_Height; % scale the radius lenght according to the body height
    
    DYDATA.Inertia(4,1) = (0.315*DYDATA.Segments_Lenghts.Humerus)^2*2.4e-2*Subject_Weight; % Iht
    DYDATA.Inertia(4,2) = (0.14*DYDATA.Segments_Lenghts.Humerus)^2*2.4e-2*Subject_Weight; % Ihl
    DYDATA.Inertia(5,1) = (0.275*DYDATA.Segments_Lenghts.Ulna)^2*0.62*1.7e-2*Subject_Weight; % Iut 
    DYDATA.Inertia(5,2) = (0.11*DYDATA.Segments_Lenghts.Ulna)^2*0.62*1.7e-2*Subject_Weight; % Iul
    DYDATA.Inertia(6,1) = (0.275*DYDATA.Segments_Lenghts.Radius)^2*0.38*1.7e-2*Subject_Weight; % Irt
    DYDATA.Inertia(6,2) = (0.11*DYDATA.Segments_Lenghts.Radius)^2*0.38*1.7e-2*Subject_Weight; % Irl
   
elseif Subject_Gender == 3 % female subject
        % for scaling the PCSA using the body weight
        
        R_f = -0.08 + 0.0203*BMI - 0.000156*(BMI^2);
        R_m = 1 - R_f;
        PCSA_scaling_factor = R_m/R_m_g; 
    % save this for the EMG assisted load-sharing
    DYDATA.PCSA_scaling_factor = PCSA_scaling_factor;
    
    DYDATA.Inertia(1,1) = 0.18e-2*Subject_Weight; % Mc
    DYDATA.Inertia(1,2) = 0.82e-2*Subject_Weight; % Ms
    DYDATA.Inertia(1,3) = 2.2e-2*Subject_Weight; % Mh
    DYDATA.Inertia(1,4) = 0.62*1.3e-2*Subject_Weight; % Mu
    DYDATA.Inertia(1,5) = 0.38*1.3e-2*Subject_Weight; % Mr
    
%     DYDATA.Inertia(2,1) =  % Ict
%     DYDATA.Inertia(2,2) =  % Icl 
%     DYDATA.Inertia(3,1) =  % Ist
%     DYDATA.Inertia(3,2) =  % Isl

    DYDATA.Segments_Lenghts.Humerus = (24.3/161)*Subject_Height; % scale the humerus lenght according to the body height
    DYDATA.Segments_Lenghts.Ulna = (24.7/161)*Subject_Height; % scale the ulna lenght according to the body height
    DYDATA.Segments_Lenghts.Radius = (24.7/161)*Subject_Height; % scale the radius lenght according to the body height
    
    DYDATA.Inertia(4,1) = (0.33*DYDATA.Segments_Lenghts.Humerus)^2*2.2e-2*Subject_Weight; % Iht
    DYDATA.Inertia(4,2) = (0.17*DYDATA.Segments_Lenghts.Humerus)^2*2.2e-2*Subject_Weight; % Ihl
    DYDATA.Inertia(5,1) = (0.255*DYDATA.Segments_Lenghts.Ulna)^2*0.62*1.3e-2*Subject_Weight; % Iut 
    DYDATA.Inertia(5,2) = (0.14*DYDATA.Segments_Lenghts.Ulna)^2*0.62*1.3e-2*Subject_Weight; % Iul
    DYDATA.Inertia(6,1) = (0.255*DYDATA.Segments_Lenghts.Radius)^2*0.38*1.3e-2*Subject_Weight; % Irt
    DYDATA.Inertia(6,2) = (0.14*DYDATA.Segments_Lenghts.Radius)^2*0.38*1.3e-2*Subject_Weight; % Irl
else
    disp('Please specify the subject''s gender.');
end

% updating the PCSA
    for muscle_id = 1: 42
        MWDATA{muscle_id, 1}.MSCInfo.PCSA = PCSA_scaling_factor*MWDATA{muscle_id, 1}.MSCInfo.PCSA;
        MWDATA{muscle_id,1}.MSCInfo.Fmax = PCSA_scaling_factor*MWDATA{muscle_id,1}.MSCInfo.Fmax;
    end

return;