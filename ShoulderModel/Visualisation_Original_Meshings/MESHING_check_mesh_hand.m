
% few lines to transform the stl file of the hand to the bone fixed frame
% of the radius. one needs to first run the first few parts of the code to have the
% rotation matrices and the bony landmarks neccessary for these
% transfromations.

% transform the points from Amira frame to the Matlab fram

Current_Folder = pwd;
load([Current_Folder, '/Visualisation_Original_Meshings/Hand_Mesh_Try1']);

IJ = BLDATA.Amira_to_MATLAB.IJ;   % origin of the Matlab frame, the Amira frame is the zero 10 -90 120

R_am = BLDATA.Amira_to_MATLAB.Rt; % Rotation matrix from Amira to MATLAB

H_am = [[R_am, -R_am*IJ]; [0, 0, 0, 1]]; % Homogeneous transformation matrix from Amira to Matlab

for i = 1:1:size(Hand_Mesh_Try1.points,1)
    
    Transformed_point_hand1(:,i) = H_am*[Hand_Mesh_Try1.points(i,:), 1]';
    Hand_Mesh_Try2.points(i,:) = Transformed_point_hand1(1:3,i)';
    Hand_Mesh_Try2.tri = Hand_Mesh_Try1.tri;
    
end
hold on
trisurf(Hand_Mesh_Try2.tri, Hand_Mesh_Try2.points(:,1), Hand_Mesh_Try2.points(:,2), Hand_Mesh_Try2.points(:,3));


% Ru = BLDATA.Original_Matrices_L2A.Ru';
% HU = BLDATA.Original_Points.HU;
% 
% H_T2U = [[Ru, -Ru*HU]; [0, 0, 0, 1]]; % Homogeneous transformation matrix from absolute to local frame

Rr = BLDATA.Original_Matrices_L2A.Rr';
CP = BLDATA.Original_Points.CP;

H_T2R = [[Rr, -Rr*CP]; [0, 0, 0, 1]]; % Homogeneous transformation matrix from absolute to local frame


RS = BLDATA.Original_Points.RS;
H_T2H = [[Rr, -Rr*RS]; [0, 0, 0, 1]];
% 
% for i = 1:1:size(Ulna_Mesh_Try2.points,1)
%     
%     Transformed_point_ulna2(:,i) = H_T2U*[Ulna_Mesh_Try2.points(i,:), 1]';
%     Ulna_Mesh_Try3.points(i,:) = Transformed_point_ulna2(1:3,i)';
%     Ulna_Mesh_Try3.tri = Ulna_Mesh_Try2.tri; 
% end

for j = 1:1:size(Hand_Mesh_Try2.points,1)

    Transformed_point_hand2(:,j) = H_T2H*[Hand_Mesh_Try2.points(j,:), 1]';
    Hand_Mesh_Try3.points(j,:) = Transformed_point_hand2(1:3,j)';
    Hand_Mesh_Try3.tri = Hand_Mesh_Try2.tri;
end

Current_Folder = pwd;% pwd displays the MATLAB current folder.


