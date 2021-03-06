clear all;
close all;
clc;

load trans.mat;
img0 = imread('0.tiff');
img1 = imread('1.tiff');
img2 = imread('2.tiff');

se = strel('disk', 7);
img00 = imdilate(img0, se);
img11 = imdilate(img1, se);
img22 = imdilate(img2, se);

imwrite(img00, '00.tiff');
imwrite(img11, '11.tiff');
imwrite(img22, '22.tiff');

xmin = -12;
xmax = 12;
ymin = 0;
ymax = 90;
zmin = -9;
zmax = 13;

eps = 1e-6;
width = 2;

max_l = 0;
max_r = 0;
max_num = 0;

for l = 40:1:50
    l
    for r = -40:-1:-60
        theta1 = l*pi/180;
        theta2 = r*pi/180;
        rot1 = [cos(theta1), 0, -sin(theta1); 0, 1, 0; sin(theta1), 0, cos(theta1)];
        rot2 = [cos(theta2), 0, -sin(theta2); 0, 1, 0; sin(theta2), 0, cos(theta2)];
        
        d = eye(4);
        d(1:3, 1:3) = rot2;
        a1 = a*d;

        e = eye(4);
        e(1:3, 1:3) = rot1;
        a2 = a*e;
        
        res = zeros(xmax-xmin+1, ymax-ymin+1, zmax-zmin+1);
        
        % fid = fopen('ans.obj', 'w');
        for i = xmin:xmax
            for j = ymin:ymax
                for k = zmin:zmax
                    pos = [i; j; k; 1];

                    ind0 = a*pos;
                    x0 = round(ind0(1) / ind0(3));
                    y0 = round(ind0(2) / ind0(3));

                    ind1 = a1*pos;
                    x1 = round(ind1(1) / ind1(3));
                    y1 = round(ind1(2) / ind1(3));

                    ind2 = a2*pos;
                    x2 = round(ind2(1) / ind2(3));
                    y2 = round(ind2(2) / ind2(3));

                    if isValid(x0, y0, img00, width) && isValid(x1, y1, img11, width) && isValid(x2, y2, img22, width)
                        res(i-xmin+1, j-ymin+1, k-zmin+1) = 255;
                        % fprintf(fid, 'v %d %d %d\n', i, j, k);
                    end
                end
            end
        end
        % fclose(fid);
        
        n = size(nonzeros(res), 1);
        if n > max_num
            max_num = n;
            max_l = l;
            max_r = r;
            % copyfile('ans.obj', 'final_ans.obj');
        end
        
    end
end


theta1 = max_l*pi/180;
theta2 = max_r*pi/180;
rot1 = [cos(theta1), 0, -sin(theta1); 0, 1, 0; sin(theta1), 0, cos(theta1)];
rot2 = [cos(theta2), 0, -sin(theta2); 0, 1, 0; sin(theta2), 0, cos(theta2)];

d = eye(4);
d(1:3, 1:3) = rot2;
a1 = a*d;

e = eye(4);
e(1:3, 1:3) = rot1;
a2 = a*e;

fid = fopen('ans.obj', 'w');
res = zeros(xmax-xmin+1, ymax-ymin+1, zmax-zmin+1);
for i = xmin:xmax
    for j = ymin:ymax
        for k = zmin:zmax
            pos = [i; j; k; 1];

            ind0 = a*pos;
            x0 = round(ind0(1) / ind0(3));
            y0 = round(ind0(2) / ind0(3));

            ind1 = a1*pos;
            x1 = round(ind1(1) / ind1(3));
            y1 = round(ind1(2) / ind1(3));

            ind2 = a2*pos;
            x2 = round(ind2(1) / ind2(3));
            y2 = round(ind2(2) / ind2(3));

            if isValid(x0, y0, img00, width) && isValid(x1, y1, img11, width) && isValid(x2, y2, img22, width)
                res(i-xmin+1, j-ymin+1, k-zmin+1) = 255;
                fprintf(fid, 'v %d %d %d\n', i, j, k);
            end
        end
    end
end
fclose(fid);


