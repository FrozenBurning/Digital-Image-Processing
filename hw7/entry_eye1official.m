close all;

raw_I = imread('eye1.jpg');
I = rgb2gray(raw_I);
fun1 = @(x) median(x(:));
% I = nlfilter(I,[7 7],fun1);
% hisgram = imhist(I);
I = imadjust(I,[0 0.8]);
% figure(3),plot(hisgram)
BW = edge(I,'canny',0.43,4);
figure(2),imshow(I)

[M,N] = size(I);
radii = 22:1:27 + 55:1:62;
h = circle_hough(BW, radii, 'same', 'normalise');
% peaks = circle_houghpeaks(h, radii, 'Threshold',2,'nhoodxy', 15, 'nhoodr', 21, 'npeaks', 10);
peaks = circle_houghpeaks(h, radii, 'nhoodxy', 15, 'nhoodr', 21, 'npeaks', 10);

mask = zeros(size(I));
masksmall = ones(size(I));
[xx,yy]=meshgrid(1:size(I,2),1:size(I,1));

% hold on;
for peak = peaks
    [x, y] = circlepoints(peak(3));
    if peak(1)<247 | peak(2)<335 | peak(1) > 1266 | peak(2) > 518
        continue;
    end
    for i=1:size(I,2)
        for j=1:size(I,1)
            if (i-(peak(1)))^2 + (j-peak(2))^2 < peak(3)^2
                mask(j,i) = 1;
            end
        end
    end
    
    if peak(3) < 50
        for i=1:size(I,2)
            for j=1:size(I,1)
                if (i-(peak(1)))^2 + (j-peak(2))^2 < peak(3)^2
                    masksmall(j,i) = 0;
                end
            end
        end
    end
    %     plot(x+peak(1), y+peak(2), 'g-');
end
% hold off

mask = mask & masksmall;
imshow(mask);
figure(1),imshow(BW);

idx = find(mask);

hsv = rgb2hsv(raw_I);
hsv2 = hsv;

H = hsv2(idx)-0.2;
S=hsv2(idx+M*N)-5;
hsv2(idx) = mod(255*H,256)/255;%Hue
hsv2(idx+M*N) =  mod(255*S,256)/255;%saturation
result = hsv2rgb(hsv2);
figure(99),imshow(result);


