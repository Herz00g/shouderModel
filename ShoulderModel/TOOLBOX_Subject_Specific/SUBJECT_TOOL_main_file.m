%{
--------------------------------------------------------------------------
  GUI FOR RUNNING THE SUBJECT SPECIFIC TOOL
--------------------------------------------------------------------------
File Description :
This file creates the GUI for running the subject specific tools.
--------------------------------------------------------------------------
File Structure :
The GUI figure is created in SHandle. The pushbuttons are defined next,
followed by the initialisation script. All the GUI control structures are
contained in SGUIHandle. The axis is called SubjectVisualisationAxes. 
All the graphics are contained in a single strucure : SPlotHandles. 

--------------------------------------------------------------------------
%}

%--------------------------------------------------------------------------
% CREATE THE MAIN FIGURE OF THE GUI
%--------------------------------------------------------------------------
SHandle = figure(...
    'color', 'white',...
    'units', 'normalized',...
    'position', [0.1, 0.1, 0.4, 0.8],...
    'toolbar', 'figure',...
    'name', 'EPFL - LBO SHOULDER MODEL: SUBJECT SPECIFIC TOOLBOX');

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CREATE PUSHBUTTONS
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Push Button for Closing the GUI
SGUIHandle.Close_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.95, 0.3, 0.05],...
    'style', 'pushbutton',...
    'string', '<html> <b>- CLOSE TOOL -------------------------------------</b><br><p style="font-size: 90%;"> <i> Closes the subject specific tool and returns to main GUI</i></p>',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', SUBJECT_TOOL_script_generator('Close Subject Tool'));

% Push Button for opening the ellipsoid toolbox
SGUIHandle.Ellipsoid_Tool_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.43, 0.3, 0.05],...
    'style', 'pushbutton',...
    'string', '<html> <b>- SCALE RIBCAGE ELLIPSOID -------------------</b><br><p style="font-size: 90%;"> <i> Dilate homogeneously the two ribcage ellispsoids associated to TS and AI</i></p>',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', SUBJECT_TOOL_script_generator('Update Ellipsoid'));

% Push Button for resetting the values enteretd by the user to the generic
% model
SGUIHandle.Reset_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.3, 0.3, 0.05],...
    'style', 'pushbutton',...
    'string', '<html> <b>- RESET TO GENERIC MODEL -------------------</b><br><p style="font-size: 90%;"> <i>Resets the anthropometry data entered to those of the generic model</i></p>',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', SUBJECT_TOOL_script_generator('RESET TO GENERIC MODEL'));

% Push Button for visualization of the scaled data
SGUIHandle.Visulization = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.38, 0.3, 0.05],...
    'style', 'pushbutton',...
    'string', '<html> <b>- VISULIZE THE SCALED DATA ---------------</b><br><p style="font-size: 90%;"> <i>Visulizes the scaled data together with the generic model</i></p>',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', SUBJECT_TOOL_script_generator('VISUALIZATION'));


% Push Button for updating everything based on the gender, BW, and BH
SGUIHandle.Update = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.48, 0.3, 0.05],...
    'style', 'pushbutton',...
    'string', '<html> <b>- SCALE USING GENDER, BW, BH ------------</b><br><p style="font-size: 90%;"> <i>Scales the model based on the patient specific data provided above</i></p>',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', SUBJECT_TOOL_script_generator('Update Subject Weight'));


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CREATE ANTHROMETRY INERATIVE MENU
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% Popup menu for choosing the subject gender
% Gender title 
SGUIHandle.Gender_Selection.Title = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.92, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Gender',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Gender Selection Popup 
SGUIHandle.Gender_Selection.Gender = uicontrol(...
    'units', 'normalized',...
    'position', [0.78, 0.92, 0.2, 0.02],...
    'style', 'popupmenu',...
    'string', {'select gender','Male','Female'},...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');%,...
    %'callback',SUBJECT_TOOL_script_generator('Update Subject Weight'));

% Weight Title 
SGUIHandle.Weight_Selection.Title = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.88, 0.15, 0.02],...
    'style', 'text',...
    'string', 'Subject weight [Kg]',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Weight Value
SGUIHandle.Weight_Selection.Weight = uicontrol(...
    'units', 'normalized',...
    'position', [0.85, 0.87, 0.05, 0.04],...
    'style', 'edit',...
    'string', '85.5',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');%,...
    %'callback', SUBJECT_TOOL_script_generator('Update Subject Weight'));

