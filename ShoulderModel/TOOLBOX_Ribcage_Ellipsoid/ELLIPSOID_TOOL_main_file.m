%--------------------------------------------------------------------------
%
%
%   GUI FOR RUNNING THE RIBCAGE ELLIPSOID TOOL 
%--------------------------------------------------------------------------
%
% File Description :
% This file creates the main GUI for running the ribcage ellipsoid
% optimisation tool. The tool allows you to select the points on the
% ribcage the ellipsoid is to pass through by imposing bounds the
% coordinates. The optimisation cost function is the sum of the norms
% between points on the ribcage mesh and their projection onto the
% ellipsoid surface.
%
%--------------------------------------------------------------------------
%
% File Structure :
% The GUI figure is created in EHandle. The pushbuttons are defined next,
% followed by the initialisation script. All the GUI control structures are
% contained in EGUIHandle. The axis is called EllipseVisualisationAxes. 
% All the graphics are contained in a single strucure : EPlotHandles. 
%
%--------------------------------------------------------------------------
%
% Contents of the Interactive GUI structure :
%   PushButton Section
%       EGUIHandle.Close_Button
%       EGUIHandle.Build_Ellipsoid_Button
%       EGUIHandle.View_Ellipsoid_Button
%       EGUIHandle.Save_Visualisation_Button
%
%   Ribcage point selection tools
%       EGUIHandle.RibCage_Selection.Title
%       EGUIHandle.RibCage_Selection.XText
%       EGUIHandle.RibCage_Selection.Xmin
%       EGUIHandle.RibCage_Selection.Xmax
%       EGUIHandle.RibCage_Selection.YText
%       EGUIHandle.RibCage_Selection.Ymin
%       EGUIHandle.RibCage_Selection.Ymax
%       EGUIHandle.RibCage_Selection.ZText
%       EGUIHandle.RibCage_Selection.Zmin
%       EGUIHandle.RibCage_Selection.Zmax
%
%   Optimisation initial value parameters
%       EGUIHandle.Optimisation_Parameters.Title
%       EGUIHandle.Optimisation_Parameters.Subtitle 
%       EGUIHandle.Optimisation_Parameters.CentreXt
%       EGUIHandle.Optimisation_Parameters.CentreXLbv
%       EGUIHandle.Optimisation_Parameters.CentreXov
%       EGUIHandle.Optimisation_Parameters.CentreXUbv
%       EGUIHandle.Optimisation_Parameters.CentreYt
%       EGUIHandle.Optimisation_Parameters.CentreYLbv
%       EGUIHandle.Optimisation_Parameters.CentreYov
%       EGUIHandle.Optimisation_Parameters.CentreYUbv
%       EGUIHandle.Optimisation_Parameters.CentreZt
%       EGUIHandle.Optimisation_Parameters.CentreZLbv
%       EGUIHandle.Optimisation_Parameters.CentreZov
%       EGUIHandle.Optimisation_Parameters.CentreZUbv
%       EGUIHandle.Optimisation_Parameters.AxisXt
%       EGUIHandle.Optimisation_Parameters.AxisXLbv
%       EGUIHandle.Optimisation_Parameters.AxisXov
%       EGUIHandle.Optimisation_Parameters.AxisXUbv
%       EGUIHandle.Optimisation_Parameters.AxisYt
%       EGUIHandle.Optimisation_Parameters.AxisYLbv
%       EGUIHandle.Optimisation_Parameters.AxisYov
%       EGUIHandle.Optimisation_Parameters.AxisYUbv
%       EGUIHandle.Optimisation_Parameters.AxisZt
%       EGUIHandle.Optimisation_Parameters.AxisZLbv
%       EGUIHandle.Optimisation_Parameters.AxisZov
%       EGUIHandle.Optimisation_Parameters.AxisZUbv
%
%   Optimisation Solver parameters
%       EGUIHandle.Optimisation_Setup.AlgorithmTxt
%       EGUIHandle.Optimisation_Setup.AlgorithmSelect
%       EGUIHandle.Optimisation_Setup.ToleranceTxt
%       EGUIHandle.Optimisation_Setup.TolXSelect
%       EGUIHandle.Optimisation_Setup.TolFunSelect
%       EGUIHandle.Optimisation_Setup.TolConSelect
%       EGUIHandle.Optimisation_Setup.MaxIterationsTxt
%       EGUIHandle.Optimisation_Setup.MaxIterSelect
%       EGUIHandle.Optimisation_Setup.MaxFunEvalSelect
%--------------------------------------------------------------------------
%
% The graphical hierarchy is :
%   EHandle
%       -> EllipseVisualisationAxes
%                       -> EPlotHandles
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% CREATE THE FIGURE
%--------------------------------------------------------------------------
EHandle = figure(...
    'color', 'white',...
    'units', 'normalized',...
    'position', [0.1, 0.1, 0.4, 0.8],...
    'toolbar', 'figure',...
    'name', 'EPFL - LBO SHOULDER MODEL: RIBCAGE ELLIPSOID TOOLBOX');

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CREATE PUSHBUTTONS
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Push Button for Closing the GUI
EGUIHandle.Close_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.95, 0.3, 0.05],...
    'style', 'pushbutton',...
    'string', '<html> <b>- CLOSE TOOL -------------------------------------</b><br><p style="font-size: 90%;"> <i> Closes the ellipsoid tool and returns to main GUI</i></p>',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Close Ellipsoid Tool'));

