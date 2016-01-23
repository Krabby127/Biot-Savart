function [BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,X,Y,Z)
%---------------------------------------------------
%  NAME:      BSmag_get_B.m
%  WHAT:      Calculates B at field points.
%  REQUIRED:  BSmag Toolbox 20150407
%  AUTHOR:    20150407, L. Queval (loic.queval@gmail.com)
%  COPYRIGHT: 2015, Loic Quéval, BSD License (http://opensource.org/licenses/BSD-3-Clause).
%
%  USE:
%    [BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,X,Y,Z)
%
%  INPUTS:
%    BSmag      = BSmag data structure
%    X          = Field points x-coordinate vector or matrix
%    Y          = Field points y-coordinate vector or matrix
%    Z          = Field points z-coordinate vector or matrix
%
%  OUTPUTS:
%    BSmag      = BSmag data structure (no update)
%    X          = Field points x-coordinate vector or matrix
%    Y          = Field points y-coordinate vector or matrix
%    Z          = Field points z-coordinate vector or matrix
%    BX         = Field points B x-component vector or matrix
%    BY         = Field points B y-component vector or matrix
%    BZ         = Field points B z-component vector or matrix
%----------------------------------------------------

mu0 = 4*pi*1e-7; % vacuum permeability [N/A^2]

BX = zeros(size(X,1),size(X,2),size(X,3));
BY = zeros(size(X,1),size(X,2),size(X,3));
BZ = zeros(size(X,1),size(X,2),size(X,3));
x_P=zeros(1,size(BSmag.filament(BSmag.Nfilament).Gamma,1)-1);
y_P=zeros(1,size(BSmag.filament(BSmag.Nfilament).Gamma,1)-1);
z_P=zeros(1,size(BSmag.filament(BSmag.Nfilament).Gamma,1)-1);
for nF = 1:BSmag.Nfilament % Loop on each filament
    
    Gamma = BSmag.filament(nF).Gamma;
    dGamma = BSmag.filament(nF).dGamma;
    I = BSmag.filament(nF).I;
    
    % Discretization of Gamma
    %         x_P = []; y_P = []; z_P = [];
    N = size(Gamma,1)-1; % Number of points defining Gamma
    
    for i = 1:N % Loop on the segments defining gamma
        L_Gamma_i = norm(Gamma(i,:)-Gamma(i+1,:));
        NP = ceil(L_Gamma_i/dGamma); % Number of points required to have a discretization step smaller than dGamma
        x_P(i) = linspace(Gamma(i,1), Gamma(i+1,1), NP); % discretization of Gamma for x component
        y_P(i) = linspace(Gamma(i,2), Gamma(i+1,2), NP); % discretization of Gamma for y component
        z_P(i) = linspace(Gamma(i,3), Gamma(i+1,3), NP); % discretization of Gamma for z component
    end
    DBx=zeros(1,size(BSmag.filament(BSmag.Nfilament).Gamma,1)-2);
    DBy=zeros(1,size(BSmag.filament(BSmag.Nfilament).Gamma,1)-2);
    DBz=zeros(1,size(BSmag.filament(BSmag.Nfilament).Gamma,1)-2);
    lastSumX = 0;
    lastSumY = 0;
    lastSumZ = 0;
    diffX=diff(x_P);
    diffY=diff(y_P);
    diffZ=diff(z_P);
    % Add contribution of each source point P on each field point M (where we want to calculate the field)
    % Total
    % callTotal = size(X,1)*size(X,2)*size(X,3)*(size(Gamma,1)-2);
    count=0;
    for m = 1:size(X,1);
        for n = 1:size(X,2);
            for p = 1:size(X,3);
                
                % M is the field point
                % This saves time on indexing
                x_M = X(m,n,p);
                y_M = Y(m,n,p);
                z_M = Z(m,n,p);
                
                % Loop on each discretized segment of Gamma PkPk+1
                for k = 1:length(x_P)-1
                    % This is the most intensive call
                    % Called size(X,1)*size(X,2)*size(X,3)*(size(Gamma,1)-2) times
                    %
                    PkM3 = (sqrt((x_M-x_P(k))^2 + (y_M-y_P(k))^2 + (z_M-z_P(k))^2))^3;
                    % DBx(k) = ((y_P(k+1)-y_P(k))*(z_M-z_P(k))-(z_P(k+1)-z_P(k))*(y_M-y_P(k)))/PkM3;
                    % DBy(k) = ((z_P(k+1)-z_P(k))*(x_M-x_P(k))-(x_P(k+1)-x_P(k))*(z_M-z_P(k)))/PkM3;
                    % DBz(k) = ((x_P(k+1)-x_P(k))*(y_M-y_P(k))-(y_P(k+1)-y_P(k))*(x_M-x_P(k)))/PkM3;
                    DBx(k) = (diffY(k)*(z_M-z_P(k))-(diffZ(k))*(y_M-y_P(k)))/PkM3;
                    DBy(k) = (diffZ(k)*(x_M-x_P(k))-(diffX(k))*(z_M-z_P(k)))/PkM3;
                    DBz(k) = (diffX(k)*(y_M-y_P(k))-(diffY(k))*(x_M-x_P(k)))/PkM3;
                    count=count+1;
                end
                
                % Sum
                lastSumX = lastSumX + DBx(k);
                lastSumY = lastSumY + DBy(k);
                lastSumZ = lastSumZ + DBz(k);
                % BX(m,n,p) = BX(m,n,p) + mu0*I/4/pi*sum(DBx);
                % BY(m,n,p) = BY(m,n,p) + mu0*I/4/pi*sum(DBy);
                % BZ(m,n,p) = BZ(m,n,p) + mu0*I/4/pi*sum(DBz);
                
                BX(m,n,p) = BX(m,n,p) + mu0*I/4/pi*lastSumX;
                BY(m,n,p) = BY(m,n,p) + mu0*I/4/pi*lastSumY;
                BZ(m,n,p) = BZ(m,n,p) + mu0*I/4/pi*lastSumZ;
                
            end
        end
    end
    display(count);
end