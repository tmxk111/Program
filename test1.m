clear all;
close all;
clc;

load border;
load loc2;

for sampleNo = 6
    sampleNo
    left = border(sampleNo, 1);
    right = border(sampleNo, 2);
    for direction = 1:3
        for count = 1:6
            img = zeros(966, 1296);
            for j = left:right
                img(loc2(1, j, sampleNo, direction, count):loc2(2, j, sampleNo, direction, count), j) = 255;
            end
            figure;
            imshow(img);
        end
    end
end















