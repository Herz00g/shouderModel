function MWDATA = MAIN_INITIALISATION_build_data_muscle_wrapping_old(BLDATA)
% Function to initialise the muscle wrapping data set
%--------------------------------------------------------------------------
% Syntax :
% MWDATA = MAIN_INITIALISATION_build_data_muscle_wrapping(BLDATA)
%--------------------------------------------------------------------------
%
% EPFL - LA - LBO SHOULDER MODEL
% Created by : David Ingram
%
% File Description :
% This file builds the muscle data structure for all the muscles. The data
% is defined in the AMIRA reference system. The script finishes with a
% transformation of all the data into the MATLAB reference frame. The data
% is contained in a 28 x 1 cell. Each element of the cell is a structure.
%
% Data Structure Format :
% Anchor Points for the Splines
%     MWDATA{Mident,1}.AnchorOrigin    = cell(1,3);
%     MWDATA{Mident,1}.AnchorViaA      = cell(1,3);
%     MWDATA{Mident,1}.AnchorViaB      = cell(1,3);
%     MWDATA{Mident,1}.AnchorInsertion = cell(1,3);
%
% Actual origin/insertion points once number of segments is decided
%     MWDATA{Mident,1}.Origin    = cell(1,20);
%     MWDATA{Mident,1}.ViaA      = cell(1,20);
%     MWDATA{Mident,1}.ViaB      = cell(1,20);
%     MWDATA{Mident,1}.Insertion = cell(1,20);
%
% Information regarding the muscle
%     MWDATA{Mident,1}.MSCInfo.OriginRef = [];
%     MWDATA{Mident,1}.MSCInfo.ViaARef = [];
%     MWDATA{Mident,1}.MSCInfo.ViaBRef = [];
%     MWDATA{Mident,1}.MSCInfo.InsertionRef = [];
%     MWDATA{Mident,1}.MSCInfo.ObjectCentre = [];
%     MWDATA{Mident,1}.MSCInfo.ObjType = [];
%     MWDATA{Mident,1}.MSCInfo.ObjZaxis = [];
%     MWDATA{Mident,1}.MSCInfo.ObjectRef = [];
%     MWDATA{Mident,1}.MSCInfo.ObjectRadii= [];
%     MWDATA{Mident,1}.MSCInfo.Visualise = 'off';
%     MWDATA{Mident,1}.MSCInfo.ObjectVisualise = 'off';
%     MWDATA{Mident,1}.MSCInfo.InterpType = 'Bi-Linear';
%     MWDATA{Mident,1}.MSCInfo.NbSegments = 1;
%     MWDATA{Mident,1}.MSCInfo.NbPlotPoints = 12;
%     MWDATA{Mident,1}.MSCInfo.ObjectRadiiscale= 1/2;
%     MWDATA{Mident,1}.MSCInfo.ObjectRadiicorrection = 1;
%     MWDATA{Mident,1}.MSCInfo.PCSA
%     MWDATA{Mident,1}.MSCInfo.Fmax
%     MWDATA{Mident,1}.MSCInfo.Lmax
%     MWDATA{Mident,1}.MSCInfo.Lmin
%
% The data structure also contains information regarding the muscle
% internal model for computing the maximum permissible force.
% Optimum Fiber Length :
%     MWDATA{Mident,1}.OptimalFiberLength = zeros(1,20);
%--------------------------------------------------------------------------

% Initialise the output
MWDATA = cell(28,1);

% List of Physical Cross-Sectional Areas
PCSA0 = 1.e-4*[...
        4.36;             % Subclavius
        8.12;             % Serratus Anterior Upper
        4;                % Serratus Anterior Middle 
        8.41;             % Serratus Anterior Lower
        6.24;             % Trapezius C1 - C6   
        3.61;             % Trapezius C7 
        3.45;             % Trapezius T1
        12.4;             % Trapezius T2 - T7
        3.78;             % Levator Scapulae
        6.71;             % Rhomboid Minor
        4.14;             % Rhomboid Major T1 - T2
        2.48;             % Rhomboid Major T3 - T4
        4.87;             % Pectoralis Minor
        10.38;            % Pectoralis Major Clavicular 
        14.68;            % Pectoralis Major Sternal 
        11.14;            % Pectoralis Major Ribs
        5.26;             % Latisimuss Dorsi Thoracic 
        5.26;             % Latisimuss Dorsi Lumbar 
        3.8;              % Latisimuss Dorsi Iliac
        8.41;             % Deltoid Clavicular 
        56.38;            % Deltoid Acromial
        17.19;            % Deltoid Scapular
        20.84;            % Supraspinatus
        33.32;            % Infraspinatus
        35.69;            % Subscapularis
        6.77;             % Teres Minor
        15.69;            % Teres Major
        4.55];             % Coracobrachialis 
    
