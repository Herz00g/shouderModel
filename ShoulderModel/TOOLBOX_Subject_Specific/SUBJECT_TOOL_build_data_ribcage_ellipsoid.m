function REDATA = SUBJECT_TOOL_build_data_ribcage_ellipsoid(BLDATA, DYDATA)
% Function to initialise the ribcage ellipsoid dataset
%{
--------------------------------------------------------------------------
Syntax:
REDATA = MAIN_INITIALISATION_build_data_ribcage_ellipsoid(BLDATA)
--------------------------------------------------------------------------


File Description:
This file generates the ellipsoid ribcage date without optimisation. The
values are by default from an optimisation that "seems" to work.

Data Structure Format :
          REDATA.Centre            center of the ellipsoid (same for all)
          REDATA.Axes              semi-principal axes of the base ellip.
          REDATA.TSscale           the SF for the ellipsoid includes TS
          REDATA.AIscale           the SF for the ellipsoid includes AI
          REDATA.TSaxes            when we add REDATA.TSscale to REDATA.Axes
          REDATA.AIaxes            when we add REDATA.AIscale to REDATA.Axes
--------------------------------------------------------------------------
%}
% Initialiase the Output
REDATA = [];

%--------------------------------------------------------------------------
% Initial Data
%--------------------------------------------------------------------------
% Create the initial data (this data was obtained from an initial
% optimisation trial)
REDATA.Centre = DYDATA.Height_Scaling_Factor*[ 34.0603; -10.2252; -60.6326];% these data are in the MATLAB coordinate system.
REDATA.Axes   = DYDATA.Height_Scaling_Factor*[106.3947; 111.4764; 152.0050];%the lenghts of the semi-principal axes of the base ellipsoid

% Position of TS & AI in thorax reference system
TS = BLDATA.Initial_Points.TS;
AI = BLDATA.Initial_Points.AI;

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% GET THE SCALING FACTOR FOR THE UPPER MEDIAL BORDER POINT TS
% The Scaling Factor (sf) is the only positive real root of a sixth order 
% polyomial. The polynomial is obtained from the ellipsoid equation. In
% other word, by some magic we already have the base ellipsoid. Therefore, in
% order to simplify the problem by using double ellipsoid we need to dilate
% the base ellipsoid in a way that it includes the points AI and TS, ie
% these two should satisfy the dilated ellipsoid equations. [Ex Ey Ez]' is
% the center of the ellipsoids which should be written as [Xo Yo Z0]' as line 57.
%
% (TSx - Ex)^2   (TSy - Ey)^2   (TSz - Ez)^2
% ------------ + ------------ + ------------ - 1 = 0
%  (A + sf)^2     (B + sf)^2     (C + sf)^2
%
% Required Data
TSx = TS(1);            TSy = TS(2);            TSz = TS(3);
A   = REDATA.Axes(1);   B   = REDATA.Axes(2);   C   = REDATA.Axes(3);
Xo  = REDATA.Centre(1); Yo  = REDATA.Centre(2); Zo  = REDATA.Centre(3);

% The polynomial coefficients are derived using MATLAB symbolic toolbox.
% DO NOT TOUCH THIS PART OF THE CODE!!!
% The Polynomial Coefficients are given by
P6 = - 1;
P5 = - 2*(A + B + C);
P4 = ((TSx - Xo)^2 + (TSy - Yo)^2 + (TSz - Zo)^2 - (C^2 + 4*C*B + B^2) - 4*(C + B)*A - A^2);
P3 = (2*(TSx - Xo)^2*(C + B) + 2*(TSy - Yo)^2*(A+C) + 2*(TSz - Zo)^2*(A + B) - 2*(C^2*B + B^2*C) - 2*(C^2 + 4*C*B + B^2)*A - 2*(C + B)*A^2);
P2 = ((TSx - Xo)^2*(B^2 + C^2 + 4*C*B) + (TSy - Yo)^2*(C^2 + 4*A*C + A^2) + (TSz - Zo)^2*(A^2 + 4*A*B + B^2) - C^2*B^2 - 4*(C^2*B + C*B^2)*A - (C^2 + 4*C*B + B^2)*A^2);
P1 = (2*(TSx - Xo)^2*(B^2*C + C^2*B) + 2*(TSy - Yo)^2*(A^2*C + C^2*A) + 2*(TSz - Zo)^2*(A^2*B + B^2*A) -2*C^2*B^2*A - 2*(C^2*B + C*B^2)*A^2);
P0 = (TSx - Xo)^2*C^2*B^2 + (TSy - Yo)^2*A^2*C^2 + (TSz - Zo)^2*A^2*B^2 - A^2*B^2*C^2;

