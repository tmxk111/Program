I = filter2(mask, img);
minVal = min(min(I));
maxVal = max(max(I));
I = uint8((I-minVal)/(maxVal-minVal)*255);
imshow(I);