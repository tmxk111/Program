clear all;
close all;
clc;

img = imread('C:\Users\Administrator\Desktop\Program\2(+45).tiff');
ratio = 1;
radius = 160*ratio;
img = imresize(img, ratio);
img = double(img);
[high, width] = size(img);
threshold = 800;
maxdiff = 10;
mask = [-1, -2, -3, -4, -5, -6, -7, -6, -5, -4, -3, -2, -1;
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0;
         1,  2,  3,  4,  5,  6,  7,  6,  5,  4,  3,  2,  1];
for threshold = 800
    location = zeros(2, width);
    for j = width-6 : -1 : 7
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
    right = 0;
    for right = width-6:-1:1
        if location(1, right)~=0 && location(2, right)~=0
            break;
        else
            location(1, right) = 0;
            location(2, right) = 0;
        end
    end

    for j = right-1 : -1 : 1
        if abs(location(1, j)-location(1, j+1)) >= maxdiff
            location(1, j) = location(1, j+1);
        end

        if abs(location(2, j)-location(2, j+1)) >= maxdiff
            location(2, j) = location(2, j+1);
        end
    end
    
    % 从左向右的location优化
    up = location(1, 1);
    down = location(2, 1);
    for j = 1 : 1 : width
        if abs(location(1, j)-up)>1 && abs(location(2, j)-down)>1
            break;
        else
            location(1, j) = 0;
            location(2, j) = 0;
        end
    end

    roi = zeros(high, width);
    for j = width : -1 : 1
        if location(1, j)~=0 && location(2, j)~=0
            roi(location(1, j):location(2, j), j) = 255;
        end
    end

    figure;
    imshow(roi);
    title(['threshold = ', num2str(threshold)]);
end