% Get the Roots
TS_Scale_Roots = roots([P6, P5, P4, P3, P2, P1, P0]);

% Extract the Positive Root only. It is more robust to search for values
% with small imaginary parts. MATLAB has a tendency to give real values
% imaginary parts with 0.
idx  = find(abs(imag(TS_Scale_Roots)) < 1.e-6);
idxx = find(real(TS_Scale_Roots(idx)) > 0); % Get the positive root

% Save The Data
REDATA.TSscale = TS_Scale_Roots(idx(idxx),1);
REDATA.TSaxes = [A; B; C] + REDATA.TSscale*ones(3,1);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% GET THE SCALING FACTOR FOR THE LOWER MEDIAL BORDER POINT AI
% The scaling factor is one of the roots of a sixth order polyomial. The
% polynomial is obtained from the equation and must be a positive real
% root.
% (AIx - Ex)^2   (AIy - Ey)^2   (AIz - Ez)^2
% ------------ + ------------ + ------------ - 1 = 0
%  (A + sf)^2     (B + sf)^2     (C + sf)^2
%
% Required Data
AIx = AI(1); AIy = AI(2); AIz = AI(3);

% The polynomial coefficients are derived using MATLAB symbolic toolbox.
% DO NOT TOUCH THIS PART OF THE CODE!!!
% The Polynomial Coefficients are given by
P6 = - 1;
P5 = - 2*(A + B + C);
P4 = ((AIx - Xo)^2 + (AIy - Yo)^2 + (AIz - Zo)^2 - (C^2 + 4*C*B + B^2) - 4*(C + B)*A - A^2);
P3 = (2*(AIx - Xo)^2*(C + B) + 2*(AIy - Yo)^2*(A+C) + 2*(AIz - Zo)^2*(A + B) - 2*(C^2*B + B^2*C) - 2*(C^2 + 4*C*B + B^2)*A - 2*(C + B)*A^2);
P2 = ((AIx - Xo)^2*(B^2 + C^2 + 4*C*B) + (AIy - Yo)^2*(C^2 + 4*A*C + A^2) + (AIz - Zo)^2*(A^2 + 4*A*B + B^2) - C^2*B^2 - 4*(C^2*B + C*B^2)*A - (C^2 + 4*C*B + B^2)*A^2);
P1 = (2*(AIx - Xo)^2*(B^2*C + C^2*B) + 2*(AIy - Yo)^2*(A^2*C + C^2*A) + 2*(AIz - Zo)^2*(A^2*B + B^2*A) -2*C^2*B^2*A - 2*(C^2*B + C*B^2)*A^2);
P0 = (AIx - Xo)^2*C^2*B^2 + (AIy - Yo)^2*A^2*C^2 + (AIz - Zo)^2*A^2*B^2 - A^2*B^2*C^2;

% Get the Roots
AI_Scale_Roots = roots([P6, P5, P4, P3, P2, P1, P0]);

% Extract the Positive Root only. It is more robust to search for values
% with small imaginary parts. MATLAB has a tendency to give real values
% imaginary parts with 0.
idx  = find(abs(imag(AI_Scale_Roots)) < 1.e-6);
idxx = find(real(AI_Scale_Roots(idx)) > 0); % Get the positive root

% Save The Data
REDATA.AIscale = AI_Scale_Roots(idx(idxx),1);
REDATA.AIaxes = [A; B; C] + REDATA.AIscale*ones(3,1);
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
return;