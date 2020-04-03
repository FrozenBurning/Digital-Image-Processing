src_img = imread('../sourceImage.jpg');
src_img = src_img(:,460:1460,:);

ImageTracking(src_img,true,true);