% Maximum force values
Fmax0 = [...
        144.02;        % Subclavius
        268.05;        % Serratus Anterior Upper
        132.12;        % Serratus Anterior Middle
        277.51;        % Serratus Anterior Lower
        205.95;        % Trapezius C1 - C6 
        119.25;        % Trapezius C7 
        114.01;        % Trapezius T1 
        409.23;        % Trapezius T2 - T7
        124.78;        % Levator Scapulae
        221.51;        % Rhomboid Minor
        136.48;        % Rhomboid Major T1 - T2
        81.93;         % Rhomboid Major T3 - T4
        160.55;        % Pectoralis Minor
        342.46;        % Pectoralis Major Clavicular
        484.35;        % Pectoralis Major Sternal
        367.78;        % Pectoralis Major Ribs
        173.43;        % Latisimuss Dorsi Thoracic 
        173.88;        % Latisimuss Dorsi Lumbar
        125.52;        % Latisimuss Dorsi Iliac
        277.48;        % Deltoid Clavicular 
        1860.52;       % Deltoid Acromial 
        567.15;        % Deltoid Scapular
        687.84;        % Supraspinatus
        1099.61;       % Infraspinatus
        1177.93;       % Subscapularis
        223.35;        % Teres Minor
        514.51;        % Teres Major
        150.05];       % Coracobrachialis
    
% Maximum Muscle Fiber Lengths (m)
Lmax0 = [...
        0.1015;        % Subclavius
        0.1224;        % Serratus Anterior Upper
        0.1932;        % Serratus Anterior Middle
        0.2489;        % Serratus Anterior Lower
        0.2012;        % Trapezius C1 - C6 
        0.2321;        % Trapezius C7 
        0.2110;        % Trapezius T1 
        0.1692;        % Trapezius T2 - T7
        0.2062;        % Levator Scapulae
        0.1900;        % Rhomboid Minor
        0.1930;        % Rhomboid Major T1 - T2
        0.1996;         % Rhomboid Major T3 - T4
        0.1575;        % Pectoralis Minor
        0.2892;        % Pectoralis Major Clavicular
        0.3224;        % Pectoralis Major Sternal
        0.3443;        % Pectoralis Major Ribs
        0.4214;        % Latisimuss Dorsi Thoracic 
        0.5600;        % Latisimuss Dorsi Lumbar
        0.5718;        % Latisimuss Dorsi Iliac
        0.2122;        % Deltoid Clavicular 
        0.1822;       % Deltoid Acromial 
        0.2414;        % Deltoid Scapular
        0.1880;        % Supraspinatus
        0.1529;       % Infraspinatus
        0.1311;       % Subscapularis
        0.1257;        % Teres Minor
        0.1927;        % Teres Major
        0.2124];       % Coracobrachialis

% Maximum Muscle Fiber Lengths
Lmin0 = [...
        0.0628;        % Subclavius
        0.0584;        % Serratus Anterior Upper
        0.1123;        % Serratus Anterior Middle
        0.1343;        % Serratus Anterior Lower
        0.0946;        % Trapezius C1 - C6 
        0.1094;        % Trapezius C7 
        0.0776;        % Trapezius T1 
        0.0971;        % Trapezius T2 - T7
        0.1204;        % Levator Scapulae
        0.0872;        % Rhomboid Minor
        0.0791;        % Rhomboid Major T1 - T2
        0.0693;        % Rhomboid Major T3 - T4
        0.0813;        % Pectoralis Minor
        0.0883;        % Pectoralis Major Clavicular
        0.1259;        % Pectoralis Major Sternal
        0.1837;        % Pectoralis Major Ribs
        0.2118;        % Latisimuss Dorsi Thoracic 
        0.3573;        % Latisimuss Dorsi Lumbar
        0.3978;        % Latisimuss Dorsi Iliac
        0.0911;        % Deltoid Clavicular 
        0.1105;        % Deltoid Acromial 
        0.1241;        % Deltoid Scapular
        0.1445;        % Supraspinatus
        0.0918;        % Infraspinatus
        0.0940;        % Subscapularis
        0.0600;        % Teres Minor
        0.1058;        % Teres Major
        0.1411];       % Coracobrachialis

