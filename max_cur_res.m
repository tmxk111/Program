clear all;
close all;
clc;

load trans.mat;
path = 'E:\指静脉与指背纹\Work\Code\NewestDatabase\max_cur_dilate\';
path_res = 'E:\指静脉与指背纹\Work\Code\NewestDatabase\max_cur_res\';

xmin = -12;
xmax = 12;
ymin = 0;
ymax = 90;
zmin = -9;
zmax = 13;

width = 2;

for sampleNo = 1:200
    sampleNo
    path1 = [path, num2str(sampleNo, '%.4d\\')];
    path1_res = [path_res, num2str(sampleNo, '%.4d\\')];
    info = zeros(xmax-xmin+1, ymax-ymin+1, zmax-zmin+1, 6);
    for id = 1:6
        id
        img0 = imread([path1, '1\', num2str(id, '%d.tiff')]);
        img1 = imread([path1, '2\', num2str(id, '%d.tiff')]);
        img2 = imread([path1, '3\', num2str(id, '%d.tiff')]);
        
        max_l = 0;
        max_r = 0;
        max_num = 0;
        
        for l = 40:1:60
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

                            if isValid(x0, y0, img0, width) && isValid(x1, y1, img1, width) && isValid(x2, y2, img2, width)
                                res(i-xmin+1, j-ymin+1, k-zmin+1) = 255;
                            end
                        end
                    end
                end

                n = size(nonzeros(res), 1);
                if n > max_num
                    max_num = n;
                    max_l = l;
                    max_r = r;
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
        
        path2_res = [path1_res, num2str(id, '%d.obj')];
        fid = fopen(path2_res, 'w');
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

                    if isValid(x0, y0, img0, width) && isValid(x1, y1, img1, width) && isValid(x2, y2, img2, width)
                        res(i-xmin+1, j-ymin+1, k-zmin+1) = 255;
                        fprintf(fid, 'v %d %d %d\n', i, j, k);
                    end
                end
            end
        end
        fclose(fid);
        info(:, :, :, id) = res;
    end
    save info.mat info
end







