%{
--------------------------------------------------------------------------
GUI FOR RUNNING THE MUSCLE FORCE ESTIMATION TOOL

--------------------------------------------------------------------------
File Description :
This file creates the force estimation GUI. Allows one to compute and
view the estimated forces and to save the data to .mat files.
--------------------------------------------------------------------------
File Structure :
The GUI figure is created in ESHandle. The pushbuttons are defined next,
followed by the initialisation script. All the GUI control structures are
contained in ESGUIHandle. The axis is called EstimateVisualisationAxes. 
All the graphics are contained in a single strucure : ESPlotHandles. 
--------------------------------------------------------------------------
Contents of the Interactive GUI structure :
  ESGUIHandle.Close_Button
  ESGUIHandle.Save_Button
  ESGUIHandle.Update_Button
  ESGUIHandle.Estimate_Button

UI menu for selecting the muscle forces to be visualised
  ESGUIHandle.Muscle_Vis_Menu.MainList
  ESGUIHandle.Muscle_Vis_Menu.Options

UIcontrol for selecting certain options
  ESGUIHandle.TimeFrameTxt
  ESGUIHandle.TimeFrameEdit
  ESGUIHandle.TimeFrameTxt2
  ESGUIHandle.HandWeightTxt
  ESGUIHandle.HandWeightEdit
  ESGUIHandle.HandWeightTxt2
  ESGUIHandle.DynForceButton
  ESGUIHandle.ReactForceButton

--------------------------------------------------------------------------

The graphical hierarchy is :
  ESHandle
      -> EstimateVisualisationAxes
                      -> ESPlotHandles

--------------------------------------------------------------------------
%}
%--------------------------------------------------------------------------
% CREATE THE FIGURE
%--------------------------------------------------------------------------
ESHandle = figure(...
    'color', 'white',...
    'units', 'normalized',...
    'position', [0.1, 0.1, 0.4, 0.8],...
    'toolbar', 'figure',...
    'name', 'EPFL - LBO Upper Extremity Model: MUSCLE FORCE ESTIMATION TOOLBOX');

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% INTERACTIVE ELEMENTS
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% Push Button for Closing the GUI
ESGUIHandle.Close_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.85, 0.95, 0.15, 0.05],...
    'style', 'pushbutton',...
    'string', 'CLOSE TOOL',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ESTIMATION_TOOL_script_generator('Close Estimation Tool'));

% Push Button to start the estimation
ESGUIHandle.Estimate_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.85, 0.9, 0.15, 0.05],...
    'style', 'pushbutton',...
    'string', 'ESTIMATE FORCES',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ESTIMATION_TOOL_script_generator('Estimate Forces'));

% Push Button for saving the data
ESGUIHandle.Save_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.85, 0.85, 0.15, 0.05],...
    'style', 'pushbutton',...
    'string', 'SAVE DATA',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ESTIMATION_TOOL_script_generator('Save Data'));

% Push Button for EMG to force
ESGUIHandle.EMG_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.85, 0.625, 0.15, 0.05],...
    'style', 'pushbutton',...
    'string', 'EMG to Force',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ESTIMATION_TOOL_script_generator('EMG to Force'));
%--------------------------------------------------------------------------
% UICONTROL FOR IMPOSING MOTION TIME SPAN & WEIGHT IN HAND
%--------------------------------------------------------------------------
% Text for imposing how fast the estimation is run
ESGUIHandle.TimeFrameTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.855, 0.805, 0.15, 0.02],...
    'style', 'text',...
    'string', 'Motion Time Span :',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Edit for imposint motion speed
