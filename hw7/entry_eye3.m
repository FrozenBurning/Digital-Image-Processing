close all;

raw_I = imread('eye3.jpg');
I = rgb2gray(raw_I);
I = imadjust(I,[0 0.8]);
% figure(3),plot(hisgram)
BW = edge(I,'canny',0.2,4);
figure(2),imshow(BW);
[M,N] = size(I);
% mask_left_pupil = ~hough_cirle(BW,200,180,10,9,10,15);
mask_left_glass = hough_cirle(BW,360,440,10,60,10,25,26);
mask_left_upper_lids = hough_cirle(BW,360,580,20,180,10,35);
mask_left_under_lids = hough_cirle(BW,330,290,20,190,10,25);

mask_left = mask_left_glass & mask_left_under_lids & mask_left_upper_lids;

% mask_right_pupil = ~hough_cirle(BW,590,180,10,9,10,15);
mask_right_glass = hough_cirle(BW,1115,415,10,60,10,15,26);
mask_right_upper_lids = hough_cirle(BW,1140,540,20,180,10,25);
mask_right_under_lids = hough_cirle(BW,1150,290,10,180,30,25);

mask_right = mask_right_glass & mask_right_under_lids & mask_right_upper_lids;

mask = mask_right | mask_left;
imshow(mask);
figure(1),imshow(BW);

idx = find(mask);

hsv = rgb2hsv(raw_I);
hsv2 = hsv;

H = hsv2(idx)-0.5;
S=hsv2(idx+M*N)-5;
hsv2(idx) = mod(255*H,256)/255;%Hue
hsv2(idx+M*N) =  mod(255*S,256)/255;%saturation
result = hsv2rgb(hsv2);
figure(99),imshow(result);