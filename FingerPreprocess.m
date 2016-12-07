%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author：  吉文阳
% Date：    2015.4.8
% Function：指形轮廓提取
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clc;

%% 假设手指水平放置，分别定义上下梯度算子
maskUp = [-1, -2, -3, -4, -5, -6, -7, -6, -5, -4, -3, -2, -1;
           0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0;
           1,  2,  3,  4,  5,  6,  7,  6,  5,  4,  3,  2,  1];
       
maskDown = [ 1,  2,  3,  4,  5,  6,  7,  6,  5,  4,  3,  2,  1;
             0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0;
            -1, -2, -3, -4, -5, -6, -7, -6, -5, -4, -3, -2, -1];

%% 定义路径并且读取一张图片
fvtFilePath = 'E:\指静脉与指背纹\Work\Code\NewestDatabase\vein\';
fvtProcessedPath = 'E:\指静脉与指背纹\Work\Code\NewestDatabase\ProcessedVein\';

str = '%d.tiff';
strFinal = '%d.tiff';

fileName = strcat(fvtFilePath, '0001\---\1.tiff');
I = imread(fileName);

%% 相关变量及参数定义
[mRows, nCols] = size(I);
midPos = mRows / 2;
radius = 300;
lineLeftPos = 400;
lineRightPos = 1200;
width = 10;
THRESHOLD = 300;
HIGH_DIFF = 5;
LOW_DIFF = 3;

t = zeros(2*radius, lineRightPos-lineLeftPos);
lineUp = zeros(1, lineRightPos-lineLeftPos);
lineDown = zeros(1, lineRightPos-lineLeftPos);

%% 读取文件夹内信息
D = dir(fvtFilePath);
nFiles = size(D, 1) - 2;

imgMem = zeros(2*radius, lineRightPos-lineLeftPos);

trainData = zeros(lineRightPos-lineLeftPos, width, nFiles);

