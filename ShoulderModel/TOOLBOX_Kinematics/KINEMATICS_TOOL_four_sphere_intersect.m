function [estimated_GH, alpha, H_PS2T1, H_PS2T2, centers_parameters] = KINEMATICS_TOOL_four_sphere_intersect(center1, center2, center3, center4, initial_configuration1, initial_configuration2, alpha0in, initial_guess)

%{
Function for defining the intersection of the four spheres centered at center1
to center4 with a common point as common_point (GH point) that defines the
radii of the spheres.
--------------------------------------------------------------------------
Syntax :
[estimated_GH, alpha] = KINEMATICS_TOOL_four_sphere_intersect(center1, center2, center3, center4, initial_configuration1, initial_configuration2, alpha0in)
--------------------------------------------------------------------------
Function Description :
This function finds the intersection of four spheres. It first uses the
function called "KINEMATICS_TOOL_two_sphere_intersect" to define the conic
section associated with two pairs of the spheres. For instance the two
spheres centered at center1 and center2 are treated first and the the other two
as the second pair. Then it finds the intersection of the the two resulted
conic sections. More precisely, the intersection of two rings in the space.
It does that by minimizing the distance between the two conic sections
(rings). Obviously, we will have two points that depending on the quality
of our input data can be coincide.
--------------------------------------------------------------------------
%}
options_outer = optimoptions('fmincon','Display','iter','Algorithm','interior-point',...
                       'TolX', 1e-12,'TolFun', 1e-12, 'TolCon', 1e-12, ...
                       'MaxFunEval', 100000,'DiffMinChange', 1e-9);
% x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)
lb = [];

ub = []; 


centers_parameters = fmincon(@(center_par) cost(center1, center2, initial_configuration1, center3, center4, initial_configuration2, alpha0in, center_par),...
                    initial_guess, [], [], [], [], lb, ub, [], options_outer);


% find the first conic section (intersection of spheres centered at center1 and center2)
[CS_point_in_T1, r1, H_PS2T1] = KINEMATICS_TOOL_two_sphere_intersect(center1, center2, initial_configuration1); % CS_point_in_T1: points of the conic section in thorax
                                                                                                                % r1: radius of the resulted conic section
                                                                                                                % H_PS2T1: Homogenous transformation from PS (parametrization Surface) to Thorax

% find the second conic section (intersection of spheres centered at center1 and center2)
[CS_point_in_T2, r2, H_PS2T2] = KINEMATICS_TOOL_two_sphere_intersect(center3, center4, initial_configuration2);


% options_outer = optimoptions('fmincon','Display','iter','Algorithm','interior-point',...
%                        'TolX', 1e-12,'TolFun', 1e-12, 'TolCon', 1e-12, ...
%                        'MaxFunEval', 100000,'DiffMinChange', 1e-5);
% 
% % x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)
% lb = [];
% 
% ub = []; 
% 
% 
% radii_parameters = fmincon(@(radii_par) cost(H_PS2T1, H_PS2T2, r1, r2, alpha0in, radii_par),...
%                     initial_guess, [], [], [], [], lb, ub, [], options_outer)
% 


options = optimset('Display','none', 'TolX', 1e-12, 'TolFun', 1e-12, 'MaxIter', 1000000);

