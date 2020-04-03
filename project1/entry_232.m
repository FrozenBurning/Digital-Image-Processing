I = imread('23_2.bmp');
useGabor = false;

if useGabor
%     I = imresize(I,[600 600],'bicubic');
    smtI = medfilt2(I,[15 15]);
    
    % smtI = imgaussfilt(I,10);
    I = 2*I-smtI;
    I = histeq(I);
    I = imbinarize(I,0.18)*100;
    
    
    
    %cut
    s =size(I);
    I = I(1:s(1),1:s(2)-2);
    
    [F,maskI] = Foreground_and_LocalFreq(I,32,2,9,1.08);
    
    O = LocalOrientation(I,32,3,50);
    fingerprint = Gabor_Filter(I,F,O,32,maskI);
    
    ShowOrientation(I,O,maskI,32);
    
    % figure(1),imshow(I);
%     figure(1);
%     subplot(1,3,1);imshow(maskI);title('Mask');
%     subplot(1,3,2),imshow(log(F));title('Frequency Map');
%     subplot(1,3,3),imshow(log(abs(O)));title('Orientation Map');
    figure(2),imshow(maskI);
    figure(3),imshow(log(F));
    figure(4),imshow(log(abs(O)));
    figure(5),imshow(real(fingerprint));
else
    
    I = imresize(I,[600 600],'bicubic');
    smtI = medfilt2(I,[15 15]);
%     
% %     % smtI = imgaussfilt(I,10);
    I = 2*I-smtI;
    
    
%     I = histeq(I);
    I = medfilt2(I,[5 5]);
%     I = imnlmfilt(I, 'SearchWindowSize', 21, 'ComparisonWindowSize', 15);
    I = imbinarize(I,0.28)*100;



    %cut
    s =size(I);
    I = I(1:s(1),1:s(2)-2);
    
    [F,maskI] = Foreground_and_LocalFreq(I,32,2,9,1.04);
    
    O = LocalOrientation(I,32,3,50);
    fingerprint = notch_filter(I,F,O,32,maskI);
    
%     ShowOrientation(I,O,maskI,32);
    
    figure(1),imshow(I);
%     figure(1);
%     subplot(1,3,1);imshow(maskI);title('Mask');
%     subplot(1,3,2),imshow(log(F));title('Frequency Map');
%     subplot(1,3,3),imshow(log(abs(O)));title('Orientation Map');
    
    
    figure(2),imshow(maskI);
    figure(3),imshow(log(F));
    figure(4),imshow(log(abs(O)));
    figure(5),imshow(real(fingerprint));
    
end