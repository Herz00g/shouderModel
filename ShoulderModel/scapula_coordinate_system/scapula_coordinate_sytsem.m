clear all


% bony landmarks for defining the thorax (Matlab) coordinate system (They
% are in Amira coordinate system)
IJ = [   74.1129;  -74.8060;   68.9446]; % Incisura Jugularis
PX = [   82.5171; -133.1130;  -76.9724]; % Processus Xiphoideus
T8 = [   78.9481;  -24.5985;  -40.6273]; % Vertebra T8
C7 = [   70.5729;  -35.7244;  150.7640]; % Vertebra C7

% AMIRA -> MATLAB Rotation Matrix
Zt = (C7 + IJ)/2 - (T8 + PX)/2;
Xt = cross(C7 - IJ, (T8 + PX)/2-IJ); 
Yt = cross(Zt, Xt); 
R_am = [Xt/norm(Xt), Yt/norm(Yt), Zt/norm(Zt)]'; %R_am=R_matlab', which means
%R_matlab map the points in matlab to AMIRA. For instance if you think
%about R_matlab*[1 0 0]' it returns the associated vector (point) related
%to the x axis of matlab in amira. Obviously it will be the first column of
%the R_matlab.

% Homogeneous transformation Matrix which maps a point in AMIRA to matlab
% coordinate system
H_am = [[R_am, -R_am*IJ]; [0, 0, 0, 1]];

% bony landmarks of the scapula in the AMIRA coordinate system
%TS = [ -0.9241  52.0670  121.3280]'; % Trigonum Spinae % old
TS = [-1.585891723632813e+000 5.131806945800781e+001 1.226403579711914e+002 ]';
%AI = [ -6.7869  50.3866   -4.7008]'; % Angulus Inferior
AI = [-4.471809387207031e+000 4.468699645996094e+001 -8.649490356445313e+000]';
%SN = [-58.6632   1.2753  114.5709]'; % Spino-glenoid Notch
SN = [-5.834277343750000e+001 1.268512725830078e+000 1.163459472656250e+002]';
%GC = [-67.8221 -14.4514  103.9502]'; % glenoid fossa center % old GC
GC = [-66.9253 -15.7935 105.5615]';
GH = [-86.1456 -31.7209  107.6860]'; % humeral head center (glenohumeral joint center)
GlenoidSphere = [-80.5921 -29.58149 106.4207]';

S1 = [-4.437187576293945e+001 1.044776678085327e+000 1.171667938232422e+002]'; % the most lateral point on the supraspinatus fossa
S2 = [-2.524987030029297e+001 3.014913558959961e+001 1.212621765136719e+002]'; % one of the other 4 points on the supraspinatus fossa
S3 = [-4.073601150512695e+001 9.907344818115234e+000 1.174581298828125e+002]'; % one of the other 4 points on the supraspinatus fossa
S4 = [-3.028522109985352e+001 2.512048149108887e+001 1.201423034667969e+002]'; % one of the other 4 points on the supraspinatus fossa
S5 = [-3.626570129394531e+001 1.977687454223633e+001 1.190045471191406e+002]'; % one of the other 4 points on the supraspinatus fossa

% transform the scapula points to thorax coordinate system
TS = H_am*[TS; 1]; TS = TS(1:3,1);
AI = H_am*[AI; 1]; AI = AI(1:3,1);
SN = H_am*[SN; 1]; SN = SN(1:3,1);
GC = H_am*[GC; 1]; GC = GC(1:3,1);
GH = H_am*[GH; 1]; GH = GH(1:3,1);
GlenoidSphere = H_am*[GlenoidSphere; 1]; GlenoidSphere = GlenoidSphere(1:3,1);
S1 = H_am*[S1; 1]; S1 = S1(1:3,1);
S2 = H_am*[S2; 1]; S2 = S2(1:3,1);
S3 = H_am*[S3; 1]; S3 = S3(1:3,1);
S4 = H_am*[S4; 1]; S4 = S4(1:3,1);
S5 = H_am*[S5; 1]; S5 = S5(1:3,1);

% plot the points to be sure they hold correspondence with their anatomical
% landmarks
Current_Folder = pwd; % get the current folder
if isunix % load the scapula mesh that is in scapula coordinate system
    load([Current_Folder, '/Scapula_Mesh0.mat']);
else
    load([Current_Folder, '\Scapula_Mesh0.mat']);
end

