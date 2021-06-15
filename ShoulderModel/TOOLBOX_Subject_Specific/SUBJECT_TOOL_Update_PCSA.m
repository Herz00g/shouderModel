function MWDATA = SUBJECT_TOOL_Update_PCSA(SGUIHandle, MWDATAin)

%{
Function for adapting the PCSA of different muscles.
--------------------------------------------------------------------------
Syntax :
MWDATA = SUBJECT_TOOL_Update_PCSA(SGUIHandle, MWDATAin)
--------------------------------------------------------------------------
File Description :

--------------------------------------------------------------------------
%}

MWDATA = MWDATAin; % initialize the input

MuscleID = get(SGUIHandle.PCSA_Selection.MuscleName, 'value') - 1; % get the muscle idea that the user wants to change

NewPCSA = str2double(get(SGUIHandle.PCSA_Selection.PCSA, 'String')); % get the associated value for the PCSA of the selected muscle

if MuscleID>0
MWDATA{MuscleID, 1}.MSCInfo.PCSA = 1e-4*NewPCSA; % update the associated value for the PCSA from the generic model

MWDATA{MuscleID,1}.MSCInfo.Fmax = NewPCSA*3.3011*10; % update the maximum force of the muscle based on the change in the PCSA
else% scale everything based on the BMI of the subject
%     Subject_Gender = get(SGUIHandle.Gender_Selection.Gender,'Value'); % import the subject's gender?from the GUI
% 
%     Subject_Weight = str2double(get(SGUIHandle.Weight_Selection.Weight,'String')); % import the subject's weight [Kg]?from the GUI
% 
%     Subject_Height = str2double(get(SGUIHandle.Height_Selection.Height,'String')); % import the subject's height [m]?from the GUI
% 
%     BMI = Subject_Weight/(Subject_Height^2);
%     
%     R_m_g = 1-(-0.09 + 0.0149*(85.5/(1.86^2)) - 0.00009*((85.5/(1.86^2))^2)); 
%     
%     if Subject_Gender == 2 % male
%         
%         R_f = -0.09 + 0.0149*BMI - 0.00009*(BMI^2);
%         
%         R_m = 1 - R_f;
%         
%         PCSA_scaling_factor = R_m/R_m_g;
%         
%     elseif Subject_Gender == 3 % female
%         
%         R_f = -0.08 + 0.0203*BMI - 0.000156*(BMI^2);
%         
%         R_m = 1 - R_f;
%         
%         PCSA_scaling_factor = R_m/R_m_g; 
%     end
%     
%     for muscle_id = 1: 42
%         MWDATA{muscle_id, 1}.MSCInfo.PCSA = PCSA_scaling_factor*MWDATA{muscle_id, 1}.MSCInfo.PCSA;
%         MWDATA{muscle_id,1}.MSCInfo.Fmax = 3.3011*10*MWDATA{muscle_id, 1}.MSCInfo.PCSA;
%     end
        
    % do nothing
end

return;