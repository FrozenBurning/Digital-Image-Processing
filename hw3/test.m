img = imread('./small.jpg');

figure(1);

blur = gauss_seperated_filter(img,20,20);

imshow(blur);

matblur = imgaussfilt(img,20);

figure(2);
imshow(matblur);
