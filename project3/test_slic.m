I = imread('data/2.jpg');
[M,N,Q]=size(I);


% ks = 1000;
ks = adaptive_ks(I);

I = rgb2lab(I);
L = SLIC_Proc(I,ks,32);
% [L,N] = superpixels(I,10);
L = EnforceSupervoxelConnectivity(I,L);
BW = boundarymask(L);
I = lab2rgb(I);
figure(3),imshow(imoverlay(I,BW,'cyan'),'InitialMagnification',67);

wt = useWaterShed(I,L,1);

[line1,x,y] = freehanddraw('color','r','linewidth',3);
x = ceil(x(:));
y = ceil(y(:));
foregroundInd = sub2ind(size(L),y,x);

[line2,x,y] = freehanddraw('color','b','linewidth',3);
x = ceil(x(:));
y = ceil(y(:));
backgroundInd = sub2ind(size(L),y,x);

BW = lazysnapping(I,L,foregroundInd,backgroundInd);

% Create masked image.
maskedImage = I;
maskedImage(repmat(~BW,[1 1 3])) = 0;
figure;
imshow(maskedImage);