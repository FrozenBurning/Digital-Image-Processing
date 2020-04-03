function demo()

%% parameters to change according to your requests
fn_im='../targetImage6.png';
fn_mask='../mask06.jpg';

%% configuration
addpath(genpath('./code'));

%% read image and mask
imdata=imread(fn_im);
mask=getMask_onlineEvaluation(fn_mask);

%% compute alpha matte
[alpha]=learningBasedMatting(imdata,mask);

%% show and save results
figure,subplot(2,1,1); imshow(imdata);
subplot(2,1,2),imshow(uint8(alpha*255));

imwrite(uint8(alpha*255),'../mask6.jpg');