ESGUIHandle.TimeFrameEdit = uicontrol(...
    'units', 'normalized',...
    'position', [0.855, 0.78, 0.05, 0.02],...
    'style', 'edit',...
    'string', '10',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Text for imposing how fast the estimation is run
ESGUIHandle.TimeFrameTxt2 = uicontrol(...
    'units', 'normalized',...
    'position', [0.91, 0.78, 0.05, 0.02],...
    'style', 'text',...
    'string', '[s]',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Text for Weight in Hand
ESGUIHandle.HandWeightTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.855, 0.7505, 0.15, 0.02],...
    'style', 'text',...
    'string', 'Weight in Hand :',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Edit for Weight in Hand
ESGUIHandle.HandWeightEdit = uicontrol(...
    'units', 'normalized',...
    'position', [0.855, 0.73, 0.05, 0.02],...
    'style', 'edit',...
    'string', '0',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Text for Weight in Hand
ESGUIHandle.HandWeightTxt2 = uicontrol(...
    'units', 'normalized',...
    'position', [0.91, 0.73, 0.05, 0.02],...
    'style', 'text',...
    'string', '[kg]',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CREATE MENU
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Initialise the menu
ESGUIHandle.MenuOptions = zeros(3,4);

ESGUIHandle.MenuOptions(1,1) = uimenu(ESHandle,...
    'label', 'Estimation Options');

% Sub-menus
ESGUIHandle.MenuOptions(2,1) = uimenu(ESGUIHandle.MenuOptions(1,1),...
    'label', 'Options');

ESGUIHandle.MenuOptions(3,1) = uimenu(ESGUIHandle.MenuOptions(1,1),...
    'label', 'About?',...
    'callback', ESTIMATION_TOOL_script_generator('Help'));

ESGUIHandle.MenuOptions(2,2) = uimenu(ESGUIHandle.MenuOptions(2,1),...
    'label', 'Glenohumeral Stability Constraint',...
    'callback', ESTIMATION_TOOL_script_generator('Update Uimenu II'));

ESGUIHandle.MenuOptions(2,3) = uimenu(ESGUIHandle.MenuOptions(2,1),...
    'label', 'EMG-Assisted',...
    'callback', ESTIMATION_TOOL_script_generator('Update Uimenu I'));

ESGUIHandle.MenuOptions(2,4) = uimenu(ESGUIHandle.MenuOptions(2,1),...
    'label', 'Measured Kinematics',...
    'callback', ESTIMATION_TOOL_script_generator('Update Uimenu III'));

% ESGUIHandle.MenuOptions(2,3) = uimenu(ESGUIHandle.MenuOptions(2,1),...
%     'label', 'Dynamic Maximum Forces',...
%     'callback', ESTIMATION_TOOL_script_generator('Update Uimenu I'));

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% load EMG data
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% Load EMG data Title
ESGUIHandle.EMG_data.Title = uicontrol(...
    'units', 'normalized',...
    'position', [0.885, 0.705, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Load EMG data:',...
    'HorizontalAlignment', 'left',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Load EMG data Text
ESGUIHandle.EMG_data.Text = uicontrol(...
    'units', 'normalized',...
    'position', [0.855, 0.68, 0.14, 0.02],...
    'style', 'Edit',...
    'HorizontalAlignment', 'left',...
    'backgroundcolor', 'white',...
    'fontsize', 10,...
    'fontweight', 'normal',...
    'callback', ESTIMATION_TOOL_script_generator('Load EMG'));

% Load EMG data Pushbottom
ESGUIHandle.EMG_data.Pushbutton = uicontrol(...
    'units', 'normalized',...
    'position', [0.965, 0.68, 0.03, 0.02],...
    'style', 'PushButton',...
    'String','...',...
    'HorizontalAlignment', 'center',...
    'backgroundcolor', [0.6 0.6 0.6],...
    'fontsize', 10,...
    'fontweight', 'bold',...
    'callback', ESTIMATION_TOOL_script_generator('Load EMG'));

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CREATE VISUALISATION AXES
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Initialise the MADATA structure
MADATA = cell(42, 1);

% Each element in the cell will contain an 15xN matrix
for MuscleId = 1:42
    MADATA{MuscleId, 1}.MomentArms    = cell(1,20);
    MADATA{MuscleId, 1}.FDirection    = cell(1,20);
    MADATA{MuscleId, 1}.ScapularPlane_GnP = cell(1,20);
    MADATA{MuscleId, 1}.ScapularPlane = cell(1,20);
    for SegmentId = 1:20
        MADATA{MuscleId, 1}.MomentArms{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
        MADATA{MuscleId, 1}.FDirection{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
        MADATA{MuscleId, 1}.MuscleLength(:,SegmentId) = zeros(size(KEDATA.Joint_Angle_Evolution,2),1);
        MADATA{MuscleId, 1}.ScapularPlane_GnP{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
        MADATA{MuscleId, 1}.ScapularPlane {1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
    end
end

% Initialise the EFDATA structure
% Initialise the output
EFDATA = cell(44,1);
JRDATA = zeros(size(KEDATA.Joint_Angle_Evolution,2),7); % Contains vector and intensity

% Each element in the cell will contain a 15 x N matrix
for MuscleId = 1:44
    EFDATA{MuscleId, 1}.MomentArms = cell(1,20);
    for SegmentId = 1:20
        EFDATA{MuscleId, 1}.Forces(:,SegmentId) = zeros(size(KEDATA.Joint_Angle_Evolution,2),1);
        EFDATA{MuscleId, 1}.MomentArms{1,SegmentId} = zeros(size(KEDATA.Joint_Angle_Evolution,2),15);
    end
end

% Central Axis
ESVisualisationAxis.Central = axes(...
    'units', 'normalized',...
    'position', [0.2, 0.064, 0.45, 0.8760],...
    'xcolor', 'white',...
    'ycolor', 'white');

% Subclavius
ESVisualisationAxis.Muscle(1,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.94, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 1));

% Serratus Anterior (Superior)
ESVisualisationAxis.Muscle(2,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.72, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 2));

% Serratus Anterior (Middle)
ESVisualisationAxis.Muscle(3,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.6650, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 3));

% Serratus Anterior (Inferior)
ESVisualisationAxis.Muscle(4,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.445, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 4));

% Trapezius (C1 - C6)
ESVisualisationAxis.Muscle(5,1) = axes(...
    'units', 'normalized',...
    'position', [0.35, 0.94, 0.15, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 5));

% Trapezius (C7)
ESVisualisationAxis.Muscle(6,1) = axes(...
    'units', 'normalized',...
    'position', [0.5, 0.94, 0.15, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 6));

% Trapezius (T1 - T2)
ESVisualisationAxis.Muscle(7,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.94, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 7));

% Trapezius (T3 - T7)
ESVisualisationAxis.Muscle(8,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.8850, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 8));

% Levator Scapuale
ESVisualisationAxis.Muscle(9,1) = axes(...
    'units', 'normalized',...
    'position', [0.2, 0.94, 0.15, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 9));

% Rhomboid Minor
ESVisualisationAxis.Muscle(10,1) = axes(...
    'units', 'normalized',...
    'position', [0.35,  0.009, 0.15, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 10));

% Rhomboid Major (T1 - T2)
ESVisualisationAxis.Muscle(11,1) = axes(...
    'units', 'normalized',...
    'position', [0.5,  0.009, 0.15, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 11));

% Rhomboid Major (T3 - T4)
ESVisualisationAxis.Muscle(12,1) = axes(...
    'units', 'normalized',...
    'position', [0.65,  0.009, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 12));

% Pectoralis Minor
ESVisualisationAxis.Muscle(13,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.83, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 13));

% Pectoralis Major (Clavicular)
ESVisualisationAxis.Muscle(14,1) = axes(...
    'units', 'normalized',...
    'position', [0.2,  0.009, 0.15, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 14));

% Pectoralis Major (Sternal)
ESVisualisationAxis.Muscle(15,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.0640, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 15));

% Pectoralis Major (Ribs)
ESVisualisationAxis.Muscle(16,1) = axes(...
    'units', 'normalized',...
    'position', [0,  0.009, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 16));

% Latissimus Doris (Thoracic)
ESVisualisationAxis.Muscle(17,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.6650, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 17));

