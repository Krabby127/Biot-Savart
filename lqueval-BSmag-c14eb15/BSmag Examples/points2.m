width=0.3048;
height=0.3048;
depth=0.00635;
xPos=0;
yPos=0;
seperation=0.1651;
close all;
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


scatter3(d(:,1),d(:,2),d(:,3));