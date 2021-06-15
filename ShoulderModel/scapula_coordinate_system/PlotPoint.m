function [] = PlotPoint(point,scale,color,edge)
%
%
%
% plot landmarks
[dummyx,dummyy,dummyz] = sphere;

dummyx=dummyx.*scale;
dummyy=dummyy.*scale;
dummyz=dummyz.*scale;

surf(dummyx+point(1),dummyy+point(2),dummyz+point(3),'facecolor',color, 'EdgeColor', edge);