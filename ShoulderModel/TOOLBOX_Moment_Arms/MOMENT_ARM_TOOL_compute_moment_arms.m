function [MA, DV] = MOMENT_ARM_TOOL_compute_moment_arms(PATH, WREF, BLDATA)
%{
 Function for computing the muscle moment arms using the geometric method
--------------------------------------------------------------------------
Syntax :
[MA, DVEC] = MOMENT_ARM_TOOL_compute_moment_arms(PATH, WREF, BLDATA)
--------------------------------------------------------------------------
Function Description :
This function computes the moment arms of a muscle given the way points
of its path The way path is already defined by MUSCLE_TOOL_compute_wrapping.
For each way point, the moment arms associated with each joint are
computed and added to the total moment arms associated with the same joint.
These adding procedure removes all the duplications caused by blindly
considering all the way points. In other word, mechanically many of the way
points are not needed to be considered. But in order to have more ease in
programming we did it this way (for more details see 148-149 of the thesis).
Apart from the moment arm for each segment, this function will give the
unit direction vector of the force associated with the segment. The output 
force vector is a 15x1 vector. If all of its enteries in rows 7,8, and 9
are not simultaneously zero, it means the muscle
applies a force on the humerus. The same is relevant for its other enteries.

The Output Data Structure is defined as follows:
  MA = 15 x 1 Moment Arms
  DV = 15 x 1 Force Direction Vector
--------------------------------------------------------------------------
%}
% Initialise the output
MA = zeros(15,1);
DV = zeros(15,1);

% Create the list of Joint Centres
JC = [BLDATA.Current_Points.SC, BLDATA.Current_Points.AC,...
    BLDATA.Current_Points.GH, BLDATA.Current_Points.HU,...
    BLDATA.Current_Points.CP];