% run the optimization
% conic_section1 = [H_PS2T1(1:3,4), H_PS2T1(1:3,1), H_PS2T1(1:3,2), [r1-0*radii_parameters(1) 0 0]']; % conic section center, u1, v1, conic section radius
% conic_section2 = [H_PS2T2(1:3,4), H_PS2T2(1:3,1), H_PS2T2(1:3,2), [r2+radii_parameters(1) 0 0]']; % conic section center, u1, v1, conic section radius
conic_section1 = [H_PS2T1(1:3,4), H_PS2T1(1:3,1), H_PS2T1(1:3,2), [r1 0 0]']; % conic section center, u1, v1, conic section radius
conic_section2 = [H_PS2T2(1:3,4)+[centers_parameters(1) centers_parameters(2) centers_parameters(3)]', H_PS2T2(1:3,1), H_PS2T2(1:3,2), [r2+centers_parameters(4) 0 0]']; % conic section center, u1, v1, conic section radius
%conic_section2 = [H_PS2T2(1:3,4), H_PS2T2(1:3,1), H_PS2T2(1:3,2), [r2 0 0]'];
alpha0 = alpha0in;      % Starting guess for the parametrization value of the conic sections (angle that defines the conic sections)

[alpha,fval,exitflag,output] = fminsearch(@(alpha) objfun(conic_section1, conic_section2, alpha), alpha0, options);% fminunc


estimated_GH(1:3,1) = point_on_conic(conic_section1, alpha(1));
estimated_GH(1:3,2) = point_on_conic(conic_section2, alpha(2));

%dist = norm(estimated_GH(1:3,1)-estimated_GH(1:3,2))
%{
% set the optimization options fminunc
%options = optimoptions(@fminunc,'Algorithm','quasi-newton');
% options = optimoptions(@fsolve,'Algorithm','Levenberg-Marquardt');
options = optimset('Display','none', 'TolX', 1e-9, 'TolFun', 1e-9, 'MaxIter', 1000);

% run the optimization
conic_section1 = [H_PS2T1(1:3,4), H_PS2T1(1:3,1), H_PS2T1(1:3,2), [r1 0 0]']; % conic section center, u1, v1, conic section radius
conic_section2 = [H_PS2T2(1:3,4), H_PS2T2(1:3,1), H_PS2T2(1:3,2), [r2 0 0]']; % conic section center, u1, v1, conic section radius

 alpha0 = alpha0in;      % Starting guess for the parametrization value of the conic sections (angle that defines the conic sections)

[alpha,fval,exitflag,output] = fminsearch(@(alpha) objfun(conic_section1, conic_section2, alpha), alpha0, options);% fminunc


estimated_GH(1:3,1) = point_on_conic(conic_section1, alpha(1));
estimated_GH(1:3,2) = point_on_conic(conic_section2, alpha(2));
%}


% % define the intersection line
%     % 1) define the direction vector
%     n_matrix = [w1 w2]';
%     n = null(n_matrix); % or equivalently cross(n1, n2)
%     % 2) define an arbitrary point of the intersection line
%     x0 = inv(n_matrix'*n_matrix)*n_matrix'*[-d1; -d2] ;%+ null(n_matrix);
%     
% % find the first intersection point (conic section one and the intersection line)
%     % 1) intersection line parameter
%     t1 = -dot((x0 - O_PS1), n)/norm(n)^2;
%     % 2) define the intersection point one
%     estimated_GH(1:3,1) = t1*n + x0;
% 
% 
%     
% % find the second intersection point (conic section two and the intersection line)
%     % 1) intersection line parameter
%     t2 = -dot((x0 - O_PS2), n)/norm(n)^2;
%     % 2) define the intersection point two
%     estimated_GH(1:3,2) = t2*n + x0;

% -------------------------------------------------------------------------
% Plot the results
% -------------------------------------------------------------------------
% discritization_CS = 40;
% t_PS = linspace(0,2*pi,discritization_CS); % the canonical parametrization variable from 0 to 2pi
% CS_point_in_uvw = [(r1-0*radii_parameters(1))*cos(t_PS);
%                    (r1-0*radii_parameters(1))*sin(t_PS);
%                    zeros(1,discritization_CS);
%                    ones(1,discritization_CS)];
%                
% CS_point_in_M1 = H_PS2T1*CS_point_in_uvw; % intersection points in the thorax frame
% CS_point_in_uvw = [(r2+radii_parameters(1))*cos(t_PS);
%                    (r2+radii_parameters(1))*sin(t_PS);
%                    zeros(1,discritization_CS);
%                    ones(1,discritization_CS)];
%                
% CS_point_in_M2 = H_PS2T2*CS_point_in_uvw; % intersection points in the thorax frame

PlotValue = 0;
if PlotValue
    %set(Ehsan_fig, 'currentaxes', Ehsan_ax); hold on;
figure('units', 'normalized', 'position', [0, 0, 0.5, 0.5]);
% plot the spheres
sphere_plot(center1, norm(initial_configuration1(:,1) - initial_configuration1(:,3)));
%sphere_plot(center1, initial_configuration1(1,1));
hold on

sphere_plot(center2, norm(initial_configuration1(:,2) - initial_configuration1(:,3)));
%sphere_plot(center2, initial_configuration1(1, 2));
sphere_plot(center3, norm(initial_configuration2(:,1) - initial_configuration2(:,3)));
%sphere_plot(center3, initial_configuration2(1,1));

sphere_plot(center4, norm(initial_configuration2(:,2) - initial_configuration2(:,3)));
%sphere_plot(center4, initial_configuration2(1, 2));

% plot the conic section 1
plot3(CS_point_in_T1(1,:),CS_point_in_T1(2,:),CS_point_in_T1(3,:),'o',...
      'MarkerSize', 7, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])

  