% Push Button for Visualising the Ellipsoid
EGUIHandle.Save_Visualisation_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.9, 0.3, 0.05],...
    'style', 'pushbutton',...
    'string', '<html> <b>- SAVE VISUALISATION ---------------------------</b><br><p style="font-size: 90%;"> <i> Saves the current visualisation to en .eps file</i></p>',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Save Visualisation'));

% Push Button for Constructing the Ellipsoid
EGUIHandle.Build_Ellipsoid_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.85, 0.3, 0.05],...
    'style', 'pushbutton',...
    'string', '<html> <b>- BUILD ELLIPSOID -------------------------------</b><br><p style="font-size: 90%;"> <i> Runs the optimisation routine</i></p>',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Build Ellipsoid'));

% Push Button for Visualising the Ellipsoid
EGUIHandle.Update_Visualisation_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.53, 0.3, 0.05],...
    'style', 'pushbutton',...
    'string', '<html> <b>- UPDATE VISUALISATION -----------------------</b><br><p style="font-size: 90%;"> <i> Updates the visualisation given the selected options above</i></p>',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Update Visualisation'));

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CREATE RADIO BUTTONS
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Radio Button for Visualising the Points
EGUIHandle.Points_Radio_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.65, 0.3, 0.02],...
    'style', 'radiobutton',...
    'string', 'View Ribcage Points',...
    'value', 1,...
    'fontsize', 14,...
    'backgroundcolor', 'white',...
    'fontweight', 'bold');

% Radio Button for Visualising the Ellipsoid
EGUIHandle.Ellipsoid_Radio_Button = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.61, 0.3, 0.02],...
    'style', 'radiobutton',...
    'string', 'View Ellipsoid',...
    'value', 0,...
    'fontsize', 14,...
    'backgroundcolor', 'white',...
    'fontweight', 'bold');

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CREATE THE RIBCAGE INTERACTION ELEMENTS
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Title 
EGUIHandle.RibCage_Selection.Title = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.82, 0.3, 0.02],...
    'style', 'text',...
    'string', 'Bounds For Selected Ribcage Points',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

