% Clean workspace
clc; clear all; close all;

load EFDATA_MOD;
EFDATAD = EFDATA;
load EFDATA_VHP;

load KEDATA_VHP;
vartheta = KEDATA.Joint_Angle_Evolution(8,1:end-2);
vartheta (1,1) = 0;

ADF = EFDATAD{22,1}.Forces(1:end-2,1)*100/277.48;
ADFA = EFDATAD{22,1}.Forces(1:end-2,2)*100/277.48;
MDF = EFDATAD{23,1}.Forces(1:end-2,1)*100/1860.52;
PDF = EFDATAD{24,1}.Forces(1:end-2,1)*100/567.15;
SUF = EFDATAD{25,1}.Forces(1:end-2,1)*100/687.84;
INF = EFDATAD{26,1}.Forces(1:end-2,1)*100/1099.61;
SBF = EFDATAD{27,1}.Forces(1:end-2,1)*100/1177.93;
TMF = EFDATAD{28,1}.Forces(1:end-2,1)*100/223.35;
TJF = EFDATAD{29,1}.Forces(1:end-2,1)*100/514.51;
CRF = EFDATAD{30,1}.Forces(1:end-2,1)*100/150.05;

ADS = EFDATA{22,1}.Forces(1:end-2,1)*100/277.48;
MDS = EFDATA{23,1}.Forces(1:end-2,1)*100/1860.52;
PDS = EFDATA{24,1}.Forces(1:end-2,1)*100/567.15;
SUS = EFDATA{25,1}.Forces(1:end-2,1)*100/687.84;
INS = EFDATA{26,1}.Forces(1:end-2,1)*100/1099.61;
SBS = EFDATA{27,1}.Forces(1:end-2,1)*100/1177.93;
TMS = EFDATA{28,1}.Forces(1:end-2,1)*100/223.35;
TJS = EFDATA{29,1}.Forces(1:end-2,1)*100/514.51;
CRS = EFDATA{30,1}.Forces(1:end-2,1)*100/150.05;

figure('color', 'white');
subplot(3,3,1)
plot(-vartheta'*180/pi, ADF, 'linewidth', 2, 'color', 'red');
hold on;
plot(-vartheta'*180/pi, ADFA, 'linewidth', 2, 'color', 'red');
plot(-vartheta'*180/pi, ADS, 'linewidth', 2);
grid on;
xlim([1, 140]);
ylim([0, 100]);
set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140], 'fontsize', 16, 'fontweight', 'bold', 'fontname', 'sansserif');
set(gca, 'ytick', [0, 20, 40, 60, 80, 100]);

subplot(3,3,2)
plot(-vartheta'*180/pi, MDF, 'linewidth', 2, 'color', 'red');
hold on;
plot(-vartheta'*180/pi, MDS, 'linewidth', 2);
grid on;
xlim([1, 140]);
ylim([0, 100]);
set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140], 'fontsize', 16, 'fontweight', 'bold', 'fontname', 'sansserif');
set(gca, 'ytick', [0, 20, 40, 60, 80, 100]);
subplot(3,3,3)
plot(-vartheta'*180/pi, PDF, 'linewidth', 2, 'color', 'red');
hold on;
plot(-vartheta'*180/pi, PDS, 'linewidth', 2);
grid on;
xlim([1, 140]);
ylim([0, 100]);
set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140], 'fontsize', 16, 'fontweight', 'bold', 'fontname', 'sansserif');
set(gca, 'ytick', [0, 20, 40, 60, 80, 100]);

subplot(3,3,4)
plot(-vartheta'*180/pi, SUF, 'linewidth', 2, 'color', 'red');
hold on;
plot(-vartheta'*180/pi, SUS, 'linewidth', 2);
grid on;
xlim([1, 140]);
ylim([0, 100]);
set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140], 'fontsize', 16, 'fontweight', 'bold', 'fontname', 'sansserif');
set(gca, 'ytick', [0, 20, 40, 60, 80, 100]);

subplot(3,3,5)
plot(-vartheta'*180/pi, INF, 'linewidth', 2, 'color', 'red');
hold on;
plot(-vartheta'*180/pi, INS, 'linewidth', 2);
grid on;
xlim([1, 140]);
ylim([0, 100]);
set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140], 'fontsize', 16, 'fontweight', 'bold', 'fontname', 'sansserif');
set(gca, 'ytick', [0, 20, 40, 60, 80, 100]);

subplot(3,3,6)
plot(-vartheta'*180/pi, SBF, 'linewidth', 2, 'color', 'red');
hold on;
plot(-vartheta'*180/pi, SBS, 'linewidth', 2);
grid on;
xlim([1, 140]);
ylim([0, 100]);
set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140], 'fontsize', 16, 'fontweight', 'bold', 'fontname', 'sansserif');
set(gca, 'ytick', [0, 20, 40, 60, 80, 100]);

subplot(3,3,7)
plot(-vartheta'*180/pi, TMF, 'linewidth', 2, 'color', 'red');
hold on;
plot(-vartheta'*180/pi, TMS, 'linewidth', 2);
grid on;
xlim([1, 140]);
ylim([0, 100]);
set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140], 'fontsize', 16, 'fontweight', 'bold', 'fontname', 'sansserif');
set(gca, 'ytick', [0, 20, 40, 60, 80, 100]);

subplot(3,3,8)
plot(-vartheta'*180/pi, TJF, 'linewidth', 2, 'color', 'red');
hold on;
plot(-vartheta'*180/pi, TJS, 'linewidth', 2);
grid on;
xlim([1, 140]);
ylim([0, 100]);
set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140], 'fontsize', 16, 'fontweight', 'bold', 'fontname', 'sansserif');
set(gca, 'ytick', [0, 20, 40, 60, 80, 100]);

subplot(3,3,9)
plot(-vartheta'*180/pi, CRF, 'linewidth', 2, 'color', 'red');
hold on;
plot(-vartheta'*180/pi, CRS, 'linewidth', 2);
grid on;
xlim([1, 140]);
ylim([0, 100]);
set(gca, 'xtick', [0, 20, 40, 60, 80, 100, 120, 140], 'fontsize', 16, 'fontweight', 'bold', 'fontname', 'sansserif');
set(gca, 'ytick', [0, 20, 40, 60, 80, 100]);