function flag = isValid(x, y, img, width)
    xmin1 = max(1, x-width);
    xmax1 = min(size(img, 2), x+width);
    ymin1 = max(1, y-width);
    ymax1 = min(size(img, 1), y+width);
    
    flag = false;
    for i = xmin1:xmax1
        for j = ymin1:ymax1
            if img(j, i) == 1
                flag = true;
                return;
            end
        end
    end
    
    return;
end