% Height Title
SGUIHandle.Height_Selection.Title = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.83, 0.14, 0.02],...
    'style', 'text',...
    'string', 'Subject height [m]',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Height Value
SGUIHandle.Height_Selection.Height = uicontrol(...
    'units', 'normalized',...
    'position', [0.85, 0.82, 0.05, 0.04],...
    'style', 'edit',...
    'string', '1.86',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');%,...
    %'callback', SUBJECT_TOOL_script_generator('Update Subject Weight'));

% PCSA Title 
SGUIHandle.PCSA_Selection.Title = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.78, 0.3, 0.02],...
    'style', 'text',...
    'string', 'Muscle name                           PCSA [cm^2]',...
    'HorizontalAlignment', 'left',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% PCSA Muscle Name 
SGUIHandle.PCSA_Selection.MuscleName = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.75, 0.2, 0.02],...
    'style', 'popupmenu',...
    'string', {'select muscle','Subclavius','Serratus Anterior Upper','Serratus Anterior Middle','Serratus Anterior Lower','Trapezius C1 - C6',...   
        'Trapezius C7','Trapezius T1','Trapezius T2 - T7','Levator Scapulae','Rhomboid Minor','Rhomboid Major T1 - T2',...
        'Rhomboid Major T3 - T4','Pectoralis Minor','Pectoralis Major Clavicular','Pectoralis Major Sternal',...
        'Pectoralis Major Ribs','Latisimuss Dorsi Thoracic','Latisimuss Dorsi Lumbar','Latisimuss Dorsi Iliac',...
        'Deltoid Clavicular','Deltoid Acromial','Deltoid Scapular','Supraspinatus','Infraspinatus','Subscapularis',...
        'Teres Minor','Teres Major','Coracobrachialis','Triceps Brachii Long','Triceps Brachii Media','Triceps Brachii Latera',...
        'Biceps Brachii Short','Biceps Brachii Long','Brachialis','Brachioradialis','Supinator','Pronator Teres',...
        'Flexor Carpi Radialis','Flexor Carpi Ulnaris','Extensor Carpi Radialis Long','Extensor Carpi Radialis Brevis',...
        'Extensor Carpi Ulnaris'},...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback',SUBJECT_TOOL_script_generator('Show PCSA From List'));

% PCSA Value/Update PCSA Value
SGUIHandle.PCSA_Selection.PCSA = uicontrol(...
    'units', 'normalized',...
    'position', [0.92, 0.74, 0.05, 0.04],...
    'style', 'edit',...
    'string', '',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', SUBJECT_TOOL_script_generator('Update Muscle PCSA'));

% Glenoid Orientation Title
SGUIHandle.Glenoid_Orientations.Title = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.69, 0.3, 0.03],...
    'style', 'text',...
    'string', 'Glenoid Orientations',...
    'HorizontalAlignment', 'left',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Glenoid Orientation Popupmenue
SGUIHandle.Glenoid_Orientations.Popupmenu = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.67, 0.17, 0.02],...
    'style', 'popupmenu',...
    'string', {'select', 'version [deg]', 'inclination [deg]', 'implant/HH radius [mm]', 'fossa center [mm]'},...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback',SUBJECT_TOOL_script_generator('Show Glenoid Orientation'));

% Glenoid Orientation Value/Update 
SGUIHandle.Glenoid_Orientations.Value = uicontrol(...
    'units', 'normalized',...
    'position', [0.88, 0.66, 0.11, 0.04],...
    'style', 'edit',...
    'string', '',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', SUBJECT_TOOL_script_generator('Update Glenoid Orientation'));

% Load Measured Kinematics Title
SGUIHandle.Measured_Kinematics.Title = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.62, 0.3, 0.03],...
    'style', 'text',...
    'string', 'Load Measured Kinematics',...
    'HorizontalAlignment', 'left',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Load Measured Kinematics Text
SGUIHandle.Measured_Kinematics.Text = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.61, 0.25, 0.02],...
    'style', 'Edit',...
    'HorizontalAlignment', 'left',...
    'backgroundcolor', 'white',...
    'fontsize', 10,...
    'fontweight', 'normal',...
    'callback', SUBJECT_TOOL_script_generator('Load Measured Kinematics'));

