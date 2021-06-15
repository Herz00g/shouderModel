function [] = MAIN_TOOL_save_visualisation(Handle, ToolId)
% Function for saving the visualisations to an EPS file.
%--------------------------------------------------------------------------
% Syntax :
% [] = MAIN_TOOL_save_visualisation(Handle, ToolId)
%--------------------------------------------------------------------------
%
%
% Function Description :
% This function saves the current visualisations of any of the tools. The
% inputs are the current visualisation figure handle and the identification 
% number of the tool calling the function. 
%
% List of Visualisation Identification Numbers :
%           Main Tool Id :                  1
%           Initial Configuration Tool Id : 2
%           Muscle Tool Id :                3
%           Joint Sinus Cone Tool Id :      4
%           Ribcage Ellipsoid Tool Id :     5
%           Kinematics Tool Id :            6
%           Motion Check Id :               7
%           Moment Arm Check Id :           8
%           Muslce Force Id :               9
%--------------------------------------------------------------------------

% List of file names depening on the tool which is calling the function
List_Of_File_Names = {...
    'Model_Visualisation',...
    'Intial_Configuration_Visualisation',...
    'Muscle_Visualisation',...
    'Joint_Sinus_Cone_Visualisation',...
    'Ellipsoid_Visualisation',...
    'Kinematics_Visualisation',...
    'Motion_Check',...
    'Moment_Arms',...
    'Muscle_Forces'};

% Inputdlg Options
options.Resize = 'on';
options.WindowStyle ='normal';
options.Interpreter ='tex';

% Create the User Input Dialog Box
User_Answer = inputdlg(...
    {'Enter File Name:','Enter Resolution (150dpi is default):'},...
    'Save Visualisation',...
    1,...
    {List_Of_File_Names{1,ToolId},'150'},...
    options);

% Construct the Path where the file will be stored
Current_Folder = pwd;
PrintPath = [];

caxes = get(Handle, 'currentaxes');
axis off;
% Differentiat UNIX and NON-UNIX
if isunix       % SYSTEM IS UNIX SYSTEM (MAC OS X INCLUDED)
    PrintPath = [Current_Folder, '/Visualisation_Prints/', User_Answer{1,1}];
else            % SYSTEM IS NOT UNIX (PC)
    PrintPath = [Current_Folder, '\Visualisation_Prints\', User_Answer{1,1}];
end

% Save the visualisation
print(Handle,...
    PrintPath,...               % File Name
    '-depsc2',...               % Save as Level 2 Color EPS (Vector Graphics)
    '-noui',...                 % The User Controls should not be printed
    '-opengl',...              % Use the opengl graphics engine         
    ['-r', User_Answer{2,1}]);  % Resolution                                    
return;