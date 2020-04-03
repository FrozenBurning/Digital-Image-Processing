% function suite_morpher(I,mask,H,S,imgindex)
I = imread('8.jpg');

%thres
%1.jpg [39 129 123 336] 40
%2.jpg [4 393 444 381] 100
%3.jpg [19 247 289 445] 70
%4.jpg [25 154 158 194] 70
%5.jpg [40 285 370 501] 50
%6,jpg [143 617 756 1077] 50
%7,jpg [25 1665 2142 1794] 50
%8.jpg [17 192 274 431] 20



rectangle_base = [39 129 123 336;4 393 444 381;9 247 289 445;25 154 158 194;...
    40 285 370 501;143 617 756 1077;25 1665 2142 1794;17 192 274 431];

I = im2double(I);
M = size(I,1);
N = size(I,2);
figure(1),imshow(I);

% % choose point of interest
% h = impoint;
% pos = wait(h);
% pos = round(pos);
% a = [I(pos(2),pos(1),1) I(pos(2),pos(1),2) I(pos(2),pos(1),3)];
% R = 40/255;% radius
% 
% D = (I(:,:,1)-a(1)).^2+(I(:,:,2)-a(2)).^2+(I(:,:,3)-a(3)).^2;
% mask = D<=R*R;

% choose ROI
% figure(2),imshow(mask);
h = imrect;
pos = wait(h);
pos = round(pos);
roi = false([M,N]);

I = rgb2hsv(I);
roi(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3)) = 1;

center = [floor(pos(2)+pos(4)/2),floor(pos(1)+pos(3)/2)];

a = [mean2(I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3),1)),mean2(I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3),2)),mean2(I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3),3))];
% a = [I(center(1),center(2),1),I(center(1),center(2),2),I(center(1),center(2),3)];
R = 20/255;% radius
% D = (I(:,:,1)-a(1)).^2+(I(:,:,2)-a(2)).^2+(I(:,:,3)-a(3)).^2;
D = (I(:,:,1)-a(1)).^2+(I(:,:,2)-a(2)).^2;
mask = D<=R*R;
mask = imdilate(mask,[0 1 0;1 1 1;0 1 0]);
% mask = imerode(mask,[0 1 0;1 1 1;0 1 0]);

I = hsv2rgb(I);
% region_mean = [0,0,0];
% region_var = [0,0,0];
% for i = 1:3%RGB
%    region_mean(i) =  mean2(I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3),i));
%    region_var(i) = std2(I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3),i))^2;
% end
% 
% major_channal = find(region_mean == max(region_mean));
% 
% mask = false([M,N]);
% 
% R = 40/255;
% D = (I(:,:,1)-region_mean(1)).^2+(I(:,:,2)-region_mean(2)).^2+(I(:,:,3)-region_mean(3)).^2;
% mask = D<=R*R;
% 
% % mask(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3)) = (region_mean(major_channal)-1.25*region_var(major_channal)...
% %     <= I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3),major_channal))...
% %     & (I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3),major_channal)<=region_mean(major_channal)...
% %     +1.25*region_var(major_channal));


colorbase=[0 100;319 44;108 100;161 51;59 25];

% mask = mask & roi;
figure(2),imshow(mask);

for i=1:5
    desired_hue = colorbase(i,1)/360;
    desired_sat = colorbase(i,2)/100;
    J = I;
    idx = find(mask);
    
    hsv = rgb2hsv(J);
    hsv2 = hsv;
    
    hsv2(idx) = mod(255*desired_hue,256)/255;
    hsv2(idx+M*N) =  mod(255*desired_sat,256)/255;
%     hsv2(idx+M*N*2) = 1;
    % J(idx) = I(idx);
    % J(idx+M*N) = I(idx+M*N);
    % J(idx+M*N*2) = I(idx+M*N*2);
    J = hsv2rgb(hsv2);
    figure(i+2),imshow(J,[]);
end
% end