%% 开始进行预处理
for i = 1:nFiles
    for m = 1:3    
        for n = 1:6
            rpath = strcat(fvtFilePath, num2str(i, '%04d\\'));
            wpath = strcat(fvtProcessedPath, num2str(i, '%04d\\'));    

            if m == 1
                rpath = strcat(rpath, '---\');
                wpath = strcat(wpath, '---\');
            elseif m == 2
                rpath = strcat(rpath, '+45\');
                wpath = strcat(wpath, '+45\');
            else
                rpath = strcat(rpath, '-45\');
                wpath = strcat(wpath, '-45\');
            end

            % 图片读取
            rpath = strcat(rpath, num2str(n, '%d.tiff'));
            mkdir(wpath);
            wpath = strcat(wpath, num2str(n, '%d.tiff'));
            IRaw = imread(rpath);

            I = medfilt2(IRaw, [3, 3]);
            I = double(I);

            lineUpPos = zeros(1, lineRightPos-lineLeftPos);
            lineDownPos = zeros(1, lineRightPos-lineLeftPos);

            for j = 1 : lineRightPos-lineLeftPos
                % 向下找边界
                flag = 0;
                temp = midPos;
                while flag == 0
                    s = sum(sum(maskUp.*I(temp-1:temp+1, lineLeftPos+j-6:lineLeftPos+j+6)));
                    if (s > THRESHOLD) || (temp<=midPos-radius+1) || ((I(temp, lineLeftPos+j) > 220) && (temp<=midPos-radius/3))
                        lineUpPos(j) = temp;
                        flag = 1;
                    end
                    temp = temp - 1;
                end

                % 向上找边界
                flag = 0;
                temp = midPos;
                while flag == 0
                    s = sum(sum(maskDown.*I(temp-1:temp+1, lineLeftPos+j-6:lineLeftPos+j+6)));
                    if (s > THRESHOLD) || (temp >= midPos+radius+1) || ((I(temp, lineLeftPos+j) > 220) && (temp>=midPos+radius/3))
                        lineDownPos(j) = temp;
                        flag = 1;
                    end
                    temp = temp + 1;
                end
            end

            meanUpPos = mean(lineUpPos);
            meanDownPos = mean(lineDownPos);

            standard = nCols / 2;
            flag = 0;
            while (flag == 0) && (standard >= 200)
                if abs(lineUpPos(standard)-meanUpPos)<8 && abs(lineDownPos(standard)-meanDownPos)<8
                    flag = 1;
                end
                standard = standard - 1;
            end

            for j = standard : -1 : 1
                d = lineUpPos(j) - lineUpPos(j+1);
                if abs(d) > LOW_DIFF
                    if abs(d) > HIGH_DIFF
                        lineUpPos(j) = lineUpPos(j+1);
                    else
                        lineUpPos(j) = lineUpPos(j+1) + 0.5*d;
                    end
                end

                d = lineDownPos(j) - lineDownPos(j+1);
                if abs(d) > LOW_DIFF
                    if abs(d) > HIGH_DIFF
                        lineDownPos(j) = lineDownPos(j+1);
                    else
                        lineDownPos(j) = lineDownPos(j+1) + 0.5*d;
                    end
                end
            end

            for j = (standard+1) : (lineRightPos-lineLeftPos)
                d = lineUpPos(j) - lineUpPos(j-1);
                if abs(d) > LOW_DIFF
                    if abs(d) > HIGH_DIFF
                        lineUpPos(j) = lineUpPos(j-1);
                    else
                        lineUpPos(j) = lineUpPos(j-1) + 0.5*d;
                    end
                end

                d = lineDownPos(j) - lineDownPos(j-1);
                if abs(d) > LOW_DIFF
                    if abs(d) > HIGH_DIFF
                        lineDownPos(j) = lineDownPos(j-1);
                    else
                        lineDownPos(j) = lineDownPos(j-1) + 0.5*d;
                    end
                end
            end

            I = I(midPos-radius+1:midPos+radius, lineLeftPos+1:lineRightPos);

            for j = 1:2*radius
                for k = 1:lineRightPos-lineLeftPos
                    if midPos-radius+j<lineUpPos(k) || midPos-radius+j>lineDownPos(k)
                        I(j, k) = 0;
                    end
                end
            end

            I = uint8(I);
            
            lineUpPos = lineUpPos - (midPos - radius);
            lineDownPos = lineDownPos - (midPos - radius);
            length = lineDownPos - lineUpPos;
            I_Final = zeros(width, lineRightPos - lineLeftPos);
            
            % 图像尺寸归一化
            for j = 1 : lineRightPos-lineLeftPos
                I_Final(1, j) = lineUpPos(j);
                I_Final(width, j) = lineDownPos(j);
                
                for k = 2:width
                    y = (k-1)/(width-1) * length(j) + lineUpPos(j);
                    yUp = floor(y);
                    yDown = yUp + 1;
                    I_Final(k, j) = (y-yUp)*I(yDown, j) + (yDown-y)*I(yUp, j);
                end
            end

            I_Final = uint8(I_Final);
            I_Final = medfilt2(I_Final, [3, 3]);
            
            % 光照归一化
            I_Final = double(I_Final);
            meanVal = sum(sum(I_Final)) / (width*(lineRightPos - lineLeftPos));
            varVal = sum(sum((I_Final - meanVal).^2)) / (width*(lineRightPos - lineLeftPos));
            stdVal = sqrt(varVal);

            I_Final = 128 + 36/stdVal * (I_Final-meanVal);
            I_Final = uint8(I_Final);
            
            % 将最终提取到的ROI图像写入磁盘
            imwrite(I_Final, wpath);
            
            trainData(:, :, i) = uint8(I_Final');
            fprintf('%d_train', m);
        end
    end
        fprintf('%d/%d\n', i, nFiles);
end

save 'Data' 'trainData'




