%---------------------------------------------------
%  NAME:      example_3D_solenoid_filament.m
%  WHAT:      Calculation of the magnetic field of a solenoid
%             on a volume (+ 3D plot).
%  REQUIRED:  BSmag Toolbox 20150407
%  AUTHOR:    20150407, L. Queval (loic.queval@gmail.com)
%  COPYRIGHT: 2015, Loic Qu�val, BSD License (http://opensource.org/licenses/BSD-3-Clause).
%----------------------------------------------------

% Initialize
close all; clc;
clear X Y Z Gamma BSmag
BSmag = BSmag_init(); % Initialize BSmag analysis

% Source points (where there is a current source)
% divide input into points from 0 to 2 Pi
% theta = linspace(-2*2*pi,2*2*pi,2*100);
% x = 1 (0,Pi/4), Cot(theta) (Pi/4, 3Pi/4),
% -1 (3Pi/4, 5Pi/4), -Cot(theta) (5Pi/4, 7Pi/4),
% 1 (7Pi/4, 2Pi)
% y = Tan(theta) (0, Pi/4), 1 (Pi/4, 3Pi/4),
% -tan(theta) (3Pi/4, 5Pi/4), -1 (5Pi/4, 7Pi/4)
% tan(theta) (7Pi/4, 2Pi)
% http://math.stackexchange.com/questions/978486/parametric-form-of-square

turns=40;
points=1000;
width=0.3048;
height=0.3048;
depth=0.00635;
xPos=0;
yPos=0;
seperation=0.1651*4;


% Points for stream3
a=-1:1;
a=[a,a,a];
b=1:-1:-1;
b=[b;b;b];
b=b(:);
c=[a;b'];
c=c';
c=c*((width-seperation/2)/1.5);
d=zeros(54,3);
% Side 1
d(1:9,2:3)=c;
d(1:9,1)=-width;
% Side 2
d(10:18,2:3)=c;
d(10:18,1)=width;
% Side 3
d(19:27,1:2)=c;
d(19:27,3)=-width;
% Side 4
d(28:36,1:2)=c;
d(28:36,3)=width;
% Side 5
d(37:45,1)=c(:,1);
d(37:45,3)=c(:,2);
d(37:45,2)=-width;
% Side 6
d(46:54,1)=c(:,1);
d(46:54,3)=c(:,2);
d(46:54,2)=width;


I = 1; % filament current [A]
dGamma = 1e9; % filament max discretization step [m]
% 0.3048 m x 0.3048 m x 0.00635 m
% Mostly independent of turn number

Gamma1 = squareHelix(turns,points, width,height, depth,xPos,yPos,-seperation/2,'x');
Gamma1 = [Gamma1; squareHelix(turns,points, width,height, depth,xPos,yPos,seperation/2,'x')];
% 1 out of 3 filaments
[BSmag] = BSmag_add_filament(BSmag,Gamma1,I,dGamma);

Gamma2 = squareHelix(turns,points, width,height, depth,0,0,-seperation/2,'y');
Gamma2 = [Gamma2; squareHelix(turns,points, width,height, depth,xPos,yPos,seperation/2,'y')];
% 2 out of 3 filaments
[BSmag] = BSmag_add_filament(BSmag,Gamma2,I,dGamma);
%
Gamma3 = squareHelix(turns,points, width,height, depth,xPos,yPos,-seperation/2,'z');
Gamma3 = [Gamma3; squareHelix(turns,points, width,height, depth,xPos,yPos,seperation/2,'z')];
% 3 out of 3 filaments
[BSmag] = BSmag_add_filament(BSmag,Gamma3,I,dGamma);
Gamma=[Gamma1;Gamma2;Gamma3];
% Gamma=[Gamma1;Gamma2];
% Field points (where we want to calculate the field)
x_M = linspace(-0.75,0.75,97); % x [m]
y_M = linspace(-1,1,98); % y [m]
z_M = linspace(-1,1,99); % z [m]
[X_M,Y_M,Z_M]=meshgrid(x_M,y_M,z_M);
% BSmag_plot_field_points(BSmag,X_M,Y_M,Z_M); % shows the field points volume
% X_M=X_M+0.5; Y_M=Y_M+0.5;Z_M=Z_M+0.5;
% For Biot-Savart Integration
[BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,X_M,Y_M,Z_M);

% % Plot B/|B|
% figure(1)
normB=sqrt(BX.^2+BY.^2+BZ.^2);
% quiver3(X,Y,Z,BX./normB,BY./normB,BZ./normB,'b')
% % axis tight

% Plot Bz on the volume
h2=figure(2); hold on, box on, grid on
plot3(Gamma(:,1),Gamma(:,2),Gamma(:,3),'.-r') % plot filament
xslice=0;
yslice=width*1.1;
zslice=[-1,0,1];
slice(X,Y,Z,normB,xslice,yslice,zslice), colorbar % plot Bz
xlabel ('x [m]'), ylabel ('y [m]'), zlabel ('z [m]'), ...
    title ('Bz [T]','FontSize',40)
view(3), axis equal, axis tight
% caxis([0,5e-3])
caxis auto
saveas(h2,'BField','jpg');
saveas(h2,'BField','fig');

% Plot some flux tubes
h3=figure(3); hold on, box on, grid on
plot3(Gamma(:,1),Gamma(:,2),Gamma(:,3),'.-r') % plot filament
% [X0,Y0,Z0] = ndgrid(-width:0.5:width,-height:0.5:height,depth-seperation:0.5:depth+seperation); % define tubes starting point
% htubes = streamtube(stream3(X,Y,Z,BX,BY,BZ,X0,Y0,Z0), [0.2 10]);
verts=stream3(X,Y,Z,BX,BY,BZ,d(:,1),d(:,2),d(:,3));
div=divergence(X,Y,Z,BX,BY,BZ);
htubes = streamtube(verts,X,Y,Z,-div,[0.25,10]);
xlabel ('x [m]'), ylabel ('y [m]'), zlabel ('z [m]'), title ('Flux tubes','FontSize',40)
view(3), axis equal, axis tight
set(htubes,'EdgeColor','none','FaceColor','c') % change tube color
shading interp;
camlight left % change tube light
% caxis auto
saveas(h3,'FluxTube','jpg');
saveas(h3,'FluxTube','fig');

filename='Workspace.mat';
save(filename);