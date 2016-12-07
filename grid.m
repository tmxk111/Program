clear all;
close all;
clc;

height = 9;
width = 9;
dpg = 501;

img = zeros(height*dpg, width*dpg);
for i = 1:height
    for j = 1:width
        if mod(i+j, 2)
            img((i-1)*dpg+1:i*dpg, (j-1)*dpg+1:j*dpg) = 255;
            img((i-1)*dpg+240:(i-1)*dpg+262, (j-1)*dpg+240:(j-1)*dpg+262) = 0;
        end
    end
end

imshow(img);