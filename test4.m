clear all;
close all;
clc;

load border;

img = imread('C:\Users\Administrator\Desktop\Program\1.tiff');
ratio = 1;
radius = 160*ratio;
img = imresize(img, ratio);
img = double(img);
[high, width] = size(img);
threshold = 400;
maxdiff = 60;
mask = [-1, -2, -3, -4, -5, -6, -7, -6, -5, -4, -3, -2, -1;
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0;
         1,  2,  3,  4,  5,  6,  7,  6,  5,  4,  3,  2,  1];

path = 'E:\指静脉与指背纹\Work\Code\NewestDatabase2\vein\';
pathSave = 'E:\指静脉与指背纹\Work\Code\NewestDatabase2\veinProcessed\';
loc2 = zeros(2, width, 200, 3, 6);
for sampleNo = 1 : 200
    sampleNo
    path1 = [path, num2str(sampleNo, '%04d\\')];
    pathSave1 = [pathSave, num2str(sampleNo, '%04d\\')];
    le = border(sampleNo, 1);
    ri = border(sampleNo, 2);
    for direction = 1 : 3
        path2 = [path1, num2str(direction, '%d\\')];
        pathSave2 = [pathSave1, num2str(direction, '%d\\')];
        for num = 1 : 6
            path3 = [path2, num2str(num, '%d.tiff')];
            pathSave3 = [pathSave2, num2str(num, '%d.tiff')];
            img = double(imread(path3));
            
            location = zeros(2, width);
            for j = ri : -1 : le
                mid = floor(high/2);
                % 向上搜索上边界
                for i = mid : -1 : 2
                    total = abs(sum(sum(mask .* img(i-1:i+1, j-6:j+6))));
                    if total >= threshold
                        location(1, j) = i;
                        break;
                    end
                end

                % 向下搜索下边界
                for i = mid : 1 : high-1
                    total = abs(sum(sum(mask .* img(i-1:i+1, j-6:j+6))));
                    if total >= threshold
                        location(2, j) = i;
                        break;
                    end
                end
            end

            % 从右向左的location优化
            % 确定右边线位置
            right = ri;
            for right = ri : -1 : le
                if location(1, right)~=0 && location(2, right)~=0
                    break;
                else
                    if location(1, right)==0
                        location(1, right) = 310;
                    end
                    if location(2, right)==0
                        location(2, right) = 710;
                    end
                end
            end
            
            while right && (location(1, right)<270 || location(2, right)>750)
                if location(1, right)<270
                    location(1, right) = 310;
                end

                if location(2, right)>750
                    location(2, right) = 710;
                end

                right = right-1;
            end

            for j = right-1 : -1 : le
                if location(1, j)<270 || location(1, j)==0
                    location(1, j) = location(1, j+1);
                end

                if location(2, j)>750 || location(2, j)==0
                    location(2, j) = location(2, j+1);
                end

                if location(1, j)>location(1, j+1)+maxdiff
                    location(1, j) = location(1, j+1);
                end

                if location(2, j)<location(2, j+1)-maxdiff
                    location(2, j) = location(2, j+1);
                end
            end
            
            loc2(:, :, sampleNo, direction, num) = location;
            
            roi = zeros(high, width);
            for j = width : -1 : 1
                if location(1, j)~=0 && location(2, j)~=0
                    roi(location(1, j):location(2, j), j) = 255;
                end
            end
            
            imwrite(roi, pathSave3);
        end
    end
end

save loc2.mat loc2


