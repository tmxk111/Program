clear all;
close all;
clc;

img = imread('E:\指静脉与指背纹\Work\Code\NewestDatabase\vein\0001\1\1.tiff');
medfilt2(img, [3, 3]);
ratio = 1;
radius = 160*ratio;
img = imresize(img, ratio);
img = double(img);
[high, width] = size(img);
threshold = 400;
mask = [-1, -2, -3, -4, -5, -6, -7, -6, -5, -4, -3, -2, -1;
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0;
         1,  2,  3,  4,  5,  6,  7,  6,  5,  4,  3,  2,  1];
for threshold = 400
    location = zeros(2, width);
    for j = width-6 : -1 : width/2
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
    
    %
    % 从右向左的location优化
    right = 0;
    for right = width-6 : -1 : width/2
        if location(1, right)~=0 && location(2, right)~=0
            break;
        else
            location(1, right) = 0;
            location(2, right) = 0;
        end
    end
    
    while (location(1, right)<270 || location(2, right)>750) && right
        if location(1, right)<270
            location(1, right) = 310;
        end
        
        if location(2, right)>750
            location(2, right) = 710;
        end
        
        right = right-1;
    end

    for j = right-1 : -1 : width/2
        if location(1, j)<270 || location(1, j)==0
            location(1, j) = location(1, j+1);
        end
        
        if location(2, j)>750 || location(2, j)==0
            location(2, j) = location(2, j+1);
        end
    end
    %}
    
    %{
    % 从左向右的location优化
    up = location(1, 1);
    down = location(2, 1);
    for j = width/2 : 1 : width
        if abs(location(1, j)-up)>1 && abs(location(2, j)-down)>1
            break;
        else
            location(1, j) = 0;
            location(2, j) = 0;
        end
    end
    %}

    roi = zeros(high, width);
    for j = width : -1 : 1
        if location(1, j)~=0 && location(2, j)~=0
            roi(location(1, j):location(2, j), j) = 255;
        end
    end

    figure;
    subplot(1, 2, 1), imshow(uint8(img));
    subplot(1, 2, 2), imshow(roi);
    title(['threshold = ', num2str(threshold)]);
end













