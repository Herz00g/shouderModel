function WireFrameHandle = VISUALISATION_view_bone_wireframe(WFHandle, BoneId, BLDATA, varargin)
%{
Function for visualising the bone wire frames.
--------------------------------------------------------------------------
Syntax :
WireFrameHandle = VISUALISATION_view_bone_wireframe(WFHandle, BoneId, BLDATA, varargin)
--------------------------------------------------------------------------
File Description :
This function either creates a visualisation of the bones or updates an
already existing one.

WFHandle contains the handle
BoneId is the bone identification number
BLDATA bony landmark data structure
--------------------------------------------------------------------------
%}

% Initialise the output
WireFrameHandle = WFHandle;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% The input handle is empty (no mesh plot has been created)
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if isempty(WFHandle) == 1
    switch BoneId
        case 0  % THORAX
            WireFrameHandle = plot3(BLDATA.Current_WFBones.Thorax(1,:),...
                                    BLDATA.Current_WFBones.Thorax(2,:),...
                                    BLDATA.Current_WFBones.Thorax(3,:),...
                                    'color', 'black',...
                                    'linewidth', 2,...
                                    'marker', 'o',...
                                    'markerfacecolor', 'red',...
                                    'markeredgecolor', 'red');
        case 1  % CLAVICULA
            WireFrameHandle = plot3(BLDATA.Current_WFBones.Clavicula(1,:),...
                                    BLDATA.Current_WFBones.Clavicula(2,:),...
                                    BLDATA.Current_WFBones.Clavicula(3,:),...
                                    'color', 'black',...
                                    'linewidth', 2,...
                                    'marker', 'o',...
                                    'markerfacecolor', 'red',...
                                    'markeredgecolor', 'red');
        case 2  % SCAPULA
            WireFrameHandle = plot3(BLDATA.Current_WFBones.Scapula(1,:),...
                                    BLDATA.Current_WFBones.Scapula(2,:),...
                                    BLDATA.Current_WFBones.Scapula(3,:),...
                                    'color', 'black',...
                                    'linewidth', 2,...
                                    'marker', 'o',...
                                    'markerfacecolor', 'red',...
                                    'markeredgecolor', 'red');
        case 3  % HUMERUS
            WireFrameHandle = plot3(BLDATA.Current_WFBones.Humerus(1,:),...
                                    BLDATA.Current_WFBones.Humerus(2,:),...
                                    BLDATA.Current_WFBones.Humerus(3,:),...
                                    'color', 'black',...
                                    'linewidth', 2,...
                                    'marker', 'o',...
                                    'markerfacecolor', 'red',...
                                    'markeredgecolor', 'red');
        case 4  % Ulna
            WireFrameHandle = plot3(BLDATA.Current_WFBones.Ulna(1,:),...
                                    BLDATA.Current_WFBones.Ulna(2,:),...
                                    BLDATA.Current_WFBones.Ulna(3,:),...
                                    'color', 'black',...
                                    'linewidth', 2,...
                                    'marker', 'o',...
                                    'markerfacecolor', 'red',...
                                    'markeredgecolor', 'red');
        case 5  % Radius
            WireFrameHandle = plot3(BLDATA.Current_WFBones.Radius(1,:),...
                                    BLDATA.Current_WFBones.Radius(2,:),...
                                    BLDATA.Current_WFBones.Radius(3,:),...
                                    'color', 'black',...
                                    'linewidth', 2,...
                                    'marker', 'o',...
                                    'markerfacecolor', 'red',...
                                    'markeredgecolor', 'red');
                                
        otherwise
            % Do nothing
    end
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% The input handle is not empty
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
else
    switch BoneId
        case 0  % THORAX
            % Update the plot
            set(WireFrameHandle,...
                'xdata', BLDATA.Current_WFBones.Thorax(1,:),...
                'ydata', BLDATA.Current_WFBones.Thorax(2,:),...
                'zdata', BLDATA.Current_WFBones.Thorax(3,:));
        case 1  % CLAVICULA
            % Update the plot
            set(WireFrameHandle,...
                'xdata', BLDATA.Current_WFBones.Clavicula(1,:),...
                'ydata', BLDATA.Current_WFBones.Clavicula(2,:),...
                'zdata', BLDATA.Current_WFBones.Clavicula(3,:));
        case 2  % SCAPULA
            % Update the plot
            set(WireFrameHandle,...
                'xdata', BLDATA.Current_WFBones.Scapula(1,:),...
                'ydata', BLDATA.Current_WFBones.Scapula(2,:),...
                'zdata', BLDATA.Current_WFBones.Scapula(3,:));
        case 3  % HUMERUS
            % Update the plot
            set(WireFrameHandle,...
                'xdata', BLDATA.Current_WFBones.Humerus(1,:),...
                'ydata', BLDATA.Current_WFBones.Humerus(2,:),...
                'zdata', BLDATA.Current_WFBones.Humerus(3,:));
        case 4  % Ulna
            % Update the plot
            set(WireFrameHandle,...
                'xdata', BLDATA.Current_WFBones.Ulna(1,:),...
                'ydata', BLDATA.Current_WFBones.Ulna(2,:),...
                'zdata', BLDATA.Current_WFBones.Ulna(3,:));
        case 5  % Radius
            % Update the plot
            set(WireFrameHandle,...
                'xdata', BLDATA.Current_WFBones.Radius(1,:),...
                'ydata', BLDATA.Current_WFBones.Radius(2,:),...
                'zdata', BLDATA.Current_WFBones.Radius(3,:));    
        otherwise
            % Do nothing
    end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% SCRIPT ENDS HERE
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
return;