% Run through the entire muscle path starting with its insertion
for PathIndex = size(PATH,2):-1:1
    % Get the reference index
    i = WREF(1,PathIndex); % the reference frame of the understudy point inside the loop
    
    % Initialise the indivdual moment arms
    MA_SC = zeros(3,1);
    MA_AC = zeros(3,1);
    MA_GH = zeros(3,1);
    MA_HU = zeros(3,1);
    MA_RU = zeros(3,1);
    
    %-----------------------------------------
    %************** INSERTION POINT
    %-----------------------------------------
    if PathIndex == size(PATH,2)
        % Direction Vector (normalised)
        dn = PATH(:,PathIndex-1) - PATH(:,PathIndex); dn = dn/norm(dn);
        
        if WREF(1,PathIndex) == 1       % The Point is on the clavicle
            % Lever vector (convert to m)
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,1));
            MA_SC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            MA_AC = zeros(3,1);
            MA_GH = zeros(3,1);
            MA_HU = zeros(3,1);
            MA_RU = zeros(3,1);

            DV(1:3,1) = DV(1:3,1) + dn; % if some force applies on the Clavicle. At the end this might be zero after all of the summations
            
        elseif WREF(1,PathIndex) == 2   % The Point is on the Scapula
            % Lever vector (convert to m)
            rn = 1.e-3*(JC(:,2) - JC(:,1));
            MA_SC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,2));
            MA_AC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            MA_GH = zeros(3,1);
            MA_HU = zeros(3,1);
            MA_RU = zeros(3,1);

            DV(4:6,1) = DV(4:6,1) + dn;
           
        elseif WREF(1,PathIndex) == 3   % The Point in on the humerus
            % Lever vector (convert to m)
            rn = 1.e-3*(JC(:,2) - JC(:,1));
            MA_SC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,3) - JC(:,2));
            MA_AC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,3));
            MA_GH = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            MA_HU = zeros(3,1);
            MA_RU = zeros(3,1);

            DV(7:9,1) = DV(7:9,1) + dn;

        elseif WREF(1,PathIndex) == 4   % The Point in on the ulna
            % Lever vector (convert to m)
            rn = 1.e-3*(JC(:,2) - JC(:,1));
            MA_SC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,3) - JC(:,2));
            MA_AC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,4) - JC(:,3));
            MA_GH = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,4));
            MA_HU = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            MA_RU = zeros(3,1);

            DV(10:12,1) = DV(10:12,1) + dn;

        elseif WREF(1,PathIndex) == 5   % The Point in on the radius
            % Lever vector (convert to m)
            rn = 1.e-3*(JC(:,2) - JC(:,1));
            MA_SC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,3) - JC(:,2));
            MA_AC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,4) - JC(:,3));
            MA_GH = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,5) - JC(:,4));
            MA_HU = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,5));
            MA_RU = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];

            DV(13:15,1) = DV(13:15,1) + dn;
            
        end
    %-----------------------------------------
    %************** MIDDLE POINTS
    %-----------------------------------------
    elseif PathIndex > 1 && PathIndex < size(PATH,2)
        % Direction Vector (normalised)
        dn_p = PATH(:,PathIndex-1) - PATH(:,PathIndex); dn_p = dn_p/norm(dn_p);
        dn_n = PATH(:,PathIndex+1) - PATH(:,PathIndex); dn_n = dn_n/norm(dn_n);
        
        if WREF(1,PathIndex) == 1       % The Point is on the clavicle
            % Lever vector (convert to m)
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,1));
            dn = dn_p + dn_n;
            MA_SC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            MA_AC = zeros(3,1);
            MA_GH = zeros(3,1);
            MA_HU = zeros(3,1);
            MA_RU = zeros(3,1);

            DV(1:3,1) = DV(1:3,1) + dn;

        elseif WREF(1,PathIndex) == 2   % The Point is on the Scapula
            % Lever vector (convert to m)
            rn = 1.e-3*(JC(:,2) - JC(:,1));
            dn = dn_p + dn_n;
            MA_SC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,2));
            MA_AC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            MA_GH = zeros(3,1);
            MA_HU = zeros(3,1);
            MA_RU = zeros(3,1);

            DV(4:6,1) = DV(4:6,1) + dn;


        elseif WREF(1,PathIndex) == 3   % The Point in on the humerus
            % Lever vector (convert to m)
            rn = 1.e-3*(JC(:,2) - JC(:,1));
            dn = dn_p + dn_n;
            MA_SC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,3) - JC(:,2));
            MA_AC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,3));
            MA_GH = cross(rn, dn);
            MA_HU = zeros(3,1);
            MA_RU = zeros(3,1);

            DV(7:9,1) = DV(7:9,1) + dn;
            
        elseif WREF(1,PathIndex) == 4   % The Point in on the ulna
            % Lever vector (convert to m)
            rn = 1.e-3*(JC(:,2) - JC(:,1));
            dn = dn_p + dn_n;
            MA_SC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,3) - JC(:,2));
            MA_AC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,4) - JC(:,3));
            MA_GH = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,4));
            MA_HU = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            MA_RU = zeros(3,1);

            DV(10:12,1) = DV(10:12,1) + dn;
            
        elseif WREF(1,PathIndex) == 5   % The Point in on the radius
            % Lever vector (convert to m)
            rn = 1.e-3*(JC(:,2) - JC(:,1));
            dn = dn_p + dn_n;
            MA_SC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,3) - JC(:,2));
            MA_AC = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,4) - JC(:,3));
            MA_GH = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(JC(:,5) - JC(:,4));
            MA_HU = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,5));
            MA_RU = [rn(2)*dn(3)-rn(3)*dn(2); rn(3)*dn(1)-rn(1)*dn(3); rn(1)*dn(2)-rn(2)*dn(1)];

            DV(13:15,1) = DV(13:15,1) + dn;           
            
        end
        
    %-----------------------------------------
    %************** ORIGIN POINT
    %-----------------------------------------
    elseif PathIndex == 1
        % Direction Vector (normalised)
        dn = PATH(:,PathIndex+1) - PATH(:,PathIndex); dn = dn/norm(dn);
        
        if WREF(1,PathIndex) == 1       % The Point is on the clavicle
            % Lever vector (convert to m)
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,1));
            MA_SC = cross(rn, dn);
            MA_AC = zeros(3,1);
            MA_GH = zeros(3,1);
            MA_HU = zeros(3,1);
            MA_RU = zeros(3,1);

            DV(1:3,1) = DV(1:3,1) + dn;

        elseif WREF(1,PathIndex) == 2   % The Point is on the Scapula
            % Lever vector (convert to m)
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,2));
            MA_SC = cross(1.e-3*(JC(:,2) - JC(:,1)), dn);
            MA_AC = cross(rn, dn);
            MA_GH = zeros(3,1);
            MA_HU = zeros(3,1);
            MA_RU = zeros(3,1);

            DV(4:6,1) = DV(4:6,1) + dn;

        elseif WREF(1,PathIndex) == 3   % The Point is on the humerus
            % Lever vector (convert to m)
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,3));
            MA_SC = cross(1.e-3*(JC(:,2) - JC(:,1)), dn);
            MA_AC = cross(1.e-3*(JC(:,3) - JC(:,2)), dn);
            MA_GH = cross(rn, dn);
            MA_HU = zeros(3,1);
            MA_RU = zeros(3,1);

            DV(7:9,1) = DV(7:9,1) + dn;
            
        elseif WREF(1,PathIndex) == 4   % The Point is on the ulna
            % Lever vector (convert to m)
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,4));
            MA_SC = cross(1.e-3*(JC(:,2) - JC(:,1)), dn);
            MA_AC = cross(1.e-3*(JC(:,3) - JC(:,2)), dn);
            MA_GH = cross(1.e-3*(JC(:,4) - JC(:,3)), dn);
            MA_HU = cross(rn, dn);
            MA_RU = zeros(3,1);

            DV(10:12,1) = DV(10:12,1) + dn;
            
        elseif WREF(1,PathIndex) == 5   % The Point is on the radius
            % Lever vector (convert to m)
            rn = 1.e-3*(PATH(:,PathIndex) - JC(:,5));
            MA_SC = cross(1.e-3*(JC(:,2) - JC(:,1)), dn);
            MA_AC = cross(1.e-3*(JC(:,3) - JC(:,2)), dn);
            MA_GH = cross(1.e-3*(JC(:,4) - JC(:,3)), dn);
            MA_HU = cross(1.e-3*(JC(:,5) - JC(:,4)), dn);
            MA_RU = cross(rn, dn);

            DV(13:15,1) = DV(13:15,1) + dn;
            
        end
        
    end
    % Complete the moment arms
    MA = MA + [MA_SC; MA_AC; MA_GH; MA_HU; MA_RU];
end

return;