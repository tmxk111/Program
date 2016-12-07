clear all;
close all;
clc;

path_max = 'E:\指静脉与指背纹\Work\Code\NewestDatabase2\max_cur\';
path_max_dilate = 'E:\指静脉与指背纹\Work\Code\NewestDatabase2\max_cur_dilate\';
se = strel('disk', 7);

for sampleID = 1:200
    sampleID
    path1_max = [path_max, num2str(sampleID, '%.4d\\')];
    path1_max_dilate = [path_max_dilate, num2str(sampleID, '%.4d\\')];
    for dir = 1:3
        path2_max = [path1_max, num2str(dir, '%d\\')];
        path2_max_dilate = [path1_max_dilate, num2str(dir, '%d\\')];
        for id = 1:6
            path3_max = [path2_max, num2str(id, '%d.tiff')];
            path3_max_dilate = [path2_max_dilate, num2str(id, '%d.tiff')];
            
            img = imread(path3_max);
            img_dilate = imdilate(img, se);
            imwrite(img_dilate, path3_max_dilate);
        end
    end
end