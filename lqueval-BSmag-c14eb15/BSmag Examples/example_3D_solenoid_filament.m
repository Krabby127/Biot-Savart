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

% 0.3048 m x 0.3048 m x 0.00635 m
% Mostly independent of turn numbers
% 10 pts (60 pts total {(10+10)*3} results in 54583452 calls to sqrt()
Gamma = squareHelix(25,1000, 0.3048,0.3048, 0.00635,0,0,-0.1651/2);
Gamma = [Gamma; squareHelix(25,1000, 0.3048,0.3048, 0.00635,0,0,0.1651/2)];
% theta = linspace(-2*2*pi,2*2*pi,2*100);
% Gamma = [cos(theta'),sin(theta'),theta'/10]; % x,y,z [m,m,m]
I = 1; % filament current [A]
dGamma = 1e9; % filament max discretization step [m]
[BSmag] = BSmag_add_filament(BSmag,Gamma,I,dGamma);

% Field points (where we want to calculate the field)
x_M = linspace(-0.75,0.75,97); % x [m]
y_M = linspace(-1,1,98); % y [m]
z_M = linspace(-1,1,99); % z [m]
[X_M,Y_M,Z_M]=meshgrid(x_M,y_M,z_M);
BSmag_plot_field_points(BSmag,X_M,Y_M,Z_M); % shows the field points volume
% X_M=X_M+0.5; Y_M=Y_M+0.5;Z_M=Z_M+0.5;
% For Biot-Savart Integration
[BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,X_M,Y_M,Z_M);

% Plot B/|B|
figure(1)
normB=sqrt(BX.^2+BY.^2+BZ.^2);
quiver3(X,Y,Z,BX./normB,BY./normB,BZ./normB,'b')
% axis tight

% Plot Bz on the volume
figure(2), hold on, box on, grid on
plot3(Gamma(:,1),Gamma(:,2),Gamma(:,3),'.-r') % plot filament
slice(X,Y,Z,BZ,[0],[],[-1,0,1]), colorbar % plot Bz
xlabel ('x [m]'), ylabel ('y [m]'), zlabel ('z [m]'), title ('Bz [T]')
view(3), axis equal, axis tight
caxis([-0.5,0.5]*1e-5)

% Plot some flux tubes
figure(3), hold on, box on, grid on
% plot3(Gamma(:,1),Gamma(:,2),Gamma(:,3),'.-r') % plot filament
[X0,Y0,Z0] = ndgrid(-1.5:0.5:1.5,-1.5:0.5:1.5,-2); % define tubes starting point
htubes = streamtube(stream3(X,Y,Z,BX,BY,BZ,X0,Y0,Z0), [0.2 10]);
xlabel ('x [m]'), ylabel ('y [m]'), zlabel ('z [m]'), title ('Some flux tubes')
view(3), axis equal, axis tight
set(htubes,'EdgeColor','none','FaceColor','c') % change tube color
camlight left % change tube light