function MWDATA = SUBJECT_TOOL_build_data_muscle_wrapping(BLDATA,MWDATAin,DYDATA)
% Function to initialise the muscle wrapping data set
%--------------------------------------------------------------------------
% Syntax :
% MWDATA = MAIN_INITIALISATION_build_data_muscle_wrapping(BLDATA)
%--------------------------------------------------------------------------
%{
File Description:

This file builds the muscle data structure (MWDATA) for all the muscles.
MWDATA consists of the below data for each muscle. Here we have 42 muscles.
    
    origin, insertion, and two types of viapoints (A and B) for each muscle
    Three different points for each of these 4 points are considered.
    It's based on the splines idea for the muscle centroid line.
    The data are assigned using two different
    functions developed in the end of this script. They are named GetPoints 
    and GetWrap which both read the data already saved in a file named
    AnatomicLandmarks.dat.
    ---> MWDATA{Mident,1}.AnchorOrigin    = cell(1,3);
    ---> MWDATA{Mident,1}.AnchorViaA      = cell(1,3);
    ---> MWDATA{Mident,1}.AnchorViaB      = cell(1,3);
    ---> MWDATA{Mident,1}.AnchorInsertion = cell(1,3);

    NOTE all the above information are in AMIRA reference frame. They are
    transformed to MATLAB and more specifically to their associated
    refrence frames in matlab, using two functions named
    Rotate_Axis_Into_Matlab_Frame and Rotate_Point_Into_Matlab_Fram.
    These two are defined in the end of the current script. 

    by default, one segment is considered for all the 42 muscles which I
    guess is large enough. This is set by giving the middle point (1,2) of the
    above four data to the below, let's say, actual origin, insertion, and
    via points data. Once the number of segments are changed by the user
    then these actuals are not anymore the middle points saved in the
    Anchors and instead they are defined using the spilne. The spline method can
    be also set and is saved in MWDATA (below in this script).
    ---> MWDATA{Mident,1}.Origin    = cell(1,20);
    ---> MWDATA{Mident,1}.ViaA      = cell(1,20);
    ---> MWDATA{Mident,1}.ViaB      = cell(1,20);
    ---> MWDATA{Mident,1}.Insertion = cell(1,20);

    in order to rotate the data currectly and also for later on (in force
    calculation and wrapping) we define the reference frames for all the
    information associated with the muscle and the obstacles.
    ---> MWDATA{Mident,1}.MSCInfo.OriginRef = [];
    ---> MWDATA{Mident,1}.MSCInfo.ViaARef = [];
    ---> MWDATA{Mident,1}.MSCInfo.ViaBRef = [];
    ---> MWDATA{Mident,1}.MSCInfo.InsertionRef = [];
    ---> MWDATA{Mident,1}.MSCInfo.ObjectCentre = [];
    ---> MWDATA{Mident,1}.MSCInfo.ObjectRef = [];
    
    the obstacle is also defined here for each muscle among the available
    shapes stated in the Obstacle Set Method of Garner (sphere, single,
    double, stub). The obstacle axis (z) is also in AMIRA in terms of the
    axis-angle rotation vector.
    ---> MWDATA{Mident,1}.MSCInfo.ObjectRadii = [];
    ---> MWDATA{Mident,1}.MSCInfo.ObjectType = [];
    ---> MWDATA{Mident,1}.MSCInfo.ObjectZaxis = [];
%}
%--------------------------------------------------------------------------

% Initialise the output
MWDATA = MWDATAin;

