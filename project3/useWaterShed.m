function wt = useWaterShed(I,L,N_var)
%% watershed utilizer
% input:I-image, L-superpixel label, N_var-param for performance
% output:wt watershed result
[M,N,Q]=size(I);
superpixel_img = I;
% superpixel_img = rgb2gray(I);

%% compute gradient
for i = 1:max(L(:))
    idx = find(L==i);
    superpixel_img(idx) = mean(superpixel_img(idx));
    superpixel_img(idx+M*N) = mean(superpixel_img(idx+M*N));
    superpixel_img(idx+2*M*N) = mean(superpixel_img(idx+2*M*N));
end

hy = fspecial('sobel');
hx = hy';

grad = 0;
for i=1:3
    Iy = imfilter(double(superpixel_img(:,:,i)), hy, 'replicate');
    Ix = imfilter(double(superpixel_img(:,:,i)), hx, 'replicate');
    
    grad = grad + sqrt(Ix.^2 + Iy.^2);
end
% for i=1:3
%     [gm,gd]=imgradient(superpixel_img(:,:,i));
%    grad = grad + gm;
% end

%% adaptive filter based on threshold
thres = mean(grad(:))+N_var*var(grad(:));
idx = grad<thres;
grad(idx)=0;
wt = watershed(grad,4);
figure(4),imshow(grad,[]);
figure(5),imshow(wt,[]);
end