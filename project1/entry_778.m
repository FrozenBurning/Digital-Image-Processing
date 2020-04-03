I = imread('77_8.bmp');
useGabor = false;

if useGabor
    
    I = imresize(I,[400 400],'bicubic');
    %cut
    s =size(I);
    I = I(1:s(1),1:s(2)-2);
    
    [F,maskI] = Foreground_and_LocalFreq(I,32,2,9,1.01);
    
    O = LocalOrientation(I,32,3,30);% 3 30
    
    fingerprint = Gabor_Filter(I,F,O,32,maskI);
    % ShowOrientation(I,O,maskI,32);
    
    % figure(1),imshow(I)
    % figure(1);
    % subplot(1,3,1);imshow(maskI);title('Mask');
    % subplot(1,3,2),imshow(log(F));title('Frequency Map');
    % subplot(1,3,3),imshow(log(abs(O)));title('Orientation Map');
    figure(2),imshow(maskI);
    figure(3),imshow(log(F));
    figure(4),imshow(log(abs(O)));
    figure(5),imshow(real(fingerprint));
    
else
    % I = histeq(I);
    I = imresize(I,[700 700],'bicubic');
    
    %cut
    s =size(I);
    I = I(1:s(1),1:s(2)-2);
    
    [F,maskI] = Foreground_and_LocalFreq(I,32,2,9,1.01);
    
    O = LocalOrientation(I,32,3,30);% 3 30
    
    fingerprint = notch_filter(I,F,O,32,maskI);
    % fingerprint = Gabor_Filter(I,F,O,32,maskI);
    % ShowOrientation(I,O,maskI,32);
    
    % figure(1),imshow(I)
    % figure(1);
    % subplot(1,3,1);imshow(maskI);title('Mask');
    % subplot(1,3,2),imshow(log(F));title('Frequency Map');
    % subplot(1,3,3),imshow(log(abs(O)));title('Orientation Map');
    figure(2),imshow(maskI);
    figure(3),imshow(log(F));
    figure(4),imshow(log(abs(O)));
    figure(5),imshow(real(fingerprint));
end