% Load Measured Kinematics Pushbottom
SGUIHandle.Measured_Kinematics.Pushbutton = uicontrol(...
    'units', 'normalized',...
    'position', [0.96, 0.61, 0.03, 0.02],...
    'style', 'PushButton',...
    'String','...',...
    'HorizontalAlignment', 'center',...
    'backgroundcolor', [0.6 0.6 0.6],...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', SUBJECT_TOOL_script_generator('Load Measured Kinematics'));

% Scale based on Measured Kinematics data (Pushbutton)
% SGUIHandle.Visulization = uicontrol(...
%     'units', 'normalized',...
%     'position', [0.7, 0.55, 0.3, 0.05],...
%     'style', 'pushbutton',...
%     'string', '<html> <b>- SCALE USING MEASURED KINEMATICS-----</b><br><p style="font-size: 90%;"> <i>Scale using kienamtics data uploaded by user. It overwites scaling based on subject height.</i></p>',...
%     'fontsize', 14,...
%     'fontweight', 'bold',...
%     'callback', SUBJECT_TOOL_script_generator('SCALING OVERWRITE'));

% Scale based on Measured Kinematics data (Pushbutton)
SGUIHandle.Kinematic_scaling = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.55, 0.3, 0.05],...
    'style', 'pushbutton',...
    'string', '<html> <b>- SCALE MEASURED KINEMATICS-----</b><br><p style="font-size: 90%;"> <i>Scale measured kienamtics data recorded on the generic subject.</i></p>',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', SUBJECT_TOOL_script_generator('SCALE KINEMATICS'));




%{
%--------------------------------------------------------------------------
% RIBCAGE Y LIMIT POINTS
%--------------------------------------------------------------------------
% Ymin Title
SGUIHandle.RibCage_Selection.YminText = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.75, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Ymin',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Minimum Value
SGUIHandle.RibCage_Selection.Ymin = uicontrol(...
    'units', 'normalized',...
    'position', [0.77, 0.74, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-120',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Update Ribcage Points'));

% Ymax Title
SGUIHandle.RibCage_Selection.YmaxText = uicontrol(...
    'units', 'normalized',...
    'position', [0.82, 0.75, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Ymax',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Maximum Value
SGUIHandle.RibCage_Selection.Ymax = uicontrol(...
    'units', 'normalized',...
    'position', [0.89, 0.74, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-60',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Update Ribcage Points'));

%--------------------------------------------------------------------------
% RIBCAGE Z LIMIT POINTS
%--------------------------------------------------------------------------
% Zmin Title
SGUIHandle.RibCage_Selection.ZminText = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.71, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Zmin',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Minimum Value
SGUIHandle.RibCage_Selection.Zmin = uicontrol(...
    'units', 'normalized',...
    'position', [0.77, 0.7, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-100',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Update Ribcage Points'));

% Zmax Title
SGUIHandle.RibCage_Selection.ZminText = uicontrol(...
    'units', 'normalized',...
    'position', [0.82, 0.71, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Zmin',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Maximum Value
SGUIHandle.RibCage_Selection.Zmax = uicontrol(...
    'units', 'normalized',...
    'position', [0.89, 0.7, 0.05, 0.04],...
    'style', 'edit',...
    'string', '50',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Update Ribcage Points'));

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CREATE OPTIMISATION PARAMETERS
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Title
SGUIHandle.Optimisation_Parameters.Title = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.5, 0.3, 0.02],...
    'style', 'text',...
    'string', 'Optimisation Parameters',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Subtitle
SGUIHandle.Optimisation_Parameters.Subtitle = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.48, 0.2, 0.02],...
    'style', 'text',...
    'string', 'Lb                    Xo                    Ub',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');


%--------------------------------------------------------------------------
% ELLIPSOID CENTRE X COORDINATE
%--------------------------------------------------------------------------
% Title
SGUIHandle.Optimisation_Parameters.CentreXt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.44, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Centre X',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
SGUIHandle.Optimisation_Parameters.CentreXLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.44, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-50',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value
SGUIHandle.Optimisation_Parameters.CentreXov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.44, 0.05, 0.04],...
    'style', 'edit',...
    'string', '0',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
SGUIHandle.Optimisation_Parameters.CentreXUbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.95, 0.44, 0.05, 0.04],...
    'style', 'edit',...
    'string', '50',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));


%--------------------------------------------------------------------------
% ELLIPSOID CENTRE Y COORDINATE
%--------------------------------------------------------------------------
% Title
SGUIHandle.Optimisation_Parameters.CentreYt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.4, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Centre Y',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
SGUIHandle.Optimisation_Parameters.CentreYLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.4, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-100',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value
SGUIHandle.Optimisation_Parameters.CentreYov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.4, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-50',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
SGUIHandle.Optimisation_Parameters.CentreYUbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.95, 0.4, 0.05, 0.04],...
    'style', 'edit',...
    'string', '100',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));


