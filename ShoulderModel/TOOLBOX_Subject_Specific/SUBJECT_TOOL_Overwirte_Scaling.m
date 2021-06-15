function DYDATA = SUBJECT_TOOL_Overwirte_Scaling(DYDATAin, SSDATAin, SGUIHandle, )
%{
Function for updating the inertia properties of the generic model based on
the subject weight and height
--------------------------------------------------------------------------
Syntax :

--------------------------------------------------------------------------
File Description :
This function based on the measured bony landmarks will scale the sedgment
lengths  that itself affects the sedgemnts inertia. It overwrite all the
scaling on the scalings from the height and weight except for few things
such as the sedgment weghts that are scaled using the body weight. The
other thing that this function does is scaling the bony landmarks and
insertion/origin of the muscles and their associated wrapping data.
The segment lenghts are defined based on specific bony landmarks that are
taken from:

--------------------------------------------------------------------------
%}
% initialize the inputs
DYDATA = DYDATAin; 

% take the subject's gender from the GUI
Subject_Gender = get(SGUIHandle.Gender_Selection.Gender,'Value');

% take the subject's weight [Kg] from the GUI
Subject_Weight = str2double(get(SGUIHandle.Weight_Selection.Weight,'String'));

% ------------------------------------------------------------------------
% Update the inertia data
% ------------------------------------------------------------------------
% 1) define the segments lenght using the measured kinematics data

    DYDATA.Segments_Lenghts.Humerus = (27.1/177)*Subject_Height; % scale the humerus lenght according to the body height
    DYDATA.Segments_Lenghts.Ulna = (28.3/177)*Subject_Height; % scale the ulna lenght according to the body height
    DYDATA.Segments_Lenghts.Radius = (28.3/177)*Subject_Height; % scale the radius lenght according to the body height
    
    DYDATA.Inertia(4,1) = (0.315*DYDATA.Segments_Lenghts.Humerus)^2*2.4e-2*Subject_Weight; % Iht
    DYDATA.Inertia(4,2) = (0.14*DYDATA.Segments_Lenghts.Humerus)^2*2.4e-2*Subject_Weight; % Ihl
    DYDATA.Inertia(5,1) = (0.275*DYDATA.Segments_Lenghts.Ulna)^2*0.62*1.7e-2*Subject_Weight; % Iut 
    DYDATA.Inertia(5,2) = (0.11*DYDATA.Segments_Lenghts.Ulna)^2*0.62*1.7e-2*Subject_Weight; % Iul
    DYDATA.Inertia(6,1) = (0.275*DYDATA.Segments_Lenghts.Radius)^2*0.38*1.7e-2*Subject_Weight; % Irt
    DYDATA.Inertia(6,2) = (0.11*DYDATA.Segments_Lenghts.Radius)^2*0.38*1.7e-2*Subject_Weight; % Irl























