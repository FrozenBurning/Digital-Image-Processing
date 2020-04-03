function result = suite_morpher(I,H,S,imgindex)
rectangle_base = [59 293 70 146;175 528 117 110;108 466 125 125;62 199 81 41;...
    50 565 226 144;275 1358 522 243;859 2199 396 498;57 376 100 155];
R_base = [40 100 70 70 50 50 50 20];
I = im2double(I);
M = size(I,1);
N = size(I,2);
% figure(1),imshow(I);

I = rgb2hsv(I);
pos = rectangle_base(imgindex,:);
% roi = false([M,N]);
% roi(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3)) = 1;
% 
% center = [floor(pos(2)+pos(4)/2),floor(pos(1)+pos(3)/2)];

a = [mean2(I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3),1)),mean2(I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3),2)),mean2(I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3),3))];
% a = [I(center(1),center(2),1),I(center(1),center(2),2),I(center(1),center(2),3)];
R = R_base(imgindex)/255;% radius
% D = (I(:,:,1)-a(1)).^2+(I(:,:,2)-a(2)).^2+(I(:,:,3)-a(3)).^2;
D = (I(:,:,1)-a(1)).^2+(I(:,:,2)-a(2)).^2;
mask = D<=R*R;
mask = imdilate(mask,[0 1 0;1 1 1;0 1 0]);
% mask = mask & roi;
I = hsv2rgb(I);
% figure(2),imshow(mask);

result = I;
idx = find(mask);

hsv = rgb2hsv(result);
hsv2 = hsv;

hsv2(idx) = mod(255*H,256)/255;%Hue
hsv2(idx+M*N) =  mod(255*S,256)/255;%saturation
result = hsv2rgb(hsv2);
% figure(3),imshow(J,[]);
end