% Optimum fiber length
Lopt0 = [...
    0.1158;
    0.0894;
    0.1995;
    0.1620;
    0.1432;
    0.1420;
    0.1311;
    0.1850;
    0.0960;
    0.0731;
    0.0734;
    0.0751;
    0.1475;
    0.1432;
    0.1677;
    0.1913;
    0.2351;
    0.3105;
    0.3623;
    0.2056;
    0.2005;
    0.1927;
    0.1317;
    0.1414;
    0.1208;
    0.0849;
    0.1230;
    0.1290];

% Run through all the Muscles
for Mident = 1:28
    MWDATA{Mident,1}.AnchorOrigin    = cell(1,3);
    MWDATA{Mident,1}.AnchorViaA      = cell(1,3);
    MWDATA{Mident,1}.AnchorViaB      = cell(1,3);
    MWDATA{Mident,1}.AnchorInsertion = cell(1,3);
    MWDATA{Mident,1}.Origin    = cell(1,20);
    MWDATA{Mident,1}.ViaA      = cell(1,20);
    MWDATA{Mident,1}.ViaB      = cell(1,20);
    MWDATA{Mident,1}.Insertion = cell(1,20);
    MWDATA{Mident,1}.MSCInfo.OriginRef = [];
    MWDATA{Mident,1}.MSCInfo.ViaARef = [];
    MWDATA{Mident,1}.MSCInfo.ViaBRef = [];
    MWDATA{Mident,1}.MSCInfo.InsertionRef = [];
    MWDATA{Mident,1}.MSCInfo.ObjectCentre = [];
    MWDATA{Mident,1}.MSCInfo.ObjectType = [];
    MWDATA{Mident,1}.MSCInfo.ObjectZaxis = [];
    MWDATA{Mident,1}.MSCInfo.ObjectRef = [];
    MWDATA{Mident,1}.MSCInfo.ObjectRadii = [];
    
    % This data is initially common to all
    MWDATA{Mident,1}.MSCInfo.Visualise = 'off';
    MWDATA{Mident,1}.MSCInfo.ObjectVisualise = 'off';
    MWDATA{Mident,1}.MSCInfo.InterpType = 'Bi-Linear';
    MWDATA{Mident,1}.MSCInfo.NbSegments = 1;
    
    % The radii are in truth the object diameters
    MWDATA{Mident,1}.MSCInfo.ObjectRadiiscale = 1/2;
    
    % There are 12 points on the wrapping surface
    MWDATA{Mident,1}.MSCInfo.NbPlotPoints = 12;
    
    % This parameter is incase the muscle' object radiius requires
    % modification. This factor is only used in the visualisation of the
    % muscle's object.
    MWDATA{Mident,1}.MSCInfo.ObjectRadiicorrection = 1;
    
    % This will be defined once the muscle model is completely defined
    MWDATA{Mident,1}.OptimalFiberLength = zeros(1,20);
    
    %----------------------------------------------------------------------
    % SUBLCAVIUS
    %----------------------------------------------------------------------
    if Mident == 1
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [45.35; -70.78; 60.95];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [42.67; -72.62; 57.57];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [39.22; -73.68; 54.57];
        
        % Via Points B Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-27.61; -41.68; 125.89];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-36.80; -34.53; 132.75];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-42.68; -27.90; 136.84];

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 1;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0; 0; 1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % SERRATUS ANTERIOR SUPERIOR PART
    %----------------------------------------------------------------------
    elseif Mident == 2
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [3.22; 51.16; 113.15];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [5.56; 45.73; 127.90];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [8.25; 31.90; 143.06];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [20.05; -43.53; 65.87];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [-4.76; -35.34; 95.40];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [7.11; -25.46; 107.48];

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 33.7391; -0.826292; 99.249];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [-0.25;1.15;-1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -78.88;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % SERRATUS ANTERIOR MIDDLE PART
    %----------------------------------------------------------------------
    elseif Mident == 3
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [3.690; 51.11; 107.06];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [0.960; 53.17;  81.43];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [3.034; 53.57;  36.62];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [-31.00; -64.37;  18.50];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [-37.46; -83.85; -44.95];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-41.32; -79.71; -63.80];

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 30; -30; 30];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.3;  1; -0.05];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -155.82                                                                                  ;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % SERRATUS ANTERIOR INFERIOR PART
    %----------------------------------------------------------------------
    elseif Mident == 4
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [ 2.060; 53.91; 30.03];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [ 2.298; 47.19; -0.12];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-7.270; 39.47; -4.05];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [-39.69; -75.99;  -88.47];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [-38.39; -58.12; -111.94];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-37.91; -32.91; -125.93];

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 65; -45; -65.7954];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [ 0.283423;  0.957817; -0.047525];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -223.16;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % TRAPEZIUS C1 - C6
    %----------------------------------------------------------------------
    elseif Mident == 5
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-64.41; -15.76; 150.67];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-45.51; -24.18; 144.10];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-32.01; -33.66; 136.14];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [73.89;  -0.56; 192.46];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [65.90;  -3.38; 205.93];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [50.12; -14.66; 205.93];

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 1;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [[38.3735; -15.4232; 153.044], [-15.51; -14.18; 144.10]];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [0, 1];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [[-0.166575;  0.982514; 0.083181], [-0.2181; 0.5215; 0.8249]];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [44.1, -20];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % TRAPEZIUS C7
    %----------------------------------------------------------------------
    elseif Mident == 6
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-83.16; -6.99; 145.60];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-73.86; 10.25; 145.22];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-63.57; 19.36; 142.42];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [66.98; 12.31; 170.79];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [61.68; 24.75; 156.78];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [63.36; 31.17; 134.67];

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 23.1081; 17.2498; 106.796];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [1;1;0];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 94.60;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % TRAPEZIUS T1
    %----------------------------------------------------------------------
    elseif Mident == 7
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-59.05; 23.17; 141.90];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-51.07; 33.01; 138.20];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-38.09; 45.75; 133.01];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [67.26; 32.25; 132.81];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [66.36; 38.69; 110.14];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [65.72; 40.56;  88.41];

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 22.9631; 18.6087; 105.564];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [1;1.5;0];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 90;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % TRAPEZIUS T2 - T7
    %----------------------------------------------------------------------
    elseif Mident == 8
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [ -5.60; 53.48; 121.31];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-15.89; 51.95; 120.89];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-24.57; 50.38; 121.23];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [68.17; 46.10; 84.34];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [75.69; 36.62; -38.65];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [82.79; 10.37; -148.25];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 25; -15; 23.8976];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.1; 0.993127; -0.115173];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 130;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % LEVATOR SCAPULAE
    %----------------------------------------------------------------------
    elseif Mident == 9
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [2.38; 48.22; 129.53];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [6.18; 43.42; 132.70];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [5.73; 35.80; 144.63];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [51.85;  1.32; 200.20];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [51.85;  1.32; 205.93];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [50.99; -9.49; 226.95];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = [0; 0; 1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef          = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef          = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % RHOMBOID MINOR
    %----------------------------------------------------------------------
    elseif Mident == 10
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [1.679; 54.08; 109.41];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [1.649; 52.70; 118.99];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [5.247; 47.09; 128.58];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [63.69; 32.18; 134.33];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [65.74; 30.72; 146.54];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [65.84; 24.41; 156.31];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = [0; 0; 1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef          = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef          = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % RHOMBOID MAJOR T1 - T2
    %----------------------------------------------------------------------
    elseif Mident == 11
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [1.514; 55.31; 54.99];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [1.070; 55.46; 75.31];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [1.320; 55.09; 97.58];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [67.69; 45.01;  85.29];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [66.67; 41.74; 100.36];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [66.18; 39.78; 122.88];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 35.5873; -10; 80];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [1;1.5;0];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 140;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % RHOMBOID MAJOR T3 - T4
    %----------------------------------------------------------------------
    elseif Mident == 12
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [2.830; 55.23;  8.86];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [2.662; 56.03; 25.74];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [3.150; 55.90; 45.74];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [72.00; 45.32; 27.79];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [69.45; 52.67; 55.99];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [67.03; 51.28; 69.93];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 35.2838; -10; 45];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [1;3.0;-0.2];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 140;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % PECTORALIS MINOR
    %----------------------------------------------------------------------
    elseif Mident == 13
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-45.29; -45.70; 117.46];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-43.77; -41.49; 119.35];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-41.82; -37.28; 121.60];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [-32.58; -90.38; -49.94];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [-29.78; -81.84; -21.88];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-27.23; -67.95;  14.08];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = [0; 0; 1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % PECTORALIS MAJOR CLAVICULAR
    %----------------------------------------------------------------------
    elseif Mident == 14
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-88.45; -41.09; 13.15];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-88.45; -42.50; 18.67];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-88.24; -43.74; 26.16];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [41.71; -78.59; 80.91];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [23.20; -73.45; 89.76];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [ 5.54; -71.57; 96.38];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 1;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -41.3096; -3.53952; 46.6423];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [-0.4;  0.7;  0.2];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -140.00;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % PECTORALIS MAJOR STERNAL
    %----------------------------------------------------------------------
    elseif Mident == 15
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-88.06; -43.58; 24.39];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-87.53; -43.63; 32.30];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-88.01; -44.18; 39.68];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [69.91; -101.47; 16.03];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [66.90;  -91.03; 34.52];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [54.40;  -79.13; 53.49];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 15; -25; 0];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [1;10;-0.1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -140.00;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % PECTORALIS MAJOR RIBS
    %----------------------------------------------------------------------
    elseif Mident == 16
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-87.89; -44.31; 36.75];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-87.24; -44.94; 45.68];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-86.38; -46.02; 55.31];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [71.11; -122.70; -47.98];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [70.11; -117.66; -20.26];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [69.98; -106.40;   6.50];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 15; -40; 0];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.2;1;-0.2];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -140.00;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % LATISSIMUS DORSI THORACIC
    %----------------------------------------------------------------------
    elseif Mident == 17
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-86.41; -45.80; 56.10];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-86.03; -44.10; 62.38];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-86.68; -45.09; 66.98];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [79.34; 20.94; -120.93];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [75.84; 31.53;  -66.96];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [72.34; 42.97;   -6.96];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [[20; -30; -37],[-60; 0; 75]];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [0 , 2];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [[0.05; 1; -0.25],[1; 1; 0.35]];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [140; -40];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % LATISSIMUS DORSI LUMBAR
    %----------------------------------------------------------------------
    elseif Mident == 18
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-86.30; -44.95; 50.77];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-86.02; -45.51; 55.87];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-86.81; -44.33; 61.03];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [82.44; -12.280; -215.70];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [82.44;  -0.788; -182.12];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [82.99;   8.920; -147.09];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [[30; -49.8121; -86.8349], [-83; -13; 70]];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [0 , 3];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [[-0.3; 1; 0.1], [0.1; 1; -0.2]];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [148.88; -35];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % LATISSIMUS DORSI ILLIAC
    %----------------------------------------------------------------------
    elseif Mident == 19
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-86.61; -45.57; 48.04];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-86.08; -44.67; 52.78];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-86.29; -44.51; 57.26];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [77.70; -13.08; -277.15];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [75.41; -20.47; -254.94];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [75.41; -18.49; -232.99];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [[35; -55; -164.025], [-75; -22; 50]];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [0 , 3];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [[-0.3; 1; 0.1], [0.2; 1; -0.2]];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [130; -25];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % DELTOID CLAVICULAR (FRONTAL)
    %----------------------------------------------------------------------
    elseif Mident == 20
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-97.13; -43.13; -43.81];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-98.02; -41.64; -36.40];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-98.11; -42.59; -26.62];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [ -92.87; -68.79; 24.32];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [ -97.35; -65.09; 23.10];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [-103.20; -60.80; 22.62];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [-45.38; -34.53; 140.08];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [-61.31; -30.44; 145.182];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-80.60; -32.00; 147.99];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 1;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -85; -30; 98];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.4;1;1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -80;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % DELTOID ACROMIAL (MIDDLE)
    %----------------------------------------------------------------------
    elseif Mident == 21
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-102.14; -39.47; -38.47];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-103.99; -39.95; -31.97];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-102.21; -39.32; -26.79];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [-106.43; -50.68; -9.699];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [-108.56; -48.48; -9.699];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [-112.01; -47.42; -5.113];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [-112.81; -42.58; 136.91]+[20; -10; 4];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [-117.65; -20.52; 134.47]+[5; -20; 0];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [-113.05; -3.139; 126.71];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [ -86.12; -36.66; 142.55];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [ -99.73; -34.57; 137.85];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-104.17;  -0.87; 133.89];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -91; -34; 101];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.1;1.0;0.3];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 85;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % DELTOID SCAPULAR (POSTERIOR)
    %----------------------------------------------------------------------
    elseif Mident == 22
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-105.34; -35.43; -32.45];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-105.22; -35.62; -27.32];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-103.93; -35.71; -24.02];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [-117.30; -45.76;  2.860];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [-118.14; -37.59;  0.323];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [-116.83; -30.06; -5.480];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [-113.92; -4.264; 125.84];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [ -97.37;  15.15; 126.24];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [ -78.22;  28.07; 115.93];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [-101.32; 1.40; 133.11];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [-79.31; 15.64; 137.99];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-47.15; 39.74; 128.56];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -74; -21; 103];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [-0.2;1;0.2];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 90;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % SUPRASPINATUS
    %----------------------------------------------------------------------
    elseif Mident == 23
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-109.31; -33.88; 112.73];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-107.97; -36.57; 114.46];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-107.14; -42.48; 113.80];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1}= [-104.81; -30.61; 127.57];
        MWDATA{Mident,1}.AnchorViaB{1,2}= [-104.64; -35.40; 126.89];
        MWDATA{Mident,1}.AnchorViaB{1,3}= [-102.48; -39.47; 126.24];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [-56.63; -3.79; 125.77];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [-56.94; -3.51; 130.45];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [-55.52; -3.57; 137.93];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [-8.09; 30.01; 129.43];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [-3.04; 25.26; 134.80];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-2.78; 21.11; 140.77];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0; 0; 1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % INFRASPINATUS
    %----------------------------------------------------------------------
    elseif Mident == 24
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-107.53; -28.02;  99.15];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-108.13; -27.92; 106.05];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-108.01; -30.44; 112.84];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [-73.92; 21.41;  71.66];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [-75.97; 17.10;  89.40];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [-76.62; 17.46; 108.10];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [ -5.936; 52.77;  15.55];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [ -9.070; 52.01;  63.59];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-10.090; 47.30; 109.30];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -82.5103; -19.2801; 99.9505];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.2;1.0;0.1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 51.06;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % SUBSCAPULARIS
    %----------------------------------------------------------------------
    elseif Mident == 25
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-74.34; -45.20;  88.78];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-70.78; -51.08;  96.51];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-69.35; -51.08; 102.79];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [-34.39; -2.81;  67.65];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [-33.27; -3.94;  79.83];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [-26.31; -9.20; 110.28];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [ -8.16; 45.41;  19.96];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [ -9.93; 42.08; 106.84];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-11.28; 29.11; 125.04];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [-49.6409; -13.7723; 139.708];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.0;1.0;-0.5];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -30.82;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % TERES MINOR
    %----------------------------------------------------------------------
    elseif Mident == 26
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-98.53; -30.18; 77.97];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-98.40; -30.09; 84.66];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-102.05; -30.19;91.49];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [-75.67; 10.87; 47.60];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [-79.40;  8.05; 60.98];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [-79.74;  7.97; 73.42];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [-35.82; 31.90; 26.09];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [-46.63; 22.23; 55.63];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-57.12; 10.75; 74.20];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = [ -85; -20; 110];
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = [0.2; 1.5; 0.3];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = 40;
        MWDATA{Mident,1}.MSCInfo.ViaBRef          = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef          = 2;
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % TERES MAJOR
    %----------------------------------------------------------------------
    elseif Mident == 27
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-82.25; -40.36; 51.08];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-82.08; -41.14; 57.19];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-81.94; -42.03; 63.86];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [ -8.30; 50.69;  2.065];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [-18.65; 43.05;  6.533];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-25.70; 38.68; 15.340];

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = [ -30; 15; 23.165];
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = [0.3;1.0;0.5];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = 48;
        MWDATA{Mident,1}.MSCInfo.ViaBRef          = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef          = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    %----------------------------------------------------------------------
    % CORACOBRACHIALIS
    %----------------------------------------------------------------------
    elseif Mident == 28
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion{1,1} = [-88.03; -35.59; -21.370];
        MWDATA{Mident,1}.AnchorInsertion{1,2} = [-86.96; -37.40;  -8.873];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = [-86.33; -38.07;   3.021];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [-79.44; -38.16; 16.41];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [-78.20; -38.16; 22.74];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [-76.69; -37.22; 29.20];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin{1,1} = [-50.10; -50.45; 115.36];
        MWDATA{Mident,1}.AnchorOrigin{1,2} = [-53.06; -52.05; 114.55];
        MWDATA{Mident,1}.AnchorOrigin{1,3} = [-57.42; -51.00; 115.53];
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -60; -10; 80];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [1.0;1.0;0.4];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -34.62;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        % Phyiscal Cross-Sectional Area
        MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
        
        % Maximum Muscle Force
        MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Maximum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmax = Lmax0(Mident, 1);
        
        % Minimum Fiber Length
        MWDATA{Mident,1}.MSCInfo.Lmin = Lmin0(Mident, 1);
        
        % Optimum Fiber Length
        MWDATA{Mident,1}.OptimalFiberLength(1,1) = Lopt0(Mident,1);
        
    end
    
