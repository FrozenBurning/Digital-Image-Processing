%%unused simulated depth using gauss_method
%Input: mask & blurred_bg

for i = 1:4000
    for j = 1:6000
        dist = sqrt((i-2000)^2+(j-1200)^2)/1000;
        mask(i,j) = mask(i,j)*dist;
        
    end
end

% gray_mask = fast_mean2(mask,[200 200]);
% gray_mask = imgaussfilt(mask,[200 200]);
% gray_mask = gauss_seperated_filter(mask,200,1);
gray_mask = fast_gauss_filter(mask,[801 801],200);
% for j = 0.01:0.01:0.1
%    mask = imbinarize(gray_mask,0.02); 
% end

blurred = blurred_bg;

% for i=0.2

for i = 0.2:0.01:0.8
    mask = imbinarize(gray_mask,i);
%     imshow(mask);
    tmp = blurred .* uint8(mask);
    unproc = blurred - tmp;
%     tmp = fast_mean2(tmp,[floor(i*10)+1 floor(i*10)+1]);
%     tmp = gauss_seperated_filter(tmp,floor((i*5)^3)+11,i*80);
    tmp = fast_gauss_filter(tmp,[floor((i*5)^3)+11 floor((i*5)^3)+11],i*80);
    blurred = tmp + unproc;
    
%     GU2 =fspecial('gaussian',[floor((i*5)^3)+11 floor((i*5)^3)+11],i*80);
%     blurred = roifilt2(GU2,blurred,mask);
end

% blurred = fast_mean2(blurred,[40 40]);
% blurred = imgaussfilt(blurred,5);
blurred = fast_gauss_filter(blurred,[21 21],5);

imshow(blurred);