function [PATH, Length, wflag] = MUSCLE_TOOL_dcylinder_wrap(P, S, O, R, Mobj, Np)
% UICONTROL Callback DOUBLE-CYLINDER WRAPPING ALGORITHM
%--------------------------------------------------------------------------
% Syntax :
% [PATH, Length, wflag] = MUSCLE_TOOL_dcylinder_wrap(P, S, O, R, Mobj, Np)
%--------------------------------------------------------------------------
%
% File Description :
% This function is the double-cylinder wrapping algorithm from the obstacle
% set method.
%--------------------------------------------------------------------------

% Initialise the output
PATH = [];
Length = [];
wflag = 0;

%--------------------------------------------------------------------------
%********* STEP 1 : Compute Object rotation Matrices
%--------------------------------------------------------------------------
% Get the Data
Ou = O(:,1); Ru = R(1);
Ov = O(:,2); Rv = R(2);

% Define the Objet to Absolute rotation matrices
Mu = Mobj(:,1:3);
Mv = Mobj(:,4:6);

%--------------------------------------------------------------------------
%********* STEP 2 : Run an interation loop to  find intermediate points G & H
%--------------------------------------------------------------------------
% Loop Parameters
Err = 1; Tol = 1.e-7; Kiter = 1;
Uact = 0;
Vact = 0;
teta = 3*pi/4;

% Take a guess at Hv (in V-cylinder frame)
Hv = [abs(Rv)*cos(teta); abs(Rv)*sin(teta); 0];
H = Mv*Hv + Ov;

% Run a search loop
while Err > Tol && Kiter < 200

    % Compute the U-cylinder wrapping
    [PATHu, Lengthu] = MUSCLE_TOOL_cylinder_wrap(P, H, Ou, Ru, Mu, Np);
    
    % Get the Value of G
    G = PATHu(:,end-1);
    
    % If wrapping occured Set Marker
    if size(PATHu,2) > 2
        Uact = 1;
    else
        Uact = 0;
    end
    
    % Compute the V-cylinder wrapping
    [PATHv, Lengthv] = MUSCLE_TOOL_cylinder_wrap(G, S, Ov, Rv, Mv, Np);
    
    % If wrapping occured Set Marker
    if size(PATHv,2) > 2
        Vact = 1;
    else
        Vact = 0;
    end
    
    % Get the new value of H & update the error
    Err = norm(H - PATHv(:,2));
    H = PATHv(:,2);

    Kiter = Kiter + 1;
end

% Get the Intermediary points
G = PATHu(:,end-1);
H = PATHv(:,2);

%--------------------------------------------------------------------------
% STEP 3 : Compute the Final Wrapping
if Uact == 1 && Vact == 1       % Both U & V-cylinders
    % Re-compute the wrappings to be sure
    [PATHu, Lengthu] = MUSCLE_TOOL_cylinder_wrap(P, H, Ou, Ru, Mu, Np);
    [PATHv, Lengthv] = MUSCLE_TOOL_cylinder_wrap(G, S, Ov, Rv, Mv, Np);
    
    % Define the path
    PATH = [PATHu, PATHv(:,3:end)];
    
    % Compute the length
    Length = Lengthu + Lengthv - norm(H - G);
    
    % Set the flag
    wflag = 4;
    %-----------------------------------------------------
elseif Uact == 0 && Vact == 1   % Only V-cylinder
    [PATHv, Lengthv] = MUSCLE_TOOL_cylinder_wrap(P, S, Ov, Rv, Mv, Np);
    
    % Define the path
    PATH = PATHv;
    
    % Compute the length
    Length = Lengthv;
    
    % Set the flag
    wflag = 3;
    %-----------------------------------------------------
elseif Uact == 1 && Vact == 0   % Only U-cylinder
    
    [PATHu, Lengthu] = MUSCLE_TOOL_cylinder_wrap(P, S, Ou, Ru, Mu, Np);
    
    % Define the path
    PATH = PATHu;
    
    % Compute the length
    Length = Lengthu;
    
    % Set the flag
    wflag = 2;
    %-----------------------------------------------------
elseif Uact == 0 && Vact == 0   % Neither Cylinder
    % Define the path
    PATH = [P, S];
    
    % Compute the length
    Length = norm(S - P);
    
    % Set the flag
    wflag = 1;
else
end
return;