% Latissimus Doris (Lumbar)
ESVisualisationAxis.Muscle(18,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.61, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 18));

% Latissimus Doris (Iliae)
ESVisualisationAxis.Muscle(19,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.555, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 19));

% Deltoid (Anterior)
ESVisualisationAxis.Muscle(20,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.335, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 20));

% Deltoid (Middle)
ESVisualisationAxis.Muscle(21,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.39, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 21));

% Deltoid (Posterior)
ESVisualisationAxis.Muscle(22,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.83, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 22));

% Supraspinatus
ESVisualisationAxis.Muscle(23,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.39, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 23));

% Infraspinatus
ESVisualisationAxis.Muscle(24,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.335, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 24));

% Subscapularis
ESVisualisationAxis.Muscle(25,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.8850, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 25));

% Teres Minor
ESVisualisationAxis.Muscle(26,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.28, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 26));

% Teres Major
ESVisualisationAxis.Muscle(27,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.225, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 27));

% Coracobrachialis
ESVisualisationAxis.Muscle(28,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.7750, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 28));

% Triceps Brachii Long
ESVisualisationAxis.Muscle(29,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.7750, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 29));

% Triceps Brachii Medial
ESVisualisationAxis.Muscle(30,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.17, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 30));

% Triceps Brachii Lateral
ESVisualisationAxis.Muscle(31,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.72, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 31));

% Biceps Brachii Short
ESVisualisationAxis.Muscle(32,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.225, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 32));

% Biceps Brachii Long
ESVisualisationAxis.Muscle(33,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.28, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 33));

% Brachialis
ESVisualisationAxis.Muscle(34,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.61, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 34));

% Brachioradialis
ESVisualisationAxis.Muscle(35,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.17, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 35));

% Supinator
ESVisualisationAxis.Muscle(36,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.0640, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 36));

% Pronator Teres
ESVisualisationAxis.Muscle(37,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.5, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 37));

% Flexor Carpi Radialis
ESVisualisationAxis.Muscle(38,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.1190, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 38));

% Flexor Carpi Ulnaris
ESVisualisationAxis.Muscle(39,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.445, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 39));

% Extensor Carpi Radialis Long
ESVisualisationAxis.Muscle(40,1) = axes(...
    'units', 'normalized',...
    'position', [0, 0.555, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 40));

