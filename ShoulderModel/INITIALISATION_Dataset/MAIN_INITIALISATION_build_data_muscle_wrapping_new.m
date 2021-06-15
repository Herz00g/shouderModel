function MWDATA = MAIN_INITIALISATION_build_data_muscle_wrapping_new(BLDATA)
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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Subclavius',3);

        % Via Points B Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Subclavius',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_SerratusAnter_Sup',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_SerratusAnter_Sup',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_SerratusAnter_Mid',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_SerratusAnter_Mid',3);

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
         MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_SerratusAnter_Inf',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_SerratusAnter_Inf',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Trapezius1_desc',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Trapezius1_desc',3);

        % This part of the data structure contains the muscle wrapping
        % information.
%         MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
%         MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
%         MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ 38.3735; -15.4232; 153.044];
%         MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
%         MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
%         MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [-0.166575;  0.982514; 0.083181];
%         MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 44.1;
%         MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
%         MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Trapezius2_trans1',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Trapezius2_trans1',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Trapezius3_trans2',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Trapezius3_trans2',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Trapezius4_ascen',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Trapezius4_ascen',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_LevatorScapula',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_LevatorScapula',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_RhomboidMinor',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_RhomboidMinor',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_RhomboidMajor1',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_RhomboidMajor1',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_RhomboidMajor2',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_RhomboidMajor2',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_PectoralisMinor',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_PectoralisMinor',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_PectoralisMajorC',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_PectoralisMajorC',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_PectoralisMajorT1',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_PectoralisMajorT1',3);    

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_PectoralisMajorT2',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_PectoralisMajorT2',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_LatissimusDorsiT',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_LatissimusDorsiT',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_LatissimusDorsiL',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_LatissimusDorsiL',3);

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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_LatissimusDorsiI',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_LatissimusDorsiI',3);

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
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Deltoid_Ant',3);

        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_Deltoid_Ant',3); 

        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Deltoid_Ant',3);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 1;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -85; -30; 98];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.4;1;1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -80;

        
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
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Deltoid_Mid',3);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Deltoid_Mid',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_Deltoid_Mid',3);

        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Deltoid_Mid',3);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -91; -34; 101];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.1;1.0;0.3];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 85;

        
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
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Deltoid_Post',3);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Deltoid_Post',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_Deltoid_Post',3);
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Deltoid_Post',3);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -74; -21; 103];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [-0.2;1;0.2];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 90;

        
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
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Supraspinatus',3);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Supraspinatus',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_Supraspinatus',3);
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Supraspinatus',3);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0; 0; 1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [];
        
        
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
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Infraspinatus',3);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Infraspinatus',3);
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];        
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Infraspinatus',3);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -82.5103; -19.2801; 99.9505];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.2;1.0;0.1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = 51.06;        
        
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
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Subscapularis',3);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Subscapularis',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Subscapularis',3);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [-49.6409; -13.7723; 139.708];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0.0;1.0;-0.5];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -30.82;

        
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
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_TeresMinor',3);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_TeresMinor',3);
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_TeresMinor',3);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef          = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef          = [];
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = [ -85; -20; 110];
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = [0.2; 1.5; 0.3];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = 40;

        
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
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_TeresMajor',3);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_TeresMajor',3);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = [ -30; 15; 23.165];
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = 2;
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
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Coracobrachialis',3);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_Coracobrachialis',3);
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Coracobrachialis',3);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [ -60; -10; 80];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [1.0;1.0;0.4];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = -34.62;

        
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

function points = GetPoints(setname, npoints)
%
% search landmark set in specified file called setname and return the first
% npoints stored linewise.
%

% open file
fileID = fopen('AnatomicLandmarks.dat');

if fileID==-1
    error(' !!! INITIALISATION:GetPoints:Error: Can not open specified input file...aborting...')
end

line = fgetl(fileID);
points=cell(1,npoints);
stringfound=0;
while ischar(line)
    if strcmp(line,setname)
        stringfound=1;
        for i=1:npoints
            line=fgetl(fileID);
            % remove white spaces
            line = line(~isspace(line));
            % split line
            line = strsplit(line,',');
            % convert to double
            line = str2double(line);
            % save point
            points{i}=line';
        end
        % exit loop
        line = [];        
    else
        line = fgetl(fileID);
    end
end

if stringfound==0
    error(' !!! INITIALISATION:GetPoints:Error: Point set %s not found in input file...aborting...',setname);
end
return;
