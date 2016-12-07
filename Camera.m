clear all;
close all;
clc;

X0 = [-10, -20, 20, 10];
Y0 = [ 25,  55, 15, 45];
Z0 = [  0,   0,  0,  0];

coor = [X0; Y0; Z0];
theta1 = pi/4;
rot1 = [cos(theta1), 0, -sin(theta1); 0, 1, 0; sin(theta1), 0, cos(theta1)];
theta2 = -pi/4;
rot2 = [cos(theta2), 0, -sin(theta2); 0, 1, 0; sin(theta2), 0, cos(theta2)];
% data = [coor, rot1*coor, rot2*coor];
data = [coor, rot1*coor];
n = size(data, 2);

X = data(1, :)';
Y = data(2, :)';
Z = data(3, :)';

u = [833, 262, 1020, 443, 817, 309, 1077, 422]';
v = [696, 888,  110, 308, 648, 771,  164, 349]';

A = zeros(2*n, 11);
b = zeros(2*n, 1);
b(1:n, 1) = u;
b(n+1:2*n, 1) = v;
A(1:n, 1:4) = [X, Y, Z, ones(n, 1)];
A(1:n, 9:11) = [-X.*u, -Y.*u, -Z.*u];
A(n+1:2*n, 5:8) = [X, Y, Z, ones(n, 1)];
A(n+1:2*n, 9:11) = [-X.*v, -Y.*v, -Z.*v];

x = inv(A'*A)*A'*b;

a = ones(3, 4);
a(1, :) = x(1:4);
a(2, :) = x(5:8);
a(3, 1:3) = x(9:11);

data1 = [data; ones(1, n)];
c = a*data1;
u1 = (c(1, :)./c(3, :))';
v1 = (c(2, :)./c(3, :))';

meanDif = (sum(abs(u-u1))+sum(abs(v-v1)))/(2*n)

d = eye(4);
d(1:3, 1:3) = rot2;
a1 = a*d;

e = eye(4);
e(1:3, 1:3) = rot1;
a2 = a*e;

save trans.mat a a1 a2