save([pwd, '/Visualisation_Original_Meshings/Hand_Mesh_Try32'],'Hand_Mesh_Try3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the older part of the code for checking visualization stuffs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load Ulna_Mesh_Try1;%Clavicula_Mesh0
%Clavicula_Mesh0 = Clavicula_Mesh;
%Clavicula_Mesh0.points = [Clavicula_Mesh0.points(:,3), Clavicula_Mesh0.points(:,1), Clavicula_Mesh0.points(:,2)];
%subplot(1,2,1)
hold on
trisurf(Hand_Mesh_Try3.tri, Hand_Mesh_Try3.points(:,1), Hand_Mesh_Try3.points(:,2), Hand_Mesh_Try3.points(:,3));

trisurf(Radius_Mesh0.tri, Radius_Mesh0.points(:,1), Radius_Mesh0.points(:,2), Radius_Mesh0.points(:,3));
axis equal;
hold on;
stop
% load Clavicula_Meshold;
% 
% subplot(1,2,2)
% trisurf(Clavicula_Mesh0.tri, Clavicula_Mesh0.points(:,1), Clavicula_Mesh0.points(:,2), Clavicula_Mesh0.points(:,3));
% axis equal;
% hold on;
% R = [cos(pi/40), 0, -sin(pi/40);
%               0, 1, 0;
%      sin(pi/40), 0,  cos(pi/40)];
% Rz = [cos(2*pi/180), -sin(2*pi/180), 0;
%       sin(2*pi/180),  cos(2*pi/180), 0;
%                   0,           0, 1];
% points = Rz'*Clavicula_Mesh0.points';
% points = points';
% trisurf(Clavicula_Mesh0.tri, points(:,1), points(:,2), points(:,3), 'facecolor', 'blue');
% axis equal;
BLDATA = MAIN_INITIALISATION_build_data_bony_landmark;
BLDATAOld = MAIN_INITIALISATION_build_data_bony_landmarkOld;
SC = BLDATA.Original_Points.SC;
SCold = BLDATAOld.Original_Points.SC;

dvec = SC-SCold;
dvec = BLDATA.Original_Matrices_L2A.Rc'*dvec;
dvec = dvec/1000;

points = Clavicula_Mesh0.points' - diag(dvec)*ones(3,size(Clavicula_Mesh0.points,1));
points = points';
trisurf(Clavicula_Mesh0.tri, points(:,1), points(:,2), points(:,3));
axis equal;
plot3(dvec(1), dvec(2), dvec(3), 'marker', 'o', 'color', 'red', 'markersize', 12, 'markerfacecolor', 'red');
% 
% Clavicula_Mesh0.points = points;
% save Clavicula_Mesh0 Clavicula_Mesh0;
%%

Current_Folder = pwd;
load([Current_Folder, '/Visualisation_Original_Meshings/Hand_Mesh_Try1']);

points = Hand_Mesh_Try1.points;
tri = Hand_Mesh_Try1.tri;

correction_translation = [24.9268  -156.24  119.754]';
IJ = BLDATA.Amira_to_MATLAB.IJ - correction_translation;   % origin of the Matlab frame, the Amira frame is the zero 10 -90 120

correction_direction_angle = [-1 1.54028e-06  -4.18706e-06]'; n_yas = correction_direction_angle/norm(correction_direction_angle);
theta_yas = 12.0445;

R_yasmine_correction = [n_yas(1)*n_yas(1)*(1-cosd(theta_yas))+cosd(theta_yas) n_yas(1)*n_yas(2)*(1-cosd(theta_yas))-n_yas(3)*sind(theta_yas) n_yas(1)*n_yas(3)*(1-cosd(theta_yas))-n_yas(2)*sind(theta_yas);
                        n_yas(1)*n_yas(2)*(1-cosd(theta_yas))+n_yas(3)*sind(theta_yas) n_yas(2)*n_yas(2)*(1-cosd(theta_yas))+cosd(theta_yas) n_yas(2)*n_yas(3)*(1-cosd(theta_yas))-n_yas(1)*sind(theta_yas);
                        n_yas(1)*n_yas(3)*(1-cosd(theta_yas))-n_yas(2)*sind(theta_yas) n_yas(2)*n_yas(3)*(1-cosd(theta_yas))+n_yas(1)*sind(theta_yas) n_yas(3)*n_yas(3)*(1-cosd(theta_yas))+cosd(theta_yas)];

R_am = BLDATA.Amira_to_MATLAB.Rt*R_yasmine_correction'; % Rotation matrix from Amira to MATLAB

H_am = [[R_am, -R_am*IJ]; [0, 0, 0, 1]]; % Homogeneous transformation matrix from Amira to Matlab

for i = 1:1:size(points,1)
    
    Transformed_points(:,i) = H_am*[points(i,:), 1]';
    Hand_Mesh_Try2.points(i,:) = Transformed_points(1:3,i)';
    Hand_Mesh_Try2.tri = tri;
    
end

hold on
trisurf(Hand_Mesh_Try2.tri, Hand_Mesh_Try2.points(:,1), Hand_Mesh_Try2.points(:,2), Hand_Mesh_Try2.points(:,3));





















