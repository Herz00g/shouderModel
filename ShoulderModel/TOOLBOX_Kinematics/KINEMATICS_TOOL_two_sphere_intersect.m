function [CS_point_in_T, r, H_PS2T] = KINEMATICS_TOOL_two_sphere_intersect(center1, center2, initial_configuration)

%{
Function for defining the intersection of the two spheres centered at center1
and center2 with a common point as common_point (GH point) that defines the
radii of the spheres.
--------------------------------------------------------------------------
Syntax :
[CS_point_in_T, r, H_PS2T] = KINEMATICS_TOOL_two_sphere_intersect(center1, center2, initial_configuration)
--------------------------------------------------------------------------
Function Description :
This function defines the conic section resulted from the intersection of
two spheres. This intersection curve is defined using the methods developed
to address the quadric surfaces intersection. The intersection of two
spheres is relatively easier than the general case of the intersection of
two arbitrary quadric surfaces. The resulted conic section is contained in
a surface. Therefore, the intersection is called planar.

Ref: Joshua Zev Levin, 1978, Mathematical Models for Determining the
     Intersections of Quadric Surfaces.

The function provides the coordinates of the points on the intersection
curve (conic section). These points are in inertial (thorax) coordinate as
the inputted points are in this frame.
The outputs are as the following:
            CS_point_in_T          intersection points (conic section) in the intertia (thorax) frame
            r                      radius of the conic section
            H_PS2T                 humugenous transformation matrix that includes the origin (center of the conic section) and the axes of the parametrization plane
--------------------------------------------------------------------------
%}
% define the spheres in the discriminant forms
radius1 = norm(initial_configuration(:,1) - initial_configuration(:,3)); % initial_configuration = [initial_center1, initial_center2, initial_common_point]
radius2 = norm(initial_configuration(:,2) - initial_configuration(:,3)); 

% radius1 = initial_configuration(1,1);
% radius2 = initial_configuration(1,2);

    % discriminant matrix of the first sphere
Q_1 = [1 0 0 -center1(1);
       0 1 0 -center1(2);
       0 0 1 -center1(3);
       -center1(1) -center1(2) -center1(3) (norm(center1))^2 - (radius1)^2]; 
    % discriminant matrix of GF sphere
Q_2 = [1 0 0 -center2(1);
       0 1 0 -center2(2);
       0 0 1 -center2(3);
       -center2(1) -center2(2) -center2(3) (norm(center2))^2 - (radius2)^2]; 
%-------------------------------------------------------------------------
% define the PARAs in the pencil of the two spheres.
% The general approach is construct the pencil and find the values alpha
% that makes the determinant of the pencil equal to zero.
% % syms lambda;
% % 
% % Pencil = Q_1(1:3,1:3) + lambda*Q_2(1:3,1:3);
% % 
% % alpha = solve(det(Pencil) == 0, lambda);
alpha = [-1 -1 -1]';
% As the subdiscriminant matrix of the two spheres are
% equal to I, we could have also used the eig command.
% alpha = -eig(Q_GF(1:3,1:3));

% define the discriminant of the parametrization surface (PS)
% note: the PS is one of the PARAs in the pencil that is more amendable to 
% parametrization. Here it makes no difference if one choses any of the
% three elements of alpha so we choose alpha(1):
Q_PS = Q_1 + alpha(1)*Q_2;
% d = Q_PS(4,4);     % n(1)x + n(2)y + n(3)z + d = 0, not needed anymore
%-------------------------------------------------------------------------

% define the transformation that transforms the parametrization surface
% resulted above to the u-v surface of the u-v-w frame (the frame attached
% to the parametrization surface).
    % 1- rotation matrix
n = [2*Q_PS(4,1) 2*Q_PS(4,2) 2*Q_PS(4,3)]'; % normal vector of the parametrization surface    

w = n/norm(n); % the w vector of the frame fixed to the PS

if isequal(w,[0 0 1]')
    u = [1 0 0]';
    v = [0 1 0]';
elseif isequal(w,[0 0 -1]')
    u = [1 0 0]';
    v = [0 -1 0]';
else
u = cross(n, [0 0 1]'); u = u/norm(u); % the u vector of the frame fixed to the PS
                                       % defined regarding the Z axis of the thorax frame
v = cross(n, u); v = v/norm(v);        % the v vector of the frame fixed to the PS
                                       % defined regarding the Z axis of the thorax frame                                       
end

R_PS2T = [u v w]; % rotation matrix from the PS frame to the thorax (inertia) frame
                  % local -----> global
                  
    % 2- center of the PS frame
% the center is considered as the point of the intersection of PS and the
% line goes through one of the centers in the direction of the normal
% vector of PS
t = -(dot(n,center1) + Q_PS(4,4))/((norm(n))^2); % t of the contact point

O_PS = [n(1)*t+center1(1) n(2)*t+center1(2) n(3)*t+center1(3)]'; % the origin of the PS fixed frame

% define the homogeneous transformation from PS to thorax (or maybe later on glenoid)
H_PS2T = [R_PS2T(1,:) O_PS(1);
          R_PS2T(2,:) O_PS(2);
          R_PS2T(3,:) O_PS(3);
          zeros(1,3)       1];
%-------------------------------------------------------------------------
      
% define the discriminant matrix of the PS in the u-v-w frame:
% Q_PS_in_uvw = H_PS2T'*Q_PS*H_PS2T;

% transform any surface in the pencil to the u-v-w frame
% for the sake of simplicity Q_1 is choosen
Q_1_in_uvw = H_PS2T'*Q_1*H_PS2T;

% the QSIC is achieved by imposing the w coordinate of the quadric surface
% above equal to zero, meaning that we are only looking for those points on
% this quadric surface that are contained in the parametrization surface.
Q_CS_in_uvw = [Q_1_in_uvw(1,[1:2,4]);
               Q_1_in_uvw(2,[1:2,4]);
               Q_1_in_uvw(4,[1:2,4])];% the discriminant matrix of the conic section in the u-v-w frame

% define the numerical values of the points of the resulted conic
% section in the u-v-w frame
% Note: we should have further transform the resulted conic section to its
% canonical form. But, given that the underquestion problem is far simpler
% than the general case, we expect to have it right away in the canonical
% form.
discritization_CS = 80;
t_PS = linspace(0,2*pi,discritization_CS); % the canonical parametrization variable from 0 to 2pi
CS_point_in_uvw = [sqrt(abs(Q_CS_in_uvw(3,3)))*cos(t_PS);
                   sqrt(abs(Q_CS_in_uvw(3,3)))*sin(t_PS);
                   zeros(1,discritization_CS);
                   ones(1,discritization_CS)];
               
r = sqrt(abs(Q_CS_in_uvw(3,3))); % radius of the conic section

% define the numerical values of the points of the resulted conic
% section in the thorax frame
CS_point_in_T = H_PS2T*CS_point_in_uvw; % intersection points in the thorax frame

% define the numerical values of the points of the resulted conic
% section in the humeral frame
% Rot_T2H = Rot_H2T';
% translation = -Rot_T2H*r_HH;
% H_T2H = [Rot_T2H(1,:) translation(1);
%          Rot_T2H(2,:) translation(2);
%          Rot_T2H(3,:) translation(3);
%          zeros(1,3)               1];

% CS_point_in_H = H_T2H*CS_point_in_T; % intersection points in the humeral frame


return;

                                                  