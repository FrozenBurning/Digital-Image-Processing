I = imread('3.bmp');
useGabor = false;
if useGabor
    I = preproc_3(I);
    
    
    [F,maskI] = Foreground_and_LocalFreq(I,32,3,9,1.04);
    
    O = LocalOrientation(I,32,3,20);
    
    fingerprint = real(Gabor_Filter(I,F,O,32,maskI));
    
    % fingerprint = imbinarize(fingerprint,0.05);
    
    ShowOrientation(I,O,maskI,32);
    
    % figure(1),imshow(I);
    figure(1);
    subplot(1,3,1);imshow(maskI);title('Mask');
    subplot(1,3,2),imshow(log(F));title('Frequency Map');
    subplot(1,3,3),imshow(log(abs(O)));title('Orientation Map');
    
    
    figure(2),imshow(maskI);
    figure(3),imshow(log(F));
    figure(4),imshow(log(abs(O)));
    figure(5),imshow(fingerprint);
else
    
    
    
    I = preproc_3(I);
    
    
    [F,maskI] = Foreground_and_LocalFreq(I,32,3,9,1.02);
    
    O = LocalOrientation(I,32,3,20);
    
    fingerprint = real(notch_filter(I,F,O,32,maskI));
    
    fingerprint = normalization(fingerprint,0.5,1);
    % fingerprint = imbinarize(fingerprint,0.05);
    
    ShowOrientation(I,O,maskI,32);
    
    % figure(1),imshow(I);
    figure(1);
    subplot(1,3,1);imshow(maskI);title('Mask');
    subplot(1,3,2),imshow(log(F));title('Frequency Map');
    subplot(1,3,3),imshow(log(abs(O)));title('Orientation Map');
    
    
    figure(2),imshow(maskI);
    figure(3),imshow(log(F));
    figure(4),imshow(log(abs(O)));
    figure(5),imshow(fingerprint);
    
end