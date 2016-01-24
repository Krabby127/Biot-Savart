function a = squareHelix(turns, points,varargin)
% squareHelix(turns, points,
%   [width, height, depth], [x_pos, y_pos,z_pos])
% close all
switch nargin
    case 2
        width=1; height = 1; depth = 1;
        x_pos = 0; y_pos = 0; z_pos = 0;
        rotation = 'A';
    case 5
        width = varargin{1};
        height = varargin{2};
        depth = varargin{3};
        x_pos = 0; y_pos = 0; z_pos = 0;
        rotation = 'A';
    case 8
        width = varargin{1};
        height = varargin{2};
        depth = varargin{3};
        x_pos = varargin{4};
        y_pos = varargin{5};
        z_pos = varargin{6};
        rotation = 'A';
    case 9
        width = varargin{1};
        height = varargin{2};
        depth = varargin{3};
        x_pos = varargin{4};
        y_pos = varargin{5};
        z_pos = varargin{6};
        rotation = varargin{7};
    otherwise
        error('myApp:argChk', 'Wrong number of input arguments');
end
if points/8<=turns
    turns=1;
end
points=ceil(points/(turns*4))*turns*4;
% t=linspace(0,2*pi*turns,points);
% x=zeros(1,points);
% x=x+x_pos;
% y=zeros(1,points);
% y=y+y_pos;
z=linspace(-depth/2,depth/2,points);
% z=z+z_pos;
% t_temp;
% t_temp=rem(t,2*pi);


points_temp=points/turns;

x(1:points_temp/4)=-width;
y(1:points_temp/4)=linspace(-height,height,points_temp/4);

x(points_temp/4+1:points_temp/4*2)=...
    linspace(-width,width,points_temp/4);
y(points_temp/4+1:points_temp/4*2)=height;

x(points_temp/4*2+1:points_temp/4*3)=width;
y(points_temp/4*2+1:points_temp/4*3)=...
    linspace(height,-height,points_temp/4);

x((3/4*points_temp)+1:points_temp)=...
    linspace(width,-width,points_temp/4);
y((3/4*points_temp)+1:points_temp)=-height;

x=repmat(x,1,turns);
y=repmat(y,1,turns);

% for i=1:points
%     if((t_temp(i) >= 0)&&(t_temp(i) < pi/4))
%         x(i)=width;
%         y(i)=height*tan(t_temp(i));
%     elseif((t_temp(i) >= pi/4)&&(t_temp(i) < 3*pi/4))
%         x(i)=width*cot(t_temp(i));
%         y(i)=height;
%     elseif((t_temp(i) >= 3*pi/4)&&(t_temp(i) < 5*pi/4))
%         x(i)=-width;
%         y(i)=-height*tan(t_temp(i));
%     elseif((t_temp(i) >= 5*pi/4)&&(t_temp(i) < 7*pi/4))
%         x(i)=-width*cot(t_temp(i));
%         y(i)=-height;
%     elseif((t_temp(i) >= 7*pi/4)&&(t_temp(i) < 2*pi))
%         x(i)=width;
%         y(i)=height*tan(t_temp(i));
%     end
% end
x=x+x_pos;
y=y+y_pos;
z=z+z_pos;

switch upper(rotation)
    case 'X'
        a=[x;y;z];
    case 'Y'
        a=[y;z;x];
    case 'Z'
        a=[z;x;y];
    case 'A'
        a=[x,y,z;y,z,x;z,x,y];
end


a=a';
end