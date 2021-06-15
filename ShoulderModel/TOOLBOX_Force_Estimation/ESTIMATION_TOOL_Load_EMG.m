function SSDATA = ESTIMATION_TOOL_Load_EMG(ESGUIHandle, SSDATAin)
%{
Function to load/check EMG data.
--------------------------------------------------------------------------
Syntax :
SSDATA = ESTIMATION_TOOL_Load_EMG(ESGUIHandle)
--------------------------------------------------------------------------
File Description :
This function is the callback script to load the Masured
EMG data. It allows the user to load the EMG data files and
then it checks if the uploaded file has the required structure.
--------------------------------------------------------------------------
%}


% ------------------------------------------------------------------------
% let the user load the data
% ------------------------------------------------------------------------
% initialize the SSDATA
SSDATA = SSDATAin;

% define the initial folder (path) that the user can look for the file
currentFile = get(ESGUIHandle.EMG_data.Text, 'String');
        if (~isempty(currentFile))
            % If a file was already loaded, start in that directory
            startPath = fileparts(currentFile);
        else
            % Start in current directory
            startPath = pwd;
        end

% open the getfile window and let the user choose only amongst the *.mat
% files. In the next part we will check other requirements regarding the
% chosen file
[filename, modelPath] = uigetfile({'*.mat' 'MAT-file ';...
                                   '*.mat' 'MAT file (*.mat)'},...
                                   'Select the EMG data file',startPath);

% if the user chose a file                               
if (filename ~= 0)
     %    if exist('filename')~=0
     fullfileName = [modelPath filename];
     SSDATA = check_the_EMG_file(SSDATA, ESGUIHandle, fullfileName);
end

% display a message for the user
msgbox(['the EMG data is imported and saved in',...
      'SSDATA.EMG_data data structure'], 'Success');
  
% set the final time of the motion time span as the maximum time of the EMG
% so that the user will understand how far he/she can go for simulating the
% motion
if ~isempty(SSDATA.EMG_data)
    set(ESGUIHandle.TimeFrameEdit,'string', num2str(SSDATA.EMG_data.DANT(4,end)));
end
  
return;

% ------------------------------------------------------------------------
% check the chosen kinematics file
% ------------------------------------------------------------------------
function SSDATA = check_the_EMG_file(SSDATAin, ESGUIHandle, fullfileName)

% initialize the SSDATA
SSDATA = SSDATAin;

% use the chosen file path/name and show it in the textbox in the GUI page
set(ESGUIHandle.EMG_data.Text, 'String', fullfileName);

% specify the required data in the EMG file
% 1) list of the required muscle EMG
   
required_muscle_list = ['DANT';'DMED';'DPOS';'TDES';'TTRA';'TASE';'TERM';
                        'PECT';'BICL';'BICS';'TLOH';'TLAH';'BRAC';
                        'FLCU';'INFS'];               % here is the full list of the landmarks that indeed here 'IJ';'PX';'T8';'C7';'SC';'AC';'GH';'HU';'TS';'AI';'AA';'EL';'EM';'CP';'US';'RS'
                                                      % NOTE: if the imported list has more landmarks than what it's specified
                                                      % it's not a problem. If, once I wanted to differentiate with that to 
                                                      % force the accepting only the files with exact number and name of landmarks
                                                      % we have to first use fieldnames(filename) to have them in a cell array and
                                                      % then draw the parallel within the for loop as it is now. In otehr words,
                                                      % the eval only allows a whole to an invidual comparision not a one to one
                                                      % comparision.
                                                     
% make sure that a right file is chosen by the user
[~, filename, ext] = fileparts(fullfileName); % returns the path, file name, and file name extension for the specified "filename"

        if strcmp(ext,'.mat') % if the extension is mat then load it otherwise do nothing
            load(fullfileName);
                        
            % Check whether the chosen file contains the required fields.
            for muscle_check_id = 1:length(required_muscle_list)
                
                if ~isfield(eval(filename),required_muscle_list(muscle_check_id,:))
                    fprintf('muscle %s was not found in the loaded data. \n Please try a different EMG data file and make sure it \n has the requirements mentioned in the help menu. \n', required_muscle_list(muscle_check_id,:));
                    %disp(['Bony landmark ''' required_landmarks_list(landmarks_check_id,:) ''' was not found in the loaded data',...
                     %      '.\n Please try a different kinematic file after reading the file requirement from the help meneu']);
                return;
                end
            end
            
            SSDATA.EMG_data = eval(filename);
        end
            
       
return;




% figure;
% 
% for landmark_id = 2:length(Landmarks_Names)
%     
%     Landmarks_Coordinate = eval(['VICON.' Landmarks_Names{landmark_id} '(1000,:)']);
%     
%     hold on;
%     
%     plot3(Landmarks_Coordinate(1), Landmarks_Coordinate(2), Landmarks_Coordinate(3),...
%           'color', 'black','linewidth', 2,'marker', 'o','markerfacecolor', 'red','markeredgecolor', 'red');
%       
%       text(Landmarks_Coordinate(1), Landmarks_Coordinate(2), Landmarks_Coordinate(3),...
%            Landmarks_Names{landmark_id},'color','b','fontsize',12,'fontweight','bold','HorizontalAlignment','left')   
%           
%  
% end
%   axis square  


% %%
% % small for loop to make a desirable kinematics source file
% required_landmarks_list = ['AJ';'PX';'T8';'C7';'SC';'AC';
%                            'AA';'EL';'EM';'US';'RS'];
%                         
%  for landmarks_check_id = 1: length(required_landmarks_list)
%      
%      eval(['try1.' required_landmarks_list(landmarks_check_id,:) '=[];']);
%  end
%  save('/Users/ehsan/Desktop/try1.mat','try1');
% %save('/Users/ehsan/Desktop/try1.mat','-struct','REDATA')
% % 
% %     