%--------------------------------------------------------------------------
% ELLIPSOID CENTRE Z COORDINATE
%--------------------------------------------------------------------------
% Title
SGUIHandle.Optimisation_Parameters.CentreZt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.36, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Centre Z',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
SGUIHandle.Optimisation_Parameters.CentreZLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.36, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-400',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value
SGUIHandle.Optimisation_Parameters.CentreZov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.36, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-200',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
SGUIHandle.Optimisation_Parameters.CentreZUbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.95, 0.36, 0.05, 0.04],...
    'style', 'edit',...
    'string', '400',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

%--------------------------------------------------------------------------
% ELLIPSOID HALF-AXIS X COORDINATE
%--------------------------------------------------------------------------
% Title
SGUIHandle.Optimisation_Parameters.AxisXt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.32, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Axis X',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
SGUIHandle.Optimisation_Parameters.AxisXLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.32, 0.05, 0.04],...
    'style', 'edit',...
    'string', '10',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value
SGUIHandle.Optimisation_Parameters.AxisXov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.32, 0.05, 0.04],...
    'style', 'edit',...
    'string', '200',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
SGUIHandle.Optimisation_Parameters.AxisXUbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.95, 0.32, 0.05, 0.04],...
    'style', 'edit',...
    'string', '400',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

%--------------------------------------------------------------------------
% ELLIPSOID HALF-AXIS Y COORDINATE
%--------------------------------------------------------------------------
% Title
SGUIHandle.Optimisation_Parameters.AxisYt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.28, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Axis X',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
SGUIHandle.Optimisation_Parameters.AxisYLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.28, 0.05, 0.04],...
    'style', 'edit',...
    'string', '10',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value
SGUIHandle.Optimisation_Parameters.AxisYov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.28, 0.05, 0.04],...
    'style', 'edit',...
    'string', '100',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
SGUIHandle.Optimisation_Parameters.AxisYUbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.95, 0.28, 0.05, 0.04],...
    'style', 'edit',...
    'string', '400',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

%--------------------------------------------------------------------------
% ELLIPSOID HALF-AXIS Z COORDINATE
%--------------------------------------------------------------------------
% Title
SGUIHandle.Optimisation_Parameters.AxisZt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.24, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Axis Z',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
SGUIHandle.Optimisation_Parameters.AxisZLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.24, 0.05, 0.04],...
    'style', 'edit',...
    'string', '10',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value 
SGUIHandle.Optimisation_Parameters.AxisZov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.24, 0.05, 0.04],...
    'style', 'edit',...
    'string', '300',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
SGUIHandle.Optimisation_Parameters.AxisZUbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.95, 0.24, 0.05, 0.04],...
    'style', 'edit',...
    'string', '400',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CREATE OPTIMISATION PARAMETERS SETUP
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% ALGORITHMS
%--------------------------------------------------------------------------
% Title 
SGUIHandle.Optimisation_Setup.AlgorithmTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.2, 0.3, 0.02],...
    'style', 'text',...
    'string', 'Algorithm',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Selection Values
SGUIHandle.Optimisation_Setup.AlgorithmSelect = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.15, 0.2, 0.045],...
    'style', 'listbox',...
    'string', {'sqp', 'trust-region-reflective', 'interior-point', 'active-set'},...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Settings'));

%--------------------------------------------------------------------------
% TOLERANCES
%--------------------------------------------------------------------------
% Title
SGUIHandle.Optimisation_Setup.ToleranceTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.13, 0.3, 0.02],...
    'style', 'text',...
    'string', 'Tolerances (X, Function, Constraints)',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Selection Values
SGUIHandle.Optimisation_Setup.TolXSelect = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.08, 0.1, 0.045],...
    'style', 'listbox',...
    'string', {'1.e-3', '1.e-4', '1.e-5', '1.e-6', '1.e-7', '1.e-8'},...
    'value', 4,...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Settings'));

% Selection Values
SGUIHandle.Optimisation_Setup.TolFunSelect = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.08, 0.1, 0.045],...
    'style', 'listbox',...
    'string', {'1.e-3', '1.e-4', '1.e-5', '1.e-6', '1.e-7', '1.e-8'},...
    'value', 4,...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Settings'));

