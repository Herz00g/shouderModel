clc; clear all; close all;

load JRDATA_VHP;
JRDATA_A = JRDATA;
load JRDATA_MOD;
JRDATA_B = JRDATA;

t = linspace(0, 1, 100);
Pmat = [1, 1, 1,  1,   1;  % Final Condition
        1, 0, 0,  0,   0;  % 1st derivative initial condition
        1, 2, 3,  4,   5;  % 1st derivative final condition
        0, 2, 0,  0,   0;  % 2nd derivative initial condition
        0, 2, 6, 12,  20];
    
pcoef = Pmat\[1; 0; 0; 0; 0];

teta = 1 + (140-1)*pcoef'*[t; t.^2; t.^3; t.^4; t.^5];

figure('color', 'white');
plot(teta(1,1:end-2)', JRDATA_A(1:end-2,4), 'color', 'blue', 'linewidth', 2);
hold on;
plot(teta(1,1:end-2)', JRDATA_B(1:end-2,4), 'color', 'red', 'linewidth', 2);
xlim([1, 140]);
% set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140]);
% xlabel('Humerus Abduction Angle [DEG]');
% ylabel('GH Joint Reaction Force (%BW)');
% title('Abduction in the Scapular Plane');
xlim([1, 140]);
ylim([0, 1000]);
set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140], 'fontsize', 16, 'fontweight', 'bold', 'fontname', 'sansserif');
set(gca, 'ytick', [0, 200, 400, 600, 800, 1000]);
grid on;