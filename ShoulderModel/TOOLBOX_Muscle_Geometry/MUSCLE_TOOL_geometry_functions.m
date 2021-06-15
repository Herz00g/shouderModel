function Output = MUSCLE_TOOL_geometry_functions(Task, BLDATA, MEDATA, PointsList_in, RefList)
%{
 UICONTROL Callback computes geometric operations for the muscle wrapping
--------------------------------------------------------------------------
Syntax :
Output = MUSCLE_TOOL_geometry_functions(Task, BLDATA, MEDATA, PointsList_in, RefList)
--------------------------------------------------------------------------


File Description :
This function computes all the geometry related operations for the muscle
wrapping.

List of Tasks :
  Task 1: Rotate Points To Absolute Frame
  Task 2: Rotate Object Centre To Absolute Frame 
  Task 3: Construct Object Rotation Matrix
--------------------------------------------------------------------------
%}

% Initialise the Output
Output = [];

%--------------------------------------------------------------------------
% TASK 1 : Transform points using the original rotation matrices
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
if isequal(Task, 'Rotate Points To Absolute Frame')
    % Get the current landmark data
    SC = BLDATA.Current_Points.SC;
    AC = BLDATA.Current_Points.AC;
    AA = BLDATA.Current_Points.AA;
    GH = BLDATA.Current_Points.GH;
    HU = BLDATA.Current_Points.HU;
    CP = BLDATA.Current_Points.CP;
    
    % Get the current rotation matrices
    Rc = BLDATA.Current_Matrices_L2A.Rc;
    Rs = BLDATA.Current_Matrices_L2A.Rs;
    Rh = BLDATA.Current_Matrices_L2A.Rh;
    Ru = BLDATA.Current_Matrices_L2A.Ru;
    Rr = BLDATA.Current_Matrices_L2A.Rr;

    
    Output = PointsList_in;
    
    % Run through the list of points and transform
    for i = 1:size(Output,2)
        if RefList(1,i) == 0        % THORAX
            Output(:,i) = PointsList_in(:,i);
        elseif RefList(1,i) == 1    % CLAVICULA   
            Output(:,i) = Rc*PointsList_in(:,i) + SC;
        elseif RefList(1,i) == 2    % SCAPULA
            Output(:,i) = Rs*PointsList_in(:,i) + AA;
        elseif RefList(1,i) == 3    % HUMERUS
            Output(:,i) = Rh*PointsList_in(:,i) + GH;
        elseif RefList(1,i) == 4    % ULNA
            Output(:,i) = Ru*PointsList_in(:,i) + HU;
        elseif RefList(1,i) == 5    % RADIUS
            Output(:,i) = Rr*PointsList_in(:,i) + CP;
        else
        end
    end
%--------------------------------------------------------------------------
% TASK 2 : Rotate the object centre point into absolute frame
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
elseif isequal(Task, 'Rotate Object Centre To Absolute Frame')
    % Get the current landmark data
    SC = BLDATA.Current_Points.SC;
    AC = BLDATA.Current_Points.AC;
    AA = BLDATA.Current_Points.AA;
    GH = BLDATA.Current_Points.GH;
    HU = BLDATA.Current_Points.HU;
    CP = BLDATA.Current_Points.CP;
    
    
    % Get the current rotation matrices
    Rc = BLDATA.Current_Matrices_L2A.Rc;
    Rs = BLDATA.Current_Matrices_L2A.Rs;
    Rh = BLDATA.Current_Matrices_L2A.Rh;
    Ru = BLDATA.Current_Matrices_L2A.Ru;
    Rr = BLDATA.Current_Matrices_L2A.Rr;
    
    % Rotate the points
    Output = zeros(3,size(MEDATA.ObjectRef,2));
    for idx = 1:size(MEDATA.ObjectRef,2)
         if MEDATA.ObjectRef(1,idx) == 0
            Output(:,idx) = MEDATA.ObjectCentre(:,idx);
        elseif MEDATA.ObjectRef(1,idx) == 1
            Output(:,idx) = Rc*MEDATA.ObjectCentre(:,idx) + SC;
        elseif MEDATA.ObjectRef(1,idx) == 2
            Output(:,idx) = Rs*MEDATA.ObjectCentre(:,idx) + AA;
        elseif MEDATA.ObjectRef(1,idx) == 3
            Output(:,idx) = Rh*MEDATA.ObjectCentre(:,idx) + GH;
        elseif MEDATA.ObjectRef(1,idx) == 4
            Output(:,idx) = Ru*MEDATA.ObjectCentre(:,idx) + HU;
        elseif MEDATA.ObjectRef(1,idx) == 5
            Output(:,idx) = Rr*MEDATA.ObjectCentre(:,idx) + CP;
        end
    end
%--------------------------------------------------------------------------
% TASK 3 : Build Object Rotation Matrix
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
elseif isequal(Task, 'Construct Object Rotation Matrix')
    % Get the original rotation matrices
    Rc = BLDATA.Current_Matrices_L2A.Rc;
    Rs = BLDATA.Current_Matrices_L2A.Rs;
    Rh = BLDATA.Current_Matrices_L2A.Rh;
    Ru = BLDATA.Current_Matrices_L2A.Ru;
    Rr = BLDATA.Current_Matrices_L2A.Rr;
    
    for idx = 1:size(MEDATA.ObjectRef,2)
        % Normalise the Z-axis
        Zaxis = MEDATA.ObjectZaxis(:,idx)/norm(MEDATA.ObjectZaxis(:,idx));
        
        % Zaxis & [0; 1; 0] colinear?
        Xaxis = [];
        if Zaxis(1,1) == 0 && Zaxis(3,1) == 0
            Xaxis = cross([1; 1; 0], Zaxis); Xaxis = Xaxis/norm(Xaxis);
        else
            Xaxis = cross([0; 1; 0], Zaxis); Xaxis = Xaxis/norm(Xaxis);
        end
        Yaxis = cross(Zaxis, Xaxis); Yaxis = Yaxis/norm(Yaxis);
        
        % Transformation Matrix Object to Absolute
        M = [Xaxis, Yaxis, Zaxis];
        
        % Add the local to absolute transformation
        if MEDATA.ObjectRef(1,idx) == 0
            Output = [Output, M];
        elseif MEDATA.ObjectRef(1,idx) == 1
            Output = [Output, Rc*M];
        elseif MEDATA.ObjectRef(1,idx) == 2
            Output = [Output, Rs*M];
        elseif MEDATA.ObjectRef(1,idx) == 3
            Output = [Output, Rh*M];
        elseif MEDATA.ObjectRef(1,idx) == 4
            Output = [Output, Ru*M];
        elseif MEDATA.ObjectRef(1,idx) == 5
            Output = [Output, Rr*M];    
        end
    end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% THE CONDITIONAL SCRIPT ENDS HERE
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
else
end
return;