tri = Scapula_Mesh0.tri; % save the surfaces and the points separately
points = 1.e3*Scapula_Mesh0.points; % scale the points to mm

BLDATA = MAIN_INITIALISATION_build_data_bony_landmark(); % get the BLDATA in which we have R_S2T

points_T = MAIN_TOOL_geometry_functions('Rotate Points From Local To Global Frame (Current)', points', BLDATA, 2); % rotate the points of the mesh to the thorax coordinate system

points_T = points_T';
            
figure('units', 'normalized','position', [0.4, 0.4, 0.5, 0.6],'name', 'scapula coordinate');
hold on;
trisurf(tri, points_T(:,1), points_T(:,2), points_T(:,3),'FaceColor','white','EdgeColor', [0.7 0.7 0.7]);
axis equal 
    % Set some lights to help visualise the model
    %light('Position',[ 1,   0,   0],'Style','infinite');
    %light('Position',[ 60, -60,  -100],'Style','local');
    %light('Position',[100, -80,  1000],'Style','infinite');
    colormap copper; % Give the bone meshings a bone color.
    box on;          % Turn the axes box on. It makes is easier to keep track of the orientation.
    material dull;   % Define the bone meshing material. It removes the shiny effect.
    axis equal;      % Correct the apsect ratio.
    %zoom(1.4);       % Zoom in on the visualisation. otherwise it looks very small.
    view([175, 25]); % Setup the initial camera postion [0,0] is behind horizontally.
    xlim([50, 200])
    ylim([-140, 0])
    zlim([-60, 100])

    
landmark_list = {'TS' 'AI' 'SN' 'GC' 'GH' 'GlenoidSphere' 'S1' 'S2' 'S3' 'S4' 'S5'}; % make a list of landmarks name

for land_id = 1:length(landmark_list)
    land_position = eval(landmark_list{land_id});
    PlotPoint(land_position, 3, 'k', 'none');
    text(1.02*land_position(1), 1*land_position(2), 1.1*land_position(3), landmark_list{land_id}, ...
         'color','k','fontsize',20, 'HorizontalAlignment','right')
end

% -------------------------------------------------------------------------
% define scapula coordinate system
% -------------------------------------------------------------------------
% 1) define the scapula plane
% define the plane normal vector (posterior-anterior positive)
X_SA = cross((S1 - AI), (S1 - TS)); X_SA = X_SA/norm(X_SA);

% plot the scapula plane and its normal vector, the plane is defined as follows:
% X_SA(1)*(x - S1(1)) + X_SA(2)*(y - S1(2)) + X_SA(3)*(y - S1(3)) = 0
[x y] = meshgrid(-140:10:200); % make the grids
z = -(X_SA(1)*(x - S1(1)) + X_SA(2)*(y - S1(2)))/X_SA(3) + S1(3); % calculate the z of the plane in the grids
surf(x, y, z, 'EdgeColor', 'none', 'FaceColor', [0.6 0.6 0.6], 'FaceAlpha', 0.4) % plot the surface
quiver3(S1(1), S1(2), S1(3), X_SA(1), X_SA(2), X_SA(3), 90, 'Color', [0.6 0.6 0.6], ...
        'linewidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'X_SA') % plot it's normal vector

% 2) project the five points of the supraspinatus fossa on the scapula plane
landmark_list = {'SN' 'S2' 'S3' 'S4' 'S5'}; % list of landmarks to be projected

for land_id = 1:length(landmark_list)
    t = X_SA'*(S1 - eval(landmark_list{land_id})); % line parameter in projection
    projected.(landmark_list{land_id}) = eval(landmark_list{land_id}) + t*X_SA; % projected points
    PlotPoint(projected.(landmark_list{land_id}), 3, [0.6 0.6 0.6], [0.4 0.4 0.4]); % plot the projected points
end