% % List of Physical Cross-Sectional Areas (page 197-198 of Garner's thesis)
% PCSA0 = 1.e-4*[...
%         4.36;             % Subclavius
%         8.12;             % Serratus Anterior Upper
%         4;                % Serratus Anterior Middle 
%         8.41;             % Serratus Anterior Lower
%         6.24;             % Trapezius C1 - C6   
%         3.61;             % Trapezius C7 
%         3.45;             % Trapezius T1
%         12.4;             % Trapezius T2 - T7
%         3.78;             % Levator Scapulae
%         6.71;             % Rhomboid Minor
%         4.14;             % Rhomboid Major T1 - T2
%         2.48;             % Rhomboid Major T3 - T4
%         4.87;             % Pectoralis Minor
%         10.38;            % Pectoralis Major Clavicular 
%         14.68;            % Pectoralis Major Sternal 
%         11.14;            % Pectoralis Major Ribs
%         5.26;             % Latisimuss Dorsi Thoracic 
%         5.26;             % Latisimuss Dorsi Lumbar 
%         3.8;              % Latisimuss Dorsi Iliac
%         8.41;             % Deltoid Clavicular 
%         56.38;            % Deltoid Acromial
%         17.19;            % Deltoid Scapular
%         20.84;            % Supraspinatus
%         33.32;            % Infraspinatus
%         35.69;            % Subscapularis
%         6.77;             % Teres Minor
%         15.69;            % Teres Major
%         4.55;             % Coracobrachialis 
%         19.07;            % Triceps Brachii Long...RECENTLY ADDED
%         18.78;            % Triceps Brachii Medial
%         38.45;            % Triceps Brachii Lateral
%         13.99;            % Biceps Brachii Short
%         11.91;            % Biceps Brachii Long
%         25.88;            % Brachialis
%         3.08;             % Brachioradialis
%         5.65;             % Supinator
%         17.96;            % Pronator Teres
%         11.16;            % Flexor Carpi Radialis
%         16.99;            % Flexor Carpi Ulnaris
%         8.13;             % Extensor Carpi Radialis Long
%         16.76;            % Extensor Carpi Radialis Brevis
%         8.04];            % Extensor Carpi Ulnaris
%         
% % Maximum force values
% Fmax0 = [...
%         144.02;           % Subclavius
%         268.05;           % Serratus Anterior Upper
%         132.12;           % Serratus Anterior Middle
%         277.51;           % Serratus Anterior Lower
%         205.95;           % Trapezius C1 - C6 
%         119.25;           % Trapezius C7 
%         114.01;           % Trapezius T1 
%         409.23;           % Trapezius T2 - T7
%         124.78;           % Levator Scapulae
%         221.51;           % Rhomboid Minor
%         136.48;           % Rhomboid Major T1 - T2
%         81.93;            % Rhomboid Major T3 - T4
%         160.55;           % Pectoralis Minor
%         342.46;           % Pectoralis Major Clavicular
%         484.35;           % Pectoralis Major Sternal
%         367.78;           % Pectoralis Major Ribs
%         173.43;           % Latisimuss Dorsi Thoracic 
%         173.88;           % Latisimuss Dorsi Lumbar
%         125.52;           % Latisimuss Dorsi Iliac
%         277.48;           % Deltoid Clavicular 
%         1860.52;          % Deltoid Acromial 
%         567.15;           % Deltoid Scapular
%         687.84;           % Supraspinatus
%         1099.61;          % Infraspinatus
%         1177.93;          % Subscapularis
%         223.35;           % Teres Minor
%         514.51;           % Teres Major
%         150.05;           % Coracobrachialis
%         629.21;           % Triceps Brachii Long...RECENTLY ADDED
%         619.67;           % Triceps Brachii Medial
%         1268.87;          % Triceps Brachii Lateral
%         461.76;           % Biceps Brachii Short
%         392.91;           % Biceps Brachii Long
%         853.90;           % Brachialis
%         101.58;           % Brachioradialis
%         186.38;           % Supinator
%         592.80;           % Pronator Teres
%         368.41;           % Flexor Carpi Radialis
%         560.70;           % Flexor Carpi Ulnaris
%         268.42;           % Extensor Carpi Radialis Long
%         553.21;           % Extensor Carpi Radialis Brevis
%         265.27];          % Extensor Carpi Ulnaris    

% Run through all the Muscles
for Mident = 1:42
    
%     MWDATA{Mident,1}.Name                   = {};
%     MWDATA{Mident,1}.AnchorOrigin    = cell(1,3);
%     MWDATA{Mident,1}.AnchorViaA      = cell(1,3);
%     MWDATA{Mident,1}.AnchorViaB      = cell(1,3);
%     MWDATA{Mident,1}.AnchorInsertion = cell(1,3);
%     MWDATA{Mident,1}.Origin    = cell(1,20);
%     MWDATA{Mident,1}.ViaA      = cell(1,20);
%     MWDATA{Mident,1}.ViaB      = cell(1,20);
%     MWDATA{Mident,1}.Insertion = cell(1,20);
%     MWDATA{Mident,1}.MSCInfo.OriginRef = [];
%     MWDATA{Mident,1}.MSCInfo.ViaARef = [];
%     MWDATA{Mident,1}.MSCInfo.ViaBRef = [];
%     MWDATA{Mident,1}.MSCInfo.InsertionRef = [];
%     MWDATA{Mident,1}.MSCInfo.ObjectCentre = [];
%     MWDATA{Mident,1}.MSCInfo.ObjectType = [];
%     MWDATA{Mident,1}.MSCInfo.ObjectZaxis = [];
%     MWDATA{Mident,1}.MSCInfo.ObjectRef = [];
%     MWDATA{Mident,1}.MSCInfo.ObjectRadii = [];
%     
%     % This data is initially common to all
%     MWDATA{Mident,1}.MSCInfo.Visualise = 'off';
%     MWDATA{Mident,1}.MSCInfo.ObjectVisualise = 'off';
%     MWDATA{Mident,1}.MSCInfo.InterpType = '3rd Order';
%     MWDATA{Mident,1}.MSCInfo.NbSegments = 1;
%     
%     % The radii
%     MWDATA{Mident,1}.MSCInfo.ObjectRadiiscale = 1;
%     
%     % There are 12 points on the wrapping surface
%     MWDATA{Mident,1}.MSCInfo.NbPlotPoints = 12;
%     
%     % This parameter is incase the muscle' object radiius requires
%     % modification. This factor is only used in the visualisation of the
%     % muscle's object.
%     MWDATA{Mident,1}.MSCInfo.ObjectRadiicorrection = 1;
%     
%     % This will be defined once the muscle model is completely defined
%     %MWDATA{Mident,1}.OptimalFiberLength = zeros(1,20);[]
%     
    %----------------------------------------------------------------------
    % SUBCLAVIUS
    %----------------------------------------------------------------------
    if Mident == 1
        
        % name
        MWDATA{Mident,1}.Name = {'Subclavius'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Subclavius',3,DYDATA);

        % Via Points B Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Subclavius',3,DYDATA);

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 1;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0; 0; DYDATA.Height_Scaling_Factor(3, 3)];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % SERRATUS ANTERIOR SUPERIOR PART
    %----------------------------------------------------------------------
    elseif Mident == 2
        
        % name
        MWDATA{Mident,1}.Name = {'Serratus Anterior Superior'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_SerratusAnter_Sup',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_SerratusAnter_Sup',3,DYDATA);

        % This part of the data structure contains the muscle wrapping
        % information.        
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_SerratusAnterior_Sup','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single'; % single cylinder
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        
        %GetWrap('Wrap_SerratusAnterior_Sup','axis')
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = GetWrap('Wrap_SerratusAnterior_Sup','axis',DYDATA);
        
        MWDATA{Mident,1}.MSCInfo.ObjectRadii  = GetWrap('Wrap_SerratusAnterior_Sup','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % SERRATUS ANTERIOR MIDDLE PART
    %----------------------------------------------------------------------
    elseif Mident == 3
        
        % name
        MWDATA{Mident,1}.Name = {'Serratus Anterior Middle'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_SerratusAnter_Mid',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_SerratusAnter_Mid',3,DYDATA);

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_SerratusAnterior_Mid','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = GetWrap('Wrap_SerratusAnterior_Mid','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_SerratusAnterior_Mid','radius',DYDATA);                  
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % SERRATUS ANTERIOR INFERIOR PART
    %----------------------------------------------------------------------
    elseif Mident == 4
        
        % name
        MWDATA{Mident,1}.Name = {'Serratus Anterior Inferior'};
        
        % Origin Anchor Points for the Segment Interpolations
         MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_SerratusAnter_Inf',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_SerratusAnter_Inf',3,DYDATA);

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_SerratusAnterior_Inf','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = GetWrap('Wrap_SerratusAnterior_Inf','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_SerratusAnterior_Inf','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % TRAPEZIUS C1 - C6
    %----------------------------------------------------------------------
    elseif Mident == 5
        
        % name
        MWDATA{Mident,1}.Name = {'Trapezius C1'};
        
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Trapezius1_desc',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Trapezius1_desc',3,DYDATA);

        MWDATA{Mident,1}.AnchorInsertion{1,1} = MWDATA{Mident,1}.AnchorInsertion{1,1} + [0; -7*DYDATA.Height_Scaling_Factor(3, 3); 0];%right away modification on the insertion points (all the three)
        MWDATA{Mident,1}.AnchorInsertion{1,2} = MWDATA{Mident,1}.AnchorInsertion{1,2} + [0; -7*DYDATA.Height_Scaling_Factor(3, 3); 0];
        MWDATA{Mident,1}.AnchorInsertion{1,3} = MWDATA{Mident,1}.AnchorInsertion{1,3} + [0; -7*DYDATA.Height_Scaling_Factor(3, 3); 0];
        
        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 1;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Trapezius1','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = GetWrap('Wrap_Trapezius1','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Trapezius1','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
%         MWDATA{Mident,1}.MSCInfo.InsertionRef    = 1;
%         MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [GetWrap('Wrap_Trapezius1','center'),GetWrap('Wrap_Trapezius11','center')];
%         MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
%         MWDATA{Mident,1}.MSCInfo.ObjectRef       = [0, 1];
%         MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [GetWrap('Wrap_Trapezius1','axis'), GetWrap('Wrap_Trapezius11','axis')];
%         MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [GetWrap('Wrap_Trapezius1','radius'), -GetWrap('Wrap_Trapezius11','radius')];
%         MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
%         MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
        %MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,1) = MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,1) + [0; 0; 1.5];
        %MWDATA{Mident,1}.MSCInfo.ObjectZaxis(3,1) = -MWDATA{Mident,1}.MSCInfo.ObjectZaxis(3,1);
        %MWDATA{Mident,1}.MSCInfo.ObjectCentre(:,1) = MWDATA{Mident,1}.MSCInfo.ObjectCentre(:,1)+[30; 0; 0];
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % TRAPEZIUS C7
    %----------------------------------------------------------------------
    elseif Mident == 6
        
        % name
        MWDATA{Mident,1}.Name = {'Trapezius C7'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Trapezius2_trans1',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Trapezius2_trans1',3,DYDATA);

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Trapezius2','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_Trapezius2','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Trapezius2','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % TRAPEZIUS T1
    %----------------------------------------------------------------------
    elseif Mident == 7
        
        % name
        MWDATA{Mident,1}.Name = {'Trapezius T1'};
        
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Trapezius3_trans2',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Trapezius3_trans2',3,DYDATA);

        % This part of the data structure contains the muscle wrapping
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Trapezius3','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_Trapezius3','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Trapezius3','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
              
    %----------------------------------------------------------------------
    % TRAPEZIUS T2 - T7
    %----------------------------------------------------------------------
    elseif Mident == 8
        
        % name
        MWDATA{Mident,1}.Name = {'Trapezius T2 - T7'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Trapezius4_ascen',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Trapezius4_ascen',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Trapezius4','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_Trapezius4','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Trapezius4','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);

    %----------------------------------------------------------------------
    % LEVATOR SCAPULAE
    %----------------------------------------------------------------------
    elseif Mident == 9
        
        % name
        MWDATA{Mident,1}.Name = {'Levator Scapulae'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_LevatorScapula',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_LevatorScapula',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = [0; 0; DYDATA.Height_Scaling_Factor(3, 3)];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef          = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef          = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);

    %----------------------------------------------------------------------
    % RHOMBOID MINOR
    %----------------------------------------------------------------------
    elseif Mident == 10
        
        % name
        MWDATA{Mident,1}.Name = {'Rhomboid Minor'};
        
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_RhomboidMinor',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_RhomboidMinor',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = [0; 0; DYDATA.Height_Scaling_Factor(3, 3)];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef          = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef          = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
       
    %----------------------------------------------------------------------
    % RHOMBOID MAJOR T1 - T2
    %----------------------------------------------------------------------
    elseif Mident == 11
        
        % name
        MWDATA{Mident,1}.Name = {'Rhomboid Major T1 - T2'};
        
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_RhomboidMajor1',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations 
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_RhomboidMajor1',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_RhomboidMajor1','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_RhomboidMajor1','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_RhomboidMajor1','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % RHOMBOID MAJOR T3 - T4
    %----------------------------------------------------------------------
    elseif Mident == 12
        
        % name
        MWDATA{Mident,1}.Name = {'Rhomboid Major T3 - T4'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_RhomboidMajor2',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_RhomboidMajor2',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_RhomboidMajor2','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_RhomboidMajor2','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_RhomboidMajor2','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % PECTORALIS MINOR
    %----------------------------------------------------------------------
    elseif Mident == 13
        
        % name
        MWDATA{Mident,1}.Name = {'Pectoralis Minor'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_PectoralisMinor',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_PectoralisMinor',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = [0; 0; DYDATA.Height_Scaling_Factor(3, 3)];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % PECTORALIS MAJOR CLAVICULAR
    %----------------------------------------------------------------------
    elseif Mident == 14
        
        % name
        MWDATA{Mident,1}.Name = {'Pectoralis Major Clavicular'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_PectoralisMajorC',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_PectoralisMajorC',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 1;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_PectoralisMajorC','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = GetWrap('Wrap_PectoralisMajorC','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_PectoralisMajorC','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % PECTORALIS MAJOR STERNAL
    %----------------------------------------------------------------------
    elseif Mident == 15
        
        % name
        MWDATA{Mident,1}.Name = {'Pectoralis Major Sternal'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_PectoralisMajorT1',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_PectoralisMajorT1',3,DYDATA);    

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_PectoralisMajorT1','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_PectoralisMajorT1','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_PectoralisMajorT1','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);

    %----------------------------------------------------------------------
    % PECTORALIS MAJOR RIBS
    %----------------------------------------------------------------------
    elseif Mident == 16
        
        % name
        MWDATA{Mident,1}.Name = {'Pectoralis Major Ribs'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_PectoralisMajorT2',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_PectoralisMajorT2',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_PectoralisMajorT2','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 0;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_PectoralisMajorT2','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_PectoralisMajorT2','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % LATISSIMUS DORSI THORACIC
    %----------------------------------------------------------------------
    elseif Mident == 17
        
        % name
        MWDATA{Mident,1}.Name = {'Latissimus Dorsi Thoracic'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_LatissimusDorsiT',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_LatissimusDorsiT',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [GetWrap('Wrap_LatissimusDorsiT1','center',DYDATA),GetWrap('Wrap_LatissimusDorsiT2','center',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [0 , 3];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [GetWrap('Wrap_LatissimusDorsiT1','axis',DYDATA),GetWrap('Wrap_LatissimusDorsiT2','axis',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [GetWrap('Wrap_LatissimusDorsiT1','radius',DYDATA),GetWrap('Wrap_LatissimusDorsiT2','radius',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % LATISSIMUS DORSI LUMBAR
    %----------------------------------------------------------------------
    elseif Mident == 18
        
        % name
        MWDATA{Mident,1}.Name = {'Latissimus Dorsi Lumbar'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_LatissimusDorsiL',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_LatissimusDorsiL',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [GetWrap('Wrap_LatissimusDorsiL1','center',DYDATA),GetWrap('Wrap_LatissimusDorsiL2','center',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [0 , 3];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [-GetWrap('Wrap_LatissimusDorsiL1','axis',DYDATA),GetWrap('Wrap_LatissimusDorsiL2','axis',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [GetWrap('Wrap_LatissimusDorsiL1','radius',DYDATA),GetWrap('Wrap_LatissimusDorsiL2','radius',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % LATISSIMUS DORSI ILLIAC
    %----------------------------------------------------------------------
    elseif Mident == 19
        
        % name
        MWDATA{Mident,1}.Name = {'Latissimus Dorsi Iliac'};
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_LatissimusDorsiI',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];

        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_LatissimusDorsiI',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 0;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [GetWrap('Wrap_LatissimusDorsiI1','center',DYDATA),GetWrap('Wrap_LatissimusDorsiI2','center',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [0 , 3];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [-GetWrap('Wrap_LatissimusDorsiI1','axis',DYDATA),GetWrap('Wrap_LatissimusDorsiI2','axis',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [GetWrap('Wrap_LatissimusDorsiI1','radius',DYDATA),GetWrap('Wrap_LatissimusDorsiI2','radius',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % DELTOID CLAVICULAR (FRONTAL)
    %----------------------------------------------------------------------
    elseif Mident == 20
        
        % name
        MWDATA{Mident,1}.Name = {'Deltoid Clavicular (Ant)'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Deltoid_Ant',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_Deltoid_Ant',3,DYDATA);        
                
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Deltoid_Ant',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 1;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Deltoid_Ant','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = GetWrap('Wrap_Deltoid_Ant','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Deltoid_Ant','radius',DYDATA);

        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % DELTOID ACROMIAL (MIDDLE)
    %----------------------------------------------------------------------
    elseif Mident == 21
        
        % name
        MWDATA{Mident,1}.Name = {'Deltoid Acromial (Mid)'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Deltoid_Mid',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Deltoid_Mid',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_Deltoid_Mid',3,DYDATA);

        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Deltoid_Mid',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Deltoid_Mid','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = GetWrap('Wrap_Deltoid_Mid','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Deltoid_Mid','radius',DYDATA);

        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % DELTOID SCAPULAR (POSTERIOR)
    %----------------------------------------------------------------------
    elseif Mident == 22
        
        % name
        MWDATA{Mident,1}.Name = {'Deltoid Scapular (Post)'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Deltoid_Post',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Deltoid_Post',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_Deltoid_Post',3,DYDATA);
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Deltoid_Post',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Deltoid_Post','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = GetWrap('Wrap_Deltoid_Post','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Deltoid_Post','radius',DYDATA);

        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % SUPRASPINATUS
    %----------------------------------------------------------------------
    elseif Mident == 23
        
        % name
        MWDATA{Mident,1}.Name = {'Supraspinatus'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Supraspinatus',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Supraspinatus',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        %MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_Supraspinatus',3);
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Supraspinatus',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = []; %it was initially 3
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Supraspinatus','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     =  -GetWrap('Wrap_Supraspinatus','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Supraspinatus','radius',DYDATA);
        
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % INFRASPINATUS
    %----------------------------------------------------------------------
    elseif Mident == 24
        
        % name
        MWDATA{Mident,1}.Name = {'Infraspinatus'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Infraspinatus',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Infraspinatus',3,DYDATA);
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];        
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Infraspinatus',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Infraspinatus','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = GetWrap('Wrap_Infraspinatus','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Infraspinatus','radius',DYDATA);        
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % SUBSCAPULARIS
    %----------------------------------------------------------------------
    elseif Mident == 25
        
        % name
        MWDATA{Mident,1}.Name = {'Subscapularis'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Subscapularis',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Subscapularis',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Subscapularis',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Subscapularis','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_Subscapularis','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Subscapularis','radius',DYDATA);

        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % TERES MINOR
    %----------------------------------------------------------------------
    elseif Mident == 26
        
        % name
        MWDATA{Mident,1}.Name = {'Teres Minor'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_TeresMinor',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_TeresMinor',3,DYDATA);
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_TeresMinor',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef          = 2;
        MWDATA{Mident,1}.MSCInfo.ViaBRef          = [];
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = GetWrap('Wrap_TeresMinor','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'stub';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = GetWrap('Wrap_TeresMinor','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = GetWrap('Wrap_TeresMinor','radius',DYDATA);

        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % TERES MAJOR
    %----------------------------------------------------------------------
    elseif Mident == 27
        
        % name
        MWDATA{Mident,1}.Name = {'Teres Major'};
        
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_TeresMajor',3,DYDATA);
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_TeresMajor',3,DYDATA);

        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef        = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef     = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre     = GetWrap('Wrap_TeresMajor','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType       = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef        = 2;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis      = GetWrap('Wrap_TeresMajor','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii      = GetWrap('Wrap_TeresMajor','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaBRef          = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef          = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
    %----------------------------------------------------------------------
    % CORACOBRACHIALIS
    %----------------------------------------------------------------------
    elseif Mident == 28
        
        % name
        MWDATA{Mident,1}.Name = {'Coracobrachialis'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Coracobrachialis',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_Coracobrachialis',3,DYDATA);
                
        % Insertion Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Coracobrachialis',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'none';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [0;0;1];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [];

        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
                   
    %----------------------------------------------------------------------
    % TRICEPS BRACHII LONG
    %----------------------------------------------------------------------
    elseif Mident == 29
        
        % name
        MWDATA{Mident,1}.Name = {'Triceps Brachii Long'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_TricepsBrachiiLong',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_TricepsBrachiiLong',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 4;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [GetWrap('Wrap_TricepsBrachiiLong1','center',DYDATA),GetWrap('Wrap_TricepsBrachiiLong2','center',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [3 , 3];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [-GetWrap('Wrap_TricepsBrachiiLong1','axis',DYDATA),GetWrap('Wrap_TricepsBrachiiLong2','axis',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [GetWrap('Wrap_TricepsBrachiiLong1','radius',DYDATA),GetWrap('Wrap_TricepsBrachiiLong2','radius',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];

        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;
    %----------------------------------------------------------------------
    % TRICEPS BRACHII MEDIAL
    %----------------------------------------------------------------------
    elseif Mident == 30
                
        % name
        MWDATA{Mident,1}.Name = {'Triceps Brachii Medial'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_TricepsBrachiiMedial',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_TricepsBrachiiMedial',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 4;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_TricepsBrachiiMedial','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_TricepsBrachiiMedial','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_TricepsBrachiiMedial','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];

        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
                
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;
    %----------------------------------------------------------------------
    % TRICEPS BRACHII LATERAL
    %----------------------------------------------------------------------
    elseif Mident == 31
        
        % name
        MWDATA{Mident,1}.Name = {'Triceps Brachii Lateral'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_TricepsBrachiiLateral',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_TricepsBrachiiLateral',3,DYDATA);
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_TricepsBrachiiLateral',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 4;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_TricepsBrachiiLateral','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_TricepsBrachiiLateral','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_TricepsBrachiiLateral','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 3;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;
    %----------------------------------------------------------------------
    % BICEPS SHORT
    %----------------------------------------------------------------------
    elseif Mident == 32
        
        % name
        MWDATA{Mident,1}.Name = {'Biceps Short'};
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_BicepsShort',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
                        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_BicepsShort',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [GetWrap('Wrap_BicepsShort1','center',DYDATA),GetWrap('Wrap_BicepsShort2','center',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [3,3];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [-GetWrap('Wrap_BicepsShort1','axis',DYDATA),-GetWrap('Wrap_BicepsShort2','axis',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [GetWrap('Wrap_BicepsShort1','radius',DYDATA),GetWrap('Wrap_BicepsShort2','radius',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
                
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;    
    %----------------------------------------------------------------------
    % BICEPS LONG
    %----------------------------------------------------------------------
    elseif Mident == 33
        
        % name
        MWDATA{Mident,1}.Name = {'Biceps Long'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_BicepsLong',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_BicepsLong',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 2;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = [GetWrap('Wrap_BicepsLong1','center',DYDATA),GetWrap('Wrap_BicepsLong2','center',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'double';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = [3,3];
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = [GetWrap('Wrap_BicepsLong1','axis',DYDATA),GetWrap('Wrap_BicepsLong2','axis',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = [GetWrap('Wrap_BicepsLong1','radius',DYDATA),GetWrap('Wrap_BicepsLong2','radius',DYDATA)];
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
                
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;                     
    %----------------------------------------------------------------------
    % BRACHIALIS
    %----------------------------------------------------------------------
    elseif Mident == 34
        
        % name
        MWDATA{Mident,1}.Name = {'Brachialis'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Brachialis',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Brachialis',3,DYDATA);
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Brachialis',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 4;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Brachialis','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_Brachialis','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Brachialis','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 3;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
                 
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;                  
    %----------------------------------------------------------------------
    % BRACHIORADIALIS
    %----------------------------------------------------------------------
    elseif Mident == 35
        
        % name
        MWDATA{Mident,1}.Name = {'Brachioradialis'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Brachioradialis',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_Brachioradialis',3,DYDATA);
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Brachioradialis',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Brachioradialis','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_Brachioradialis','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Brachioradialis','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 3;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
                  
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;  
    %----------------------------------------------------------------------
    % SUPINATOR
    %----------------------------------------------------------------------
    elseif Mident == 36
        
        % name
        MWDATA{Mident,1}.Name = {'Supinator'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_Supinator',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_Supinator',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 4;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_Supinator','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_Supinator','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_Supinator','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
                
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;
    %----------------------------------------------------------------------
    % PRONATOR TERES
    %----------------------------------------------------------------------
    elseif Mident == 37
        
        % name
        MWDATA{Mident,1}.Name = {'Pronator Teres'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_PronatorTeres',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_PronatorTeres',3,DYDATA);
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_PronatorTeres',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_PronatorTeres','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_PronatorTeres','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_PronatorTeres','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 3;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
         
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;
    %----------------------------------------------------------------------
    % FLEXOR CARPI RADIALIS
    %----------------------------------------------------------------------
    elseif Mident == 38
        
        % name
        MWDATA{Mident,1}.Name = {'Flexor Carpi Radialis'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_FlexorCarpiRadialis',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        %MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_FlexorCarpiRadialis',3,DYDATA);
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_FlexorCarpiRadialis',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_FlexorCarpiRadialis','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_FlexorCarpiRadialis','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_FlexorCarpiRadialis','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
                 
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;
    %----------------------------------------------------------------------
    % FLEXOR CARPI ULNARIS
    %----------------------------------------------------------------------
    elseif Mident == 39
        
        % name
        MWDATA{Mident,1}.Name = {'Flexor Carpi Ulnaris'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_FlexorCarpiUlnaris',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];        
                
        % Via Points B Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaB{1,1} = [];
        MWDATA{Mident,1}.AnchorViaB{1,2} = [];
        MWDATA{Mident,1}.AnchorViaB{1,3} = [];
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_FlexorCarpiUlnaris',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_FlexorCarpiUlnaris','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 3;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_FlexorCarpiUlnaris','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_FlexorCarpiUlnaris','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = [];
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
                
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;
    %----------------------------------------------------------------------
    % EXTENSOR CARPI RADIALIS LONG
    %----------------------------------------------------------------------
    elseif Mident == 40
        
        % name
        MWDATA{Mident,1}.Name = {'Extensor Carpi Radialis Long'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_ExtensorRadialisLong',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
%         MWDATA{Mident,1}.AnchorViaA{1,1} = [];
%         MWDATA{Mident,1}.AnchorViaA{1,2} = [];
%         MWDATA{Mident,1}.AnchorViaA{1,3} = [];
        MWDATA{Mident,1}.AnchorViaA = GetPoints('V_A_ExtensorRadialisLong',3,DYDATA);        
        % Via Points B Anchor Points for the Segment Interpolations
%         MWDATA{Mident,1}.AnchorViaB{1,1} = [];
%         MWDATA{Mident,1}.AnchorViaB{1,2} = [];
%         MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_ExtensorRadialisLong',3,DYDATA);        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_ExtensorRadialisLong',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_ExtensorRadialisLong','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_ExtensorRadialisLong','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_ExtensorRadialisLong','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = 4;
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 5;
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
                
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;
    %----------------------------------------------------------------------
    % EXTENSOR CARPI RADIALIS BREVIS
    %----------------------------------------------------------------------
    elseif Mident == 41
                
        % name
        MWDATA{Mident,1}.Name = {'Extensor Carpi Radialis Brevis'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_ExtensorRadialisBrevis',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
                
        % Via Points B Anchor Points for the Segment Interpolations
%         MWDATA{Mident,1}.AnchorViaB{1,1} = [];
%         MWDATA{Mident,1}.AnchorViaB{1,2} = [];
%         MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_ExtensorRadialisBrevis',3, DYDATA);
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_ExtensorRadialisBrevis',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_ExtensorRadialisBrevis','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 4;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_ExtensorRadialisBrevis','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_ExtensorRadialisBrevis','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 5;
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
           
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;
    %----------------------------------------------------------------------
    % EXTENSOR CARPI ULNARIS
    %----------------------------------------------------------------------
    elseif Mident == 42
        
        % name
        MWDATA{Mident,1}.Name = {'Extensor Carpi Ulnaris'};
        
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorOrigin = GetPoints('O_ExtensorUlnaris',3,DYDATA);
        
        % Via Points A Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorViaA{1,1} = [];
        MWDATA{Mident,1}.AnchorViaA{1,2} = [];
        MWDATA{Mident,1}.AnchorViaA{1,3} = [];
                
        % Via Points B Anchor Points for the Segment Interpolations
%         MWDATA{Mident,1}.AnchorViaB{1,1} = [];
%         MWDATA{Mident,1}.AnchorViaB{1,2} = [];
%         MWDATA{Mident,1}.AnchorViaB{1,3} = [];
        MWDATA{Mident,1}.AnchorViaB = GetPoints('V_B_ExtensorUlnaris',3, DYDATA);        
                
        % Origin Anchor Points for the Segment Interpolations
        MWDATA{Mident,1}.AnchorInsertion = GetPoints('I_ExtensorUlnaris',3,DYDATA);
        
        % This part of the data structure contains the muscle wrapping         
        % information.
        MWDATA{Mident,1}.MSCInfo.OriginRef       = 3;
        MWDATA{Mident,1}.MSCInfo.InsertionRef    = 5;
        MWDATA{Mident,1}.MSCInfo.ObjectCentre    = GetWrap('Wrap_ExtensorUlnaris','center',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectType      = 'single';
        MWDATA{Mident,1}.MSCInfo.ObjectRef       = 4;
        MWDATA{Mident,1}.MSCInfo.ObjectZaxis     = -GetWrap('Wrap_ExtensorUlnaris','axis',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ObjectRadii     = GetWrap('Wrap_ExtensorUlnaris','radius',DYDATA);
        MWDATA{Mident,1}.MSCInfo.ViaARef         = [];
        MWDATA{Mident,1}.MSCInfo.ViaBRef         = 4;
        
%         % Phyiscal Cross-Sectional Area
%         MWDATA{Mident,1}.MSCInfo.PCSA = PCSA0(Mident, 1);
%         
%         % Maximum Muscle Force
%         MWDATA{Mident,1}.MSCInfo.Fmax = Fmax0(Mident, 1);
        
        % Save original wraping object radius for sensitivity study
        MWDATA{Mident,1}.MSCInfo.ObjectRadiiOrg  = MWDATA{Mident,1}.MSCInfo.ObjectRadii;
    end
    
%--------------------------------------------------------------------------
% ROTATE ALL POINTS INTO MATLAB FRAME
%--------------------------------------------------------------------------
    % All the anchor points must be rotated into their associated frames.
    
    for i = 1:3
        % Rotate the Origin points
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
    % a predefined space for up to 20 segments.
    MWDATA{Mident,1}.Insertion{1,1} = MWDATA{Mident,1}.AnchorInsertion{1,2};
    MWDATA{Mident,1}.ViaA{1,1}      = MWDATA{Mident,1}.AnchorViaA{1,2};
    MWDATA{Mident,1}.ViaB{1,1}      = MWDATA{Mident,1}.AnchorViaB{1,2};
    MWDATA{Mident,1}.Origin{1,1}    = MWDATA{Mident,1}.AnchorOrigin{1,2};
        
%--------------------------------------------------------------------------
% ROTATE THE WRAPPING OBJECT
%--------------------------------------------------------------------------
    % The muscle has wrapping and the object must be rotated into
    % the correct local bone frame.
    if isempty(MWDATA{Mident,1}.MSCInfo.ObjectCentre) == 0
        % rotate object centre
        for idx = 1:size(MWDATA{Mident,1}.MSCInfo.ObjectRef,2)%we use the idx for the case of double cylinder when we have to objects with obviously two different centers
             MWDATA{Mident,1}.MSCInfo.ObjectCentre(:,idx) =...
                Rotate_Point_Into_Matlab_Frame(MWDATA{Mident,1}.MSCInfo.ObjectCentre(:,idx), BLDATA, MWDATA{Mident,1}.MSCInfo.ObjectRef(1,idx));
        end
        % rotate object axis
        for idx = 1:size(MWDATA{Mident,1}.MSCInfo.ObjectRef,2)
            MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,idx) =...
               Rotate_Axis_Into_Matlab_Frame(MWDATA{Mident,1}.MSCInfo.ObjectZaxis(:,idx), BLDATA, MWDATA{Mident,1}.MSCInfo.ObjectRef(1,idx));
        end
    else
        % The muscle has no wrapping
    end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% END OF PRIMARY SCRIPT
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
return;

% All the points in AnatomicLandmarks are given in the AMIRA frame.
% All points must be transformed into their associated MATLAB reference frames in the intial configuration.
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
     P = BLDATA.Original_Matrices_L2A.Rh'*(BLDATA.Amira_to_MATLAB.Rt*(Q + BLDATA.offset_Amira - BLDATA.Amira_to_MATLAB.IJ) - BLDATA.Original_Points.GH);
elseif frameId == 4
     P = BLDATA.Original_Matrices_L2A.Ru'*(BLDATA.Amira_to_MATLAB.Rt*(Q + BLDATA.offset_Amira - BLDATA.Amira_to_MATLAB.IJ) - BLDATA.Original_Points.HU);
elseif frameId == 5
     P = BLDATA.Original_Matrices_L2A.Rr'*(BLDATA.Amira_to_MATLAB.Rt*(Q + BLDATA.offset_Amira - BLDATA.Amira_to_MATLAB.IJ) - BLDATA.Original_Points.CP);
else
    % The wrong frame was provided
end
return;

function P = Rotate_Axis_Into_Matlab_Frame(Q, BLDATA, frameId)
    
% Initialise the output
P = [];

% Transform points. The original data is used because once the location in
% the local frame is defined, it remains independently of the current
% configuration. (Rigid Body Hypothesis)
if frameId == 0
    P = BLDATA.Amira_to_MATLAB.Rt*Q;
elseif frameId == 1
     P = BLDATA.Original_Matrices_L2A.Rc'*(BLDATA.Amira_to_MATLAB.Rt*Q);
elseif frameId == 2
     P = BLDATA.Original_Matrices_L2A.Rs'*(BLDATA.Amira_to_MATLAB.Rt*Q);
elseif frameId == 3
     P = BLDATA.Original_Matrices_L2A.Rh'*(BLDATA.Amira_to_MATLAB.Rt*(Q));
elseif frameId == 4
     P = BLDATA.Original_Matrices_L2A.Ru'*(BLDATA.Amira_to_MATLAB.Rt*(Q));
elseif frameId == 5
     P = BLDATA.Original_Matrices_L2A.Rr'*(BLDATA.Amira_to_MATLAB.Rt*(Q));
     
else
    % The wrong frame was provided
end
return;

function points = GetPoints(setname, npoints, DYDATA)
%
% search landmark set in specified file called setname and return the first
% npoints stored linewise.
%

% scaling factor to scale the landmarks according to the body height
Height_Scaling_Factor = DYDATA.Height_Scaling_Factor;

% open file
fileID = fopen('MuscleLandmarks_Male01.dat');

if fileID==-1
    error(' !!! INITIALISATION:GetPoints:Error: Cannot open specified input file...aborting...')
end

line = fgetl(fileID);
points=cell(1,npoints);
stringfound=0;
while ischar(line)
    if strcmp(line,setname)
        stringfound=1;
        for i=npoints:-1:1 %:npoints
            line=fgetl(fileID);
            % remove white spaces
            line = line(~isspace(line));
            % split line
            line = strsplit(line,',');
            % convert to double
            line = str2double(line);
            % save point
            points{i}= Height_Scaling_Factor*line'; % scale the points
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
fclose(fileID);
return;


function info = GetWrap(setname,type, DYDATA)
%
% search wrapping information in specified file called setname and return
% center of wrapping object or axis or radius defined by type
%

% scaling factor to scale the landmarks according to the body height
Height_Scaling_Factor = DYDATA.Height_Scaling_Factor;

% open file
fileID = fopen('MuscleLandmarks_Male01.dat');

if fileID==-1
    error(' !!! INITIALISATION:GetWrap:Error: Can not open specified input file...aborting...')
end

line = fgetl(fileID);
stringfound=0;
while ischar(line)
    if strcmp(line,setname)
        stringfound=1;
        if strcmp(type,'center')
            % get first line
            line=fgetl(fileID);
            % split line
            line = strsplit(line,' ');
            % convert to double
            info = Height_Scaling_Factor*(str2double(line))'; % scale the center of the wraping obstacle
            %info = [1 0 0; 0 1 0; 0 0 Height_Scaling_Factor(3, 3)]*(str2double(line))'; % scale the center of the wraping obstacle
            %info = (str2double(line))';
        elseif strcmp(type,'axis')
            % get second line
            line=fgetl(fileID);
            line=fgetl(fileID);
            % split line
            line = strsplit(line,' ');
            % convert to double => axis given as axis-angle rotation vector for
            % unit vector in z
            line = str2double(line);
            % convert rotation angle from radians to degrees
            line(4) = line(4)*pi/180;
            % compute rotation matrix
            rotmat = vrrotvec2mat(line);
            % get cylinder axis => initial axis is y-axis
            %info = Height_Scaling_Factor*rotmat*[0;1;0]; % scale the axis
            info = rotmat*[0;1;0]; 
        elseif strcmp(type,'radius')
            % get third line
            line=fgetl(fileID);
            line=fgetl(fileID);
            line=fgetl(fileID);
            % split line
            line = strsplit(line,' ');
            % convert to double
            line = str2double(line);
            info = Height_Scaling_Factor(3,3)*line(1); % scale the radius
             
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
fclose(fileID);

return;
