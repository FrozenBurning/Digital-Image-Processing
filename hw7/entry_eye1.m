close all;

raw_I = imread('eye1.jpg');
I = rgb2gray(raw_I);
I = imadjust(I,[0 0.8]);
% figure(3),plot(hisgram)
BW = edge(I,'canny',0.43,4);
figure(2),imshow(BW)
[M,N] = size(I);
figure(1),imshow(BW);
mask_left_pupil = ~hough_cirle(BW,448,448,10,13,10,40);
mask_left_glass = hough_cirle(BW,450,448,10,52,10,40);
mask_left_upper_lids = hough_cirle(BW,440,560,20,155,10,30);

mask_left = mask_left_pupil & mask_left_glass & mask_left_upper_lids;

mask_right_pupil = ~hough_cirle(BW,1055,420,10,15,10,25);
mask_right_glass = hough_cirle(BW,1057,420,10,52,10,25);
mask_right_upper_lids = hough_cirle(BW,1080,540,20,155,20,25);

mask_right = mask_right_glass & mask_right_pupil & mask_right_upper_lids;

mask = mask_right | mask_left;
imshow(mask);
figure(1),imshow(BW);

idx = find(mask);

hsv = rgb2hsv(raw_I);
hsv2 = hsv;

H = hsv2(idx)-0.1;
S=hsv2(idx+M*N)-50;
hsv2(idx) = mod(255*H,256)/255;%Hue
hsv2(idx+M*N) =  mod(255*S,256)/255;%saturation
result = hsv2rgb(hsv2);
figure(99),imshow(result);