%--------------------------------------------------------------------------
% ROTATE ALL POINTS INTO MATLAB FRAME
%--------------------------------------------------------------------------
    % All the anchor points must be rotated into the correct frame.
    for i = 1:3
        % Rotate the origin points
        MWDATA{Mident,1}.AnchorOrigin{1,i} =...
            Rotate_Point_Into_Matlab_Frame(MWDATA{Mident,1}.AnchorOrigin{1,i}, BLDATA, MWDATA{Mident,1}.MSCInfo.OriginRef);
        
        % Rotate the insertion points
        MWDATA{Mident,1}.AnchorInsertion{1,i} =...
            Rotate_Point_Into_Matlab_Frame(MWDATA{Mident,1}.AnchorInsertion{1,i}, BLDATA, MWDATA{Mident,1}.MSCInfo.InsertionRef);
        
        % If they exist, rotate the via points A
        if isempty(MWDATA{Mident,1}.AnchorViaA{1,1}) == 0
            MWDATA{Mident,1}.AnchorViaA{1,i} =...
                Rotate_Point_Into_Matlab_Frame(MWDATA{Mident,1}.AnchorViaA{1,i}, BLDATA, MWDATA{Mident,1}.MSCInfo.ViaARef);
        else
        end
        
        % If they exist, rotate the via points B
        if isempty(MWDATA{Mident,1}.AnchorViaB{1,1}) == 0
            MWDATA{Mident,1}.AnchorViaB{1,i} =...
                Rotate_Point_Into_Matlab_Frame(MWDATA{Mident,1}.AnchorViaB{1,i}, BLDATA, MWDATA{Mident,1}.MSCInfo.ViaBRef);
        else
        end
    end
    
    % The strucutre initially uses a single segment. There is   
    % predefined space for 20 segments
    MWDATA{Mident,1}.Insertion{1,1} = MWDATA{Mident,1}.AnchorInsertion{1,2};
    MWDATA{Mident,1}.ViaA{1,1}      = MWDATA{Mident,1}.AnchorViaA{1,2};
    MWDATA{Mident,1}.ViaB{1,1}      = MWDATA{Mident,1}.AnchorViaB{1,2};
    MWDATA{Mident,1}.Origin{1,1}    = MWDATA{Mident,1}.AnchorOrigin{1,2};
        
