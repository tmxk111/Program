clear all;
close all;
clc;

load border;
load loc;
path = 'E:\÷∏æ≤¬ˆ”Î÷∏±≥Œ∆\Work\Code\NewestDatabase\veinProcessed\';
for sampleNo = 1 : 200
    sampleNo
    path1 = [path, num2str(sampleNo, '%04d\\')];
    left = 1;
    right = 1296;
    for direction = 1 : 3
        path2 = [path1, num2str(direction, '%d\\')];
        for num = 1 : 6
            path3 = [path2, num2str(num, '%d.tiff')];
            img = imread(path3);
            
            if direction==1 && num==1
                while img(483, left)==0
                    left = left+1;
                end
                
                border(sampleNo, 1) = left;
            end
            
            while img(483, right)==0
                right = right-1;
            end
            border(sampleNo, 2) = right;
        end
    end
    
    for direction = 1 : 3
        path2 = [path1, num2str(direction, '%d\\')];
        for num = 1 : 6
            path3 = [path2, num2str(num, '%d.tiff')];
            img = imread(path3);
            
            location = zeros(2, 1296);
            for j = left : 1 : right
                up = 1;
                while img(up, j)==0
                    up = up+1;
                end

                down = 966;
                while img(down, j)==0
                    down = down-1;
                end

                location(1, j) = up;
                location(2, j) = down;
            end
            loc(:, :, sampleNo, direction, num) = location;
        end
    end

end

save border.mat border;
save loc.mat loc