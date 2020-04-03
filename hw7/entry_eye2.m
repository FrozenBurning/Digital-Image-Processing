close all;

raw_I = imread('eye2.jpg');
I = rgb2gray(raw_I);
I = imadjust(I,[0 0.8]);
% figure(3),plot(hisgram)
BW = edge(I,'canny',0.2,2);
figure(2),imshow(BW)
[M,N] = size(I);
figure(1),imshow(BW);
mask_left_pupil = ~hough_cirle(BW,200,180,10,9,10,15);
mask_left_glass = hough_cirle(BW,200,180,10,30,10,10);
mask_left_upper_lids = hough_cirle(BW,180,300,10,130,20,25);
mask_left_under_lids = hough_cirle(BW,180,110,10,100,10,40);

mask_left = mask_left_pupil & mask_left_glass & mask_left_under_lids & mask_left_upper_lids;

mask_right_pupil = ~hough_cirle(BW,590,180,10,9,10,15);
mask_right_glass = hough_cirle(BW,590,180,10,30,10,10);
mask_right_upper_lids = hough_cirle(BW,620,310,20,150,20,25);
mask_right_under_lids = hough_cirle(BW,610,60,20,140,10,16);

mask_right = mask_right_glass & mask_right_pupil & mask_right_under_lids & mask_right_upper_lids;

mask = mask_right | mask_left;
imshow(mask);
figure(1),imshow(BW);

idx = find(mask);

hsv = rgb2hsv(raw_I);
hsv2 = hsv;

H = hsv2(idx)-0.15;
S=hsv2(idx+M*N)-15;
hsv2(idx) = mod(255*H,256)/255;%Hue
hsv2(idx+M*N) =  mod(255*S,256)/255;%saturation
result = hsv2rgb(hsv2);
figure(99),imshow(result);