%--------------------------------------------------------------------------
% ROTATE THE Z-AXIS
%--------------------------------------------------------------------------
    % The Z-axis is defined in the ISB referece system. It must be 
    % transformed. The transformation ISB to MATLAB Rotation Matrix is
    Rmi = [0, 0, 1;
           1, 0, 0;
           0, 1, 0];
    
    % If there is an object, the object Axis musct be converted
    if isempty(MWDATA{Mident,1}.MSCInfo.ObjectCentre) == 0
        
        for idx = 1:size(MWDATA{Mident,1}.MSCInfo.ObjectRef,2)
            %--------------------------------------------------------------
            if MWDATA{Mident,1}.MSCInfo.ObjectRef(1,idx) == 0      % Thorax Frame
                MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,idx) =...
                    Rmi*MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,idx);
            %--------------------------------------------------------------    
            elseif MWDATA{Mident,1}.MSCInfo.ObjectRef(1,idx) == 1  % Clavicula Frame
                MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,idx) =...
                    BLDATA.Original_Matrices_L2A.Rc'*Rmi*MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,idx);
            %--------------------------------------------------------------    
            elseif MWDATA{Mident,1}.MSCInfo.ObjectRef(1,idx) == 2  % Scapula Frame
                MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,idx) =...
                    BLDATA.Original_Matrices_L2A.Rs'*Rmi*MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,idx);
            %--------------------------------------------------------------    
            elseif MWDATA{Mident,1}.MSCInfo.ObjectRef(1,idx) == 3  % Humerus Frame
                MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,idx) =...
                    BLDATA.Original_Matrices_L2A.Rh'*Rmi*MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,idx);
            end
        end
    else
        % There is no object
    end
    