plot3(CS_point_in_M1(1,:),CS_point_in_M1(2,:),CS_point_in_M1(3,:),'*',...
      'MarkerSize', 7, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')


% plot the conic section 2
plot3(CS_point_in_T2(1,:),CS_point_in_T2(2,:),CS_point_in_T2(3,:),'o',...
      'MarkerSize', 7, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])

  plot3(CS_point_in_M2(1,:),CS_point_in_M2(2,:),CS_point_in_M2(3,:),'*',...
      'MarkerSize', 7, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
  
% plot the intersection point 1
plot3(estimated_GH(1,1),estimated_GH(2,1),estimated_GH(3,1),'o',...
      'MarkerSize', 12, 'MarkerEdgeColor', [0 0 1], 'MarkerFaceColor', [0 0 1])
  
% plot the intersection point 2
plot3(estimated_GH(1,2),estimated_GH(2,2),estimated_GH(3,2),'o',...
      'MarkerSize', 12, 'MarkerEdgeColor', [1 0 0], 'MarkerFaceColor', [1 0 0])
  
  plot3(center1(1,1),center1(2,1),center1(3,1),'o',...
      'MarkerSize', 5, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 1 0])
  plot3(center2(1,1),center2(2,1),center2(3,1),'o',...
      'MarkerSize', 5, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 1 0])
  plot3(center3(1,1),center3(2,1),center3(3,1),'o',...
      'MarkerSize', 5, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 1 0])
  plot3(center4(1,1),center4(2,1),center4(3,1),'o',...
      'MarkerSize', 5, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 1 0])
  
%axis equal
end
return;

% -------------------------------------------------------------------------
% function for plotting
% -------------------------------------------------------------------------

function sphere_plot(center_value, radius_value)

theta = linspace(0,2*pi,40);
phi   = linspace(0,pi,40);

[theta,phi] = meshgrid(theta,phi);

% quantify and plot the sphere centered at center_value
% r_value = norm(center_value - common_point_value);
r_value = radius_value;

x_value = r_value*sin(phi).*cos(theta) + center_value(1);
y_value = r_value*sin(phi).*sin(theta) + center_value(2);
z_value = r_value*cos(phi) + center_value(3);

sphere_plot = surf(x_value, y_value, z_value);
sphere_plot.EdgeColor = [0.7 0.7 0.7];
sphere_plot.FaceColor = [0.7 0.7 0.7];
sphere_plot.FaceAlpha = 0.1;
sphere_plot.EdgeAlpha = 0.3;

axis equal

return;

% -------------------------------------------------------------------------
% Cost function inside four sphere
% -------------------------------------------------------------------------
function f = objfun(conic_section1, conic_section2, alpha)

% center_value1   = conic_section1(1:3,1);
% radius_value1   = conic_section1(1,4);
% yvector_value1  = conic_section1(1:3,2);
% xvector_value1  = conic_section1(1:3,3);
% 
% center_value2   = conic_section2(1:3,1);
% radius_value2   = conic_section2(1,4);
% yvector_value2  = conic_section2(1:3,2);
% xvector_value2  = conic_section2(1:3,3);

pp1 = point_on_conic(conic_section1, alpha(1));
pp2 = point_on_conic(conic_section2, alpha(2));

f = norm(pp1 - pp2)^2;

%f = pp1 - pp2;
return;

% -------------------------------------------------------------------------
% Conic section eval
% -------------------------------------------------------------------------
function pp = point_on_conic(conic_section, angle_id)

center_value   = conic_section(1:3,1);
radius_value   = conic_section(1,4);
yvector_value  = conic_section(1:3,2);
xvector_value  = conic_section(1:3,3);

