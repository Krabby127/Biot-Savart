function a = squareHelix(turns, points,varargin)
% squareHelix(turns, points,
%   [width, height, depth], [x_pos, y_pos,z_pos])
% close all
switch nargin
    case 2
        width=1; height = 1; depth = 1;
        x_pos = 0; y_pos = 0; z_pos = 0;
    case 5
        width = varargin{1};
        height = varargin{2};
        depth = varargin{3};
        x_pos = 0; y_pos = 0; z_pos = 0;
    case 8
        width = varargin{1};
        height = varargin{2};
        depth = varargin{3};
        x_pos = varargin{4};
        y_pos = varargin{5};
        z_pos = varargin{6};
    otherwise
        error('myApp:argChk', 'Wrong number of input arguments');
end
t=linspace(0,2*pi*turns,points);
x=zeros(1,points);
x=x+x_pos;
y=zeros(1,points);
y=y+y_pos;
z=linspace(0,depth,points);
z=z+z_pos;
% t_temp;
t_temp=rem(t,2*pi);
for i=1:points
    if((t_temp(i) >= 0)&&(t_temp(i) < pi/4))
        x(i)=width;
        y(i)=height*tan(t_temp(i));
    elseif((t_temp(i) >= pi/4)&&(t_temp(i) < 3*pi/4))
        x(i)=width*cot(t_temp(i));
        y(i)=height;
    elseif((t_temp(i) >= 3*pi/4)&&(t_temp(i) < 5*pi/4))
        x(i)=-width;
        y(i)=-height*tan(t_temp(i));
    elseif((t_temp(i) >= 5*pi/4)&&(t_temp(i) < 7*pi/4))
        x(i)=-width*cot(t_temp(i));
        y(i)=-height;
    elseif((t_temp(i) >= 7*pi/4)&&(t_temp(i) < 2*pi))
        x(i)=width;
        y(i)=height*tan(t_temp(i));
    end
end
a=[x,y,z;y,z,x;z,x,y];
a=a';
end