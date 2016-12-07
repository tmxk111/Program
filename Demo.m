clear all;
close all;
clc;

pathImg = 'E:\指静脉与指背纹\Work\Code\NewestDatabase2\vein\';
pathMask = 'E:\指静脉与指背纹\Work\Code\NewestDatabase2\veinProcessed\';
pathSave = 'E:\指静脉与指背纹\Work\Code\NewestDatabase2\max_cur\';

for sampleNo = 1:200
    sampleNo
    pathImg1 = [pathImg, num2str(sampleNo, '%04d\\')];
    pathMask1 = [pathMask, num2str(sampleNo, '%04d\\')];
    pathSave1 = [pathSave, num2str(sampleNo, '%04d\\')];
    for direction = 1:3
        pathImg2 = [pathImg1, num2str(direction, '%d\\')];
        pathMask2 = [pathMask1, num2str(direction, '%d\\')];
        pathSave2 = [pathSave1, num2str(direction, '%d\\')];
        for num = 1:6
            pathImg3 = [pathImg2, num2str(num, '%d.tiff')];
            pathMask3 = [pathMask2, num2str(num, '%d.tiff')];
            pathSave3 = [pathSave2, num2str(num, '%d.tiff')];
            
            img = imread(pathImg3);
            mask = imread(pathMask3);
            mask(mask==255) = 1;
            sigma = 10;
            v_max_curvature = miura_max_curvature(im2double(img), im2double(mask), sigma);
            md = median(v_max_curvature(v_max_curvature>0));
            imgProcessed = v_max_curvature>md;
            imgProcessed(imgProcessed==1) = 255;
            imwrite(imgProcessed, pathSave3);
        end
    end
end