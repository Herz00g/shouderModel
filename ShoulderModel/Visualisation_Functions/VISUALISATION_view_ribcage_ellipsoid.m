function EllipseHandle = VISUALISATION_view_ribcage_ellipsoid(task, EHandle, REDATA)
% Function for visualising the ribcage ellipsoid.
%--------------------------------------------------------------------------
% Syntax :
% EllipseHandle = VISUALISATION_view_ribcage_ellipsoid(EHandle, REDATA)
%--------------------------------------------------------------------------
%
%
% File Description :
% This function either creates a visualisation of the ribcage ellipsoid or
% upadates an already existing one.
%--------------------------------------------------------------------------

% Initialise the output
EllipseHandle = EHandle;

% Create sphere
[Sx, Sy, Sz] = sphere(20);

if isequal(task, 'ribcage')
    
% Transform to ellipsoid
Ex = REDATA.Axes(1)*Sx + REDATA.Centre(1)*ones(21,21);
Ey = REDATA.Axes(2)*Sy + REDATA.Centre(2)*ones(21,21);
Ez = REDATA.Axes(3)*Sz + REDATA.Centre(3)*ones(21,21);
   
% The Handle is empty: Create a visualisation
if isempty(EllipseHandle)
    EllipseHandle = surf(Ex, Ey, Ez, 'facecolor', 'cyan', 'facealpha', 0.5, 'edgealpha', 0.5);
% Update a pre-existing visualisation
else
    set(EllipseHandle, 'xdata', Ex, 'ydata', Ey, 'zdata', Ez, 'facecolor', 'cyan', 'facealpha', 0.5, 'edgealpha', 0.5);
end


elseif isequal(task, 'TS')
    
    % Transform to ellipsoid
Ex = REDATA.TSaxes(1)*Sx + REDATA.Centre(1)*ones(21,21);
Ey = REDATA.TSaxes(2)*Sy + REDATA.Centre(2)*ones(21,21);
Ez = REDATA.TSaxes(3)*Sz + REDATA.Centre(3)*ones(21,21);
   
% The Handle is empty: Create a visualisation
if isempty(EllipseHandle)
    EllipseHandle = surf(Ex, Ey, Ez, 'facecolor', 'red', 'facealpha', 0.5, 'edgealpha', 0.5);
% Update a pre-existing visualisation
else
    set(EllipseHandle, 'xdata', Ex, 'ydata', Ey, 'zdata', Ez, 'facecolor', 'red', 'facealpha', 0.5, 'edgealpha', 0.5);
end

elseif isequal(task, 'AI')
        
      % Transform to ellipsoid
Ex = REDATA.AIaxes(1)*Sx + REDATA.Centre(1)*ones(21,21);
Ey = REDATA.AIaxes(2)*Sy + REDATA.Centre(2)*ones(21,21);
Ez = REDATA.AIaxes(3)*Sz + REDATA.Centre(3)*ones(21,21);
   
% The Handle is empty: Create a visualisation
if isempty(EllipseHandle)
    EllipseHandle = surf(Ex, Ey, Ez, 'facecolor', 'red', 'facealpha', 0.3, 'edgealpha', 0.3);
% Update a pre-existing visualisation
else
    set(EllipseHandle, 'xdata', Ex, 'ydata', Ey, 'zdata', Ez, 'facecolor', 'red', 'facealpha', 0.3, 'edgealpha', 0.3);
end  
    
else
    %
end

    
    
    
    
    
    
    
    
    
    
return