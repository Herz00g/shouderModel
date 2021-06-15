function checking_the_landmarks
IJ = [   74.1129;  -74.8060;   68.9446]; % Incisura Jugularis
PX = [   82.5171; -133.1130;  -76.9724]; % Processus Xiphoideus
T8 = [   78.9481;  -24.5985;  -40.6273]; % Vertebra T8
C7 = [   70.5729;  -35.7244;  150.7640]; % Vertebra C7
SC = [   56.6771;  -69.2782;   72.7629]; % Sternoclaviuclar joint
%SC= [   52.0511;  -79.0859;   75.0302]; % Sternoclaviuclar joint
AC = [   -82.2127; -25.2576;   148.444]; % Sternoclaviuclar joint
%AC = [  -82.1051;  -30.7575;  145.4510]; % Acromioclavicular joint
GH = [  -86.1456;  -31.7209;  107.6860]; % Glenohumeral joint
HU = [ -103.7780;  -33.3235; -205.8640]; % Humeroulnar joint= 0.5(EM+EL)
TS = [   -0.9241;   52.0670;  121.3280]; % Trigonum Spinae
AI = [   -6.7869;   50.3866;   -4.7008]; % Angulus Inferior
AA = [ -104.3290;   -1.0350;  133.7840]; % Angulus Acromialis
EL = [ -127.2850;  -54.8861; -208.4960]; % Lateral epicondyle
EM = [  -80.2709;  -11.7610; -203.2320]; % Medial epicondyle
%CP = [ -117.9780;   20.2045; -201.1550]; %Capitulum center
%CP = [-1.119019088745117e+002 2.951757049560547e+001 -2.114102478027344e+002]';
CP_r = [-1.162884872079883e+02;-50.987791082214290;-2.133781068022996e+02];
t = ((EM(1)-EL(1))*CP_r(1) + (EM(2)-EL(2))*CP_r(2) + (EM(3)-EL(3))*CP_r(3) - (EM(1)-EL(1))*EM(1) - (EM(2)-EL(2))*EM(2) - (EM(3)-EL(3))*EM(3))...
    /((EM(1)-EL(1))^2 + (EM(2)-EL(2))^2 + (EM(3)-EL(3))^2);

CP = [EM(1) - (EL(1)-EM(1))*t; EM(2) - (EL(2)-EM(2))*t; EM(3) - (EL(3)-EM(3))*t];
%US = [ -119.1449;  -32.0329; -459.3816]; %Ulna Styloid
US = [-8.111890411376953e+001 -1.277923679351807e+001 -4.723002319335938e+002]'; 

%RS = [  -80.0832;  -17.1580; -471.3330]; %Radius Styloid
RS = [-1.216534347534180e+002 -1.614651107788086e+001 -4.654623413085938e+002 ]';

Thorax      = [IJ, PX, T8, C7, IJ]; 
Clavicula   = [SC, AC];
Scapula     = [AC, AA, TS, AI, AC];
Humerus     = [GH, HU, EL, EM];
Ulna        = [CP, EM, US];
Radius      = [CP, RS];
figure
hold on
plot3(Thorax(1,:),...
      Thorax(2,:),...
      Thorax(3,:),...
      'color', 'black',...
      'linewidth', 2,...
      'marker', 'o',...
      'markerfacecolor', 'red',...
      'markeredgecolor', 'red');

plot3(Clavicula(1,:),...
      Clavicula(2,:),...
      Clavicula(3,:),...
      'color', 'black',...
      'linewidth', 2,...
      'marker', 'o',...
      'markerfacecolor', 'red',...
      'markeredgecolor', 'red');  
  
plot3(Scapula(1,:),...
      Scapula(2,:),...
      Scapula(3,:),...
      'color', 'black',...
      'linewidth', 2,...
      'marker', 'o',...
      'markerfacecolor', 'red',...
      'markeredgecolor', 'red'); 
  
  plot3(Humerus(1,:),...
      Humerus(2,:),...
      Humerus(3,:),...
      'color', 'black',...
      'linewidth', 2,...
      'marker', 'o',...
      'markerfacecolor', 'red',...
      'markeredgecolor', 'red'); 
  
  plot3(Ulna(1,:),...
      Ulna(2,:),...
      Ulna(3,:),...
      'color', 'black',...
      'linewidth', 2,...
      'marker', 'o',...
      'markerfacecolor', 'red',...
      'markeredgecolor', 'red'); 
  
  plot3(Radius(1,:),...
      Radius(2,:),...
      Radius(3,:),...
      'color', 'black',...
      'linewidth', 2,...
      'marker', 'o',...
      'markerfacecolor', 'red',...
      'markeredgecolor', 'red'); 
  
PointsCoordinate = [IJ PX T8 C7 SC AC GH HU TS...
    AI AA EL EM CP US RS];

PointsTitle = ['IJ';'PX';'T8';'C7';'SC';'AC';'GH';'HU';
               'TS';'AI';'AA';'EL';'EM';'CP';'US';'RS'];
           
           
for i = 1:size(PointsCoordinate,2)
text(PointsCoordinate(1,i),PointsCoordinate(2,i),PointsCoordinate(3,i),...
     strcat('   ',PointsTitle(i,:)),'color',...
    'b','fontsize',26,'fontweight','bold','HorizontalAlignment','left')                                
end 

return
                                