%--------------------------------------------------------------------------
% ROTATE THE OBJECT CENTRE
%--------------------------------------------------------------------------
    % The muscle has wrapping and the object centre must be rotated into
    % the correct local bone frame.
    if isempty(MWDATA{Mident,1}.MSCInfo.ObjectCentre) == 0
        for idx = 1:size(MWDATA{Mident,1}.MSCInfo.ObjectRef,2)
             MWDATA{Mident,1}.MSCInfo.ObjectCentre(:,idx) =...
                Rotate_Point_Into_Matlab_Frame(MWDATA{Mident,1}.MSCInfo.ObjectCentre(:,idx), BLDATA, MWDATA{Mident,1}.MSCInfo.ObjectRef(1,idx));
        end
    % The muscle has no wrapping
    else
    end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% END OF PRIMARY SCRIPT
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
return;

% All the points are given in the AMIRA frame. All points must be converted
% to the MATLAB reference frame in the intial configuration.
function P = Rotate_Point_Into_Matlab_Frame(Q, BLDATA, frameId)
    
% Initialise the output
P = [];

% Transform points. The original data is used because once the location in
% the local frame is defined, it remains independently of the current
% configuration. (Rigid Body Hypothesis)
if frameId == 0
    P = BLDATA.Amira_to_MATLAB.Rt*(Q - BLDATA.Amira_to_MATLAB.IJ);
elseif frameId == 1
     P = BLDATA.Original_Matrices_L2A.Rc'*(BLDATA.Amira_to_MATLAB.Rt*(Q - BLDATA.Amira_to_MATLAB.IJ) - BLDATA.Original_Points.SC);
elseif frameId == 2
     P = BLDATA.Original_Matrices_L2A.Rs'*(BLDATA.Amira_to_MATLAB.Rt*(Q - BLDATA.Amira_to_MATLAB.IJ) - BLDATA.Original_Points.AA);
elseif frameId == 3
     P = BLDATA.Original_Matrices_L2A.Rh'*(BLDATA.Amira_to_MATLAB.Rt*(Q - BLDATA.Amira_to_MATLAB.IJ) - BLDATA.Original_Points.GH);
else
    % The wrong frame was provided
end
return;
