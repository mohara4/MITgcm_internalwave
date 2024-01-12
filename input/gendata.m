cd('C:\Users\osu894\OneDrive - Bangor University\Documents\model_MITgcm\Nov_23\offline')
addpath('C:\Users\osu894\OneDrive - Bangor University\Documents\model_MITgcm\Nov_23\offline\topography')
clear;

% This is a matlab script that generates the input data
% variable x resolution
prec='real*8';
ieee='b';

% Dimensions of grid
nx=600;
ny=1;
nz=290;
% Nominal depth of model (meters)
H=4995.0;
% Size of domain
Lx=305000;

% Horizontal resolution (m)
dx=zeros(nx,1);
for i=1:nx
dx(i) = Lx/(nx+1);
end

% dx=[];


% ACTION !!! load dz !!!!     load dx        !!!!      load sliceElev             !!!
% dy = Lx/nx
% Stratification
gravity=9.81;
talpha=2.0e-4;
N2=1e-6;

Tz=N2/(gravity*talpha);
x=zeros(nx,1);
x(1) = dx(1);
for i=2:nx
x(i)=x(i-1) + dx(i);
end
z=-dz/2:-dz:-H;

% Temperature profile
%  Tref=Tz*z-mean(Tz*z);
% Tref(1*165)=[27.97, 27.97, 27.97, 27.97, 27.97, 27.97, 27.97, 27.97, 27, 26, 25, 24,24, 23, 21, 19,...
%  17, 15, 13, 12, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, ...
%  11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,11,11,11, 11, 11, 11, 11, 11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,...
%  8, 6, 4, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5,0.5,0.5 0.5,0.5, 0.5, 0.5, 0.5,0.5,0.5, 0.5, 0.5, 0.5,0.5,...
%  0.5, 0.5, 0.5, 0.5,0.5,0.5, 0.5, 0.5, 0.5,0.5,0.5, 0.5, 0.5, 0.5,0.5,0.5, 0.5, 0.5, 0.5,0.5,...
%  0.5, 0.5, 0.5, 0.5,0.5,0.5, 0.5, 0.5, 0.5,0.5,0.5, 0.5, 0.5, 0.5,0.5,0.5, 0.5, 0.5, 0.5,0.5,...
%  0.5, 0.5, 0.5, 0.5,0.5,0.5, 0.5, 0.5, 0.5,0.5,0.5, 0.5, 0.5, 0.5,0.5,];

Tref =   [29.65,    29.68,    29.72,    29.75,    29.78,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.83,    29.83,    29.83,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.82,    29.81,    29.81,    29.81,    29.81,     29.8,     29.8,     29.8,     29.8,    29.79,    29.79,    29.79,    29.78,    29.77,    29.77,    29.76,    29.75,    29.75,    29.74,    29.73,    29.73,    29.73,    29.72,    29.71,     29.7,     29.7,    29.69,    29.68,    29.67,    29.66,    29.66,    29.65,    29.65,    29.63,    29.61,     29.6,    29.58,    29.56,    29.55,    29.53,    29.51,     29.5,    29.48,    29.48,    29.42,    29.36,     29.3,    29.24,    29.18,    29.12,    29.06,       29,    28.94,    28.88,    28.88,    28.77,    28.66,    28.55,    28.44,    28.33,    28.22,    28.11,       28,    27.89,    27.78,    27.78,    27.68,    27.58,    27.48,    27.38,    27.28,    27.18,    27.08,    26.99,    26.89,    26.79,    26.79,    26.68,    26.57,    26.47,    26.36,    26.25,    26.14,    26.04,    25.93,    25.82,    25.71,    25.71,    25.59,	25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,...
25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,...
25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,25.47,    25.34,    25.22,     25.1,    24.97,    24.85,    24.73,    24.61,    24.48,    24.48,    24.33,    24.18,    24.02,    23.87,    23.72,    23.56,    23.41,    23.26,     23.1,    22.95,    22.95,    22.77,    22.58,     22.4,    22.21,    22.03,    21.84,    21.66,    21.48,    21.29,    21.11,    21.11,    20.91,    20.71,    20.51,    20.31,     20.1,     19.9,     19.7,     19.5,     19.3,     19.1,     19.1,     18.9,     18.7,    18.49,    18.29,    18.09,    17.89,    17.69,    17.49,    17.28,    17.08,    17.08,    16.89,     16.7,    16.51,    16.33,    16.14,    15.95,    15.76,    15.57,    15.38,    15.19,    15.19,    15.05,     14.9,    14.76,    14.61,    14.47,    14.32,    14.18,    14.03,    13.89,    13.74,    13.74,    13.63,    13.52,     13.4,    13.29,    13.18,    13.07,    12.95,    12.84,    12.73,    12.62,    12.62,    12.54,    12.46,    12.39,    12.31,    12.24,    12.16,    12.08,    12.01,    11.93,    11.86,    11.86,    11.38,    11.01,    10.63,    10.16,     9.76,      9.3,     8.66,     7.67,     6.48,     5.15,     3.91,     2.84,     2.01,     1.45,     1.14,        1];