% Selection Values
SGUIHandle.Optimisation_Setup.TolConSelect = uicontrol(...
    'units', 'normalized',...
    'position', [0.9, 0.08, 0.1, 0.045],...
    'style', 'listbox',...
    'string', {'1.e-3', '1.e-4', '1.e-5', '1.e-6', '1.e-7', '1.e-8'},...
    'value', 4,...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Settings'));

%--------------------------------------------------------------------------
% MAXIMUM FUNCTION EVALUATIONS & ITERATIONS
%--------------------------------------------------------------------------
% Title
SGUIHandle.Optimisation_Setup.MaxIterationsTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.06, 0.3, 0.02],...
    'style', 'text',...
    'string', 'Maximum Nb. of Iterations & Function Evaluations',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Selection Values
SGUIHandle.Optimisation_Setup.MaxIterSelect = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.02, 0.15, 0.035],...
    'style', 'listbox',...
    'string', {'1.e2', '1.e3', '1.e4'},...
    'value', 2,...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Settings'));

% Selection Values
SGUIHandle.Optimisation_Setup.MaxFunEvalSelect = uicontrol(...
    'units', 'normalized',...
    'position', [0.85, 0.02, 0.15, 0.035],...
    'style', 'listbox',...
    'string', {'1.e2', '1.e3', '1.e4'},...
    'value', 2,...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Settings'));

% Create the Help Menu
SGUIHandle.HelpMenu(1,1) = uimenu(SHandle,...
    'label', 'GUI Help');
SGUIHandle.HelpMenu(2,1) = uimenu(SGUIHandle.HelpMenu(1,1),...
    'label', 'About?',...
    'callback', ELLIPSOID_TOOL_script_generator('Help'));

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% INITIALISE THE OPTIMISATION DATA STRUCTURE
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Create the Data Structure
EOPTDATA.points         = [];
EOPTDATA.Initial_Guess  = [0, -50, -200, 200, 100, 300];
EOPTDATA.Lower_Bounds   = [-50, -100, -400,  10,  10,  10];
EOPTDATA.Upper_Bounds   = [50,  100,  400, 400, 400, 400];
EOPTDATA.Algorithm      = 'sqp';
EOPTDATA.TolX           = 1.e-6;
EOPTDATA.TolFun         = 1.e-6;
EOPTDATA.TolCon         = 1.e-6;
EOPTDATA.MaxFunEval     = 1.e3;
EOPTDATA.MaxIter        = 1.e3;

% Give it the List of Points
points = [];
for i = 1:size(MEDATA.Thorax_Mesh.points,1)
    Xmax = str2double(get(SGUIHandle.RibCage_Selection.Xmax, 'string'));
    Ymax = str2double(get(SGUIHandle.RibCage_Selection.Ymax, 'string'));
    Zmax = str2double(get(SGUIHandle.RibCage_Selection.Zmax, 'string'));
    Xmin = str2double(get(SGUIHandle.RibCage_Selection.Xmin, 'string'));
    Ymin = str2double(get(SGUIHandle.RibCage_Selection.Ymin, 'string'));
    Zmin = str2double(get(SGUIHandle.RibCage_Selection.Zmin, 'string'));
    
    % Select an initial set of points
    if MEDATA.Thorax_Mesh.points(i,1) > Xmin && MEDATA.Thorax_Mesh.points(i,1) < Xmax
        if MEDATA.Thorax_Mesh.points(i,2) > Ymin && MEDATA.Thorax_Mesh.points(i,2) < Ymax
            if MEDATA.Thorax_Mesh.points(i,3) > Zmin && MEDATA.Thorax_Mesh.points(i,3) < Zmax
                points = [points; [MEDATA.Thorax_Mesh.points(i,:)]];
            end
        end
    end
end
EOPTDATA.points = points; clear points;
%}
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% INITIALISATION OF THE VISUALISATION
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Create the Axes
SPlotHandles.SubjectSpecificVisualisationAxes = axes(...
    'units', 'normalized',...
    'position', [0.1, 0.05, 0.6, 0.9]);

% Set the Axis
set(SHandle, 'currentaxes', SPlotHandles.SubjectSpecificVisualisationAxes); hold on;