%--------------------------------------------------------------------------
% RIBCAGE X LIMIT POINTS
%--------------------------------------------------------------------------
% Xmin Title 
EGUIHandle.RibCage_Selection.XminText = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.79, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Xmin',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Minimum Value
EGUIHandle.RibCage_Selection.Xmin = uicontrol(...
    'units', 'normalized',...
    'position', [0.77, 0.78, 0.05, 0.04],...
    'style', 'edit',...
    'string', '50',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Update Ribcage Points'));

% Xmax Title 
EGUIHandle.RibCage_Selection.XmaxText = uicontrol(...
    'units', 'normalized',...
    'position', [0.82, 0.78, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Xmax',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Maximum Value
EGUIHandle.RibCage_Selection.Xmax = uicontrol(...
    'units', 'normalized',...
    'position', [0.89, 0.78, 0.05, 0.04],...
    'style', 'edit',...
    'string', '200',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Update Ribcage Points'));

%--------------------------------------------------------------------------
% RIBCAGE Y LIMIT POINTS
%--------------------------------------------------------------------------
% Ymin Title
EGUIHandle.RibCage_Selection.YminText = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.75, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Ymin',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Minimum Value
EGUIHandle.RibCage_Selection.Ymin = uicontrol(...
    'units', 'normalized',...
    'position', [0.77, 0.74, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-120',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Update Ribcage Points'));

% Ymax Title
EGUIHandle.RibCage_Selection.YmaxText = uicontrol(...
    'units', 'normalized',...
    'position', [0.82, 0.75, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Ymax',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Maximum Value
EGUIHandle.RibCage_Selection.Ymax = uicontrol(...
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
EGUIHandle.RibCage_Selection.ZminText = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.71, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Zmin',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Minimum Value
EGUIHandle.RibCage_Selection.Zmin = uicontrol(...
    'units', 'normalized',...
    'position', [0.77, 0.7, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-100',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Update Ribcage Points'));

% Zmax Title
EGUIHandle.RibCage_Selection.ZminText = uicontrol(...
    'units', 'normalized',...
    'position', [0.82, 0.71, 0.07, 0.02],...
    'style', 'text',...
    'string', 'Zmin',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Maximum Value
EGUIHandle.RibCage_Selection.Zmax = uicontrol(...
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
EGUIHandle.Optimisation_Parameters.Title = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.5, 0.3, 0.02],...
    'style', 'text',...
    'string', 'Optimisation Parameters',...
    'backgroundcolor', 'white',...
    'fontsize', 14,...
    'fontweight', 'bold');

% Subtitle
EGUIHandle.Optimisation_Parameters.Subtitle = uicontrol(...
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
EGUIHandle.Optimisation_Parameters.CentreXt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.44, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Centre X',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
EGUIHandle.Optimisation_Parameters.CentreXLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.44, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-50',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value
EGUIHandle.Optimisation_Parameters.CentreXov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.44, 0.05, 0.04],...
    'style', 'edit',...
    'string', '0',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
EGUIHandle.Optimisation_Parameters.CentreXUbv = uicontrol(...
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
EGUIHandle.Optimisation_Parameters.CentreYt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.4, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Centre Y',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
EGUIHandle.Optimisation_Parameters.CentreYLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.4, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-100',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value
EGUIHandle.Optimisation_Parameters.CentreYov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.4, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-50',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
EGUIHandle.Optimisation_Parameters.CentreYUbv = uicontrol(...
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
EGUIHandle.Optimisation_Parameters.CentreZt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.36, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Centre Z',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
EGUIHandle.Optimisation_Parameters.CentreZLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.36, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-400',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value
EGUIHandle.Optimisation_Parameters.CentreZov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.36, 0.05, 0.04],...
    'style', 'edit',...
    'string', '-200',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
EGUIHandle.Optimisation_Parameters.CentreZUbv = uicontrol(...
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
EGUIHandle.Optimisation_Parameters.AxisXt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.32, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Axis X',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
EGUIHandle.Optimisation_Parameters.AxisXLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.32, 0.05, 0.04],...
    'style', 'edit',...
    'string', '10',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value
EGUIHandle.Optimisation_Parameters.AxisXov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.32, 0.05, 0.04],...
    'style', 'edit',...
    'string', '200',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
EGUIHandle.Optimisation_Parameters.AxisXUbv = uicontrol(...
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
EGUIHandle.Optimisation_Parameters.AxisYt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.28, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Axis X',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
EGUIHandle.Optimisation_Parameters.AxisYLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.28, 0.05, 0.04],...
    'style', 'edit',...
    'string', '10',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value
EGUIHandle.Optimisation_Parameters.AxisYov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.28, 0.05, 0.04],...
    'style', 'edit',...
    'string', '100',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
EGUIHandle.Optimisation_Parameters.AxisYUbv = uicontrol(...
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
EGUIHandle.Optimisation_Parameters.AxisZt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.24, 0.1, 0.02],...
    'style', 'text',...
    'string', 'Axis Z',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Lower Bound
EGUIHandle.Optimisation_Parameters.AxisZLbv = uicontrol(...
    'units', 'normalized',...
    'position', [0.8, 0.24, 0.05, 0.04],...
    'style', 'edit',...
    'string', '10',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Initial Value 
EGUIHandle.Optimisation_Parameters.AxisZov = uicontrol(...
    'units', 'normalized',...
    'position', [0.875, 0.24, 0.05, 0.04],...
    'style', 'edit',...
    'string', '300',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'callback', ELLIPSOID_TOOL_script_generator('Set Optimisation Parameters'));

% Upper Bound
EGUIHandle.Optimisation_Parameters.AxisZUbv = uicontrol(...
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
EGUIHandle.Optimisation_Setup.AlgorithmTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.2, 0.3, 0.02],...
    'style', 'text',...
    'string', 'Algorithm',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Selection Values
EGUIHandle.Optimisation_Setup.AlgorithmSelect = uicontrol(...
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
EGUIHandle.Optimisation_Setup.ToleranceTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.13, 0.3, 0.02],...
    'style', 'text',...
    'string', 'Tolerances (X, Function, Constraints)',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Selection Values
EGUIHandle.Optimisation_Setup.TolXSelect = uicontrol(...
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
EGUIHandle.Optimisation_Setup.TolFunSelect = uicontrol(...
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
EGUIHandle.Optimisation_Setup.TolConSelect = uicontrol(...
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
EGUIHandle.Optimisation_Setup.MaxIterationsTxt = uicontrol(...
    'units', 'normalized',...
    'position', [0.7, 0.06, 0.3, 0.02],...
    'style', 'text',...
    'string', 'Maximum Nb. of Iterations & Function Evaluations',...
    'backgroundcolor', 'white',...
    'fontsize', 12,...
    'fontweight', 'bold');

% Selection Values
EGUIHandle.Optimisation_Setup.MaxIterSelect = uicontrol(...
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
EGUIHandle.Optimisation_Setup.MaxFunEvalSelect = uicontrol(...
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
EGUIHandle.HelpMenu(1,1) = uimenu(EHandle,...
    'label', 'GUI Help');
EGUIHandle.HelpMenu(2,1) = uimenu(EGUIHandle.HelpMenu(1,1),...
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
    Xmax = str2double(get(EGUIHandle.RibCage_Selection.Xmax, 'string'));
    Ymax = str2double(get(EGUIHandle.RibCage_Selection.Ymax, 'string'));
    Zmax = str2double(get(EGUIHandle.RibCage_Selection.Zmax, 'string'));
    Xmin = str2double(get(EGUIHandle.RibCage_Selection.Xmin, 'string'));
    Ymin = str2double(get(EGUIHandle.RibCage_Selection.Ymin, 'string'));
    Zmin = str2double(get(EGUIHandle.RibCage_Selection.Zmin, 'string'));
    
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

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% INITIALISATION OF THE VISUALISATION
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Create the Axes
EllipseVisualisationAxes = axes(...
    'units', 'normalized',...
    'position', [0.1, 0.05, 0.6, 0.9]);

% Set the Axis
set(EHandle, 'currentaxes', EllipseVisualisationAxes); hold on;

% Create the 3-D Meshing Visualisations
EPlotHandles.MeshHandle(1) = VISUALISATION_view_bone_meshing([], MEDATA, 0, BLDATA);
EPlotHandles.MeshHandle(2) = VISUALISATION_view_bone_meshing([], MEDATA, 1, BLDATA);
EPlotHandles.MeshHandle(3) = VISUALISATION_view_bone_meshing([], MEDATA, 2, BLDATA);
EPlotHandles.MeshHandle(4) = VISUALISATION_view_bone_meshing([], MEDATA, 3, BLDATA);
EPlotHandles.MeshHandle(5) = VISUALISATION_view_bone_meshing([], MEDATA, 4, BLDATA);
EPlotHandles.MeshHandle(6) = VISUALISATION_view_bone_meshing([], MEDATA, 5, BLDATA);
EPlotHandles.MeshHandle(7) = VISUALISATION_view_bone_meshing([], MEDATA, 6, BLDATA);


% Create the 3-D Wire Frame Visualisations
EPlotHandles.WireFrameHandle(1) = VISUALISATION_view_bone_wireframe([], 0, BLDATA);
EPlotHandles.WireFrameHandle(2) = VISUALISATION_view_bone_wireframe([], 1, BLDATA);
EPlotHandles.WireFrameHandle(3) = VISUALISATION_view_bone_wireframe([], 2, BLDATA);
EPlotHandles.WireFrameHandle(4) = VISUALISATION_view_bone_wireframe([], 3, BLDATA);
EPlotHandles.WireFrameHandle(5) = VISUALISATION_view_bone_wireframe([], 4, BLDATA);
EPlotHandles.WireFrameHandle(6) = VISUALISATION_view_bone_wireframe([], 5, BLDATA);

% Initialise the ellipsoid plot
EPlotHandles.Ellipsoid = [];

% Visualise the Area to be used
EPlotHandles.RibCage = plot3(EOPTDATA.points(:,1), EOPTDATA.points(:,2), EOPTDATA.points(:,3),...
    'linestyle', '--',...
    'marker', 'o',...
    'color', 'red',...
    'markerfacecolor', 'blue',...
    'markersize', 6);

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
view([45, 25]); % Setup the initial camera postion [0,0] is behind horizontally.