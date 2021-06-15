function Nout = ESTIMATION_TOOL_glenoid_cone_make(DYDATA, BLDATA)
%{
Function for building the glenoid stability cone constraint
--------------------------------------------------------------------------
Syntax :
Nout = ESTIMATION_TOOL_glenoid_cone_make(DYDATA, BLDATA)
--------------------------------------------------------------------------

File description :
This function builds the glenoid joint stability cone to keep the joint
reaction force inside the glenoid. The Cone data is all statically
defined in the thorax reference system and stored in the DYDATA
structutre. This function simply rotates the constraints into the correct
position.

--------------------------------------------------------------------------
%}

% Initialise the output
Nout = zeros(DYDATA.NbConstraints,3);
          
% define the generic glenoid fossa
C = DYDATA.Cone_Rb'*DYDATA.ConeCentre; % cone base center in cone frame in the generic model

theta = linspace(0, 2*pi, DYDATA.NbConstraints);

P = [zeros(1,DYDATA.NbConstraints)+C(1); 
     DYDATA.ConeDimensions(1)*cos(theta)+C(2); 
     DYDATA.ConeDimensions(2)*sin(theta)+C(3)]; % fossa points in cone frame in the generic model
 
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

% Get initial and current scapula rotation matrices
Rs0 = BLDATA.Initial_Matrices_L2A.Rs;
Rs = BLDATA.Current_Matrices_L2A.Rs;


% Build the normal vectors
for i = 1:size(Nout,1)
    % first make the normal vectors for the generic model
    % points on the fossa for the generic model in the cone frame
    C1 = C(1);
    y = P(2,i);
    z = P(3,i);
    
    % old method (the same but more calculations are required on paper)
    %dxdy = -(C1^2*y)/(DYDATA.ConeDimensions(1)^2*((C1^2*y^2)/DYDATA.ConeDimensions(1)^2 + (C1^2*z^2)/DYDATA.ConeDimensions(2)^2)^(1/2)); % the minus is due to the position of C_x that is defined as ((C1^2*y^2)/DYDATA.ConeDimensions(1)^2 + (C1^2*z^2)/DYDATA.ConeDimensions(2)^2)^(1/2) however we could have just put C1 here and it's fine. For the details I have the derivations and one can see them.
    %dxdz = -(C1^2*z)/(DYDATA.ConeDimensions(2)^2*((C1^2*y^2)/DYDATA.ConeDimensions(1)^2 + (C1^2*z^2)/DYDATA.ConeDimensions(2)^2)^(1/2));
    
    % define the normals using the gradiant of
    % f: y^2/a_y^2 + z^2/a_z^2 - x^2/h^2 = 0
    dfdx = 2*C1/(C1^2);
    dfdy = 2*y/(DYDATA.ConeDimensions(1)^2);
    dfdz = 2*z/(DYDATA.ConeDimensions(2)^2);
    
    % Compute the Normal Vector in Absolute reference frame for the subject
    % specific model. R_opt rotate the normal vectors to fit the rotated
    % fossa of the subject-specific model
    %Nout(i,:) =(Rs*Rs0'*DYDATA.Cone_Rb*R_opt*[dfdx; dfdy; dfdz]/norm([dfdx; dfdy; dfdz]))';
    
    Nout(i,:) =(Rs*Rs0'*DYDATA.Cone_Rb*[dfdx; dfdy; dfdz]/norm([dfdx; dfdy; dfdz]))';
    
    % few lines of code to illustrate first the normal vectors and then the
    % cone itself. Uncomment if you want to see them
    %{
    fossa_points = 1e3*DYDATA.Cone_Rb*R_opt*P(:,i) + BLDATA.Initial_Points.GH; % points on the fossa (cone base)
    hold on
    plot3([fossa_points(1) Nout(i,1)*1e3], [fossa_points(2) Nout(i,2)*1e3], [fossa_points(3) Nout(i,3)*1e3],'-o','color','b','linewidth',2,'markersize',6,'markerfacecolor','w')
    plot3([fossa_points(1) BLDATA.Initial_Points.GH(1)], [fossa_points(2) BLDATA.Initial_Points.GH(2)], [fossa_points(3) BLDATA.Initial_Points.GH(3)],'-o','color','b','linewidth',2,'markersize',6,'markerfacecolor','w')
    %}
end


return;




