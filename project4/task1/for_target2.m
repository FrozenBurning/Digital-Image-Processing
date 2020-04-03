%% Input Data
src_img = imread('./images/sourceImage.jpg');
target_img = imread('./images/targetImage2.jpg');
mask = imread('./images/mask2.jpg');

%% Image Pre Proc
[h2,w2,c] = size(target_img);
p2 = [47 50;541 55;19 369;592 409];
src_img = imresize(src_img,[h2,w2]);

%% Stylization
% src_img = carton_trans(src_img);

[h1,w1,c] = size(src_img);
p0 = [1 1;w1 1;1 h1;w1 h1];


%% TPS
img_ref_tps = morph_tps_wrapper(src_img,target_img,p0,p2,1,0);

%% image fusion based on mask
mask = double(mask);
scaler = (mask/255).^1;
img_ref_tps=double(img_ref_tps);
target_img=double(target_img);
img_ref_tps(:,:,1) = img_ref_tps(:,:,1).*scaler+target_img(:,:,1).*(1-scaler);
img_ref_tps(:,:,2) = img_ref_tps(:,:,2).*scaler+target_img(:,:,2).*(1-scaler);
img_ref_tps(:,:,3) = img_ref_tps(:,:,3).*scaler+target_img(:,:,3).*(1-scaler);

%% show result
img_ref_tps=uint8(img_ref_tps);
figure(3),imshow(img_ref_tps);