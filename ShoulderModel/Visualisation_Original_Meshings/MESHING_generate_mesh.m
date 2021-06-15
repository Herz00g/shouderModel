clc; clear all; close all;

% CREATE ULNA MESH
teta = linspace(0, 2*pi,50);
z = linspace(-10, -300, 100);
Points = [10, 0, -10];

for i = 1:size(z,2)
    for j = 1:size(teta,2)-1
        Points = [Points; [5*cos(teta(1,j))+10, 5*sin(teta(1,j)), z(1,i)]];
    end
end
Points = [Points; [10, 0, -300]];

TRI = convhull(Points(:,1), Points(:,2), Points(:,3));

Ulna_Mesh0.tri = TRI;
Ulna_Mesh0.points = Points;

save([pwd, '/Visualisation_Original_Meshings/Ulna_Mesh0']);

% CREATE RADIUS MESH
teta = linspace(0, 2*pi,50);
z = linspace(-10, -300, 100);
Points = [-13, 0, -10];

for i = 1:size(z,2)
    for j = 1:size(teta,2)-1
        Points = [Points; [10*cos(teta(1,j))-13, 10*sin(teta(1,j)), z(1,i)]];
    end
end
Points = [Points; [-13, 0, -300]];

TRI = convhull(Points(:,1), Points(:,2), Points(:,3));

Radius_Mesh0.tri = TRI;
Radius_Mesh0.points = Points;

save([pwd, '/Visualisation_Original_Meshings/Radius_Mesh0']);


