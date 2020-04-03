I=imread('pics/337.jpg');
I=rgb2hsv(I);
a=[0.96,0.2];

r = 0.27;

D1 = (I(:,:,1)-a(1)).^2+(I(:,:,2)-a(2)).^2;
mask1 = D1<=r*r;

D2 = (I(:,:,1)-0.04).^2+(I(:,:,2)-a(2)).^2;
mask2 = D2<=r*r;
mask = mask1|mask2;

% mask = imopen(mask,ones(3,3));
imshow(mask);