pp = center_value + radius_value*cos(angle_id)*yvector_value + radius_value*sin(angle_id)*xvector_value;
return;

% % -------------------------------------------------------------------------
% % Cost function outside four sphere
% % -------------------------------------------------------------------------
% function distance = cost(H_PS2T1, H_PS2T2, r1, r2, alpha0in, radii_par)
% 
% % set the optimization options fminunc
% %options = optimoptions(@fminunc,'Algorithm','quasi-newton');
% % options = optimoptions(@fsolve,'Algorithm','Levenberg-Marquardt');
% options = optimset('Display','none', 'TolX', 1e-12, 'TolFun', 1e-12, 'MaxIter', 100000);
% 
% % run the optimization
% conic_section1 = [H_PS2T1(1:3,4), H_PS2T1(1:3,1), H_PS2T1(1:3,2), [r1-0*radii_par(1) 0 0]']; % conic section center, u1, v1, conic section radius
% conic_section2 = [H_PS2T2(1:3,4), H_PS2T2(1:3,1), H_PS2T2(1:3,2), [r2+radii_par(1) 0 0]']; % conic section center, u1, v1, conic section radius
% 
% alpha0 = alpha0in;      % Starting guess for the parametrization value of the conic sections (angle that defines the conic sections)
% 
% [alpha,fval,exitflag,output] = fminsearch(@(alpha) objfun(conic_section1, conic_section2, alpha), alpha0, options);% fminunc
% 
% 
% estimated_GH(1:3,1) = point_on_conic(conic_section1, alpha(1));
% estimated_GH(1:3,2) = point_on_conic(conic_section2, alpha(2));
% % center_value1   = conic_section1(1:3,1);
% % radius_value1   = conic_section1(1,4);
% % yvector_value1  = conic_section1(1:3,2);
% % xvector_value1  = conic_section1(1:3,3);
% % 
% % center_value2   = conic_section2(1:3,1);
% % radius_value2   = conic_section2(1,4);
% % yvector_value2  = conic_section2(1:3,2);
% % xvector_value2  = conic_section2(1:3,3);
% 
% 
% distance = norm(estimated_GH(1:3,1) - estimated_GH(1:3,2))^2;
% 
% %f = pp1 - pp2;
% return;

% -------------------------------------------------------------------------
% Cost function outside four sphere
% -------------------------------------------------------------------------
function distance = cost(center1, center2, initial_configuration1, center3, center4, initial_configuration2, alpha0in, center_par)

% find the first conic section (intersection of spheres centered at center1 and center2)
[CS_point_in_T1, r1, H_PS2T1] = KINEMATICS_TOOL_two_sphere_intersect(center1, center2, initial_configuration1); % CS_point_in_T1: points of the conic section in thorax
                                                                                                                % r1: radius of the resulted conic section
                                                                                                                % H_PS2T1: Homogenous transformation from PS (parametrization Surface) to Thorax

% find the second conic section (intersection of spheres centered at center1 and center2)
[CS_point_in_T2, r2, H_PS2T2] = KINEMATICS_TOOL_two_sphere_intersect(center3, center4, initial_configuration2);


options = optimset('Display','none', 'TolX', 1e-12, 'TolFun', 1e-12, 'MaxIter', 1000000);

% run the optimization
conic_section1 = [H_PS2T1(1:3,4), H_PS2T1(1:3,1), H_PS2T1(1:3,2), [r1 0 0]']; % conic section center, u1, v1, conic section radius
conic_section2 = [H_PS2T2(1:3,4)+[center_par(1) center_par(2) center_par(3)]', H_PS2T2(1:3,1), H_PS2T2(1:3,2), [r2+center_par(4) 0 0]']; % conic section center, u1, v1, conic section radius

alpha0 = alpha0in;      % Starting guess for the parametrization value of the conic sections (angle that defines the conic sections)

[alpha,fval,exitflag,output] = fminsearch(@(alpha) objfun(conic_section1, conic_section2, alpha), alpha0, options);% fminunc


estimated_GH(1:3,1) = point_on_conic(conic_section1, alpha(1));
estimated_GH(1:3,2) = point_on_conic(conic_section2, alpha(2));

distance = norm(estimated_GH(1:3,1) - estimated_GH(1:3,2));

%f = pp1 - pp2;
return;




