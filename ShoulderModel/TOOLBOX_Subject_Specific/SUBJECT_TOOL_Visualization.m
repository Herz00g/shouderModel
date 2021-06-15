function SPlotHandles = SUBJECT_TOOL_Visualization(SHandle, SPlotHandlesin, BLDATA, DYDATA, REDATA)

%{
Function for visualization of the scaled anthrometry data.
--------------------------------------------------------------------------
Syntax :

--------------------------------------------------------------------------
File Description :

--------------------------------------------------------------------------
%}
% initialize the plot handle
SPlotHandles = SPlotHandlesin;

% Set the Axis
set(SHandle, 'currentaxes', SPlotHandles.SubjectSpecificVisualisationAxes);

hold on;

% -------------------------------------------------------------------------
% Create the 3-D Wire Frame Visualisations
% -------------------------------------------------------------------------
SPlotHandles.Scaled.WireFrameHandle(1) = VISUALISATION_view_bone_wireframe([], 0, BLDATA);
SPlotHandles.Scaled.WireFrameHandle(2) = VISUALISATION_view_bone_wireframe([], 1, BLDATA);
SPlotHandles.Scaled.WireFrameHandle(3) = VISUALISATION_view_bone_wireframe([], 2, BLDATA);
SPlotHandles.Scaled.WireFrameHandle(4) = VISUALISATION_view_bone_wireframe([], 3, BLDATA);
SPlotHandles.Scaled.WireFrameHandle(5) = VISUALISATION_view_bone_wireframe([], 4, BLDATA);
SPlotHandles.Scaled.WireFrameHandle(6) = VISUALISATION_view_bone_wireframe([], 5, BLDATA);


% set the bony landmarks color to blue
for wire = 1:6
    set(SPlotHandles.Scaled.WireFrameHandle(wire),'markerfacecolor', 'blue','markeredgecolor', 'blue')
end

% -------------------------------------------------------------------------
% visualize the glenoid fossa
% -------------------------------------------------------------------------
% % update the cone rotation matrix according to the glenoid orientations
% % data from the subject specific toolbox
% %       1) inclination
% Inc = BLDATA.Glenoid_Orientations(1);
% %       2) version (shown by declination)
% Dec = BLDATA.Glenoid_Orientations(2);
% 
% % get the generic values for inclination and version
% Inc0 = BLDATA.Glenoid_Orientations_Unchanged(1);
% Dec0 = BLDATA.Glenoid_Orientations_Unchanged(2);
% 
% % define the rotational operator to rotate the cone base center in the cone
% % frame by the given values for inclination and version (note that it's an
% % operator and therefore a transpose of a rotation matrix)
% R_opt = [cosd(Dec-Dec0) -sind(Dec-Dec0) 0;sind(Dec-Dec0) cosd(Dec-Dec0) 0;0 0 1]*...
%         [cosd(Inc-Inc0) 0 sind(Inc-Inc0);0 1 0;-sind(Inc-Inc0) 0 cosd(Inc-Inc0)];
    
% define the generic glenoid fossa
C = DYDATA.Cone_Rb'*DYDATA.ConeCentre; % cone base center in cone frame in the generic model

theta = linspace(0, 2*pi, DYDATA.NbConstraints);

P = [zeros(1,DYDATA.NbConstraints)+C(1); 
     DYDATA.ConeDimensions(1)*cos(theta)+C(2); 
     DYDATA.ConeDimensions(2)*sin(theta)+C(3)]; % fossa points in cone frame in the generic model
 
% rotate the fossa ellipse and draw it in the thorax (matlab) frame 
for i = 1:DYDATA.NbConstraints
     %P_inT = DYDATA.Cone_Rb*P(:,i)*1e3 + BLDATA.Initial_Points.GH; % wrong
     %P_inT = DYDATA.Cone_Rb*R_opt*P(:,i)*1e3 + BLDATA.Initial_Points.GH; % first rotate the fossa points by the R_opt and then transfer them to the thorax frame to be drawn
     P_inT = DYDATA.Cone_Rb*P(:,i)*1e3 + BLDATA.Initial_Points.GH;

     hold on
    SPlotHandles.Scaled.Glenoid(i) = plot3(P_inT(1), P_inT(2), P_inT(3),'marker', 'o','markersize',4,'markerfacecolor', 'blue','markeredgecolor', 'blue');
end


% ploting the scaled ribcage
SPlotHandles.Ellipsoid_scaled = [];
SPlotHandles.Ellipsoid_scaled = VISUALISATION_view_ribcage_ellipsoid('AI', SPlotHandles.Ellipsoid_scaled, REDATA);
%SPlotHandles.Ellipsoid = VISUALISATION_view_ribcage_ellipsoid('AI', SPlotHandles.Ellipsoid, REDATA); 

set(SPlotHandles.Ellipsoid_scaled, 'facecolor', 'blue', 'facealpha', 0.2, 'edgealpha', 0.2);


return;