%% simulated depth using background-blurred image
% Input: background-blurred image
% Output: various of image with simulated depth 
close all;
image = imread('./blurred_bg.jpg');

siz = size(image);
result = image;

%% expand image with enough space for doing mean2
expanded = padarray(image,[320 480],'replicate','both');

expanded = integralImage(expanded);


%% doing mean2 for each pixel based on its distance to the focus plate
for i = 1:siz(1)
    for j=1:siz(2)
        
        %1200 2400 3400 4400 5200
        dist = sqrt((i-2000)^2+(j-1200)^2)/100;

        dist = dist + (1+randn(1,1))*(dist*0.05);
        window = [floor(sigmoid(dist/5-2,2)) floor(sigmoid(dist/5-2,2))];
        tmpi = i+320;
        tmpj = j+480;
        
        % do nothing in the focus plate
        if dist < 8
           result(i,j)=expanded(tmpi,tmpj)+expanded(tmpi-1,tmpj-1)-expanded(tmpi,tmpj-1)-expanded(tmpi-1,tmpj);
           continue; 
        end
        if dist > 7.7 && dist < 8.5
           if i-10 >0 && i+10<siz(1) && j-10 >0 && j+10<siz(2)
               result(i-10:i+10,j-10:j+10) = fast_gauss_filter(result(i-10:i+10,j-10:j+10),[9 9],20);
           end
        end
        
        
        result(i,j)=(expanded(tmpi+floor(window(1)/2),tmpj+floor(window(2)/2))+expanded(tmpi-floor(window(1)/2),tmpj-floor(window(2)/2))-expanded(tmpi-floor(window(1)/2),tmpj+floor(window(2)/2))-expanded(tmpi+floor(window(1)/2),tmpj-floor(window(2)/2)))/(window(1)*window(2));
        
        
    end
end

%% slightly smooth result image 
result = fast_gauss_filter(result,[10 10],10);
imshow(result);
imwrite(result,'new1.png');

% sigmoid function used to genereate various of mean2 window size
function f=sigmoid(x,omeg)
    f=100/(1+exp((-1.0)*omeg*x));
end