% Create the 3-D Meshing Visualisations
SPlotHandles.MeshHandle(1) = VISUALISATION_view_bone_meshing([], MEDATA, 0, BLDATA);
SPlotHandles.MeshHandle(2) = VISUALISATION_view_bone_meshing([], MEDATA, 1, BLDATA);
SPlotHandles.MeshHandle(3) = VISUALISATION_view_bone_meshing([], MEDATA, 2, BLDATA);
SPlotHandles.MeshHandle(4) = VISUALISATION_view_bone_meshing([], MEDATA, 3, BLDATA);
SPlotHandles.MeshHandle(5) = VISUALISATION_view_bone_meshing([], MEDATA, 4, BLDATA);
SPlotHandles.MeshHandle(6) = VISUALISATION_view_bone_meshing([], MEDATA, 5, BLDATA);
SPlotHandles.MeshHandle(7) = VISUALISATION_view_bone_meshing([], MEDATA, 6, BLDATA);


% make the meshings to look transparent
for mesh = 1:7
    SPlotHandles.MeshHandle(mesh).FaceAlpha = 0.7;
end


% Create the 3-D Wire Frame Visualisations
SPlotHandles.WireFrameHandle(1) = VISUALISATION_view_bone_wireframe([], 0, BLDATA);
SPlotHandles.WireFrameHandle(2) = VISUALISATION_view_bone_wireframe([], 1, BLDATA);
SPlotHandles.WireFrameHandle(3) = VISUALISATION_view_bone_wireframe([], 2, BLDATA);
SPlotHandles.WireFrameHandle(4) = VISUALISATION_view_bone_wireframe([], 3, BLDATA);
SPlotHandles.WireFrameHandle(5) = VISUALISATION_view_bone_wireframe([], 4, BLDATA);
SPlotHandles.WireFrameHandle(6) = VISUALISATION_view_bone_wireframe([], 5, BLDATA);


% visualize the generic glenoid

% initialize the number of points that we want to draw the fossa with
Nout = zeros(DYDATA.NbConstraints,3);

% Get initial and current scapula rotation matrices
Rs0 = BLDATA.Initial_Matrices_L2A.Rs;

% Put the Cone Center (center of the ellipse) in Cone Frame (its origin on vertex of the cone)
C = DYDATA.Cone_Rb'*DYDATA.ConeCentre;

% Angle Around the Ellipse (number of cutting planes)
theta = linspace(0, 2*pi, DYDATA.NbConstraints);

% Points Around the Ellipse where the normal vectors are to be computed (they are in cone frame)
P = [zeros(1,DYDATA.NbConstraints)+C(1); 
     DYDATA.ConeDimensions(1)*cos(theta)+C(2); 
     DYDATA.ConeDimensions(2)*sin(theta)+C(3)];
 
% transform the points to the thorax frame, only for the initial
% configuration
 for i = 1:DYDATA.NbConstraints
     P_inT = DYDATA.Cone_Rb*P(:,i)*1e3 + BLDATA.Initial_Points.GH;
 hold on
 plot3(P_inT(1), P_inT(2), P_inT(3),'marker', 'o','markersize',4,'markerfacecolor', 'red','markeredgecolor', 'red')
 end



% visualize the ribcage ellipsoid

SPlotHandles.Ellipsoid = []; 
SPlotHandles.Ellipsoid = VISUALISATION_view_ribcage_ellipsoid('AI', SPlotHandles.Ellipsoid, REDATA); 

set(SPlotHandles.Ellipsoid, 'facecolor', 'red', 'facealpha', 0.3, 'edgealpha', 0.3);

%  % Initialise the ellipsoid plot
% EPlotHandles.Ellipsoid = [];
% 
% % Visualise the Area to be used
% EPlotHandles.RibCage = plot3(EOPTDATA.points(:,1), EOPTDATA.points(:,2), EOPTDATA.points(:,3),...
%     'linestyle', '--',...
%     'marker', 'o',...
%     'color', 'red',...
%     'markerfacecolor', 'blue',...
%     'markersize', 6);

%--------------------------------------------------------------------------
% SET THE APPEARANCE OF THE VISUALISATION
%--------------------------------------------------------------------------
% Set some lights to help visualise the model
light('Position',[ 1,   0,   0],'Style','infinite');
light('Position',[ 0,   0, -10],'Style','local');
light('Position',[10, -50,   0],'Style','infinite');
colormap copper; % Give the bone meshings a bone color.
%box on;          % Turn the axes box on. It makes is easier to keep track of the orientation.
material dull;   % Define the bone meshing material. It removes the shiny effect.
axis equal;      % Correct the apsect ratio.
zoom(1);       % Zoom in on the visualisation. otherwise it looks very small.    
view([185, 25]); % Setup the initial camera postion [0,0] is behind horizontally.