[sprintf('Tref =') sprintf(' %8.6g,',Tref)]
t=0.0*rand([nx,ny,nz]);
for k=1:nz
t(:,:,k) = t(:,:,k) + Tref(k);
end

fid=fopen('T.init','w',ieee); fwrite(fid,t,prec); fclose(fid);

%%%% !!!!!!!! load PNorth_r_bathy.mat
% fid=fopen('sliceElev','w',ieee); 
% fwrite(fid,sliceElev,prec); fclose(fid);
fid=fopen('delXvar','w',ieee); fwrite(fid,dx,prec); fclose(fid);

slope=0.02;
offset=1.25e5;
dmax=0.0;
d=0.0*rand([nx,ny]);
for i=1:nx
for j=1:ny
d(i,j) = -H;
d(i,j) = d(i,j) + slope*(x(i) - offset);
if d(i,j) < -H ;
d(i,j) = -H;
end
if d(i,j) > dmax;
d(i,j) = dmax;
end
end
end
d(nx,:)=0.0;
fid=fopen('topog.slope','w',ieee); fwrite(fid,d,prec); fclose(fid);
plot(x,d(:,1))


















% %convex slope
% nxslope=(dmax + H)/(slope)
% d1=zeros(nx,ny);
% hamp=(H-dmax)/5.0
% pi=4.0*atan(1.0)
% for i=1:nx
% for j=1:ny
% if x(i) < (offset + nxslope)
% if x(i) < offset
% d1(i,j) = d(i,j);
% else
% d1(i,j) = -H;
% d1(i,j) = d(i,j) + hamp*sin(pi*(x(i)-offset)/nxslope);
% if d1(i,j) < -H ;
% d1(i,j) = -H;
% end
% if d1(i,j) > dmax;
% d1(i,j) = dmax;
% end
% end
% else
% d1(i,j) = d(i,j);
% end
% end
% end
% %d1(end-1:end,:)=d1(1:2,:); % debug by aja
% fid=fopen('topog.convex','w',ieee); fwrite(fid,d1,prec); fclose(fid);
% plot(x,d1(:,1),'g')
% % 
% %convex slope
% d2=zeros(nx,ny);
% for i=1:nx
% for j=1:ny
% if x(i) < (offset + nxslope)
% if x(i) < offset
% d2(i,j) = d(i,j);
% else
% d2(i,j) = -H;
% d2(i,j) = d(i,j) - hamp*sin(pi*(x(i)-offset)/nxslope);
% if d2(i,j) < -H ;
% d2(i,j) = -H;
% end
% if d2(i,j) > dmax;
% d2(i,j) = dmax;
% end
% end
% else
% d2(i,j) = d(i,j);
% end
% end
% end
% %d2(end-1:end,:)=d2(1:2,:); % debug by aja
% fid=fopen('topog.concave','w',ieee); fwrite(fid,d2,prec); fclose(fid);
% hold on
% plot(x,d2(:,1),'r')
% hold off
% % 
% % 
% % fid=fopen('delXvar','w',ieee); fwrite(fid,dx,prec); fclose(fid);
