% �����ļ���

clear all;
close all;
clc;

path = 'E:\ָ������ָ����\Work\Code\NewestDatabase2\max_cur_dilate\';
for sampleID = 1:200;
    path1 = [path, num2str(sampleID, '%.4d')];
    mkdir(path1);
    for dir = 1:3
        path2 = [path1, num2str(dir, '\\%d')];
        mkdir(path2);
    end
end