% Extensor Carpi Radialis Brevis
ESVisualisationAxis.Muscle(41,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.1190, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 41));

% Extensor Carpi Ulnaris
ESVisualisationAxis.Muscle(42,1) = axes(...
    'units', 'normalized',...
    'position', [0.65, 0.5, 0.2, 0.055],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 42));

% % Text for TS Force [N]
% ESGUIHandle.TSforceTxt = uicontrol(...
%     'units', 'normalized',...
%     'position', [0.855, 0.595, 0.15, 0.02],...
%     'style', 'text',...
%     'string', 'TS Force [N]',...
%     'backgroundcolor', 'white',...
%     'fontsize', 10,...
%     'fontweight', 'bold');
% 
% % TS scapulothoracic force
% ESVisualisationAxis.Muscle(43,1) = axes(...
%     'units', 'normalized',...
%     'position', [0.85, 0.5, 0.15, 0.09],...
%     'xtick', [],...
%     'ytick', [],...
%     'box', 'on');%,...
%     %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 43));
% 
% % Text for AI Force [N]
% ESGUIHandle.AIForceTxt = uicontrol(...
%     'units', 'normalized',...
%     'position', [0.855, 0.45, 0.15, 0.02],...
%     'style', 'text',...
%     'string', 'AI Force [N]',...
%     'backgroundcolor', 'white',...
%     'fontsize', 10,...
%     'fontweight', 'bold');
% 
% % AI scapulothoracic force
% ESVisualisationAxis.Muscle(44,1) = axes(...
%     'units', 'normalized',...
%     'position', [0.85, 0.35, 0.15, 0.09],...
%     'xtick', [],...
%     'ytick', [],...
%     'box', 'on');%,...
%     %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 44));

% added here to show the HU and RU joint reaction forces instead of the TS
% and AI constranit forces
% -------------------------------------------------------------------------
% Text for TS Force [N]
ESGUIHandle.HUJointForceTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.855, 0.595, 0.15, 0.02],...
    'style', 'text',...
    'string', 'HU Joint Force [N]',...
    'backgroundcolor', 'white',...
    'fontsize', 10,...
    'fontweight', 'bold');

% TS scapulothoracic force
ESVisualisationAxis.Muscle(43,1) = axes(...
    'units', 'normalized',...
    'position', [0.85, 0.5, 0.15, 0.09],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 43));

% Text for AI Force [N]
ESGUIHandle.RUJointForceTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.855, 0.45, 0.15, 0.02],...
    'style', 'text',...
    'string', 'RU Joint Force [N]',...
    'backgroundcolor', 'white',...
    'fontsize', 10,...
    'fontweight', 'bold');

% AI scapulothoracic force
ESVisualisationAxis.Muscle(44,1) = axes(...
    'units', 'normalized',...
    'position', [0.85, 0.35, 0.15, 0.09],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 44));
% -------------------------------------------------------------------------
   
% Text for Joint Reaction Force [N]
ESGUIHandle.JointForceTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.855, 0.3, 0.15, 0.02],...
    'style', 'text',...
    'string', 'GH Joint Force [N]',...
    'backgroundcolor', 'white',...
    'fontsize', 10,...
    'fontweight', 'bold');

% Joint Reaction Force [N]
ESVisualisationAxis.Muscle(45,1) = axes(...
    'units', 'normalized',...
    'position', [0.85, 0.2, 0.15, 0.09],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 45));

% Text for Glenoid Stability
ESGUIHandle.GHStabilityTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.855, 0.15, 0.15, 0.02],...
    'style', 'text',...
    'string', 'Glenoid Stability',...
    'backgroundcolor', 'white',...
    'fontsize', 10,...
    'fontweight', 'bold');

% Glenoid Stability
ESVisualisationAxis.Muscle(46,1) = axes(...
    'units', 'normalized',...
    'position', [0.85, 0.05, 0.15, 0.09],...
    'xtick', [],...
    'ytick', [],...
    'box', 'on');%,...
    %'buttondownfcn', MOMENT_ARM_TOOL_script_generator('View Data', 46));
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% INITIALISE THE PLOT HANDLES
%--------------------------------------------------------------------------
%-------------------------------------------------------------------------- 
% Set the current axes
set(ESHandle, 'currentaxes', ESVisualisationAxis.Central);

% Get the current file path
Cpath = pwd;

% Differentiate for non unix systems
if isunix
    Cpath = [Cpath, '/LOGOS/MusclesFigure2.png'];
else
    Cpath = [Cpath, '\LOGOS\MusclesFigure2.png'];
end

% Load the image of the muscles
Image = imread(Cpath);
image(Image)
set(gca, 'xcolor', 'white','ycolor', 'white');
