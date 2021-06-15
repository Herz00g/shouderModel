%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% MASTHEAD SCRIPT BEGINS HERE
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Creat the Masthead Figure
MASThead = figure(...
    'color', 'white',...
    'units', 'normalized',...
    'position', [0.1, 0.1, 0.4, 0.8],...
    'menubar', 'none',...
    'name', 'EPFL - LBO Upper Extremity Model (Version 1.00)');

% Create the List of Axes
MainAxis = axes('units', 'normalized', 'position', [0.3, 0.00, 0.70, 0.90]);
EPFLAxis = axes('units', 'normalized', 'position', [0.0, 0.85, 0.30, 0.11]);
%LAAxis   = axes('units', 'normalized', 'position', [0.0, 0.70, 0.30, 0.10]);
LBOAxis  = axes('units', 'normalized', 'position', [0.0, 0.80, 0.60, 0.05]);
CHUVAxis = axes('units', 'normalized', 'position', [0.0, 0.70, 0.22, 0.08]);

% List of Text To Print
TextList = {'Created By :  Ehsan Sarshari (LA/LBO- EPFL), 2014-present',...
            'David Ingram (LA - EPFL), 2009-2014',...
            'Contributions From :',...
            'Marion Rothlisberger (LBO - EPFL)',...
            'Christoph Engelhardt (LBO - EPFL)',...
            'Yasmine Boulanaache (LBO - EPFL)',...
            '',...
            'Prof. Alain Farron (CHUV)',...
            'Prof. Dominique Pioletti (LBO - EPFL)',...
            'Dr. Alexandre Terrier (LBO - EPFL)',...
            'Dr. Philippe Mullhaupt (LA - EPFL)',...
            'Illustration Zygote Body (www.zygotebody.com)'};
        
% List of Positons
PositionList = [[0.01, 0.36, 0.45, 0.03, 14];
                [0.1, 0.34, 0.4, 0.03, 14];
                [0.01, 0.31, 0.3, 0.03, 14];
                [0.1, 0.29, 0.3, 0.03, 12];
                [0.1, 0.27, 0.3, 0.03, 12];
                [0.1, 0.25, 0.3, 0.03, 12];
                [0.1, 0.23, 0.3, 0.03, 12];
                [0.1, 0.21, 0.3, 0.03, 12];
                [0.1, 0.19, 0.3, 0.03, 12];
                [0.1, 0.17, 0.3, 0.03, 12];
                [0.1, 0.15, 0.3, 0.03, 12];
                [0.54, 0.00, 0.5, 0.02, 10]];
            
% Create the text in the masthead figure
TextHandle = zeros(8,1);
for i = 1:12
    TextHandle(i,1) = uicontrol(...
    'units', 'normalized',...
    'position', PositionList(i,1:4),...
    'style', 'text',...
    'string', TextList{1,i},...
    'fontsize', PositionList(i,5),...
    'fontname', 'Arial',...
    'HorizontalAlignment','left',...
    'backgroundcolor', 'white',...
    'fontweight', 'bold');
end

% Get the Current Directoy
CurrentDirectory = pwd;

% Create the Image Storage Variables
EPFLLogo = []; LALogo = []; LBOLogo = []; MAINPic = []; CHUVLogo = [];

% The Script must work on both unix and non unix systems
if isunix
    EPFLLogo = imread([CurrentDirectory, '/LOGOS/EPFLLogo.png'], 'png');
    %LALogo   = imread([CurrentDirectory, '/LOGOS/LALogo.jpg'], 'jpg');
    LBOLogo  = imread([CurrentDirectory, '/LOGOS/LBOLogo.png'], 'png');
    MAINPic  = imread([CurrentDirectory, '/LOGOS/MAINPix.png'], 'png');
    CHUVLogo = imread([CurrentDirectory, '/LOGOS/CHUVLogo.png'], 'png');
else
    EPFLLogo = imread([CurrentDirectory, '\LOGOS\EPFLLogo.png'], 'png');
    %LALogo   = imread([CurrentDirectory, '\LOGOS\LALogo.jpg'], 'jpg');
    LBOLogo  = imread([CurrentDirectory, '\LOGOS\LBOLogo.png'], 'png');
    MAINPic  = imread([CurrentDirectory, '\LOGOS\MAINPix.png'], 'png');
    CHUVLogo = imread([CurrentDirectory, '\LOGOS\CHUVLogo.png'], 'png');
end

% Draw all the images
set(MASThead, 'CurrentAxes', MainAxis);
LogoHandle(1) = image(MAINPic); box off; axis off;
set(MASThead, 'CurrentAxes', EPFLAxis);
LogoHandle(2) = image(EPFLLogo); box off; axis off;
%set(MASThead, 'CurrentAxes', LAAxis);
%LogoHandle(3) = image(LALogo); box off; axis off;
set(MASThead, 'CurrentAxes', LBOAxis);
LogoHandle(4) = image(LBOLogo); box off; axis off;
set(MASThead, 'CurrentAxes', CHUVAxis);
LogoHandle(4) = image(CHUVLogo); box off; axis off;

