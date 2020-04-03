rgb = imread('data/sourceImage.jpg');
[M,N,Q]=size(rgb);

I = rgb2gray(rgb);

hy = fspecial('sobel');    hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

se = strel('disk',20);
Io = imopen(I,se);
figure(1),imshow(Io);

Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
figure(2),imshow(Iobr);

Ioc = imclose(Io,se);
figure(3),imshow(Ioc);

Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure(4),imshow(Iobrcbr);



fgm = imregionalmax(Iobrcbr);
I2 = I;
I2(fgm)=255;
figure(5),imshow(I2);

se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);

fgm4 = bwareaopen(fgm3, 20);
I3 = I;
I3(fgm4) = 255;
figure(6),imshow(I3);

bw = im2bw(Iobrcbr, graythresh(Iobrcbr));
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
figure(7),imshow(bgm,[]);

gradmag2 = imimposemin(gradmag, bgm | fgm4);
figure(8),imshow(gradmag2,[]);

L = watershed(gradmag2);
figure(9),imshow(L,[]);

