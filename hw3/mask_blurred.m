%% generate blurred background
% Input: raw image
close all;
image = imread('0.jpg');

%% generate darker image
mask = image*0.5;


%% bottle area luminated
image_light = image;
for i=1100:2700
    image_light(i,:) = image(i,:)*5;
end
imshow(image_light);

%% blurred image with gauss filter
% gray_mask = fast_mean2(image_light*0.7,[150 150]);
% gray_mask = imgaussfilt(image_light*0.7,[150 150]);
% gray_mask = gauss_seperated_filter(image_light*0.7,150,1);
gray_mask = fast_gauss_filter(image_light*0.7,[601 601],150);

figure(1);
imshow(gray_mask);

%% generate mask for area which contains no bottles
bm_mask = imbinarize(gray_mask,0.3);
bm_mask = imcomplement(bm_mask);
figure(3);
imshow(bm_mask);

%% roifilter with gauss core, generating image with blurred background but clear foreground
tobeproc = image;
[row, col] = find(bm_mask==1);
colpad = 50;
rowpad = 50;
mincol = max(1, min(col(:)) - colpad);
minrow = max(1, min(row(:)) - rowpad);
maxcol = min(size(tobeproc,2), max(col(:)) + colpad);
maxrow = min(size(tobeproc,1), max(row(:)) + rowpad);

% crop and expand
tmp = tobeproc;
tobeproc = tobeproc(minrow:maxrow, mincol:maxcol);
bm_mask = bm_mask(minrow:maxrow, mincol:maxcol);

filt_Image = fast_gauss_filter(tobeproc,[100 100],30);
tobeproc(bm_mask) = filt_Image(bm_mask);


if minrow ~= 0
    tmp(minrow: maxrow, mincol: maxcol) = tobeproc;
    tobeproc = tmp;
end

%background blurred image
blurred_bg = tobeproc;

figure(2);
imshow(blurred_bg);
imwrite(blurred_bg,'./blurred_bg.jpg');