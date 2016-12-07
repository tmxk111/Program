close all;
clear all;
clc;

load border;
load loc;

pathRead = 'E:\指静脉与指背纹\Work\Code\NewestDatabase\vein\';
pathProcessed = 'E:\指静脉与指背纹\Work\Code\NewestDatabase\veinProcessed\';
pathSave = 'E:\指静脉与指背纹\Work\Code\NewestDatabase\step1\';

for sampleNo = 1:200
    sampleNo
    pathRead1 = [pathRead, num2str(sampleNo, '%04d\\')];
    pathSave1 = [pathSave, num2str(sampleNo, '%04d\\')];
    pathProcessed1 = [pathProcessed, num2str(sampleNo, '%04d\\')];
    
    left = border(sampleNo, 1);
    right = border(sampleNo, 2);
    for direction = 1:3
        pathRead2 = [pathRead1, num2str(direction, '%d\\')];
        pathSave2 = [pathSave1, num2str(direction, '%d\\')];
        pathProcessed2 = [pathProcessed1, num2str(direction, '%d\\')];
        for num = 1:6
            pathRead3 = [pathRead2, num2str(num, '%d.tiff')];
            pathSave3 = [pathSave2, num2str(num, '%d.tiff')];
            pathProcessed3 = [pathProcessed2, num2str(num, '%d.tiff')];
            
            up = min(loc(1, left:right, sampleNo, direction, num));
            down = max(loc(2, left:right, sampleNo, direction, num));
            
            mask = imread(pathProcessed3);
            mask(mask==255) = 1;
            img = imread(pathRead3);
            img = img .* mask;
            roi = img(up:down, left:right);
            imwrite(roi, pathSave3);
        end
    end
end