% 3) fit a line through the 4 projected points of the supraspinatus fossa
% and S1. The projected SN will be used as the origin of the scapula
% coordnate system
Z_SA = fitLine([S1, projected.S2, projected.S3, projected.S4, projected.S5]');
Z_SA = Z_SA/norm(Z_SA);
quiver3(projected.S2(1), projected.S2(2), projected.S2(3), Z_SA(1), Z_SA(2), Z_SA(3), 120, 'Color', [0.6 0.6 0.6], ...
        'linewidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'X_SA') % plot it's normal vector

% 4) construct the scapula coordinate system and its rotation matrix
X_SA = X_SA; % x axis of the scapula coordinate system
Z_SA = Z_SA; % z axis of the scapula coordinate system
Y_SA = cross(Z_SA, X_SA); Y_SA = Y_SA/norm(Y_SA); % y axis of the scapula coordinate system

R_SA2T = [X_SA, Y_SA, Z_SA]; % local ---> global


quiver3(projected.SN(1), projected.SN(2), projected.SN(3), X_SA(1), X_SA(2), X_SA(3), 40, 'Color', 'b', ...
        'linewidth', 4, 'MaxHeadSize', 0.5, 'DisplayName', 'X_SA') % plot axis
quiver3(projected.SN(1), projected.SN(2), projected.SN(3), Y_SA(1), Y_SA(2), Y_SA(3), 40, 'Color', 'b', ...
        'linewidth', 4, 'MaxHeadSize', 0.5, 'DisplayName', 'X_SA') % plot axis
quiver3(projected.SN(1), projected.SN(2), projected.SN(3), Z_SA(1), Z_SA(2), Z_SA(3), 40, 'Color', 'b', ...
        'linewidth', 4, 'MaxHeadSize', 0.5, 'DisplayName', 'X_SA') % plot axis
PlotPoint(projected.SN, 5, 'b', 'b') % plot the origin (again)


% -------------------------------------------------------------------------
% define the glenoid center line from glenoid center, glenoid version, and inclination
% -------------------------------------------------------------------------
% note that we get the glenoid center for each patient in the scapula
% coordinate system of that patient obtained from CT scans.
% the idea is to find the center line in the scapula coordinate system and
% then at the very end we transform them to the matlab frame. The center
% line will be used in the next step to find the new GH landmark.

GC_SA = R_SA2T'*(GC - projected.SN); % as yasmine did not give me this yet, imagine I have it
%GH_g = R_SA2T'*(GH - GC); % coordinate of the GH in glenoid frame (scpula frame attached to GC)

GlenoidSphere_g = R_SA2T'*(GlenoidSphere - GC);
GV = atand(GlenoidSphere_g(1)/GlenoidSphere_g(3)); % glenoid version in deg
GI = atand(GlenoidSphere_g(2)/GlenoidSphere_g(3)); % glenoid inclination in deg

% add a description of the GV and GI
% add a description of how I find the center line, not that obvious

% define the glenoid center line
GC_axis = [sind(GV)*cosd(GI) cosd(GV)*sind(GI) cosd(GV)*cosd(GI)]';
GC_axis = GC_axis/norm(GC_axis);

quiver3(GC(1), GC(2), GC(3), X_SA(1), X_SA(2), X_SA(3), 30, 'Color', 'r', ...
        'linewidth', 3, 'MaxHeadSize', 0.5, 'DisplayName', 'X_SA') % plot axis
quiver3(GC(1), GC(2), GC(3), Y_SA(1), Y_SA(2), Y_SA(3), 30, 'Color', 'r', ...
        'linewidth', 3, 'MaxHeadSize', 0.5, 'DisplayName', 'X_SA') % plot axis
quiver3(GC(1), GC(2), GC(3), Z_SA(1), Z_SA(2), Z_SA(3), 30, 'Color', 'r', ...
        'linewidth', 3, 'MaxHeadSize', 0.5, 'DisplayName', 'X_SA') % plot axis
    
GC_axis_T = R_SA2T*GC_axis; % glenoid center line in thorax for plotting    
quiver3(GC(1), GC(2), GC(3), GC_axis_T(1), GC_axis_T(2), GC_axis_T(3), 60, 'Color', 'k', ...
        'linewidth', 5, 'MaxHeadSize', 0.5, 'DisplayName', 'X_SA') % plot axis


% -------------------------------------------------------------------------
% define a new GH based on the new glenoid center line
% -------------------------------------------------------------------------
humeral_head_radius = norm(GH - GC); %radius of the humeral head, you should be able to scale it for each patient

GH_new_g = humeral_head_radius*GC_axis; % the new GH in glenoid frame

GH_new_T = projected.SN + R_SA2T*(GC_SA + eye(3)*GH_new_g);

GC_T = projected.SN + R_SA2T*GC_SA; % for the glenoid cone we'll need it

PlotPoint(GH_new_T, 3, 'g', 'g') % plot the new GH that will be used to construct the model, cone, and everything basically




































